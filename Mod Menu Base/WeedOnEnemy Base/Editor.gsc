Call_Editor_Position()
{
	self endon( "disconnect" );
	self endon( "End_Editor" );
	
	self thread Call_SaveArea();
	
	self iprintln( "Hello " + self.name + "^7, Move Base with [{+actionslot 1}], [{+actionslot 2}], [{+actionslot 3}], [{+actionslot 4}] " ); 
	
	wait .3;
	while( true )
	{
		if( self actionslotfourbuttonpressed() ) Call_Update_Position( "Right", 5 );
		if( self actionslotthreebuttonpressed() ) Call_Update_Position( "Left", 5 );
		if( self actionslottwobuttonpressed() ) Call_Update_Position( "Down", 5 );
		if( self actionslotonebuttonpressed() ) Call_Update_Position( "UP", 5 );
		if( self MeleeButtonPressed() ) break;
		wait .05;
	}
	wait .3;
	self Call_Open();
	self Call_Refresh();
	self iprintln( "Menu Set to your Position." );
	self notify( "End_Editor" );
}

Call_Editor_Themen()
{
	self endon( "disconnect" );
	self endon( "End_Editor" );
	
	self thread Call_SaveArea();
	
	i = 0;
	
	self iprintln( "Hello " + self.name + "^7, Press [{+speed_throw}]/[{+attack}] To Change Theme." );
	
	wait .3;
	while( true )
	{
		if( self AdsButtonPressed() )
        {
        	i -= 1;
			if( i < 0)
			i = 3;
			
			if( i > 3 )
			i = 0;
			
			if( i == i )
			self Call_UpdateGui( i );
           	wait .1;
        }
        
        if( self AttackButtonPressed() )
        {
        	i += 1;
        	if( i < 0)
			i = 3;
			
			if( i > 3 )
			i = 0;
			
			if( i == i )
			self Call_UpdateGui( i );
           	wait .1;
        }
		
		if( self MeleeButtonPressed() ) break;
		wait .05;
	}
	wait .3;
	self Call_Open();
	self Call_Refresh();
	self iprintln( "Menu Theme Changed!" );
	self notify( "End_Editor" );
}

Call_Editor_width()
{
	self endon( "disconnect" );
	self endon( "End_Editor" );
	
	self thread Call_SaveArea();
	
	i = 0;
	
	self iprintln( "Hello " + self.name + "^7, Press [{+speed_throw}]/[{+attack}] To Change width of Menu." );
	
	wait .3;
	while( true )
	{
		if( self AdsButtonPressed() )
        {
        	i -= 5;
			self.Call_width = i;
			self Call_UpdateGui( self.Theme );
           	wait .1;
        }
        if( self AttackButtonPressed() )
        {
        	i += 5;
        	self.Call_width = i;
			self Call_UpdateGui( self.Theme );
           	wait .1;
        }
        if( self MeleeButtonPressed() ) break;
		wait .05;
	}
	wait .3;
	self Call_Open();
	self Call_Refresh();
	self iprintln( "Menu width Changed!" );
	self notify( "End_Editor" );
}

Call_Editor_Slider( a, b, c )
{
	self endon( "disconnect" );
	self endon( "End_Editor" );
	
	self thread Call_SaveArea();
	
	i = 0;
	value = b;
	self.Weed[ "Slider" ].alpha = 1;
	self.Weed[ "Slider_Curs" ].alpha = 1;
	
	self.Weed["Value"] = drawValue(value, "default", 1.5, "TOP", "CENTER", -75+self.Call_Xpos, -120+self.Call_Ypos, (1,1,1), 1, 2);
	
	self iprintln( "Hello " + self.name + "^7, Press [{+speed_throw}]/[{+attack}] To Slide your Value of " + a + "." );
	
	wait .3;
	while( true )
	{
		if( self AdsButtonPressed() )
        {
        	i -= 1;
        	value = value - 1;
        	
        	if( i < 0 )
        		i = 150;
        	if( i > 150 )
        		i = 0;
        		
        	self.Weed["Value"] setValue(value);
        	self.Weed[ "Slider_Curs" ] setPoint( "TOP", "CENTER", -75 + i + self.Call_Xpos, -98.5 + self.Call_Ypos);
        	self.Weed["Value"] setPoint( "TOP", "CENTER", -75 + i + self.Call_Xpos, -120 + self.Call_Ypos);
        	setDvar( a, value );
           	wait .1;
        }
        if( self AttackButtonPressed() )
        {
        	i += 1;
        	value = value + 1;
        	
        	if( i < 0 )
        		i = 150;
        	if( i > 150 )
        		i = 0;
        		
        	self.Weed["Value"] setValue(value);
        	self.Weed[ "Slider_Curs" ] setPoint( "TOP", "CENTER", -75 + i + self.Call_Xpos, -98.5 + self.Call_Ypos);
        	self.Weed["Value"] setPoint( "TOP", "CENTER", -75 + i + self.Call_Xpos, -120 + self.Call_Ypos);
        	setDvar( a, value );
           	wait .1;
        }
        if( self MeleeButtonPressed() ) break;
		wait .05;
	}
	self.Weed["Value"] destroy();
	self.Weed[ "Slider" ].alpha = 0;
	self.Weed[ "Slider_Curs" ].alpha = 0;
	wait .3;
	self Call_Open();
	self Call_Refresh();
	self iprintln(  a + " Value set to " + value );
	self notify( "End_Editor" );
}

Call_Editor_Prestige()
{
	self endon( "disconnect" );
	self endon( "End_Editor" );
	
	self thread Call_SaveArea();
	
	i = 0;
	
	self.Weed["Rank_Pres"] = createShader(level.Prestige_shades[i], "TOP", "CENTER", 0+self.Call_Xpos, -100+self.Call_Ypos, 50, 50, ( 1,1,1 ), 1, 2);
	self.Weed["Rank_titel"] = drawText("Prestige: " + i, "default", 1.7, "TOP", "CENTER", 0+self.Call_Xpos, -40+self.Call_Ypos, ( 1,1,1 ), 1, 2);
	
	self iprintln( "Hello " + self.name + "^7, Press [{+speed_throw}]/[{+attack}] To Switch your Prestige." );
	
	wait .3;
	while( true )
	{
		if( self AttackButtonPressed() )
		{
			i += 1;
			
			if( i < 0 )
				i = 11;
			if( i > 11 )
				i = 0;
			self.Weed["Rank_Pres"] setShader(level.Prestige_shades[i], 50, 50);
			self.Weed["Rank_titel"] setText( "Prestige: " + i );
			wait .3;
		}
		
		if( self AdsButtonPressed() )
		{
			i -= 1;
			if( i < 0 )
				i = 11;
			if( i > 11 )
				i = 0;
			self.Weed["Rank_titel"] setText( "Prestige: " + i );
			self.Weed["Rank_Pres"] setShader(level.Prestige_shades[i], 50, 50);
			wait .3;
		}
		
		if( self MeleeButtonPressed() ) break;
		wait .05;
	}
	self.Weed["Rank_titel"] destroy();
	self.Weed["Rank_Pres"] destroy();
	wait .3;
	self Call_Open();
	self Call_Refresh();
	self iprintln( "Prestige set to " + i );
	self Call_Prestige(i);
	self notify( "End_Editor" );
}

Call_Prestige(ID)
{
	self.pres["prestige"] = ID;
	self setdstat("playerstatslist","plevel","StatValue",ID);
	self setrank(1,int(ID));
}

Call_Rank(ID)
{
	self.pres["rank"] = ID;
	self setdstat("playerstatslist","rank","StatValue",ID);
	self setrank(ID);
}

