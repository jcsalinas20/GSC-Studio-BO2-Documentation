Godmode(player) 
{
	player endon( "disconnect" );
	
	if( !player.ClientHealth )
	{  player enableInvulnerability();  player.ClientHealth = true; }
	else
	{  player disableInvulnerability(); player.ClientHealth = false; }
	
	player ToggleScript( player, "Godmode", player.ClientHealth );
}

ToggleScript( player, Function, var )
{
	if( Function )
	{
		if( var )
			player iprintln( Function+" ^2ON" );
		else
			player iprintln( Function+" ^1OFF" );
	}
}

