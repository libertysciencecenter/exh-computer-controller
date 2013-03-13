;;;;;;;;;;;;;;;;;;;;;;;
; ID Vars
;;;;;;;;;;;;;;;;;;;;;;; 

; Our group database for the caches
CG := "EXHCOMPUTERCOMMAND"

; Get computer Id from the registery
RegRead, ComputerID, HKEY_LOCAL_MACHINE, SOFTWARE\EXHCOMMANDCENTER, ComputerName
if (ErrorLevel = 1) 
{
	RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\EXHCOMMANDCENTER, ComputerName, %computername%
	ComputerID = %computername%
}

;;;;;;;;;;;;;;;;;;;;;;;
; Functions
;;;;;;;;;;;;;;;;;;;;;;; 

getCacheData(key, group)
{
	Random, rand, 0.0, 10000.0
	url = http://api.lsc.local/v1/cache/get/?key=%key%&group=%group%&fake%rand%=%rand%
	UrlDownloadToFile, %url%, getCacheResult.txt
	FileRead, Contents, getCacheResult.txt
	FileDelete, getCacheResult.txt
	return Contents
}

setCacheData(key, value, group)
{
	Random, rand, 0.0, 10000.0
	url = http://api.lsc.local/v1/cache/set/?key=%key%&group=%group%&value=%value%&fake%rand%=%rand%
	UrlDownloadToFile, %url%, setCacheResult.txt
	FileRead, Contents, setCacheResult.txt
	FileDelete, setCacheResult.txt
	return Contents
}

deleteCacheKey(key, group)
{
	Random, rand, 0.0, 10000.0
	url = http://api.lsc.local/v1/cache/delete/?key=%key%&group=%group%&fake%rand%=%rand%
	UrlDownloadToFile, %url%, setCacheResult.txt
	FileRead, Contents, setCacheResult.txt
	FileDelete, setCacheResult.txt
	return Contents
}

;;;;;;;;;;;;;;;;;;;;;;;
; Instatiate UI
;;;;;;;;;;;;;;;;;;;;;;;

Menu, Tray, Click, 1
Menu, tray, add  ; Creates a separator line.
Menu, tray, add, Set computer name, MenuHandler 
Menu, Tray, Default,Set computer name

Gui, Add, Text,, Computer ID:
Gui, Add, Edit,W200 vID, %ComputerID%  ; The ym option starts a new column of controls.
Gui, Add, Button, default, OK  ; The label ButtonOK (if it exists) will be run when the button is pressed.

;;;;;;;;;;;;;;;;;;;;;;;
; Main Loop
;;;;;;;;;;;;;;;;;;;;;;;

;Add to the cache so it is discoverable
setCacheData(ComputerID,"READY", CG)

Loop
{
	data := getCacheData(ComputerID, CG)

	if ( InStr(data,"EVAL:") )
	{
		if (setCacheData(ComputerID,"READY", CG) = "1")
		{
			StringReplace, data, data, EVAL:
			StringReplace, data, data, |newline|, `n, All 
			FileDelete, eval.ahk
			FileAppend, %data%, eval.ahk
			Run, eval.ahk
			Sleep, 1000
			FileDelete, eval.ahk
		}
	}

	if ( InStr(data,"CMD:") )
	{
		if (setCacheData(ComputerID,"READY", CG) = "1")
		{
			if ( InStr(data,"CMD:RESTART") )
				Shutdown, 6
			else if ( InStr(data,"CMD:SHUTDOWN") )
				Shutdown, 5
		}
	}

	Sleep, 3000
}

;;;;;;;;;;;;;;;;;;;;;;;
; Hooks
;;;;;;;;;;;;;;;;;;;;;;;

MenuHandler:
Gui, Show,W300, Set Computer ID
return

ButtonOK:
Gui, Submit  ; Save the input from the user to each control's associated variable.
RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SOFTWARE\EXHCOMMANDCENTER, ComputerName, %ID%
deleteCacheKey(ComputerID,CG)
ComputerID = %ID%
setCacheData(ComputerID,"READY", CG)
return