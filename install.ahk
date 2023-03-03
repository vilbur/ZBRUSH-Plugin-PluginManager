#SingleInstance force

/** -------------------------------------------
  *
  *    CREATE HARDLINK FOR FILES AND FOLDERS
  *
  * -------------------------------------------
  */


/** Array of source paths for hardlinks
  *
  *	Path will be replace by paths
  *
  */
global $source_paths := [	"PluginManagerData"
	;,"PluginManager.txt" 
	,"PluginManager.zsc" ]

global $zbrush_plugins_path	:= "C:/Program Files/Pixologic/ZBrush 2022/ZStartup/ZPlugs64"



/** CREATE HARDLINKS TOS ZBRUSH
 */
createHardlink( $path_source, $path_link )
{
	$is_folder := InStr( FileExist($path_source), "D" ) != 0

	$file_or_folder	:= $is_folder ? "/d" : ""

	$mklink	:= "mklink " $file_or_folder " """ $path_link """ """ $path_source """"

	RunWait %comspec% /c %$mklink%,,Hide
}

/** LOOP SOURCE PATHS
 */
createHardlinks()
{
	;MsgBox,262144,search_and_replaces, % $search_and_replaces[1][1]

	For $index, $path in $source_paths
	{
		;$path_split	:= StrSplit( $path, "/",, 2 )

		$path_source := A_WorkingDir "/" $path
		$path_link := $zbrush_plugins_path "/" $path

		$path_source	:= RegExReplace( $path_source, "/", "\") ;"
		$path_link	:= RegExReplace( $path_link, "/", "\") ;"

		if( FileExist($path_link) == "D" )
			FileRemoveDir, %$path_link%

		else
			FileDelete, %$path_link%

		createHardlink( $path_source,	$path_link )
	}

	MsgBox,262144, SUCCESS, Hardlinks created
}

/** EXECUTE
  *
  */
createHardlinks()