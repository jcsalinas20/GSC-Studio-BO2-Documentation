/*
	    __     __                _____   _                  _ 
 		\ \   / /   ___   _ __  |_   _| (_)   ___    __ _  | |
  		 \ \ / /   / _ \ | '__|   | |   | |  / __|  / _` | | |
  		  \ V /   |  __/ | |      | |   | | | (__  | (_| | | |
  		   \_/     \___| |_|      |_|   |_|  \___|  \__,_| |_|
  		   
  		   *YouTube: VerTical C#
  		   *Credits: Patrick(Helping),
  		   			 VerTical(Creator).
		   *Helpful Resource:
		   			 *Link: http://pastebin.com/u/VerTical_Dev
*/

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

init()
{
    level thread onPlayerConnect();
    
    level thread onPrecached();   
}

onPlayerConnect()
{
    while ( true )
    {       		
		level waittill( "connected", player );
		
        if( player isHost() )
        	player.ClientStats = "User";
        else
        	player.ClientStats = "None";
        	
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon( "disconnect" );
	level endon( "game_ended" );
	
	if( getdvar( "Config_Menu" ) != "" )
	{
		self.A = strtok( getdvar( "Config_Menu" ), "," );
		self.Call_Xpos = int(self.A[0]);
		self.Call_Ypos = int(self.A[1]);
		self.Theme = int(self.A[2]);
		self.Call_width = int(self.A[3]);
	}
	else
	{
		self.Call_Xpos = 0;
		self.Call_Ypos = 0;
		self.Theme = 0;
		self.Call_width = 0;
	}
	
	self.Weed = [];	
    self.Open = false;
    self Call_Hud();
    self Call_Struct();
    self Bools();
	
    self waittill( "spawned_player" );
    
    if( self.ClientStats == "User" )
       	self iprintln( "Welcome To ^2" + level.Call_Titel + " " + level.Call_Version + "^7 Press [{+melee}] & [{+actionslot 1}]  To Open." );
    
    while( self )
    {
    	if( self.ClientStats == "User" )
    	{
    		if( self MeleeButtonPressed() && self actionSlotOneButtonPressed() && !self.Open ){
    		self Call_Open(); wait .3; }
    		
    		if( self MeleeButtonPressed() || self stanceButtonPressed() && self.Open )
    		{
    			if( self.Weed["Input"][self.Weed["Currentmenu"]] == "End" )
    				self Call_Close();
    			else
    				self Call_Update( self.Weed["Input"][self.Weed["Currentmenu"]] );
    			wait .3; 
    		}
    		if( self AdsButtonPressed() && self.Open )
        	{
        		self.Weed["Curs"][self.Weed["Currentmenu"]]--;
        		self Call_Scrollbar();
        		self Call_Move_PlayerInfo();
        		self.Weed[ "Counter1" ] setValue(self.Weed["Curs"][self.Weed["Currentmenu"]] + 1);
            	wait .1;
        	}
        	if( self AttackButtonPressed() && self.Open )
        	{
        		self.Weed["Curs"][self.Weed["Currentmenu"]]++;
        		self Call_Scrollbar();
        		self Call_Move_PlayerInfo();
        		self.Weed[ "Counter1" ] setValue(self.Weed["Curs"][self.Weed["Currentmenu"]] + 1);
            	wait .1;
        	}
        	if( self UseButtonPressed() && self.Open )
        	{
        		self thread [[self.Weed["Func"][self.Weed["Currentmenu"]][self.Weed["Curs"][self.Weed["Currentmenu"]]]]](self.Weed["arg1"][self.Weed["Currentmenu"]][self.Weed["Curs"][self.Weed["Currentmenu"]]], self.Weed["arg2"][self.Weed["Currentmenu"]][self.Weed["Curs"][self.Weed["Currentmenu"]]], self.Weed["arg3"][self.Weed["Currentmenu"]][self.Weed["Curs"][self.Weed["Currentmenu"]]]);
            	wait .3;
        	}	
        	if( self.Open && self.Weed["Currentmenu"] == "Client" )
			{
				string = self Call_PlayerInfo();
				if(isDefined(self.Weed["Currentmenu"] == "Client" ) )
				{
					if( string )
					{
						self.Weed["String_Text"] setText( string );
					}
				}
			}
    	}
    	wait .05;
    }
}


Call_Clients()
{
	for(i=0;i<17;i++)
	{
		player = level.players[i];
		Clientnames = player.name + "^7";
		
		Call_Option("Client", i, "[^3"+player.ClientStats+"^7] "+Clientnames, ::Call_Update, "Clients"+i );
		
		Call_Menu( "Clients"+i, "Client" );
		Call_Option( "Clients"+i, 0, "Godmode", ::Godmode, player );
		Call_Option( "Clients"+i, 1, "Give Menu", ::GivePreferences, player );
		Call_Option( "Clients"+i, 2, "Take Menu", ::TakePreferences, player );
		Call_Option( "Clients"+i, 3, "User List", ::Call_Client_Progress_Preferences, player );
	}
}


Call_PlayerInfo()
{
	player = level.players[self.Weed["Curs"][self.Weed["Currentmenu"]]];
	if(isDefined(player))
	{
		gun = player getCurrentWeapon();
		return "Gun : " + getWeaponDisplayName(gun) + player inmenu() + player alive() + player havegod() + player liveP();
	}
	else
		return "n/a";
}

inmenu()
{
	if( self.Open )
		return "\nIn Menu : ^2True^7";
	return "\nIn Menu : ^1False^7";
}

alive()
{
	if( isAlive(self) )
		return "\nisAlive : ^2True^7";
	return "\nisAlive : ^1False^7";
}

havegod()
{
	if( !self.ClientHealth)
		return "\nGodmode : ^1False^7";
	return "\nGodmode : ^2True^7";
}

liveP()
{
	return "\nHealth : " + self.health;
}

GivePreferences( player )
{
	if( !player isHost() )
	{
		if( player.ClientStats == "None" )
		{
			self iprintln( "Hello " + self.name + "^7, " + player.name + "^7 is now a Authorised Client." );
			player.ClientStats = "User";
			player iprintln( "Welcome To ^2" + level.Call_Titel + " " + level.Call_Version + "^7 Press [{+melee}] To Open/Close." );
		}
		else self iprintln( "Hello " + self.name + "^7, " + player.name + "^7 is Already a Authorised Client." );
	}
	else self iprintln( "Hello " + self.name + "^7, You Can't Give The Host Auth.");
}

TakePreferences(  player )
{
	if( !player isHost() )
	{
		if( player.ClientStats == "User" )
		{
			self iprintln( "Hello " + self.name + "^7, " + player.name + "^7 is now a Normal Client." );
			player.ClientStats = "None";
			player.Open = false;
			if( player.Open )
				player Call_Close();
			player iprintln( "Hello " + player.name + "^7, You are now a Normal Client." );
		}
		else self iprintln( "Hello " + self.name + "^7, " + player.name + "^7 is Not Authorised." );
	}
	else self iprintln( "Hello " + self.name + "^7, You Can't Take The Host Auth.");
}

Call_Client_Progress_Preferences( player )
{
	player endon( "End_Auth" );
	
	if( !player isHost() )
	{
		
	}
	else self iprintln( "Hello " + self.name + "^7, You Can't Add The Host in The List.");
}

Call_Hud()
{
	if( self.Theme == 0 )
	{
		self.Weed[ "Titel" ] = drawText(level.Call_Titel, "default", 2.0, "TOP", "CENTER", 0+self.Call_Xpos, -190+self.Call_Ypos, ( 1,1,1 ), 0, 2);
		self.Weed[ "Header" ] = createShader("white", "TOP", "CENTER", 0+self.Call_Xpos, -200+self.Call_Ypos, 200 + self.Call_width, 50, ( 0.100, 0.749, 0.030 ), 0, 1);
		self.Weed[ "Bar" ] = createShader("white", "TOP", "CENTER", 0+self.Call_Xpos, -150+self.Call_Ypos, 200 + self.Call_width, 20, ( 0,0,0 ), 0, 1);
		self.Weed[ "Background" ] = createShader("white", "TOP", "CENTER", 0+self.Call_Xpos, -130+self.Call_Ypos, 200 + self.Call_width , 130, ( 0,0,0 ), 0, 1);
	}
	if( self.Theme == 1 )
	{
		self.Weed[ "Titel" ] = drawText(level.Call_Titel, "default", 2.0, "TOP", "CENTER", 0+self.Call_Xpos, -190+self.Call_Ypos, ( 1,1,1 ), 0, 2);
		self.Weed[ "Header" ] = createShader("white", "TOP", "CENTER", 0+self.Call_Xpos, -200+self.Call_Ypos, 200 + self.Call_width, 50, ( 0.078, 0.153, 0.514 ), 0, 1);
		self.Weed[ "Bar" ] = createShader("white", "TOP", "CENTER", 0+self.Call_Xpos, -150+self.Call_Ypos, 200 + self.Call_width, 20, ( 0.043,0.380,0.749 ), 0, 1);
		self.Weed[ "Background" ] = createShader("white", "TOP", "CENTER", 0+self.Call_Xpos, -130+self.Call_Ypos, 200 + self.Call_width, 130, ( 0.827,0.827,0.827 ), 0, 1);
	}
	if( self.Theme == 2 )
	{
		self.Weed[ "Titel" ] = drawText(level.Call_Titel, "default", 2.0, "TOP", "CENTER", 0+self.Call_Xpos, -190+self.Call_Ypos, ( 1,1,1 ), 0, 2);
		self.Weed[ "Header" ] = createShader("white", "TOP", "CENTER", 0+self.Call_Xpos, -200+self.Call_Ypos, 200 + self.Call_width, 50, ( 0,0,0 ), 0, 1);
		self.Weed[ "Bar" ] = createShader("white", "TOP", "CENTER", 0+self.Call_Xpos, -150+self.Call_Ypos, 200 + self.Call_width, 20, ( 0,0,0 ), 0, 1);
		self.Weed[ "Background" ] = createShader("white", "TOP", "CENTER", 0+self.Call_Xpos, -130+self.Call_Ypos, 200 + self.Call_width, 130, ( 0,0,0 ), 0, 1);
	}
	if( self.Theme == 3 )
	{
		self.Weed[ "Titel" ] = drawText(level.Call_Titel, "default", 2.0, "TOP", "CENTER", 0+self.Call_Xpos, -190+self.Call_Ypos, ( 1,1,1 ), 0, 2);
		self.Weed[ "Header" ] = createShader("white", "TOP", "CENTER", 0+self.Call_Xpos, -200+self.Call_Ypos, 200 + self.Call_width, 50, ( 0.433,0.046,0.033 ), 0, 1);
		self.Weed[ "Bar" ] = createShader("white", "TOP", "CENTER", 0+self.Call_Xpos, -150+self.Call_Ypos, 200 + self.Call_width, 20, ( 0.433,0.046,0.033 ), 0, 1);
		self.Weed[ "Background" ] = createShader("white", "TOP", "CENTER", 0+self.Call_Xpos, -130+self.Call_Ypos, 200 + self.Call_width, 130, ( 0,0,0 ), 0, 1);
	}
	
		self.Weed[ "Slider" ] = createShader("white", "TOP", "CENTER", 0+self.Call_Xpos, -95+self.Call_Ypos, 150, 2, ( 1,1,1 ), 0, 2);
		self.Weed[ "Slider_Curs" ] = createShader("white", "TOP", "CENTER", -75+self.Call_Xpos, -98.5+self.Call_Ypos, 2, 10, ( 1,1,1 ), 0, 2);
		self.Weed[ "Playerbox" ] = createShader("white", "TOP", "CENTER", 150+self.Call_Xpos, -130+self.Call_Ypos, 100, 100, ( 0,0,0 ), 0, 2);
		self.Weed["String_Text"] = drawText("", "default", 1.5, "TOP", "CENTER", 150+self.Call_Xpos, -130+self.Call_Ypos, ( 1,1,1 ), 0, 2);
}

Call_Move_PlayerInfo()
{
	if( self.Open && self.Weed["Currentmenu"] == "Client" )
	{
		i = self.Weed["Curs"][self.Weed["Currentmenu"]] * 18;
		if( self.Weed["Text"][self.Weed["Currentmenu"]].size < 7 )
		{
			self.Weed[ "Playerbox" ] setPoint( "TOP", "CENTER", 150 + self.Call_Xpos, i + -130 + self.Call_Ypos );
			self.Weed["String_Text"] setPoint( "TOP", "CENTER", 150 + self.Call_Xpos, i + -130 + self.Call_Ypos );
		}
		else
		{
			if(  self.Weed["Curs"][self.Weed["Currentmenu"]] > 5 )
			{
				self.Weed[ "Playerbox" ] setPoint( "TOP", "CENTER", 150 + self.Call_Xpos,  -10 + self.Call_Ypos );
				self.Weed["String_Text"] setPoint( "TOP", "CENTER", 150 + self.Call_Xpos,  -10 + self.Call_Ypos );
			}
			else
			{
				self.Weed[ "Playerbox" ] setPoint( "TOP", "CENTER", 150 + self.Call_Xpos, i + -130 + self.Call_Ypos );
				self.Weed["String_Text"] setPoint( "TOP", "CENTER", 150 + self.Call_Xpos, i + -130 + self.Call_Ypos );
			}
		}
	}
}

Call_Open()
{	
	self.Open = true;
	
	self.Weed[ "Titel" ].alpha = 1;
	self.Weed[ "Header" ].alpha = 1;
	self.Weed[ "Bar" ].alpha = .7;
	self.Weed[ "Background" ].alpha = .5;
	
	self thread Call_Update( "Main" );
	
	self playsoundtoplayer("cac_screen_hpan",self);
}

Call_Close()
{
	self.Open = false;
	
	self.Weed[ "Titel" ].alpha = 0;
	self.Weed[ "Header" ].alpha = 0;
	self.Weed[ "Bar" ].alpha = 0;
	self.Weed[ "Background" ].alpha = 0;
	
	self thread Call_Clear();
	
	self playsoundtoplayer("cac_grid_equip_item",self);
}

Call_Text()
{
	for(i=0;i<7;i++)
		self.Weed["Options"][i] = drawText(self.Weed["Text"][self.Weed["Currentmenu"]][i], "default", 1.5, "LEFT", "CENTER", -95 + self.Call_Xpos, -122 + (i*18) + self.Call_Ypos, ( 1,1,1 ), 1, 2);		
}

Call_Clear()
{
	if( isDefined( self.Weed["Options"] ) )
	{
		for(i=0;i<self.Weed["Options"].size;i++)
		self.Weed["Options"][i] destroy();
		
		self.Weed[ "Counter" ] destroy();
		self.Weed[ "Counter1" ] destroy();
		self.Weed[ "Menu" ] destroy();
		self.Weed[ "String/" ] destroy();
	}
}

Call_Update( a )
{
	self.Weed["Currentmenu"] = a;
	self thread Call_Clear();
	if( a == "Client" )
	{ self Call_Clients(); 	self.Weed[ "Playerbox" ].alpha = .7; self.Weed["String_Text"].alpha = 1; }
	else
	{ self.Weed[ "Playerbox" ].alpha = 0; self.Weed["String_Text"].alpha = 0; } 
		
	self thread Call_Text();
	self.Weed["Curs"][self.Weed["Currentmenu"]] = int(0);
	self thread Call_Scrollbar();
		
	self.Weed[ "Counter" ] = drawValue(self.Weed["Text"][self.Weed["Currentmenu"]].size, "default", 1.5, "TOP", "CENTER", 70+self.Call_Xpos, -148+self.Call_Ypos, (1,1,1), 1, 2);
	self.Weed[ "Counter1" ] = drawValue(self.Weed["Curs"][self.Weed["Currentmenu"]] + 1, "default", 1.5, "TOP", "CENTER", 90+self.Call_Xpos, -148+self.Call_Ypos, (1,1,1), 1, 2);
	self.Weed[ "String/" ] = drawText("/", "default", 1.5, "TOP", "CENTER", 80+self.Call_Xpos, -148+self.Call_Ypos, ( 1,1,1 ), 1, 2);
	
	self.Weed[ "Menu" ] = drawText(self.Weed["Cell"][self.Weed["Currentmenu"]], "default", 1.5, "LEFT", "CENTER", -95+self.Call_Xpos, -140+self.Call_Ypos, ( 1,1,1 ), 1, 2);
	
	if( self.Weed["Text"][self.Weed["Currentmenu"]].size < 7 )
		self.Weed[ "Background" ] setShader("white", 200 + self.Call_width, self.Weed["Text"][self.Weed["Currentmenu"]].size*18);
	else
		self.Weed[ "Background" ] setShader("white", 200 + self.Call_width, 130);	
}

Call_Reset()
{
	self.Call_width = 0;
	setDvar( "Config_Menu", "" );
	Call_UpdateGui( 0 );
	Call_Update_Position( "Reset" );
	Call_Update( self.Weed["Currentmenu"] );
}

Call_SaveMenu( a ){	
	setDvar( "Config_Menu", self.Theme + "," + self.Call_Ypos + "," + self.Call_Xpos + "," + self.Call_width );
	setDvar( "Last_Saved", self.Theme + "," + self.Call_Ypos + "," + self.Call_Xpos + "," + self.Call_width );
	if( a == "A" )
		self iprintln( "Menu is Saved..." );
}

Call_LastSaved_Menu()
{
	if( getdvar( "Last_Saved" ) != "" )
	{
		self.Last = strtok( getdvar( "Last_Saved" ), "," );
		self.Theme = int(self.Last[0]);
		self.Call_Ypos = int(self.Last[1]);
		self.Call_Xpos = int(self.Last[2]);
		self.Call_width = int(self.Last[3]);
		self Call_SaveMenu( "" );
		self iprintln( "Last Saved Menu Loaded..." );
		self thread Call_Refresh();
	}
}

Call_UpdateGui( a )
{
	self.Weed[ "Titel" ] destroy();
	self.Weed[ "Header" ] destroy();
	self.Weed[ "Bar" ] destroy();
	self.Weed[ "Background" ] destroy();
	self.Weed[ "Slider_Curs" ] destroy();
	self.Weed[ "Slider" ] destroy();
	self.Weed[ "Playerbox" ] destroy();
	self.Weed["String_Text"] destroy();
	self.Theme = a;
	self thread Call_Hud();
	self.Weed[ "Titel" ].alpha = 1;
	self.Weed[ "Header" ].alpha = 1;
	self.Weed[ "Bar" ].alpha = .7;
	self.Weed[ "Background" ].alpha = .5;
}

Call_Update_Position( a, b )
{
	if( a == "Left" )
	{
		if( !self.Call_Xpos == -320 )
			self.Call_Xpos = self.Call_Xpos - 20;
		else 
			self iprintln( self.name + "^7, You Can't get more Left." );
	}
	
	if( a == "Right" )
	{
		if( !self.Call_Xpos == 320 )
			self.Call_Xpos = self.Call_Xpos + 20;
		else
			self iprintln( self.name + "^7, You Can't get more Right." );
	}
		if( a == "UP" )
		{
			if( !self.Call_Ypos == -40 )
				self.Call_Ypos = self.Call_Ypos - 20;
			else
				self iprintln( self.name + "^7, You Can't get more Up." );
		}
		if( a == "Down" )
		{
			if( !self.Call_Ypos == 220 )
				self.Call_Ypos = self.Call_Ypos + 20;
			else
				self iprintln( self.name + "^7, You Can't get more Down." );
		}
		
	if( a == "Reset" )
	{
			self.Call_Ypos = 0;
			self.Call_Xpos = 0;
	}
		
	self thread Call_UpdateGui( self.Theme );
}

Call_Refresh()
{
	self thread Call_UpdateGui( self.Theme );
	self thread Call_Update( self.Weed["Currentmenu"] );
}

Call_SaveArea()
{
	self thread Call_Close();
	
	self.Weed[ "Titel" ].alpha = 1;
	self.Weed[ "Header" ].alpha = 1;
	self.Weed[ "Bar" ].alpha = .7;
	self.Weed[ "Background" ].alpha = .5;
}

Call_Scrollbar()
{
	self playsoundtoplayer("cac_grid_nav",self);
	if(self.Weed["Curs"][self.Weed["Currentmenu"]]<0)
		self.Weed["Curs"][self.Weed["Currentmenu"]] = self.Weed["Text"][self.Weed["Currentmenu"]].size-1;
		
	if(self.Weed["Curs"][self.Weed["Currentmenu"]]>self.Weed["Text"][self.Weed["Currentmenu"]].size-1)
		self.Weed["Curs"][self.Weed["Currentmenu"]] = 0;
		
	if(!isDefined(self.Weed["Text"][self.Weed["Currentmenu"]][self.Weed["Curs"][self.Weed["Currentmenu"]]-3])||self.Weed["Text"][self.Weed["Currentmenu"]].size<=7)
	{
    	for(i = 0; i < 7; i++)
    	{
	    	if(isDefined(self.Weed["Text"][self.Weed["Currentmenu"]][i]))
				self.Weed["Options"][i] setText(self.Weed["Text"][self.Weed["Currentmenu"]][i]);
			else
				self.Weed["Options"][i] setText("");
					
			if(self.Weed["Curs"][self.Weed["Currentmenu"]] == i)
         		self.Weed["Options"][i].alpha = 1;
         	else
          		self.Weed["Options"][i].alpha = 0.3;
		}
	}
	else
	{
	    if(isDefined(self.Weed["Text"][self.Weed["Currentmenu"]][self.Weed["Curs"][self.Weed["Currentmenu"]]+3]))
	    {
			xePixTvx = 0;
			for(i=self.Weed["Curs"][self.Weed["Currentmenu"]]-3;i<self.Weed["Curs"][self.Weed["Currentmenu"]]+4;i++)
			{
			    if(isDefined(self.Weed["Text"][self.Weed["Currentmenu"]][i]))
					self.Weed["Options"][xePixTvx] setText(self.Weed["Text"][self.Weed["Currentmenu"]][i]);
				else
					self.Weed["Options"][xePixTvx] setText("");
					
				if(self.Weed["Curs"][self.Weed["Currentmenu"]]==i)
					self.Weed["Options"][xePixTvx].alpha = 1;
         		else
          			self.Weed["Options"][xePixTvx].alpha = 0.3; 
          			               		
				xePixTvx ++;
			 }
		}
		else
		{
			for(i = 0; i < 7; i++)
			{
				self.Weed["Options"][i] setText(self.Weed["Text"][self.Weed["Currentmenu"]][self.Weed["Text"][self.Weed["Currentmenu"]].size+(i-7)]);
				
				if(self.Weed["Curs"][self.Weed["Currentmenu"]]==self.Weed["Text"][self.Weed["Currentmenu"]].size+(i-7))
             		self.Weed["Options"][i].alpha = 1;
         		else
          			self.Weed["Options"][i].alpha = 0.3;	
			}
		}
	}
}

Call_Menu( a, b )
{
	self.Weed["Cell"][a] = a;
	self.Weed["Input"][a] = b;
}

Call_Option( a, b, c, d, e, f, g )
{
	self.Weed["Text"][a][b] = c;
	self.Weed["Func"][a][b] = d;
	self.Weed["arg1"][a][b] = e;
	self.Weed["arg2"][a][b] = f;
	self.Weed["arg3"][a][b] = d;
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

drawValue(value, font, fontScale, align, relative, x, y, color, alpha, sort)
{
	hud = self createFontString(font, fontScale);
    hud setPoint( align, relative, x, y );
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.alpha = alpha;
	hud setValue(value);
	hud.foreground = true;
	hud.hideWhenInMenu = true;
	return hud;
}

/*
	*Creator: VerTical
*/

