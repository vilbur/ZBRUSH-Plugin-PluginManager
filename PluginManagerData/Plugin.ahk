/** Class Plugin
*/
Class Plugin
{
	name	:= ""
	path_source	:= ""
	path_zbrush	:= ""
	installed	:= false

	suffixes	:= [".zsc", ".txt", "Data"]

	HardLinkCreator	:= new HardLinkCreator()

	/*
	*/
	__New( $path_source )
	{
		this.path_source := $path_source

		this._setScriptName()
	}

	/**
	 */
	install( $path_zbrush )
	{
		;this._checkMainPluginFile()
		this.path_zbrush := $path_zbrush

		$zsc_file := this._getPath(this.path_source, ".zsc")

		if( FileExist($zsc_file) )
		{
			this._createHardlinks()

			this.installed := true
		}
		;else
			;MsgBox,262144, PATH ERROR, % "Plugin " this.name " could not be installed.`n`nMAIN FILE IS MISSING:`n`n" $zsc_file
	}

	/** Set script name by plugin directory name
	 */
	_setScriptName()
	{
		SplitPath, % this.path_source, $script_name, $script_dir, $script_ext, $script_noext, $script_drive

		this.name := $script_name
	}

	/**
	 */
	_createHardlinks()
	{
		;if( FileExist($path_link) == "D" )
		For $index, $suffix in this.suffixes
			this.HardLinkCreator.createHardlink( this._getPath(this.path_source, $suffix), this._getPath(this.path_zbrush, $suffix) )
	}

	/**
	 */
	_getPath( $path, $suffix )
	{
		return this._sanitizeBackslashes( $path . "\\" . this.name . $suffix)
	}

	/**
	 */
	_sanitizeBackslashes( $path )
	{
		return % RegExReplace( $path, "[/\\]+", "\") ;"
	}
}