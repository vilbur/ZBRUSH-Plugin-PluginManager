#SingleInstance force

#Include %A_LineFile%\..\ScriptFileGenerator.ahk


/** Class PluginManager
*/
Class PluginManager
{
	
	ScriptFileGenerator := new ScriptFileGenerator()
	
	plugins_source	:= "C:\GoogleDrive\ProgramsData\CG\ZBrush\Plugins"
	plugins_zbrush	:= "C:\Program Files\Pixologic\ZBrush 2022\ZStartup\ZPlugs64"

	plugins	:= []
	suffixes	:= [".zsc", ".txt", "Data"]
	

	__New(){
		;this.parameter := $parameter
		;MsgBox,262144,, PluginManager, 2
		
		;this.plugins.push("A", "B")

		
		this._getPluginsInFolder()
		
		;this._installPlugins()
		
		;this._uninstallPlugins()
		
		this.ScriptFileGenerator.file := "Reload-Plugins.txt"
		
		this.ScriptFileGenerator.menu	:= "~PluginManager"
		this.ScriptFileGenerator.submenu	:= "Reload-Plugins"
		
		this.ScriptFileGenerator.create()
		
		For $index, $plugin in this.plugins
			this.ScriptFileGenerator.writeScriptLoadButton($plugin)
		
	}
	
	
	/** Create Hardlinks to Zbrush\Zplugs64
	 */
	_installPlugins()
	{
		;$plugins := this.plugins
		
		For $index, $plugin_path in this.plugins
			For $index, this.suffixes in [".zsc", ".txt", "Data" ]
				createHardlink( $plugin_path, $suffix )
			;MsgBox,262144,plugin, %$plugin%,3
		
	}
	
	/**
	 */
	_getPluginsInFolder()
	{
		Loop, Files, % this.plugins_source "\*.*", D
			this.plugins.push( this.sanitizeBackslashes(A_LoopFileFullPath))
	}
	
	/**
	 */
	_uninstallPlugins()
	{
		Loop, Files, % this.plugins_zbrush "\*.*"
			if( this._isHardlink( A_LoopFileFullPath ) )
				this._deleteFileOrFolder(A_LoopFileFullPath)
	}
	
	/**
	 */
	_deleteFileOrFolder($path)
	{
		if( this._isFolder($path) )
			FileRemoveDir, %$path%
		else
			FileDelete, %$path%
	}
	
	/**
	 */
	_isFolder( $path )
	{
		InStr( FileExist($path), "D" ) != 0
	}
	
	

	/** CREATE HARDLINKS TOS ZBRUSH
	 */
	createHardlink( $path_source, $path_link )
	{
		;$is_folder := InStr( FileExist($path_source), "D" ) != 0
		;
		;$file_or_folder	:= $is_folder ? "/d" : ""
		;
		;;$path_source	:= RegExReplace( $path_source, "/", "\") ;"
		;;$path_link	:= RegExReplace( $path_link, "/", "\") ;"
		;
		;
		;if( FileExist($path_source) )
		;{		
		;	if( $is_folder  )
		;		FileRemoveDir, %$path_link%
		;	
		;	else
		;		FileDelete, %$path_link%
		;	
		;	$mklink	:= "mklink " $file_or_folder " """ $path_link """ """ $path_source """"
		;	
		;	RunWait %comspec% /c %$mklink%,,Hide
		;	
		;}
		;else
		;	MsgBox,262144, PATH ERROR, % "SOURCE PATH FOR HARDLINK IS MISSING:`n`n" $path_source
	}
	
	
	/** isHardlink
	 */
	_isHardlink( $path )
	{
		SplitPath, $path, $dir_name, $path_parent
	
		objShell.Exec(comspec " /c dir /al /s c:\*.*")

		$objShell	:= ComObjCreate("WScript.Shell")
		$objExec	:= $objShell.Exec(comspec " /c dir """ $path_parent """ | find /i ""<SYMLINK""")
	
		$objExec_result := $objExec.StdOut.ReadAll()

		return RegExMatch( $objExec_result, "<SYMLINKD*>\s+" $dir_name ) ? 1 : 0
	}

	/**
	 */
	sanitizeBackslashes( $path )
	{
		return % RegExReplace( $path, "/", "\") ;"
	}
	
}
/* CALL CLASS FUNCTION
*/
PluginManager($parameter:="value"){
	return % new PluginManager($parameter)
}
/* EXECUTE CALL CLASS FUNCTION
*/
PluginManager()