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
