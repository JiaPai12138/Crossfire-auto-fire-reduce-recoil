﻿; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_Limit_net_1_bmp(NewHandle := False) {
Static hBitmap := 0
If (NewHandle)
   hBitmap := 0
If (hBitmap)
   Return hBitmap
VarSetCapacity(B64, 6088 << !!A_IsUnicode)
B64 := "Qk3WEQAAAAAAADYAAAAoAAAAPgAAABgAAAABABgAAAAAAKARAAB0EgAAdBIAAAAAAAAAAAAA////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////AAD///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8AAP///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wAA////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////AAD///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8AAP///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wAA////7uD6+s+V////9v//56iW/+KU////////////////////////57W7/+KU////7uX/7a9R///h////////////9///66+j//7A////573P5ZsD7KkX//vN////8P//7Kht///Z////////5bW77KgD///Z////////58Ha5ZsE5ZsD8LQD///+9v//5aiW/89q////////////////6tD//89r////5bW75ZsD5ZsD9sE5////////AAD////u6P/pnk7/8rD2///lqJbmohfmpCjmpCjmpCjmpCjmpCjmpCjnnh3/4pT////2///mqJb903b////////////2///qqJb//rn////////2///nqJb/4pT////////nwdr/z2v////////////q0P/nmwX/4pT////ntbv/4pT2///qqJb//rn////2///lqJb2wTn////////w///wtG3///7////////////w///sqG3//9n///8AAP///////+e+0/S+Lfb//ueolv/ilP///////////////////////+e1u//ilP///////+nM8PC0EP//+f////////b//+qolv/+uf////////b//+eolv/ilP////////D//+qbbf/+uf////////////D//+qbbf/+uee1u//ilP///+e1u//ilP////////b//+Wolv/Pavb//+qolv/+uf////////////////D//+yobf//2f///wAA////////7ej/7KVI9v/S56iW/+KU////////////////////////57W7/+KU////////7/P/66Bb//7F////////9v//6qiW//65////////9v//56iW/+KU////////////58Ha/89r////7OL/9sFs////7OL/8LQ757W6/+KU////////////////////////7OL/8LQ757W6/+KU////////6tD/9sE6////8P//7Kht///Z////AAD////////z///opIf266Lmr6PmpCjmpCjmpCjmpCjmpCjmpCjmpCjopCj/5KH////////1///pp5L/8q3////////2///qqJb//rn////////2///nqJb/4pT////////////s4v/wtDvw//7qm23//rn////2///qqJbntGv/4pTnwdr/z2v////////nwdr/z2v2///qqJb//rn2///qqJb//rnq0P/2wTr////w///sqG3//9n///8AAP///////////+a1u//Vev////////////////////////////////////////////////n//+WtpOWbA+WbA+WbA+WbA+WbA+WbA+WbA+WbA+WbA+ebA//ilP////////////D//+yobefBuf/Pa+rQ//bBOv///+e1u//ilP///+fB2v/Pa////////+fB2v/Pa////+e1u//ilPb//+qolv/+uerQ//bBOv////D//+yobf//2f///wAA////////////573P5qEP5qQo5qQo5qQo5qQo5qQo5qQo5qQo5qQo66MP///O////////////57W7/+KU////////9v//6qiW//65////////9v//56iW/+KU////////////9v//6qiW//65////6tD/9sE6////58Ha/89r////58Ha/89r////////58Ha/89r////57W7/+KU9v//6qiW//656tD/9sE6////8P//7Kht///Z////AAD////////////nwdr/z2v////////////////////////////w///sqG3//9n////////////ntbv/2oX////////2///qqJb//rn////////2///nqJb/4pT////w///lm23lmwPlmwPlmwPlmwPqtGr2wTr////nwdr/z2v////nwdr/z2v////////nwdr/z2v////ntbv/4pT2///qqJb//rnq0P/2wTr////w///sqG3//9n///8AAP///////////+fB2v/Pa/////////////////////////////D//+yobf//2f///////////+W1u+WbA+WbA+WbA+WbA+WbA+WbA+WbA+WbA+WbA+ebA//ilP///////////////+e1u//ilP///+rQ//bBOv///+fB2v/Pa////+fB2v/Pa////////+fB2v/Pa////+e1u//ilPb//+qolv/+uerQ//bBOv////D//+yobf//2f///wAA////////////58Ha5qEQ5qQo5qQo5qQo5qQo5qQo5qQo5qQo5qQo7awo///V////////////5bW7/89q////////9v//6qiW//65////////9v//56iW/+KU////////////////57W7/+KU////6tD/9sE6////58Ha/89r////58Ha/89r////////58Ha/89r////57W7/+KU9v//6qiW//656tD/9sE6////8P//7Kht///Z////AAD////////////nwdr/z2v////////////////////////////////////////////////////ltbv/z2r////////2///qqJb//rn////////2///nqJb/4pT////////ltbvlmwPlmwPlmwPqmwPq0Ln2wTr////nwdr/z2v////nwdr/z2v////////nwdr/z2v////ntbv/4pT2///qqJb//rnq0P/2wTr////w///sqG3//9n///8AAP///////////+fB2uahEOakKOakKOmqKOq2c+y6c+/NqfbZvPvt5f//+v///////////////+W1u//Pav////////b//+qolv/+uf////////b//+eolv/ilP///////////////+e1u//ilP///+rQ//bBOv///////////////+fB2v/Pa////////+fB2v/Pa/////////////b//+qolv/+uerQ//bBOv////D//+yobf//2f///wAA////////////+/T6///2/////f//+Ort9url79HN7Mi06bZ/5qZO7q4k///Z////////////5bW75ZsD5ZsD5ZsD5ZsD5ZsD5ZsD5ZsD5ZsD5ZsD55sD/+KU////////////////57W7/+KU////6tD/5ZsF5ZsD5ZsD5ZsD5ZsD5ZsD/89q////////58Ha5ZsE5ZsD5ZsD5ZsD5ZsD6psD//65////////////8P//7Kht///Z////AAD///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8AAP///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wAA////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////AAD///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8AAP///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wAA"
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Dec, DecLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return hBitmap
}