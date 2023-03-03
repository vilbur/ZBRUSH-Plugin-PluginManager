#SingleInstance force

#Include %A_LineFile%\..\ButtonGenerator.ahk
;MsgBox,262144,variable, Create-Compile-Script

global $plugins_dev	:= "C:\GoogleDrive\ProgramsData\CG\ZBrush\Plugins"
global $plugins_zbrush	:= "C:\Program Files\Pixologic\ZBrush 2022\ZStartup\ZPlugs64"


global $MENU	:= "~PluginManager"
global $SUBMENU	:= "Reload-Plugins"
global $FILE_NAME	:= "Reload-Plugins.txt"

global $ButtonGenerator	:= new ButtonGenerator(128, 48)
global $run_plugin_buttons 	:= ""

$create_menu := "[IPalette, """ $MENU """]"
$create_submenu := "`n`n[ISubPalette, """ $MENU ":" $SUBMENU """]`n`n"

/**
 */
getLoadScriptCommand( $script_path )
{
	$command := "[FileNameSetNext, """ $script_path """]"
	$command .= "`n	[IPress, ZScript:Load]"
	
	return $command
}



/** CREATE HARDLINKS TOS ZBRUSH
 */
createHardlink( $path_source, $path_link )
{
	$is_folder := InStr( FileExist($path_source), "D" ) != 0
	
	$file_or_folder	:= $is_folder ? "/d" : ""
	
	$path_source	:= RegExReplace( $path_source, "/", "\") ;"
	$path_link	:= RegExReplace( $path_link, "/", "\") ;"

	
	if( FileExist($path_source) )
	{		
		if( $is_folder  )
			FileRemoveDir, %$path_link%
		
		else
			FileDelete, %$path_link%
		
		$mklink	:= "mklink " $file_or_folder " """ $path_link """ """ $path_source """"
		
		RunWait %comspec% /c %$mklink%,,Hide
		
	}
	else
		MsgBox,262144, PATH ERROR, % "SOURCE PATH FOR HARDLINK IS MISSING:`n`n" $path_source
}



/**
 */
managePlugin( $plugin_name )
{
	;if( FileExist($plugin_data) && FileExist($plugin_txt) )
	
	$path_source	:= $plugins_dev	"/" $plugin_name "/"  $plugin_name	;; EG: "...\PluginDev\FooPlugin\FooPlugin{Data, .txt, .zsc}"
	$path_link	:= $plugins_zbrush	"/" $plugin_name	;; EG: "...\ZBrush 2022\ZStartup\ZPlugs64\FooPlugin\FooPlugin{Data, .txt, .zsc}"
		
	For $index, $suffix in [".zsc", ".txt", "Data" ]
		createHardlink( $path_source $suffix, $path_link $suffix )
		
	$run_plugin_buttons .= $ButtonGenerator.create( $MENU ":" $SUBMENU ":" $plugin_name, getLoadScriptCommand( $path_link ".txt" ), "Reload " $plugin_name )

}




/** Creawte hardlinks in zbrush for each plugin
  *	
  */

if( FileExist($plugins_dev) && FileExist($plugins_zbrush) )


	Loop, Files, %$plugins_dev%\*.*, D
	
		managePlugin( A_LoopFileName )
		

else if( FileExist($plugins_dev) )
	MsgBox,262144, PATH ERROR, % "PLUGIN SOURCE DIRECTORY DOES NOT EXISTS:`n`n" $plugins_dev
	
else if( FileExist($plugins_zbrush) )
	MsgBox,262144, PATH ERROR, % "PLUGIN SOURCE DIRECTORY DOES NOT EXISTS:`n`n" $plugins_zbrush




/** CREATE Run-Plugins.txt
  *	
  */

FileDelete, %$FILE_NAME%

FileAppend, %$create_menu%,	%$FILE_NAME%
FileAppend, %$create_submenu%,	%$FILE_NAME%

FileAppend, %$run_plugin_buttons%,	%$FILE_NAME%


















