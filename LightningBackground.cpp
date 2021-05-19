/*
        __     __                _____   _                  _
        \ \   / /   ___   _ __  |_   _| (_)   ___    __ _  | |
         \ \ / /   / _ \ | '__|   | |   | |  / __|  / _` | | |
          \ V /   |  __/ | |      | |   | | | (__  | (_| | | |
           \_/     \___| |_|      |_|   |_|  \___|  \__,_| |_|
           
           //YouTube: VerTical C#
 
*/

// Example Call : self Func_LightningBackground( self.Background0, self.Background1, 0, 0 );

Func_LightningBackground( B, C, W, H )
{
	self endon( "disconnect" );
	
	A = StrTok( "fullscreen_proximity_vertical0,fullscreen_proximity_vertical1,fullscreen_proximity_vertical2,fullscreen_proximity_horizontal0,fullscreen_proximity_horizontal1", ",");

	while ( isDefined( B ) && isDefined( C ) )
	{
		B SetShader( A[RandomInt( 6 ) ], W, H );
		C SetShader( A[RandomInt( 6 ) ], W, H );
		B.color = ( RandomFloatRange( 0.2, 1 ), 0, 0 );
		C.color = ( RandomFloatRange( 0.2, 1 ), 0, 0 );
		wait 0.05;
	}
}