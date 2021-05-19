/*
          __     __                _____   _                  _
          \ \   / /   ___   _ __  |_   _| (_)   ___    __ _  | |
           \ \ / /   / _ \ | '__|   | |   | |  / __|  / _` | | |
            \ V /   |  __/ | |      | |   | | | (__  | (_| | | |
             \_/     \___| |_|      |_|   |_|  \___|  \__,_| |_|
             #WeMakeModdingGreatAgain!
           
           *YouTube :
                        *Link : 
           *Helpful Resource :
                        *Link : http://pastebin.com/u/VerTical_Dev
*/

init_viewModelChanger()
{
	self endon ( "disconnect" );
	level endon ( "Quit_Changer" );
	
	struct = spawnstruct ();
	struct.hud [ 0 ] = drawText ( "Press [{+attack}] or [{+speed_throw}] To Change The view Model", "default", 1.8, "CENTER", "CENTER", 0, 200, ( 1, 1, 1 ), 1, 2);
	struct.hud [ 1 ] = createShader( "white", "CENTER", "CENTER", 0, 200, 1000, 20, ( 0, 0, 0 ), .5, 1); 
	struct.index = int ( 0 );
	struct.items = strTok ( "c_mul_mp_cordis_assault_viewhands|c_chn_mp_pla_longsleeve_viewhands|c_usa_mp_isa_assault_viewhands|c_mul_mp_pmc_longsleeve_viewhands|c_usa_mp_fbi_longsleeve_viewhands|c_usa_mp_seal6_longsleeve_viewhands|iw5_viewmodel_usa_sog_standard_arms|iw5_viewmodel_vtn_nva_standard_arms|c_mul_mp_cordis_lmg_viewhands|c_chn_mp_pla_armorsleeve_viewhands|c_usa_mp_isa_lmg_viewhands|c_mul_mp_cordis_shotgun_viewhands|c_usa_mp_isa_shotgun_viewhands|c_mul_mp_pmc_shortsleeve_viewhands|c_usa_mp_seal6_shortsleeve_viewhands|c_mul_mp_cordis_smg_viewhands|c_usa_mp_isa_smg_viewhands|c_usa_mp_fbi_shortsleeve_viewhands|c_mul_mp_cordis_sniper_viewhands|c_usa_mp_isa_sniper_viewhands", "|" );
	wait .3;
	while( isDefined ( struct ) )
	{
		self setViewModel ( struct.items [ struct.index ] );
		
		if ( self adsButtonPressed () ) { wait .1;
			struct.index--; }
		
		if ( self attackButtonPressed () ) { wait .1;
			struct.index++; }
		
		if ( self usebuttonpressed () ) { wait .3;
			break; }
		
		if ( struct.index < 0 )
			struct.index = struct.items.size;
		
		if ( struct.index > struct.items.size )
			struct.index = 0;
			
		wait .05;
	}
	self iprintln ( "Model set to : ^2" + struct.items [ struct.index ] );
	
	foreach( hud in struct.hud )
	hud destroy ();
	
	struct = undefined;
	self notify ( "Quit_Changer" );
}