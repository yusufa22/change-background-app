param($FolderPath)
[xml]$lockscreenchange = get-content .\win_scheduler_templates\lock_screen_change_template
[xml]$desktopbackgroundchange = get-content .\win_scheduler_templates\desktop_background_change_template

#FORMAT FOLDERPATH HERE

$lockscreenchange.Task.Actions.Exec.Arguments = $FolderPath
$desktopbackgroundchange.Task.Actions.Exec[0].Arguments = $FolderPath
$lockscreenchange.Task.Actions.Exec.Command = "$pwd" + "\lockscreen\change-lock-screen.vbs"
$desktopbackgroundchange.Task.Actions.Exec[0].Command = "$pwd" + "\desktop\app\bin\Release\net8.0\publish\app.exe"
$desktopbackgroundchange.Task.Actions.Exec[1].Command = "$pwd" + "\desktop\minimize_windows.vbs"

$lockscreenchange.Save(".\win_scheduler_templates\lock_screen_change_template")
$desktopbackgroundchange.Save(".\win_scheduler_templates\desktop_background_change_template")