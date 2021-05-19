
init_prestige() //Credits : VerTical.
{
	self endon ( "disconnect" );
	self endon ( "quit_editor" );
	
	self Call_Close();
	
	struct = spawnstruct ();
	
	struct.list =  strtok ( "rank_com,rank_prestige01,rank_prestige02,rank_prestige03,rank_prestige04,rank_prestige05,rank_prestige06,rank_prestige07,rank_prestige08,rank_prestige09,rank_prestige10,rank_prestige11", "," );
	struct.index = int ( 0 );
	struct.hud [ 0 ] = createShader ( struct.list [ struct.index ], "CENTER", "CENTER", 0, 0, 50, 50, ( 1, 1, 1 ), 1, 2 );
	struct.hud [ 1 ] = drawText ( "[{+attack}]/[{+speed_throw}] Prestige Value, [{+usereload}] Use Value, Cancel [{+melee}]", "default", 1.5, "CENTER", "CENTER", 0, 80, ( 1, 1, 1 ), 1, 2);
	struct.hud [ 2 ] = drawText ( "Prestige Editor", "default", 2.0, "LEFT", "CENTER", -140, -80, ( 1, 1, 1 ), 1, 2);
	struct.hud [ 3 ] = createShader ( "white", "CENTER", "CENTER", 0, 0, 300, 200, ( 0, 0, 0 ), .5, 1 );
	
	wait .3;
	while ( isDefined ( struct ) )
	{
	
		if ( self AttackButtonPressed () )
		{
			struct.index++;
			
			if( struct.index > 11 )
				struct.index = int ( 0 );
				
			struct.hud [ 0 ] setShader ( struct.list [ struct.index ], 50, 50 );
			wait .1;
		}
		
		if ( self AdsButtonPressed () )
		{
			struct.index--;
			
			if( struct.index < int ( 0 ) )
				struct.index = 11;
				
			struct.hud [ 0 ] setShader ( struct.list [ struct.index ], 50, 50 );
			wait .1;
		}
		
		if ( self usebuttonpressed () )
		{
			self.pres [ "prestige" ] = struct.index;
			self setdstat ( "playerstatslist", "plevel", "StatValue", struct.index );
			self iprintln ( "Prestige set to ^2" + struct.index );
			wait .3;
			break;
		}
		
		if ( self MeleeButtonPressed() ) break;
		
		wait .05;
	}
	foreach ( hud in struct.hud )
	hud destroy ();
	
	struct = undefined;
	self notify ( "quit_editor" );
}