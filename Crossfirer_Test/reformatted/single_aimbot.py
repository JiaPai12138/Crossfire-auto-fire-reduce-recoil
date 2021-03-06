'''
Detection code modified from project AIMBOT-YOLO
Detection code Author: monokim
Detection project website: https://github.com/monokim/AIMBOT-YOLO
Detection project video: https://www.youtube.com/watch?v=vQlb0tK1DH0
Screenshot method from: https://www.youtube.com/watch?v=WymCpVUPWQ4
Screenshot method code modified from project: opencv_tutorials
Screenshot method code Author: Ben Johnson (learncodebygaming)
Screenshot method website: https://github.com/learncodebygaming/opencv_tutorials
'''

from math import sqrt, pow, ceil, floor
from multiprocessing import Process, Array, Pipe, freeze_support, JoinableQueue
from win32con import SRCCOPY, MOUSEEVENTF_MOVE, VK_LBUTTON, MOUSEEVENTF_LEFTDOWN, MOUSEEVENTF_LEFTUP
from win32api import mouse_event, GetAsyncKeyState
from keyboard import is_pressed
from collections import deque
from os import system, path, chdir
from ctypes import windll
from sys import exit, executable
from time import sleep, time
from platform import release
from statistics import mean
import numpy as np
import cv2
import win32gui
import win32ui
import pywintypes
import nvidia_smi


# 截图类
class WindowCapture:
    # 类属性
    total_w = 0  # 窗口内宽
    total_h = 0  # 窗口内高
    cut_w = 0  # 截取宽
    cut_h = 0  # 截取高
    hwnd = None  # 窗口句柄
    offset_x = 0  # 窗口内偏移x
    offset_y = 0  # 窗口内偏移y
    actual_x = 0  # 截图左上角屏幕位置x
    actual_y = 0  # 截图左上角屏幕位置y
    left_var = 0  # 窗口距离左侧距离

    # 构造函数
    def __init__(self, window_class):
        self.hwnd = win32gui.FindWindow(window_class, None)
        if not self.hwnd:
            raise Exception(f'\033[1;31;40m窗口类名未找到: {window_class}')

        # 获取窗口数据
        window_rect = win32gui.GetWindowRect(self.hwnd)
        client_rect = win32gui.GetClientRect(self.hwnd)
        left_corner = win32gui.ClientToScreen(self.hwnd, (0, 0))

        # 确认截图相关数据
        self.left_var = window_rect[0]
        self.total_w = client_rect[2] - client_rect[0]
        self.total_h = client_rect[3] - client_rect[1]
        self.cut_h = int(self.total_h * 2 / 3)
        self.cut_w = self.cut_h
        if window_class == 'CrossFire':  # 画面实际4:3简单拉平
            self.cut_w = int(self.cut_w * (self.total_w / self.total_h) / 4 * 3)
        self.offset_x = (self.total_w - self.cut_w) // 2 + left_corner[0] - window_rect[0]
        self.offset_y = (self.total_h - self.cut_h) // 2 + left_corner[1] - window_rect[1]
        self.actual_x = window_rect[0] + self.offset_x
        self.actual_y = window_rect[1] + self.offset_y

    def get_screenshot(self):
        # 获取截图相关
        try:
            wDC = win32gui.GetWindowDC(self.hwnd)
            dcObj = win32ui.CreateDCFromHandle(wDC)
            cDC = dcObj.CreateCompatibleDC()
            dataBitMap = win32ui.CreateBitmap()
            dataBitMap.CreateCompatibleBitmap(dcObj, self.cut_w, self.cut_h)
            cDC.SelectObject(dataBitMap)
            cDC.BitBlt((0, 0), (self.cut_w, self.cut_h), dcObj, (self.offset_x, self.offset_y), SRCCOPY)

            # 转换使得opencv可读
            signedIntsArray = dataBitMap.GetBitmapBits(True)
            cut_img = np.frombuffer(signedIntsArray, dtype='uint8')
            cut_img.shape = (self.cut_h, self.cut_w, 4)

            # 释放资源
            dcObj.DeleteDC()
            cDC.DeleteDC()
            win32gui.ReleaseDC(self.hwnd, wDC)
            win32gui.DeleteObject(dataBitMap.GetHandle())

            # 去除alpha
            cut_img = cut_img[..., :3]

            # 转换减少错误
            cut_img = np.ascontiguousarray(cut_img)
            return cut_img
        except pywintypes.error:
            return None

    def get_cut_info(self):
        return self.cut_w, self.cut_h

    def get_actual_xy(self):
        return self.actual_x, self.actual_y

    def get_window_left(self):
        self.left_var = win32gui.GetWindowRect(self.hwnd)[0]
        return self.left_var


# 分析类
class FrameDetection:
    # 类属性
    side_length = 0  # 输入尺寸
    std_confidence = 0  # 置信度阀值
    win_class_name = ''  # 窗口类名
    CONFIG_FILE = ['./']
    WEIGHT_FILE = ['./']
    net = ''  # 建立网络
    ln = ''

    # 构造函数
    def __init__(self, aim_mode, hwnd_value, gpu_level):
        if aim_mode == 1:  # 极速自瞄
            self.side_length = 416
        elif aim_mode == 2:  # 标准自瞄
            self.side_length = 512
        elif aim_mode == 3:  # 高精自瞄
            self.side_length = 608

        self.win_class_name = win32gui.GetClassName(hwnd_value)
        if self.win_class_name == 'Valve001':
            self.std_confidence = 0.4
        elif self.win_class_name == 'CrossFire':
            self.std_confidence = 0.5
        else:
            self.std_confidence = 0.5

        check_file('yolov4-tiny-vvv', self.CONFIG_FILE, self.WEIGHT_FILE)
        self.net = cv2.dnn.readNetFromDarknet(self.CONFIG_FILE[0], self.WEIGHT_FILE[0])  # 读取权重与配置文件

        # 读取YOLO神经网络内容
        self.ln = self.net.getLayerNames()
        self.ln = [self.ln[i[0] - 1] for i in self.net.getUnconnectedOutLayers()]

        # 检测并设置在GPU上运行图像识别
        if cv2.cuda.getCudaEnabledDeviceCount():
            self.net.setPreferableBackend(cv2.dnn.DNN_BACKEND_CUDA)
            self.net.setPreferableTarget(cv2.dnn.DNN_TARGET_CUDA)
            if not check_gpu(gpu_level):
                print('您的显卡配置不够')
        else:
            print('您的没有可识别的N卡')

    def detect(self, frame):
        try:
            frames = np.array(frame)  # 从队列中读取帧
            try:
                if frames.any():
                    frame_height, frame_width = frames.shape[:2]
            except AttributeError:  # 游戏窗口意外最小化后不强制(报错)退出
                return
        except cv2.error:
            return

        # 初始化返回数值
        x, y, fire_range = 0, 0, 0
        # y = 0
        # fire_range = 0

        # 画实心框避免错误检测武器与手
        if self.win_class_name == 'CrossFire':
            cv2.rectangle(frames, (int(frame_width*3/5), int(frame_height*3/4)), (int(frame_width*4/5), frame_height), (127, 127, 127), cv2.FILLED)
            cv2.rectangle(frames, (int(frame_width*1/5), int(frame_height*3/4)), (int(frame_width*2/5), frame_height), (127, 127, 127), cv2.FILLED)
            if frame_width / frame_height > 1.3:
                frame_width = int(frame_width / 4 * 3)
                dim = (frame_width, frame_height)
                frames = cv2.resize(frames, dim, interpolation=cv2.INTER_AREA)
        elif self.win_class_name == 'Valve001':
            pass
            # cv2.rectangle(frames, (int(frame_width*3/4), int(frame_height*11/15)), (frame_width, frame_height), (127, 127, 127), cv2.FILLED)
            # cv2.rectangle(frames, (0, int(frame_height*11/15)), (int(frame_width*1/4), frame_height), (127, 127, 127), cv2.FILLED)

        # 检测
        blob = cv2.dnn.blobFromImage(frames, 1 / 255.0, (self.side_length, self.side_length), swapRB=False, crop=False)  # 转换为二进制大型对象
        self.net.setInput(blob)
        layerOutputs = self.net.forward(self.ln)  # 前向传播

        boxes = []
        confidences = []

        # 检测目标,计算框内目标到框中心距离
        for output in layerOutputs:
            for detection in output:
                scores = detection[5:]
                classID = np.argmax(scores)
                confidence = scores[classID]
                if confidence > self.std_confidence and classID == 0:  # 人类/body为0
                    box = detection[:4] * np.array([frame_width, frame_height, frame_width, frame_height])
                    (centerX, centerY, width, height) = box.astype('int')
                    x = int(centerX - (width / 2))
                    y = int(centerY - (height / 2))
                    box = [x, y, int(width), int(height)]
                    boxes.append(box)
                    confidences.append(float(confidence))

        # 移除重复
        indices = cv2.dnn.NMSBoxes(boxes, confidences, 0.4, 0.3)

        # 画框,计算距离框中心距离最小的威胁目标
        if len(indices) > 0:
            max_var = 0
            max_at = 0
            for j in indices.flatten():
                (x, y) = (boxes[j][0], boxes[j][1])
                (w, h) = (boxes[j][2], boxes[j][3])
                cv2.rectangle(frames, (x, y), (x + w, y + h), (0, 36, 255), 2)

                # 计算威胁指数(正面画框面积的平方根除以鼠标移动到近似胸大肌距离)
                threat_var = pow(boxes[j][2] * boxes[j][3], 1/3) / sqrt(pow(frame_width / 2 - (x + w / 2), 2) + pow(frame_height / 2 - (y + h / 4), 2))
                if threat_var > max_var:
                    max_var = threat_var
                    max_at = j

            # 指向距离最近威胁的位移
            x = int(boxes[max_at][0] + boxes[max_at][2] / 2 - frame_width / 2)
            y1 = int(boxes[max_at][1] + boxes[max_at][3] / 8 - frame_height / 2)  # 爆头优先
            y2 = int(boxes[max_at][1] + boxes[max_at][3] / 4 - frame_height / 2)  # 击中优先
            if y1 <= y2:
                y = y1
                fire_range = int(ceil(boxes[max_at][2] / 5))  # 头宽约占肩宽二点五分之一
            else:
                y = y2
                fire_range = int(ceil(boxes[max_at][2] / 3))

        return len(indices), x, y, fire_range, frames


# 简单检查gpu是否够格
def check_gpu(level):
    nvidia_smi.nvmlInit()
    handle = nvidia_smi.nvmlDeviceGetHandleByIndex(0)  # 默认卡1
    info = nvidia_smi.nvmlDeviceGetMemoryInfo(handle)
    memory_total = info.total / 1024 / 1024
    nvidia_smi.nvmlShutdown()
    if level == 1 and memory_total > 4092:  # 正常值为4096,减少损耗误报
        return True
    elif level == 2 and memory_total > 6140:  # 正常值为6144,减少损耗误报
        return True
    else:
        return False


# 高DPI感知
def set_dpi():
    if int(release()) >= 7:
        windll.user32.SetProcessDPIAware()
    else:
        exit(0)


# 确认窗口句柄与类名
def get_window_info():
    supported_games = 'Valve001 CrossFire LaunchUnrealUWindowsClient'
    test_window = 'Notepad3 PX_WINDOW_CLASS Notepad++'
    class_name = ''
    hwnd_var = ''
    while not hwnd_var:  # 等待游戏窗口出现
        hwnd_active = win32gui.GetForegroundWindow()
        try:
            class_name = win32gui.GetClassName(hwnd_active)
        except pywintypes.error:
            continue

        if class_name not in supported_games and class_name not in test_window:
            print('请使支持的游戏/程序窗口成为活动窗口...')
        else:
            hwnd_var = win32gui.FindWindow(class_name, None)
            print('已找到窗口')
        sleep(3)
    return class_name, hwnd_var


# 重启脚本
def restart():
    windll.shell32.ShellExecuteW(None, 'runas', executable, __file__, None, 1)
    exit(0)


# 检测是否存在配置与权重文件
def check_file(file, config_filename, weight_filename):
    cfg_filename = file + '.cfg'
    weights_filename = file + '.weights'
    if path.isfile(cfg_filename) and path.isfile(weights_filename):
        config_filename[0] += cfg_filename
        weight_filename[0] += weights_filename
        return
    else:
        print(f'请下载{file}相关文件!!!')
        sleep(3)
        exit(0)


# 检查是否为管理员权限
def is_admin():
    try:
        return windll.shell32.IsUserAnAdmin()
    except OSError as err:
        print('OS error: {0}'.format(err))
        return False


# 清空命令指示符输出
def clear():
    _ = system('cls')


# 移动鼠标(并射击)
def control_mouse(a, b, fps_var, ranges, win_class):
    if fps_var:
        if win_class == 'CrossFire':
            x0 = a / 4 / (fps_var / 19.2)
            y0 = b / 4 / (fps_var / 14.4)
        elif win_class == 'Valve001':
            x0 = a / 1.56 / (fps_var / 28)
            y0 = b / 1.56 / (fps_var / 21)
        else:
            x0 = a / 6
            y0 = b / 8
        mouse_event(MOUSEEVENTF_MOVE, int(round(x0)), int(round(y0)), 0, 0)

    # 不分敌友射击
    if win_class != 'CrossFire':
        if floor(sqrt(pow(a, 2) + pow(b, 2))) <= ranges:
            if (time() * 1000 - press_time[0]) > 100:
                if not GetAsyncKeyState(VK_LBUTTON):
                    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0)
                    up_time[0] = int(time() * 1000)
            mouse_event(MOUSEEVENTF_MOVE, 0, 3, 0, 0)  # 压枪
        else:
            if (time() * 1000 - up_time[0]) > 50:
                if GetAsyncKeyState(VK_LBUTTON):
                    press_time[0] = int(time() * 1000)
                mouse_event(MOUSEEVENTF_LEFTUP, 0, 0)


# 转变状态
def check_status(exit0, mouse):
    if is_pressed('delete'):
        exit0 = True
    if is_pressed('1') or is_pressed('2'):
        mouse = True
    if is_pressed('3') or is_pressed('4'):
        mouse = False
    if is_pressed('i'):
        arr[3] = 0
    if is_pressed('o'):
        arr[3] = 1
    if is_pressed('p'):
        show_proc.terminate()
        restart()

    return exit0, mouse


# 多线程展示效果
def show_frames(output_pipe, array):
    set_dpi()
    cv2.namedWindow('Show frame')
    cv2.moveWindow('Show frame', 0, 0)
    font = cv2.FONT_HERSHEY_SIMPLEX  # 效果展示字体
    while True:
        show_img = output_pipe.recv()
        try:
            if show_img.any():
                show_img = cv2.resize(show_img, (show_img.shape[1] // array[1], show_img.shape[0] // array[1]))
                cv2.putText(show_img, str(array[2]), (10, 25), font, 0.5, (127, 255, 0), 2, cv2.LINE_AA)
                cv2.imshow('Show frame', show_img)
                cv2.waitKey(1)
        except AttributeError:
            cv2.destroyAllWindows()


# 主程序
if __name__ == '__main__':
    # 为了Pyinstaller顺利生成exe
    freeze_support()

    # 检查管理员权限
    if not is_admin():
        restart()

    # 设置高DPI不受影响
    set_dpi()

    # 设置工作路径
    chdir(path.dirname(path.abspath(__file__)))

    # 选择分析输入大小
    aim_mode = 0
    while not (3 >= aim_mode >= 1):
        user_input = input('你想要的自瞄模式是?(1:极速, 2:标准, 3:高精): ')
        try:
            aim_mode = int(user_input)
        except ValueError:
            print('呵呵...请重新输入')

    # 初始化变量
    queue = JoinableQueue()  # 初始化队列
    frame_output, frame_input = Pipe(False)  # 初始化管道(receiving,sending)
    press_time, up_time, show_fps = [0], [0], [1]
    process_time = deque()
    move_mouse = False
    exit_program = False

    # 分享数据以及展示新进程
    arr = Array('i', range(10))
    '''
    0  窗口句柄
    1  左侧距离除数
    2  FPS整数值
    3
    '''
    show_proc = Process(target=show_frames, args=(frame_output, arr,))
    show_proc.start()
    arr[2] = 0  # FPS值
    arr[3] = 0  # 开关效果展示

    # 寻找读取游戏窗口类型并确认截取位置
    window_class_name, window_hwnd = get_window_info()
    arr[0] = window_hwnd

    # 初始化截图类
    win_cap = WindowCapture(window_class_name)

    # 初始化分析类
    Analysis = FrameDetection(aim_mode, window_hwnd, 1)

    # 清空命令指示符面板
    clear()

    while True:
        ini_sct_time = time()  # 计时
        screenshot = win_cap.get_screenshot()  # 截屏
        try:
            enemy, move_x, move_y, move_range, show_frame = Analysis.detect(screenshot)
        except UnboundLocalError:
            break

        exit_program, move_mouse = check_status(exit_program, move_mouse)

        if exit_program:
            break

        if enemy and move_mouse:
            control_mouse(move_x, move_y, show_fps[0], move_range, window_class_name)

        if arr[3]:
            try:
                arr[1] = int(ceil(show_frame.shape[1] / win_cap.get_window_left()))
                frame_input.send(show_frame)
            except pywintypes.error:
                break
        else:
            frame_input.send(0)

        time_used = time() - ini_sct_time
        if time_used:  # 防止被0除
            current_fps = 1 / time_used
            process_time.append(current_fps)
            if len(process_time) > 59:
                process_time.popleft()

            show_fps[0] = mean(process_time)  # 计算fps
            arr[2] = int(show_fps[0])

        if move_mouse:
            print(f'\033[1;37;44m FPS={show_fps[0]:.2f};\033[1;37;41m 检测{enemy}人 ', end='\r')
        else:
            print(f'\033[0m FPS={show_fps[0]:.2f}; 检测{enemy}人 ', end='\r')

    show_proc.terminate()
    exit(0)
