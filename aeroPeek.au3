#include <Timers.au3>
Global Const $VK_NUMLOCK = 0x90
Global Const $VK_SCROLL = 0x91
Global Const $VK_CAPITAL = 0x14

Global $mouseCoord
Global $doLock = True
Global $mouse;

Global $currentTimer = 0
Global $needLock = False ;
Global $lowLimit = 60 ;
Global $iLimit = 200; idle limit in seconds
Global $lockNow = False 


AdlibRegister("_CheckIdleTime", 500)

HotKeySet ( "{SCROLLLOCK}" , "lockNow")

While 1
   ConsoleWrite('Start loop'&@CRLF)
   ConsoleWrite('Reset Lock'&@CRLF)
   $needLock = False ;
   mainWait();
   ConsoleWrite('Idle time passed'&@CRLF);
   $hWnd = DllCall("user32.dll", "hwnd", "FindWindow", "str", "Shell_TrayWnd", "int", 0)
   $pickerPost = WinGetPos($hWnd[0]);   
   
   ConsoleWrite($hWnd[0]&@CRLF);
   ConsoleWrite($pickerPost[0]&@CRLF);
   ConsoleWrite($pickerPost[1]&@CRLF);
   ConsoleWrite($pickerPost[2]&@CRLF);
   ConsoleWrite($pickerPost[3]&@CRLF);
   MouseMove($pickerPost[2]-5,$pickerPost[1]+$pickerPost[3]);
   waitWake();
   ConsoleWrite('Wake'&@CRLF);
   ;And $CmdLineRaw == '/s'
   ConsoleWrite('Need Lock : '& $needLock &@CRLF);
   if($doLock == True And $needLock == True) Then
	  ConsoleWrite('Should lock workstation'&@CRLF);
	  Run("rundll32.exe user32.dll,LockWorkStation")
   EndIf
   send("{SCROLLLOCK off}")
WEnd
   

Func _CheckIdleTime()
    If _Timer_GetIdleTime() > $lowLimit * 1000 Then
	   return False
    Else
	   return True
	EndIf
EndFunc

Func _Quit()
    Exit
EndFunc



Func mainWait()
   While _CheckIdleTime() == True And $lockNow == False
	  sleep(20)
   WEnd
   $lockNow = False 
EndFunc



Func waitWake()
   sleep(1000)
   While _Timer_GetIdleTime() > 0 or $lockNow == True
	  if((_Timer_GetIdleTime() >= $iLimit*1000 And $needLock == False) or $lockNow == True) Then
		 $needLock = True
		 $lockNow = False 		 
		 send("{SCROLLLOCK on}")
	  EndIf
	  sleep(20)
   WEnd
EndFunc

Func lockNow()
   if(_GetScrollLock() == '-127') Then
	  $lockNow = True
	  $needLock = True
   EndIf   
EndFunc
   
	
	






Func _GetNumLock()
    Local $ret
    $ret = DllCall("user32.dll","long","GetKeyState","long",$VK_NUMLOCK)
    Return $ret[0]
EndFunc

Func _GetScrollLock()
    Local $ret
    $ret = DllCall("user32.dll","long","GetKeyState","long",$VK_SCROLL)
    Return $ret[0]
EndFunc

Func _GetCapsLock()
    Local $ret
    $ret = DllCall("user32.dll","long","GetKeyState","long",$VK_CAPITAL)
    Return $ret[0]
EndFunc