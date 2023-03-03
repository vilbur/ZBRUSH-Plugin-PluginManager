#Include %A_LineFile%\..\ButtonGenerator.ahk

/** Class ScriptFileGenerator
*/
Class ScriptFileGenerator
{
	
	file	:= ""
	menu	:= ""
	submenu	:= ""

	ButtonGenerator := new ButtonGenerator(96, 48)
	
	__New( $file )
	{
		this.file := $file
		;MsgBox,262144,, ScriptFileGenerator, 2
		
		;this.plugins.push("A", "B")

		
		;this._getPluginsInFolder()
		
		;this._installPlugins()
		
		;this._uninstallPlugins()
		
		;MsgBox,262144,, % this.plugins[1], 2
		
	}
	
	/**
	 */
	create()
	{
		FileDelete, % this.file
		
		this.writeMenu()
		this.writeSubMenu()
	}
	
	/**
	 */
	writeScriptLoadButton( $script_path )
	{
		SplitPath, $script_path, $script_name, $script_dir, $script_ext, $script_noext, $script_drive

		$load_command := "[FileNameSetNext, """ $script_path """]"
		$load_command .= "`n	[IPress, ZScript:Load]"
		
		$button := this.ButtonGenerator.create( this.menu ":" this.submenu ":" $script_noext, $load_command, "Reload " $script_name )
		
		FileAppend, %$button%,	% this.file
	}
	
	/**
	 */
	writeMenu()
	{
		if( this.menu != "" )
			FileAppend, % "`n[IPalette, """ this.menu """]",	% this.file
	}
	
	/**
	 */
	writeSubMenu()
	{
		if( this.submenu != "" )
			FileAppend, % "`n[ISubPalette, """ this.submenu """]",	% this.file
	}
}

;/* CALL CLASS FUNCTION
;*/
;ScriptFileGenerator($parameter:="value"){
;	return % new ScriptFileGenerator($parameter)
;}


;/* EXECUTE CALL CLASS FUNCTION
;*/
;
;$ScriptFileGenerator := new ScriptFileGenerator("test-script.txt")
;
;$ScriptFileGenerator.menu := "Test"
;
;$ScriptFileGenerator.create()