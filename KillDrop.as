#include "Random";
#include "KillDropConf";
Random::PCG randomObj = Random::PCG();
array<EHandle> monsterList;
array<string> nameList;
array<Vector> posList;
CScheduledFunction@ refreshMonster;

ent_dead@ g_ent_dead;

void PluginInit()
{
  g_Scheduler.ClearTimerList();
  monsterList.removeRange(0, monsterList.length());
  nameList.removeRange(0, nameList.length());
  posList.removeRange(0, posList.length());  


  g_Module.ScriptInfo.SetAuthor("yts_nakano");
  g_Module.ScriptInfo.SetContactInfo("https://discord.gg/WrZJcRZvEZ");



  ent_dead g_ent();
  @g_ent_dead = @g_ent;


  g_ent_dead.start();

}



final class ent_dead 
{
  void timer_refreshMonster()
  {
    for(int i=0; i<int(monsterList.length()); i++)
    {
      CBaseEntity@ thatMonster = monsterList[i];
      if(thatMonster is null || !thatMonster.IsAlive())
      {
        dropItems(nameList[i], posList[i]);
      }
    }


    monsterList.removeRange(0, monsterList.length());
    nameList.removeRange(0, nameList.length());
    posList.removeRange(0, posList.length());


    CBaseEntity@ g_ent = null;
    int monsterNumber = 0;
    while((@g_ent = g_EntityFuncs.FindEntityByClassname(g_ent, "monster_*")) !is null)
    {
      int relationship = g_ent.IRelationshipByClass(CLASS_PLAYER);
      if(g_ent.IsAlive() && relationship != R_AL && relationship != R_NO)
      {
        EHandle g_entHandle = g_ent;
        monsterList.insertLast(g_entHandle);
        nameList.insertLast(g_ent.GetClassname());
        posList.insertLast(g_ent.GetOrigin());
      }
    }
  }


  void dropItems(string monsterName, Vector position){
    if(dropList.exists(monsterName)){
      dictionary dropLoot = cast<dictionary>(dropList[monsterName]);
      array<string> dictKeys = dropLoot.getKeys();
      
      int randomSum = 0;
      for(int i=0; i<int(dictKeys.length()); i++){
        randomSum += int(dropLoot[dictKeys[i]]);
      }
      int randomNum = int(randomObj.nextInt(randomSum + 1));
      int thisRandom = 0;
      for(int i=0; i<int(dictKeys.length()); i++){
        thisRandom += int(dropLoot[dictKeys[i]]);
        if(thisRandom >= randomNum){
          
          if(dictKeys[i] != ""){
            g_EntityFuncs.Create(dictKeys[i], position + Vector(0, 0, 50), Vector(0, 0, 0), false).KeyValue("m_flCustomRespawnTime", "-1");

          }
          break;
        }
      }
    }
    g_Scheduler.RemoveTimer(refreshMonster);
    @refreshMonster = g_Scheduler.SetInterval(this, "timer_refreshMonster", 0.1);
  }


 void start()
 {
    @refreshMonster = null;
    bool mapAllowed = true;

    for(int i=0; i<int(bannedMaps.length()); i++)
    {
      if(bannedMaps[i] == g_Engine.mapname)
      {
        mapAllowed = false;
        break;
      }
    }
    if(mapAllowed)
    {
      @refreshMonster = g_Scheduler.SetInterval(this, "timer_refreshMonster", 0.1);

    }
 }

  ent_dead()
  {


  }

}
/*















/**
bind "TAB" "+showscores"
bind "ENTER" "+attack"
bind "ESCAPE" "cancelselect"
bind "SPACE" "+jump"
bind "'" "grab_toggle"
bind "+" "impulse 102"
bind "," "grab_toggle"
bind "0" "slot10"
bind "1" "slot1"
bind "2" "slot2"
bind "3" "slot3"
bind "4" "slot4"
bind "5" "slot5"
bind "6" "slot6"
bind "7" "slot7"
bind "8" "slot8"
bind "9" "slot9"
bind "?" "grab_toggle"
bind "[" "invprev"
bind "]" "invnext"
bind "`" "toggleconsole"
bind "a" "+moveleft"
bind "b" "npc_return"
bind "c" "+commandmenu"
bind "d" "+moveright"
bind "e" "+use"
bind "f" "impulse 100"
bind "g" "drop"
bind "h" "dropammo"
bind "i" "inventory"
bind "j" "sc_chasecam"
bind "k" "kill"
bind "l" "stuck"
bind "m" "npc_moveto"
bind "n" ".ec_spawnent monster_rat"
bind "p" ".ec_spawnent monster_handgrenade"
bind "q" "lastinv"
bind "r" "+reload"
bind "s" "+back"
bind "t" "say /p"
bind "u" "messagemode"
bind "v" "votemenu"
bind "w" "+forward"
bind "x" "grenade;npc_findcover"
bind "y" ".cloak;.god;.noclip;.notarget 1;.notouch;.nonsolid 1"
bind "z" "medic"
bind "{" "say ,"
bind "~" "toggleconsole"
bind "BACKSPACE" "+attack2"
bind "UPARROW" "+lookup"
bind "DOWNARROW" "+lookdown"
bind "LEFTARROW" "+left"
bind "RIGHTARROW" "+right"
bind "ALT" "hook_toggle"
bind "CTRL" "+duck"
bind "SHIFT" "+speed"
bind "F1" "missionbriefing"
bind "F2" "servermotd"
bind "F3" ".impulse 101"
bind "F5" "snapshot"
bind "F10" ".rambo \"
bind "F11" "impulse 201"
bind "INS" "playmedia"
bind "PGDN" "nextsong"
bind "PGUP" "lastsong"
bind "HOME" "mediaplayer"
bind "END" "stopsong"
bind "KP_PLUS" "+voicerecord"
bind "MWHEELDOWN" "invnext"
bind "MWHEELUP" "invprev"
bind "MOUSE1" "+attack"
bind "MOUSE2" "+attack2"
bind "MOUSE3" "+alt1"
bind "MOUSE4" "+voicerecord"
bind "MOUSE5" "+use"