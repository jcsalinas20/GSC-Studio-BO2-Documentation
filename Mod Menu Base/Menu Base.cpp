/*
 __     __                _____   _                  _ 
 \ \   / /   ___   _ __  |_   _| (_)   ___    __ _  | |
  \ \ / /   / _ \ | '__|   | |   | |  / __|  / _` | | |
   \ V /   |  __/ | |      | |   | | | (__  | (_| | | |
    \_/     \___| |_|      |_|   |_|  \___|  \__,_| |_| 
    
    YouTube - VerTical C#
    CCM - VerTical
    General Post: https://cabconmodding.com/threads/basic-menu-base.1685/                                                   
*/
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_rank;
 
init()
{
    level thread onplayerconnect();
    
    foreach(shaders in strTok("rank_prestige15_128", ","))
    precacheShader(shaders);
}
 
onplayerconnect()
{
    for(;;)
    {
        level waittill( "connecting", player ); 
        if(isDefined(level.player_out_of_playable_area_monitor) && level.player_out_of_playable_area_monitor)
            level.player_out_of_playable_area_monitor = 0;
        if(isDefined(level.player_too_many_weapons_monitor) && level.player_too_many_weapons_monitor)
            level.player_too_many_weapons_monitor = 0;
        if(player isHost())
                        player.status = "User";
                else
                        player.status = "Bot";
                       
        player thread onplayerspawned();
    }
}
 
onplayerspawned()
{
    self endon( "disconnect" );
    level endon( "game_ended" );
   
    self.MenuInit = false;
   
    for(;;)
    {
                self waittill( "spawned_player" );
                if( self.status == "User")
                {
                        if (!self.MenuInit)
                        {
                                self.MenuInit = true;
                                self thread MenuInit();
                                self thread closeMenuOnDeath();
                        }
                }
    }
}
 
drawText(text, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort)
{
        hud = self createFontString(font, fontScale);
        hud setText(text);
        hud.x = x;
        hud.y = y;
        hud.color = color;
        hud.alpha = alpha;
        hud.glowColor = glowColor;
        hud.glowAlpha = glowAlpha;
        hud.sort = sort;
        hud.alpha = alpha;
        return hud;
}
 
drawShader(shader, x, y, width, height, color, alpha, sort)
{
    hud = newClientHudElem(self);
    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud.x = x;
    hud.y = y;
    return hud;
}
 
verificationToNum(status)
{
        if (status == "User")
                return 1;
        else
                return 0;
}
 
verificationToColor(status)
{
        if (status == "User")
                return "^2User";
        else
                return "^1Bot";
}
 
changeVerificationMenu(player, verlevel)
{
        if( player.status != verlevel)
        {              
                player.status = verlevel;
       
                self.menu.title destroy();
                self.menu.title = drawText("[" + verificationToColor(player.status) + "^7] " + player.name, "default", 2, 280, 30, (1, 1, 1), 1, (0, 0, 0), 0, 3);
               
                if(player.status == "Bot")
                        self thread destroyMenu(player);
       
                player suicide();
                self iPrintln("Set Access Level For " + player.name + " To " + verificationToColor(verlevel));
                player iPrintln("Your Access Level Has Been Set To " + verificationToColor(verlevel));
        }
        else
        {
                self iPrintln("Access Level For " + player.name + " Is Already Set To " + verificationToColor(verlevel));
        }
}
 
changeVerification(player, verlevel)
{
        player.status = verlevel;
}
 
Iif(bool, rTrue, rFalse)
{
        if(bool)
                return rTrue;
        else
                return rFalse;
}
 
CreateMenu()
{           
      
        self M("Main Menu", undefined);
        self.MM = strTok("Basic Menu, Option Menu, Shader Menu,", ",");
        for(i=0;i<self.MM.size; i++)
        {self O("Main Menu", self.MM[i], ::submenu, "SubMenu"+i, self.MM[i]);}
        self O("Main Menu", "Players", ::submenu, "PlayersMenu", "");
       
        self M("SubMenu0", "Main Menu");
        self.Basic = strTok("GodMode|Change Weapon|Exit Game", "|");
        self.Bf[0] = ::Test; self.Bf[1] = ::Test; self.Bf[2] = ::Test;
         for(a=0;a<self.Basic.size;a++)
         {self O("SubMenu0", self.Basic[a], self.Bf[a]);}
       
         self M("SubMenu1", "Main Menu");
         self O("SubMenu1", "Option 1");
         self O("SubMenu1", "Option 2");
         self O("SubMenu1", "Option 3");
              
         self M("SubMenu2", "Main Menu");
         self O("SubMenu2", "white");
         self O("SubMenu2", "rank_prestige15_128");
         self O("SubMenu2", "white"); 
       
       if(self isHost())
       {
        self M("PlayersMenu", "Main Menu");
        for (i = 0; i < 12; i++)
        { self M("pOpt " + i, "PlayersMenu"); }
       }
}
 
updatePlayersMenu()
{
        self.menu.menucount["PlayersMenu"] = 0;
        for (i = 0; i < 12; i++)
        {
                player = level.players[i];
                name = player.name;
               
                playersizefixed = level.players.size - 1;
                if(self.menu.curs["PlayersMenu"] > playersizefixed)
                {
                        self.menu.scrollerpos["PlayersMenu"] = playersizefixed;
                        self.menu.curs["PlayersMenu"] = playersizefixed;
                }
               
                self O("PlayersMenu", "[" + verificationToColor(player.status) + "^7] " + player.name, ::submenu, "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + player.name);
       
                self M_alt("pOpt " + i, "PlayersMenu");
                if(!self isHost())
                {
                self O("pOpt " + i, "Give Menu", ::changeVerificationMenu, player, "User");
                self O("pOpt " + i, "Take Menu", ::changeVerificationMenu, player, "Bot"); 
                } 
                self O("pOpt " + i, "Test", ::Test);
        }
}

M_alt(Menu, prevmenu)
{
        self.menu.getmenu[Menu] = Menu;
        self.menu.menucount[Menu] = 0;
        self.menu.previousmenu[Menu] = prevmenu;
}
 

M(Menu, prevmenu)
{
        self.menu.status[Menu] = "User";
        self.menu.getmenu[Menu] = Menu;
        self.menu.scrollerpos[Menu] = 0;
        self.menu.curs[Menu] = 0;
        self.menu.menucount[Menu] = 0;
        self.menu.previousmenu[Menu] = prevmenu;
}
 
O(Menu, Text, Func, arg1, arg2)
{
        Menu = self.menu.getmenu[Menu];
        Num = self.menu.menucount[Menu];
        self.menu.menuopt[Menu][Num] = Text;
        self.menu.menufunc[Menu][Num] = Func;
        self.menu.menuinput[Menu][Num] = arg1;
        self.menu.menuinput1[Menu][Num] = arg2;
        self.menu.menucount[Menu] += 1;
}
 
openMenu()
{
        self freezeControls( false );
        self StoreText("Main Menu", "Main Menu");                                      
        self.menu.background.alpha = 0.65;
        self.menu.scroller.y = self.menu.opt[self.menu.curs[self.menu.currentmenu]].y+1;
        self.menu.open = true;
}
 
closeMenu()
{
        for(i = 0; i < self.menu.opt.size; i++)
        {self.menu.opt[i].alpha = 0;}
               
        self.menu.background.alpha = 0;
        self.menu.title.alpha = 0;      
        self.menu.scroller.y = -500;   
        self.menu.open = false;
}
 
destroyMenu(player)
{
    player.MenuInit = false;
    closeMenu();
       
        wait 0.3;
       
        for(i=0; i < self.menu.menuopt[player.menu.currentmenu].size; i++)
        { player.menu.opt[i] destroy(); }
               
        player.menu.background destroy();
        player.menu.scroller destroy();
        player.menu.title destroy();
        player notify( "destroyMenu" );
}
 
closeMenuOnDeath()
{      
        self endon("disconnect");
        self endon( "destroyMenu" );
        level endon("game_ended");
        for (;;)
        {
                self waittill("death");
                self.menu.closeondeath = true;
                self submenu("Main Menu", "Main Menu");
                closeMenu();
                self.menu.closeondeath = false;
        }
}
 
StoreShaders()
{
    self.menu.background = self drawShader("white", 0, -50, 300, 500, (0, 0, 0), 0, 2);
        self.menu.scroller = self drawShader("white", 0, -500, 300, 17, (0, 0, 0), .9, 1);
}
 
StoreText(menu, title)
{
        self.menu.currentmenu = menu;
    self.menu.title destroy();
    self.menu.title = drawText(title, "default", 2, 0, 30, (1, 1, 1), 1, (0, 0, 0), 0, 0);
    self.menu.title.foreground = true; 
       
    for(i=0; i < self.menu.menuopt[menu].size; i++)
    { 
        if(!self.Shader)
        {
        self.menu.opt[i] destroy();
        self.menu.opt[i] = drawText(self.menu.menuopt[menu][i], "default", 1.6, 0, 68 + (i*20), (1, 1, 1), 1, (0, 0, 0), 0, 4);
        }
    else
    {
        self.menu.opt[i] destroy();
        self.menu.opt[i] = self drawShader(self.menu.menuopt[menu][i], 0, 68 + (i*20), 10, 10, (1, 1, 1), 1, 0);
        self.menu.opt[i].foreground = true;        
    }
    }
}
 
MenuInit()
{
        self endon("disconnect");
        self endon( "destroyMenu" );
        level endon("game_ended");
       
        self.menu = spawnstruct();
     
        self.menu.open = false;
        
        self.Shader = false;
        
       
        self StoreShaders();
        self CreateMenu();
       
        for(;;)
        {  
                if(self MeleeButtonPressed() && self adsbuttonpressed() && !self.menu.open) // Open.
                {
                        openMenu();
                }
                if(self.menu.open)
                {
                        if(self usebuttonpressed())
                        {
                                if(isDefined(self.menu.previousmenu[self.menu.currentmenu]))
                                {
                                        self submenu(self.menu.previousmenu[self.menu.currentmenu]);
                                }
                                else
                                {
                                        closeMenu();
                                }
                                wait 0.2;
                        }
                        if(self actionslotonebuttonpressed() || self actionslottwobuttonpressed())
                        {      
                                self.menu.curs[self.menu.currentmenu] += (Iif(self actionslottwobuttonpressed(), 1, -1));
                                self.menu.curs[self.menu.currentmenu] = (Iif(self.menu.curs[self.menu.currentmenu] < 0, self.menu.menuopt[self.menu.currentmenu].size-1, Iif(self.menu.curs[self.menu.currentmenu] > self.menu.menuopt[self.menu.currentmenu].size-1, 0, self.menu.curs[self.menu.currentmenu])));
                               
                                self.menu.scroller MoveOverTime(0.15);
                                self.menu.scroller.y = self.menu.opt[self.menu.curs[self.menu.currentmenu]].y+1;
                        }
                        if(self jumpbuttonpressed())
                        {
                                self thread [[self.menu.menufunc[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]]]](self.menu.menuinput[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]], self.menu.menuinput1[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]]);
                                wait 0.2;
                        }
                }
                wait 0.05;
        }
}
 
submenu(input, title)
{
        if (verificationToNum(self.status) >= verificationToNum(self.menu.status[input]))
        {
                for(i=0; i < self.menu.opt.size; i++)
                { self.menu.opt[i] destroy(); }
               
                if (input == "Main Menu")
                {       
                    self.Shader = false;
                        self thread StoreText(input, "Main Menu"); 
                    }
                else if (input == "PlayersMenu")
                {
                        self updatePlayersMenu();
                        self thread StoreText(input, "Clients");
                }
                    else if(input == "SubMenu2")
                    {        
                        self.Shader = true;
                          self thread StoreText(input, "Shader");
                    }
                    else 
                    {
                        self thread StoreText(input, title);
                        self.Shader = false;
                    }
                       
                self.CurMenu = input;
               
                self.menu.scrollerpos[self.CurMenu] = self.menu.curs[self.CurMenu];
                self.menu.curs[input] = self.menu.scrollerpos[input];
               
                if (!self.menu.closeondeath)
                {
                        self.menu.scroller MoveOverTime(0.15);
                self.menu.scroller.y = self.menu.opt[self.menu.curs[self.CurMenu]].y+1;
                }
    }
}
 
//Functions

Test()
{
 self iprintln("Test");   
}