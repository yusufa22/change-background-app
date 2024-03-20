Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs, args
set args = WScript.Arguments
strArgs = "cmd /c powershell.exe -executionpolicy bypass -windowstyle hidden -noninteractive -nologo -file " & CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName) + "\lockscreenmain.ps1" & " " & args(0)
oShell.Run strArgs, 0, falses