#SingleInstance force

#Include %A_LineFile%\..\ScriptFileGenerator.ahk
#Include %A_LineFile%\..\Plugin.ahk


/** Class PluginManager
*/
Class PluginManager
{
	
	ScriptFileGenerator := new ScriptFileGenerator()
	
	plugins_source	:= "C:\GoogleDrive\ProgramsData\CG\ZBrush\Plugins"
	plugins_zbrush	:= "C:\Program Files\Pixologic\ZBrush 2022\ZStartup\ZPlugs64"

	plugins	:= []
	suffixes	:= [".zsc", ".txt", "Data"]
	

	__New()
	{
		;this.parameter := $parameter
		;MsgBox,262144,, PluginManager, 2
		
		;this.plugins.push("A", "B")

		
		this._getPluginsInFolder()
		
		this._installPlugins()
		
		;this._uninstallPlugins()
		
		;this.ScriptFileGenerator.file := "Reload-Plugins.txt"
		;
		;this.ScriptFileGenerator.menu	:= "~PluginManager"
		;this.ScriptFileGenerator.submenu	:= "Reload-Plugins"
		;
		;this.ScriptFileGenerator.create()
		;
		;For $index, $plugin in this.plugins
		;	this.ScriptFileGenerator.writeScriptLoadButton($plugin)
		
	}
	
	/** Create Hardlinks to Zbrush\Zplugs64
	 */
	_installPlugins()
	{
		For $index, $Plugin in this.plugins
			$Plugin.install(this.plugins_zbrush)
	}
	
	/**
	 */
	_getPluginsInFolder()
	{
		Loop, Files, % this.plugins_source "\*.*", D
			this.plugins.push( new Plugin(A_LoopFileFullPath) )
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


;/* CALL CLASS FUNCTION
;*/
;PluginManager($parameter:="value"){
;	return % new PluginManager($parameter)
;}
;/* EXECUTE CALL CLASS FUNCTION
;*/
;PluginManager()