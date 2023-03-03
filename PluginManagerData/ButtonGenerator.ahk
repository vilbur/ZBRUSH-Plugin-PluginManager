#SingleInstance force

/** Generate button for Zscript
*/
Class ButtonGenerator 
{

	__New( $width := "", $height := "" )
	{
		this.width	:= $width
		this.height	:= $height
		this.hotkey	:= ""
		this.icon	:= ""
		this.disabled	:= ""	
	}
	
	/**
	 */
	create( $name, $command, $tooltip := "", $hotkey := "", $disabled := "", $icon := ""  )
	{
		
		if( $icon != "" )
			$icon := " """ $icon """"
		
		
		$button := "`n[IButton, """ $name """, """ $tooltip ""","
		
		$button .= "`n	" $command
				
		$button .= "`n, " $disabled ", " this.width ", " $hotkey ", " $icon ", " this.height " ]`n"
		
		return % $button
	}
}