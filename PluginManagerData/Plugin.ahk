#SingleInstance force


/** Class Plugin
*/
Class Plugin
{
	name	:= ""
	path_source	:= ""
	path_zbrush	:= ""
	installed	:= false
	
	suffixes	:= [".zsc", ".txt", "Data"]

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
		else
			MsgBox,262144, PATH ERROR, % "Plugin " this.name " could not be installed.`n`nMAIN FILE IS MISSING:`n`n" $zsc_file
	}
	
	/**
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
			this._createHardlink( this._getPath(this.path_source, $suffix), this._getPath(this.path_zbrush, $suffix) )
	}
	
	/** CREATE HARDLINKS TOS ZBRUSH
	 */
	_createHardlink( $path_source, $path_link )
	{
		$is_folder := InStr( FileExist($path_source), "D" ) != 0
		
		$file_or_folder	:= $is_folder ? "/d" : ""
		
		if( FileExist($path_source) )
		{		
			if( $is_folder  )
				FileRemoveDir, %$path_link%
			
			else
				FileDelete, %$path_link%
			
			$mklink	:= "mklink " $file_or_folder " """ $path_link """ """ $path_source """"
			
			RunWait %comspec% /c %$mklink%,,Hide
		}
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