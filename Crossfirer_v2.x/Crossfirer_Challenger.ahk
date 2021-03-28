﻿#Include Crossfirer_Functions.ahk
Preset("尽")
;==================================================================================
global CLG_Service_On := False
CheckPermission("无尽挂机")
;==================================================================================
global cstage := 0
global IndiMulti := "单人"
global 挂机 := False
global 准备 := False
global 找人 := False
global Xj := 0, Yj := 0, Wj := 1600, Hj := 900

If WinExist("ahk_class CrossFire")
{
    CheckPosition(Xj, Yj, Wj, Hj, "CrossFire")
    Gui, challen_mode: New, +LastFound +AlwaysOnTop -Caption +ToolWindow -DPIScale, Listening ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
    Gui, challen_mode: Margin, 0, 0
    Gui, challen_mode: Color, 333333 ;#333333
    Gui, challen_mode: Font, S10 Q5, Microsoft YaHei
    Gui, challen_mode: Add, Text, hwndGui_10 vModeChallen c00FF00, 单人无尽挂机 ;#00FF00
    GuiControlGet, P10, Pos, %Gui_10%
    WinSet, TransColor, 333333 255 ;#333333
    WinSet, ExStyle, +0x20 +0x8; 鼠标穿透以及最顶端
    SetGuiPosition(XGui10, YGui10, "H", -P10W // 2, Round(Hj / 18) - P10H // 2)
    Gui, challen_mode: Show, x%XGui10% y%YGui10% NA
    OnMessage(0x1001, "ReceiveMessage")
    CLG_Service_On := True
    CoordMode, Mouse, Screen
    Return
}
;==================================================================================
~*-::ExitApp

#If WinActive("ahk_class CrossFire") && CLG_Service_On ;以下的热键需要相应条件才能激活

~*Enter Up::
    Suspend, Off ;恢复热键,首行为挂起关闭才有效
    If Is_Chatting()
        Suspend, On 
    Suspended()
Return

~*RAlt::
    Suspend, Off ;恢复热键,双保险
    Suspended()
    SetGuiPosition(XGui10, YGui10, "H", -P10W // 2, Round(Hj / 18) - P10H // 2)
    Gui, challen_mode: Show, x%XGui10% y%YGui10% NA
Return

~*F2::
    IndiMulti := "多人"
    UpdateText("challen_mode", "ModeChallen", "多人无尽挂机", XGui10, YGui10)
    挂机 := True
    找人 := False
Return

~*F3::
    IndiMulti := "单人"
    UpdateText("challen_mode", "ModeChallen", "单人无尽挂机", XGui10, YGui10)
    挂机 := True
    找人 := False
Return

~*F8::
    Send, {Blind}{vk86 Down}
    GuiControl, challen_mode: +c00FFFF +Redraw, ModeChallen ;#00FFFF
    While, WinActive("ahk_class CrossFire") && 挂机
    {
        If !准备
            无尽准备()
        Else If !找人
            单挑合作()
        Else
        {
            无尽挑战挂机()
            无尽收尾()
        }
        HyperSleep(1000)
    }
    GuiControl, challen_mode: +c00FF00 +Redraw, ModeChallen ;#00FF00
    Send, {Blind}{vk86 Up}
Return

~*Esc::
    挂机 := False
    准备 := False
Exit ;退出当前线程
;==================================================================================
;执行无尽挑战挂机,需要目前背包选择的武器或者背包1位主武器为神圣爆裂者
无尽挑战挂机()
{
    If GetKeyState("vk87")
    {
        称号升级 := True
        Loop
        {
            ClickWait(0.589, 0.913) ;确认称号
            PixelSearch, 称号升级X, 称号升级Y, Xj + Wj // 2 - Round(Wj / 8), Yj + Hj // 2 - Round(Hj / 20), Xj + Wj // 2 + Round(Wj / 8), Yj + Hj // 2 + Round(Hj / 20), 0xFF972F, 0, Fast ;#2F97FF #FF972F
            If ErrorLevel
                称号升级 := False
        } Until, JumpLoop() || !称号升级
        
        ClickWait(0.94, 0.823) ;点击开始游戏
        游戏即将开始 := False, 进入游戏x := 0, 进入游戏y := 0
        Loop
        {
            ToolTip, 等待进入游戏, , , 19
            HyperSleep(1000)
            PixelSearch, 进入游戏x, 进入游戏y, Xj + Round(Wj * 0.8125), Yj + Hj // 2, Xj + Round(Wj * 0.9), Yj + Round(Hj * 2 / 3), 0xF2EEF2, 0, Fast ;#F2EEF2
            If !ErrorLevel
                游戏即将开始 := True
        } Until, (!GetKeyState("vk87") && 游戏即将开始) || JumpLoop() ;等待进入游戏

        Game_Start := A_TickCount
        Time_Use := 0
        Char_Dead := False

        Loop
        {
            确认成绩x := 0, 确认成绩y := 0, 确认成绩a := 0, 确认成绩b := 0, 确认死亡x := 0, 确认死亡y := 0
            CheckPosition(Xj, Yj, Wj, Hj, "CrossFire")
            PixelSearch, 确认死亡x, 确认死亡y, Xj + Wj // 2 - Round(Wj * 0.05), Yj + Round(Hj / 3), Xj + Wj // 2 + Round(Wj * 0.05), Yj + Hj // 2, 0x00FFFF, 0, Fast ;#FFFF00 #00FFFF 确认死亡
            If !ErrorLevel
            {
                Char_Dead := True
                ToolTip, 玩家死亡, , , 19
            }
            Else
                Char_Dead := False

            If !Char_Dead
            {
                MouseMove, Xj + Wj // 2, Yj + Hj // 2
                MouseMove, Xj + Wj // 2, Yj + Round(Hj * 0.75) ;枪口朝下
                Loop, 50
                {
                    Random, RanClick, 8, 12
                    press_key("RButton", RanClick, 60 - RanClick)
                    ToolTip, 爆裂轰炸, , , 19
                }
            }

            Time_Use := A_TickCount - Game_Start ;确认所用时间

            PixelSearch, 确认成绩x, 确认成绩y, Xj + Round(Wj * 0.72), Yj + Round(Hj * 0.87), Xj + Round(Wj * 0.835), Yj + Round(Hj * 0.925), 0x553503, 0, Fast ;#303555 #553505 确认按钮
            If !ErrorLevel
                PixelSearch, 确认成绩a, 确认成绩b, Xj + Round(Wj * 0.72), Yj + Round(Hj * 0.87), Xj + Round(Wj * 0.835), Yj + Round(Hj * 0.925), 0xFFFFFF, 0, Fast ;#FFFFFF 确认字样
        } Until, (确认成绩x > 0 && 确认成绩y > 0 && 确认成绩a > 0, 确认成绩b > 0) || Time_Use > 1320000 || JumpLoop() || GetKeyState("vk87") ;每局最多22分钟
        ToolTip, 本局完毕, , , 19
    }
}
;==================================================================================
;初始化挑战环境
无尽准备()
{
    global 准备
    地图选择x := 0, 地图选择y := 0, 暗黑营地x := 0, 暗黑营地y := 0
    If GetKeyState("vk87")
    {
        ToolTip, 选择模式, , , 19
        Loop ;确认是否进入模式/地图选择界面
        {
            ClickWait(0.2, 0.03) ;进行游戏
            ClickWait(0.09, 0.117) ;新版大厅
            ClickWait(0.8125, 0.805) ;选择模式
            PixelSearch, 地图选择x, 地图选择y, Xj + Wj // 2 - Round(Wj / 16), Yj, Xj + Wj // 2 + Round(Wj / 16), Yj + Round(Hj / 9), 0x4CCDFF, 0, Fast ;#FFCD4C #4CCDFF
        } Until, (地图选择x > 0 && 地图选择y > 0) || JumpLoop()

        Loop ;确认是否选择了暗黑营地地图
        {
            ToolTip, 确认暗黑营地, , , 19
            ClickWait(0.4125, 0.141) ;挑战模式
            ClickWait(0.1, 0.25) ;无尽挑战
            PixelSearch, 暗黑营地x, 暗黑营地y, Xj + Round(Wj * 0.53), Yj + Round(Hj * 0.36), Xj + Round(Wj * 0.8125), Yj + Round(Hj * 0.76), 0x638B62, 0, Fast ;#628B63 #638B62
            ClickWait(0.6, 0.556) ;目前第三栏暗黑营地位置
        } Until, (暗黑营地x > 0 && 暗黑营地y > 0) || JumpLoop()
        
        Loop
        {
            ClickWait(0.844, 0.95) ;点击确认
        } Until, GetKeyState("vk87") || JumpLoop()

        ;ToolTip, 选择等级, , , 19
        ;ClickWait(0.8125, 0.85)
        ;MouseMove, Xj + Round(Wj * 0.8125), Yj + Round(Hj * 0.75)
        ;Loop, 4
        ;{
        ;    HyperSleep(100)
        ;    press_key("WheelDown", 50, 50) ;选比最高通过等级小的等级
        ;}
        ;ClickWait(0.8125, 0.655)

        准备 := True
        ToolTip, 准备完毕, , , 19
    }
}
;==================================================================================
;单双人模式切换
单挑合作()
{
    global IndiMulti, 找人
    ToolTip, 选择单/多人, , , 19
    ClickWait(0.975, 0.889) ;选择多人/单人
    If InStr(IndiMulti, "单人")
        ClickWait(0.856, 0.946)
    Else If InStr(IndiMulti, "多人")
        ClickWait(0.856, 0.975)
    找人 := True
}
;==================================================================================
;确认分数返回主界面
无尽收尾()
{
    ToolTip, 点击确认成绩, , , 19
    Loop
    {
        ClickWait(0.775, 0.9) ;点击确认键
    } Until, GetKeyState("vk87") || JumpLoop()
    ToolTip, , , , 19
}
;==================================================================================
;退出循环
JumpLoop()
{
    If !WinActive("ahk_class CrossFire") || GetKeyState("Esc", "P")
        Return True
    Return False
}
;==================================================================================
;鼠标点击指定位置并等待
ClickWait(a, b)
{
    CheckPosition(Xj, Yj, Wj, Hj, "CrossFire")
    MouseClick, Left, Xj + Round(Wj * a), Yj + Round(Hj * b)
    HyperSleep(500)
}
;==================================================================================