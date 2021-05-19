init_modelchanger()
{
	self endon ( "disconnect" );
	self endon ( "Quit_Changer" );
	
	self setClientThirdPerson ( true );
	struct = spawnstruct();	
	struct.hud [ 0 ] = drawText ( "Press [{+attack}] or [{+speed_throw}] To Change Your Model, Cancel [{+melee}]", "default", 1.7, "CENTER", "CENTER", 0, 200, ( 1, 1, 1 ), 1, 2);
	struct.hud [ 1 ] = createShader( "white", "CENTER", "CENTER", 0, 200, 1000, 20, ( 0, 0, 0 ), .5, 1); 
	struct.list = strtok ( "spread;default;mg;rifle;smg", ";" ); //Thx To Patrick ( Extinct )!
	struct.index = int ( 0 );
	
	wait .3;
	while ( isDefined ( struct ) )
	{
		if ( self AttackButtonPressed () )
		{
			struct.index++;
			
			if( struct.index > 4 )
				struct.index = int ( 0 );
				
			self [[ game[ "set_player_model" ][ self.team ][ struct.list [ struct.index ] ] ]]();
			wait .1;
		}
		
		if ( self AdsButtonPressed () )
		{
			struct.index--;
			
			if( struct.index < int ( 0 ) )
				struct.index = 4;
				
			self [[ game[ "set_player_model" ][ self.team ][ struct.list [ struct.index ] ] ]]();
			wait .1;
		}
		
		if ( self MeleeButtonPressed() ) break;
		
		wait .05;
	}
	
	self setClientThirdPerson ( false );
	
	foreach ( hud in struct.hud )
	hud destroy ();
	
	struct = undefined;
	self notify ( "Quit_Changer" );
}