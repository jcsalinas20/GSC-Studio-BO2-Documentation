/*
 __     __                _____   _                  _ 
 \ \   / /   ___   _ __  |_   _| (_)   ___    __ _  | |
  \ \ / /   / _ \ | '__|   | |   | |  / __|  / _` | | |
   \ V /   |  __/ | |      | |   | | | (__  | (_| | | |
    \_/     \___| |_|      |_|   |_|  \___|  \__,_| |_| 
    
	*Credits : xTuL                                                
*/

init()
{
	level.strings = [];

	level thread onPlayerConnect();
}

onPlayerSpawned()
{
	self endon("disconnect");
	level endon("game_ended");

	for(;;)
	{
		self waittill("spawned_player");
		
		if(!isDefined(level.overflowFixThreaded))
		{
			level.overflowFixThreaded = true;
			level thread overflowFix();
		}
	}
}

recreateMenuText()
{
	//re-create your text here using setSafeText, no need for calling "submenu" if using sharks base
}

overflowfix()
{
	level endon("game_ended");
	level endon("host_migration_begin");
	
	test = level createServerFontString("default", 1);
	test setText("xTUL");
	test.alpha = 0;

	if(GetDvar("g_gametype") == "sd")
    	limit = 45; //110 with _rank.gsc
    else
    	limit = 55; //115 with _rank.gsc

	for(;;)
	{
		level waittill("textset"); 
		if(level.strings.size >= limit)
		{
			test ClearAllTextAfterHudElem();
			level.strings = [];//re-building the string array

			foreach(player in level.players)
			{
				if(isDefined(player.hasMenu) && player isVerified())//if the player has the menu and they are verified (change this to work with your menu)
				{
					if(isDefined(player.menu.open))//if the menu is open
						player recreateMenuText();
				}
			}
		}
	}
}

setSafeText(text)
{
    if (!isInArray(level.strings, text))
    {
        level.strings[level.strings.size] = text;
        self setText(text);
        level notify("textset");
    }
    else
        self setText(text);
}