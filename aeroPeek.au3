#include <Timers.au3>
Global $mouseCoord
Global $doLock = False
Global $mouse;




Global $iLimit = 600 ; idle limit in seconds

AdlibRegister("_CheckIdleTime", 500)


While 1
   ConsoleWrite('Start loop'&@CRLF)
   mainWait();
   ConsoleWrite('Idle time passed'&@CRLF);
   MouseMove(1910,1190);
   $mouseCoord = MouseGetPos()
   waitMove();
   ConsoleWrite('Mooved'&@CRLF);
   ;And $CmdLineRaw == '/s'
   if($doLock == True ) Then
	  Run("rundll32.exe user32.dll,LockWorkStation")
   EndIf
WEnd
   

Func _CheckIdleTime()
    If _Timer_GetIdleTime() > $iLimit * 1000 Then
	   return False
    Else
	   return True
	EndIf
EndFunc

Func _Quit()
    Exit
EndFunc



Func mainWait()
   While _CheckIdleTime() == True 
	  sleep(20)
   WEnd
EndFunc
 
Func waitMove()
   While mouseCheck() == True 
	  sleep(20)
   WEnd
EndFunc

 
 
 
Func mouseCheck()
   $mouse = MouseGetPos()
   if ($mouse[0] <> $mouseCoord[0] or  $mouse[1] <> $mouseCoord[1] ) Then
	  return False
   Else
	  return True
   EndIf   
EndFunc

    
	
	


  