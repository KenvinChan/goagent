Sub WriteIniVisible(isVisible)
    Set objFSO   = CreateObject("Scripting.FileSystemObject")

    Set objReadFile = objFSO.OpenTextFile("proxy.ini", 1)
    strContents = objReadFile.ReadAll()
    objReadFile.Close()

    Set regEx = New RegExp
    regEx.Pattern = "(visible\s*=[^\r]*)"
    regEx.IgnoreCase = True
    regEx.Global = True
    regEx.MultiLine = True
    strNewContents = regEx.Replace(strContents, "visible = " & isVisible)

    Set objWriteFile = objFSO.OpenTextFile("proxy.ini", 2)
    objWriteFile.Write(strNewContents)
    objWriteFile.Close()
End Sub

Sub Main()
    Set WshShell = WScript.CreateObject("WScript.Shell")

    If WshShell.Popup("是否将goagent.exe加入到启动项？(本对话框6秒后消失)", 6, "GoAgent 对话框", 1) = 1 Then
        If WshShell.Popup("是否显示托盘区图标？", 5, "GoAgent 对话框", 1) = 1 Then
            strTargetPath = WshShell.CurrentDirectory & "\goagent.exe"
        Else
            strTargetPath = WshShell.CurrentDirectory & "\proxy.exe"
        End If
        strStartup = WshShell.SpecialFolders("Startup")
        Set oShellLink = WshShell.CreateShortcut(strStartup & "\goagent.lnk")
        oShellLink.TargetPath = strTargetPath
        oShellLink.WindowStyle = 7
        oShellLink.Description = "GoAgent"
        oShellLink.WorkingDirectory = WshShell.CurrentDirectory
        oShellLink.Save

        WriteIniVisible "0"

        WshShell.Popup "成功加入GoAgent到启动项", 5, "GoAgent 对话框", 0
    End If
End Sub

Main
