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

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

init()
{
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    while( true )
    {
        level waittill( "connected", player );
       
        if( player isHost() )
            self.Client = "Host";
        else
            self.Client = "None";
           
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon( "disconnect" );
    level endon( "game_ended" );
   
    self.Open = false;
    self.Curs = int( 0 );
    self func_struct();
   
    self waittill( "spawned_player" );
   
    if( self.Client == "Host" )
    {
        self iprintln( "^2Menu Base" );
   
        while( self )
        {
            if( func_KeyPressed( "Melee" ) && func_KeyPressed( "Ads" ) && !self.Open )
            {
                self.Open = true;
                self func_Page( "Menu" );
                wait .3;
            }
           
            if( self.Open )
            {
                if( func_KeyPressed( "Melee" ) )
                {                  
                    if( self.last[ self.CurM ] == "Quit" )
                    {
                        self func_Delete();
                        self.Open = false;
                    }
                    else
                        self func_Page( self.last[ self.CurM ] );
                       
                    wait .3;
                }
               
                if( func_KeyPressed( "Ads" ) )
                {
                    self.Curs--;
                    self func_Scrollupdate();
                     wait .1;
                }
               
                if( func_KeyPressed( "Attack" ) )
                {
                    self.Curs++;
                    self func_Scrollupdate();
                    wait .1;
                }
               
                if( func_KeyPressed( "Use" ) )
                {
                    self thread[[self.func[ self.CurM ][ self.Curs ]]]( self.A1[ self.CurM ][ self.Curs ], self.A2[ self.CurM ][ self.Curs ], self.A3[ self.CurM ][ self.Curs ], self.A4[ self.CurM ][ self.Curs ], self.A5[ self.CurM ][ self.Curs ] );
                    wait .3;
                }
            }
            wait .05;
        }
    }
}

func_Create()
{
	for( i = 0; i < self.Text[ self.CurM ].size; i++ )
	{
		self.str[i] = drawText( self.Text[ self.CurM ][i], "default", 1.5, "CENTER", "CENTER", 0, -180 + int( 25 * i ), ( 1, 1, 1 ), 1, 3 );
		self.Background[i] = createShader( "white", "CENTER", "CENTER", 0, -180 + int( 25 * i ), 150, 20, ( 0, 0, 0 ), .5, 1 );
		wait .1;
	}
	self.Scroller = createShader( "white", "CENTER", "CENTER", 0, -180, 150, 20, ( 0, 0, 1 ), .3, 2 );
}

func_Delete()
{
    if( isDefined( self.str ) )
    {
    	self.Scroller destroy();
		for( i = 0; i < self.str.size; i++ )
		{
            self.str[i] destroy();
            self.Background[i] destroy();
            wait .1;
        }
    }
}

func_Page( str )
{
    self.CurM = str;
    self.Curs = int( 0 );
    self func_Delete();
	self func_Create();
    self func_Scrollupdate();
}

func_struct()
{
    func_men( "Menu", "Quit" );
    func_opt( "Menu", 0, "Option1", ::func_Page, "Basic" );
    func_opt( "Menu", 1, "Option2", ::Test );
    func_opt( "Menu", 2, "Option3", ::Test );
    func_opt( "Menu", 3, "Option4", ::Test );
    func_opt( "Menu", 4, "Option5", ::Test );
    
    func_men( "Basic", "Menu" );
    func_opt( "Basic", 0, "Option1", ::Test );
}

func_opt( str, str1, str2, str3, str4, str5, str6, str7, str8 )
{
    self.Text[ str ][ str1 ] = str2;
    self.func[ str ][ str1 ] = str3;
    self.A1[ str ][ str1 ] = str4;
    self.A2[ str ][ str1 ] = str5;
    self.A3[ str ][ str1 ] = str6;
    self.A4[ str ][ str1 ] = str7;
    self.A5[ str ][ str1 ] = str8;
}

func_men( str, str1 )
{
    self.last[ str ] = str1;
}

func_Scrollupdate()
{
    if( self.Curs < 0 )
        self.Curs = self.Text[ self.CurM ].size -1;
   
    if( self.Curs > self.Text[ self.CurM ].size -1 )
        self.Curs = int( 0 );
   
    self.Scroller.y = -180 + int( self.Curs * 25 );
}

Test()
{
    self iprintln( "Cursor pos: " + self.Curs + 1 );
}

func_KeyPressed( C_Key )
{  
    if( C_Key == "Jump" )
        return self jumpbuttonpressed();
       
    if( C_Key == "Stance" )
        return self stancebuttonpressed();
       
    if( C_Key == "Frag" )
        return self fragbuttonpressed();
       
    if( C_Key == "Inventory" )
        return self inventorybuttonpressed();
       
    if( C_Key == "Sprint" )
        return self sprintbuttonpressed();
       
    if( C_Key == "Melee" )
        return self meleebuttonpressed();
       
    if( C_Key == "Ads" )
        return self adsbuttonpressed();
       
    if( C_Key == "Attack" )
        return self attackbuttonpressed();
       
    if( C_Key == "Seat" )
        return self changeseatbuttonpressed();
       
    if( C_Key == "Use" )
        return self usebuttonpressed();
       
    if( C_Key == "D-Up" )
        return self actionslotonebuttonpressed();
       
    if( C_Key == "D-Down" )
        return self actionslottwobuttonpressed();
       
    if( C_Key == "D-Left" )
        return self actionslotthreebuttonpressed();
       
    if( C_Key == "D-Right" )
        return self actionslotfourbuttonpressed();
   
    if( C_Key == "" )
        return break;
}

createShader(shader, align, relative, x, y, width, height, color, alpha, sort)
{
    hud = newClientHudElem(self);
    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud setPoint(align, relative, x, y);
    hud.hideWhenInMenu = true;
    return hud;
}

drawText(text, font, fontScale, align, relative, x, y, color, alpha, sort)
{
    hud = self createFontString(font, fontScale);
    hud setPoint(align, relative, x, y);
    hud.color = color;
    hud.alpha = alpha;
    hud.hideWhenInMenu = true;
    hud.sort = sort;
    hud.foreground = true;
    hud setText(text);
    return hud;
}