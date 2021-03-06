﻿#IfWinExist, ahk_class CrossFire  
#Include, CrossHirer_Functions.ahk
Preset()
DetectHiddenWindows, On  
SetTitleMatchMode, Regex  
;==================================================================================
global Service_On := False
CheckPermission()
Game_Obj := CriticalObject()  ;Create new critical object
Game_Obj.In_Game := False
;==================================================================================
Need_Help := False
Need_Hide := False
global Title_Blank := 0
GAMEOBJECT := CriticalObject()

If WinExist("ahk_class CrossFire")
{
    Gui, Helper: New, +LastFound +AlwaysOnTop -Caption +ToolWindow +MinSize -DPIScale, CTL ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
    Gui, Helper: Margin, 0, 0
    Gui, Helper: Color, 333333 ;#333333
    Gui, Helper: Font, s12 c00FF00, Microsoft YaHei ;#00FF00
    Gui, Helper: add, Text, hwndGui_8, ╔====使用==说明===╗`n     按~     =开关自火==`n     按2   ==手枪模式==`n     按3/4  =暂停模式==`n     按J    ==瞬狙模式==`n     按L   ==连发速点==`n     按K键   通用模式==`n================`n     鼠标中间键 右键连点`n     鼠标前进键 炼狱连刺`n     鼠标后退键 左键连点`n     按W和F ==基础鬼跳`n     按W和Alt =空中跳蹲`n     按W放LCtrl bug小道`n     按S和F  ==跳蹲上墙`n     按W和C==前跳跳蹲`n     按S和C ==后跳跳蹲`n     按Z和C ==六级跳箱`n     按?或/ ==随机动作`n     按<或, ==左旋转跳`n     按>或. ==右旋转跳`n================`n     小键盘123 更换射速`n     小键盘0     关闭压枪`n     小键盘+ 更换压枪度`n     小键盘Del. 点射压枪`n================`n     按H  =运行一键限速`n     按-   =重新加载脚本`n     按=      开关E键快反`n     大写锁定 小大化窗口`n     回车键 开关所有按键`n     右Alt   恢复按键显示`n╚====使用==说明===╝
    GuiControlGet, P8, Pos, %Gui_8%
    global P8H ;*= (A_ScreenDPI / 96)
    WinSet, TransColor, 333333 191 ;#333333
    WinSet, ExStyle, +0x20 +0x8; 鼠标穿透以及最顶端

    Gui, Hint: New, +LastFound +AlwaysOnTop -Caption +ToolWindow +MinSize -DPIScale, CTL ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
    Gui, Hint: Margin, 0, 0
    Gui, Hint: Color, 333333 ;#333333
    Gui, Hint: Font, s12 c00FF00, Microsoft YaHei ;#00FF00
    Gui, Hint: add, Text, hwndGui_9, 按`n右`n c`n t`n r`n l`n键`n开`n关`n帮`n助
    GuiControlGet, P9, Pos, %Gui_9%
    global P9H ;*= (A_ScreenDPI / 96)
    WinSet, TransColor, 333333 191 ;#333333
    WinSet, ExStyle, +0x20 +0x8; 鼠标穿透以及最顶端

    SetGuiPosition(XGui9, YGui9, "V", 0, -P8H // 2)
    SetGuiPosition(XGui10, YGui10, "V", 0, -P9H // 2)
    Gui, Hint: Show, x%XGui10% y%YGui10% NA
    Gui, Helper: Show, Hide

    ;WinMinimize, ahk_class ConsoleWindowClass
    SetTimer, UpdateGui, 500 ;不需要太频繁
    DPI_Initial := A_ScreenDPI
    Service_On := True
}
;OutputVar := AhkThread(ScriptOrFile, , , True) ;true if script is file
;ahkthread_free(ahkdll),ahkdll:="" ; Stop execution in thread and free resources.
;==================================================================================
;第一个线程:自动开火
AhkThread_Shooter := AhkThread("
(
    object:=CriticalObject(" (&GAMEOBJECT) ")
)")
;==================================================================================
;第二个线程:基础身法
AhkThread_Bhop := AhkThread("
(
    object:=CriticalObject(" (&GAMEOBJECT) ")
)")
;==================================================================================
;第三个线程:C4计时+秒变猎手
AhkThread_C4_Hero := AhkThread("
(
    object:=CriticalObject(" (&GAMEOBJECT) ")
)")
;==================================================================================
;第四个线程:鼠标连点
AhkThread_Clicker := AhkThread("
(
    object:=CriticalObject(" (&GAMEOBJECT) ")
)")
;==================================================================================
;第五个线程:小小压枪
AhkThread_Recoilless := AhkThread("
(
    object:=CriticalObject(" (&GAMEOBJECT) ")
)")
;==================================================================================
;第六个线程:一键限网
AhkThread_NetBlocker := AhkThread("
(
    object:=CriticalObject(" (&GAMEOBJECT) ")
)")
;==================================================================================
;第七个线程:无尽挂机
AhkThread_NetBlocker := AhkThread("
(
    object:=CriticalObject(" (&GAMEOBJECT) ")
)")
;==================================================================================
~*-::
    HyperSleep(1000)
ExitApp

~*Right::Suspend, Toggle ;输入聊天时不受影响

~*RAlt::
    PostMessage("Listening", 123865)
    If CTL_Service_On
    {
        SetGuiPosition(XGui9, YGui9, "V", 0, -P8H // 2)
        SetGuiPosition(XGui10, YGui10, "V", 0, -P9H // 2)
        ShowHelp(Need_Help, XGui9, YGui9, "Helper", XGui10, YGui10, "Hint", 0)
    }
Return

~*RCtrl::
    If CTL_Service_On
        ShowHelp(Need_Help, XGui9, YGui9, "Helper", XGui10, YGui10, "Hint", 1)
Return

~*CapsLock:: ;minimize window and replace origin use
    If CTL_Service_On
    {
        Need_Hide := !Need_Hide
        If (WinActive("ahk_class CrossFire") && Need_Hide)
        {
            WinMinimize, ahk_class CrossFire
            HyperSleep(100)
            MouseMove, A_ScreenWidth // 2, A_ScreenHeight // 2 ;The middle of screen
        }
        Else If (!WinActive("ahk_class CrossFire") && !Need_Hide)
            WinActivate, ahk_class CrossFire ;激活该窗口
    }
Return
