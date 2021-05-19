/*
	    __     __                _____   _                  _ 
 		\ \   / /   ___   _ __  |_   _| (_)   ___    __ _  | |
  		 \ \ / /   / _ \ | '__|   | |   | |  / __|  / _` | | |
  		  \ V /   |  __/ | |      | |   | | | (__  | (_| | | |
  		   \_/     \___| |_|      |_|   |_|  \___|  \__,_| |_|
  		   
  		   //YouTube: VerTical C#

*/

//Example Call: self thread ToggleScript( "Godmode", self.Godmode );

ToggleScript( Function, var )
{
	if( Function )
	{
		if( var )
			self iprintln( Function+" ^2ON" );
		else
			self iprintln( Function+" ^1OFF" );
	}
}