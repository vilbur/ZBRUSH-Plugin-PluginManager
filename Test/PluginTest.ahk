#SingleInstance force


#Include %A_LineFile%\..\..\PluginManagerData\PluginManager.ahk


$Plugin := new Plugin( A_WorkingDir "\FooPlugin")


$Plugin.install("C:\Program Files\Pixologic\ZBrush 2022\ZStartup\ZPlugs64")


;MsgBox,262144,, % $Plugin.path_source
;MsgBox,262144,, % $Plugin.name