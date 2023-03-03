#SingleInstance force

#Include %A_LineFile%\..\ScriptFileGenerator.ahk
#Include %A_LineFile%\..\Plugin.ahk


/** Class PluginManager
*/
Class PluginManager
{
	
	ScriptFileGenerator := new ScriptFileGenerator()
	
	plugins_source	:= ""
	plugins_zbrush	:= ""

	Plugins	:= []
	

	__New( $plugins_source, $plugins_zbrush )
	{
		this.plugins_source := $plugins_source
		this.plugins_zbrush := $plugins_zbrush
		
		if( FileExist($plugins_source) && FileExist($plugins_zbrush) )
			this._getPluginsInFolder()
			
		else if( ! FileExist($plugins_source) )
			MsgBox,262144, PATH ERROR, % "PLUGIN SOURCE DIRECTORY DOES NOT EXISTS:`n`n" $plugins_source
			
		else if( ! FileExist($plugins_zbrush) )
			MsgBox,262144, PATH ERROR, % "PLUGIN INSTALL DIRECTORY DOES NOT EXISTS:`n`n" $plugins_zbrush
		
	}
	
	/** Create Hardlinks to Zbrush\Zplugs64
	 */
	_installPlugins()
	{
		For $index, $Plugin in this.Plugins
			$Plugin.install(this.plugins_zbrush)
	}
	
	/** Create Hardlinks to Zbrush\Zplugs64
	 */
	_createReloadScript()
	{
		this.ScriptFileGenerator.file := "Reload-Plugins.txt"
		
		this.ScriptFileGenerator.menu	:= "~PluginManager"
		this.ScriptFileGenerator.submenu	:= "Plugins"
		
		this.ScriptFileGenerator.create()
		
		For $index, $Plugin in this.plugins
			if( $Plugin.installed )
				this.ScriptFileGenerator.writeScriptLoadButton( $Plugin._getPath( this.plugins_zbrush, ".txt" ) )
	}
	
	/**
	 */
	_getPluginsInFolder()
	{
		Loop, Files, % this.plugins_source "\*.*", D
			this.Plugins.push( new Plugin(A_LoopFileFullPath) )
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

}


$PluginManager := new PluginManager("C:\GoogleDrive\ProgramsData\CG\ZBrush\Plugins", "C:\Program Files\Pixologic\ZBrush 2022\ZStartup\ZPlugs64")

$PluginManager._installPlugins()
		
$PluginManager._createReloadScript()