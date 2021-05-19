onPrecached()
{
	//Precache Models & Shaders!
	foreach(models in strTok("example_model1", ",")) //Can Precache Models.
		precacheModel(models);
			
	foreach(shaders in strTok("white,rank_com,rank_prestige01,rank_prestige02,rank_prestige03,rank_prestige04,rank_prestige05,rank_prestige06,rank_prestige07,rank_prestige08,rank_prestige09,rank_prestige10,rank_prestige11", ",")) //Can Precache Shaders.
		precacheShader(shaders);
		
	//Change Dvars!
	setDvar("g_speed", "200"); //Set Speed Normal.
	setDvar("player_meleeRange", "64"); //Set Melee Range Normal.
	
	//Array
	level.Test = strtok( "Test1,Test2", "," ); //Test Array e.g. level.Test[0] Output: Test1
	
	//Strings!
	level.Call_Titel = "WeedOnEnemy"; //Menu Name.
	level.Call_Version = "V1"; //Menu Version.
	
	level.Prestige_shades = strtok( "rank_com,rank_prestige01,rank_prestige02,rank_prestige03,rank_prestige04,rank_prestige05,rank_prestige06,rank_prestige07,rank_prestige08,rank_prestige09,rank_prestige10,rank_prestige11", ",");
}

//Bools

Bools()
{
	self.ClientHealth = false;
}

//Structur

Call_Struct()
{
	Call_Menu( "Main", "End" );
	Call_Option( "Main", 0, "Slider Editor", ::Call_Editor_Slider, "Cg_fov", 60, 120 );
	Call_Option( "Main", 1, "Prestige Editor", ::Call_Editor_Prestige );
	Call_Option( "Main", 2, "Godmode", ::Godmode, self );
	Call_Option( "Main", 3, "Option4", ::Test );
	Call_Option( "Main", 4, "Option5", ::Test );
	Call_Option( "Main", 5, "Option6", ::Test );
	Call_Option( "Main", 6, "Config", ::Call_Update, "Config" );
	Call_Option( "Main", 7, "Client Menu", ::Call_Update, "Client" );
	
	Call_Menu( "Client", "Main" );
	for(i=0;i<17;i++)
	Call_Menu( "Clients"+i, "Client" );
	
	Call_Menu( "Config", "Main" );
	Call_Option( "Config", 0, "Menu Position", ::Call_Editor_Position );
	Call_Option( "Config", 1, "Menu Themen", ::Call_Editor_Themen );
	Call_Option( "Config", 2, "Menu Width", ::Call_Editor_width );
	Call_Option( "Config", 3, "Reset Menu", ::Call_Reset );
	Call_Option( "Config", 4, "Save Menu", ::Call_SaveMenu, "A" );
	Call_Option( "Config", 5, "Last Saved Menu", ::Call_LastSaved_Menu );
}

//Example of a Function!

Test()
{
	self endon( "disconnect" );
	//Test Function...
}

