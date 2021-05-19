/*
        __     __                _____   _                  _
        \ \   / /   ___   _ __  |_   _| (_)   ___    __ _  | |
         \ \ / /   / _ \ | '__|   | |   | |  / __|  / _` | | |
          \ V /   |  __/ | |      | |   | | | (__  | (_| | | |
           \_/     \___| |_|      |_|   |_|  \___|  \__,_| |_|
           
           //YouTube: VerTical C#
 
*/

//Example Call: self thread Call_TitelFX( self.Weed["Titel"] );

Call_TitelFX( menu_Titel )
{
	while( menu_Titel )
	{
		if( self.Open )
			menu_Titel setTypeWriterFx(70, 4000, 1000);
		wait 6.5;
	}
}