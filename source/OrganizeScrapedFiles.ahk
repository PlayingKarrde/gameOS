#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;FileSelectFolder, WhichFolder 
Loop, Files, %A_ScriptDir%\media\*, R
{
	MediaFileNameArr := StrSplit(A_LoopFileName, "."A_LoopFileExt)
	MediaName := MediaFileNameArr[1]

	PathArr := StrSplit(A_LoopFileDir, "media\")
	Path := PathArr[2]

	if (Path == "fanart")
	{
		renameTo := "background"
	} 
	else if  (Path == "screenshot")
	{
		renameTo := "screenshot"
	} 
	else if  (Path == "box2dfront")
	{
		renameTo := "boxFront"
	} 
	else if  (Path == "wheel")
	{
		renameTo := "logo"
	} 
	else if  (Path == "steamgrid")
	{
		renameTo := "steamgrid"
	}
	else if  (Path == "videos")
	{
		renameTo := "video"
	}
	else
	{
		renameTo := "skip"
	}

	if (renameTo != "skip")
	{
		FileCreateDir, %A_ScriptDir%\media\%MediaName%
		FileMove, %A_LoopFileLongPath%, %A_ScriptDir%\media\%MediaName%\%renameTo%.%A_LoopFileExt%, 0
	}
}

MsgBox, 0, Complete