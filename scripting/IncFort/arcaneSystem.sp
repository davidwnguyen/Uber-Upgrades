public void CastSpell(int client, int param2){
	//waiting for there to be a way to map functions
	switch(AttunedSpells[client][param2])
	{
		case 1:
		{
			CastZap(client, param2);
		}
		case 2:
		{
			CastLightning(client, param2);
		}
		case 3:
		{
			CastHealing(client, param2);
		}
		case 4:
		{
			CastACallBeyond(client, param2);
		}
		case 5:
		{
			CastBlackskyEye(client, param2);
		}
		case 6:
		{
			CastSunlightSpear(client, param2);
		}
		case 7:
		{
			CastLightningEnchantment(client, param2);
		}
		case 8:
		{
			CastSnapFreeze(client, param2);
		}
		case 9:
		{
			CastArcanePrison(client, param2);
		}
		case 10:
		{
			CastDarkmoonBlade(client, param2);
		}
		case 11:
		{
			CastSpeedAura(client, param2);
		}
		case 12:
		{
			CastAerialStrike(client, param2);
		}
		case 13:
		{
			CastInferno(client, param2);
		}
		case 14:
		{
			CastMineField(client, param2);
		}
		case 15:
		{
			CastShockwave(client, param2);
		}
		case 16:
		{
			CastAutoSentry(client, param2);
		}						
		case 17:
		{
			CastSoothingSunlight(client, param2);
		}
		case 18:
		{
			CastArcaneHunter(client, param2);
		}
		case 19:
		{
			CastMarkForDeath(client, param2);
		}
		case 20:
		{
			CastInfernalEnchantment(client, param2);
		}
		case 21:
		{
			CastSplittingThunder(client, param2);
		}
		case 22:
		{
			CastAntisepticBlast(client, param2);
		}
		case 23:
		{
			CastKarmicJustice(client, param2);
		}
		case 24:
		{
			CastSnowstorm(client, param2);
		}
		case 25:
		{
			CastStunShot(client, param2);
		}
		case 26:
		{
			CastFireballVolley(client, param2);
		}
		case 27:
		{
			CastDash(client, param2);
		}
		case 28:
		{
			CastTransientMoonlight(client, param2);
		}
		case 29:
		{
			CastCorpsePiler(client, param2);
		}
		case 30:
		{
			CastHomingFlares(client, param2);
		}
		case 31:
		{
			CastSilentDash(client, param2);
		}
		default:
		{
			PrintHintText(client, "Sorry, we havent implemented this yet!");
		}
	}
}

//Arcane Menu
public Menu_ShowArcane(client)
{
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		Handle menu = CreateMenu(MenuHandler_ArcaneCast);
		
		SetMenuExitBackButton(menu, true);
		SetMenuTitle(menu, "Use Arcane Spells");
		for (int s = 0; s < Max_Attunement_Slots; s++)
		{
			if(!AttunedSpells[client][s])
				continue;

			char fstr[32]
			Format(fstr, sizeof(fstr), "Use %s", ArcaneSpellList[AttunedSpells[client][s]-1]);
			AddMenuItem(menu, "spell", fstr);
		}
		if (IsValidClient(client) && IsPlayerAlive(client))
		{
			DisplayMenu(menu, client, MENU_TIME_FOREVER);
		}
	}
	return;
}
public MenuHandler_ArcaneCast(Handle menu, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select && IsValidClient(client) && IsPlayerAlive(client))
	{
		RequestFrame(Menu_ShowArcane, client);
		CloseHandle(menu);

		if(param2 < 0 || param2 > Max_Attunement_Slots)
			return;

		if(AttunedSpells[client][param2] == 0)
			{PrintHintText(client, "You have nothing attuned to this slot!");return;}

		if(TF2_IsPlayerInCondition(client, TFCond_Cloaked))
			{PrintHintText(client, "You cannot cast spells while invisible.");return;}

		if(TF2_IsPlayerInCondition(client, TFCond_Disguised))
		{
			TF2_RemoveCondition(client, TFCond_Disguised);
		}
		CastSpell(client, param2);
	}
	else if(action == MenuAction_Cancel && param2 == MenuCancel_ExitBack)
	{
		CloseHandle(menu);
		Menu_BuyUpgrade(client, 0);
	}
	return; 
}
public Action:Command_UseArcane(client, args)
{
	if (!IsValidClient(client))
		return Plugin_Handled;

	if (!IsPlayerAlive(client))
		return Plugin_Handled;

	char arg1[128];
	int param2;
	if (!GetCmdArg(1, arg1, sizeof(arg1)))
		return Plugin_Handled;
	
	param2 = StringToInt(arg1)-1;

	//Attempt to search for string in array of arcane names
	if(param2 == -1) {
		for(int i = 0;i < Max_Attunement_Slots; i++) {
			int id = AttunedSpells[client][i]-1;
			if(id < 0)
				continue;
			
			if(StrContains(ArcaneSpellList[id], arg1, false) != -1) {
				param2 = i;
				break;
			}
		}
	}

	if(param2 < 0 || param2 > Max_Attunement_Slots)
		return Plugin_Handled;

	if(AttunedSpells[client][param2] == 0)
		{PrintHintText(client, "You have nothing attuned to this slot!");return Plugin_Handled;}

	if(TF2_IsPlayerInCondition(client, TFCond_Cloaked))
		{PrintHintText(client, "You cannot cast spells while invisible.");return Plugin_Handled;}

	if(TF2_IsPlayerInCondition(client, TFCond_Disguised))
		TF2_RemoveCondition(client, TFCond_Disguised);

	CastSpell(client, param2);
	return Plugin_Handled;
}


//Arcane Spells
CastMarkForDeath(client, attuneSlot)
{
	if(applyArcaneRestrictions(client, attuneSlot, fl_MaxFocus[client]*0.5, 25.0))
		return; 

	float clientpos[3];
	TracePlayerAim(client, clientpos);
	float Range = 900.0*ArcanePower[client];
	int i = -1;
	while ((i = FindEntityByClassname(i, "*")) != -1)
	{
		if(!IsValidForDamage(i))
			continue;
		if(!IsOnDifferentTeams(client,i))
			continue;

		float VictimPos[3];
		GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
		VictimPos[2] += 30.0;
		if(GetVectorDistance(clientpos,VictimPos,true) > Range*Range)
			continue;

		if(!IsPointVisible(clientpos,VictimPos))
			continue;

		if(IsValidClient3(i))
		{
			TF2_AddCondition(i, TFCond_Sapped, 10.0, client);
			TF2Attrib_SetByName(i,"CARD: move speed bonus", 0.5);
			TF2Attrib_SetByName(i,"major increased jump height", 0.5);
			CreateTimer(10.0, DisableSlowdown, EntIndexToEntRef(i));
		}
		else if(HasEntProp(i,Prop_Send,"m_hBuilder"))
		{
			SetEntProp(i, Prop_Send, "m_bDisabled", 1);
			CreateTimer(5.0, ReEnableBuilding, EntIndexToEntRef(i));
		}
	}
	EmitSoundToAll(SOUND_SABOTAGE, 0, client, SNDLEVEL_SNOWMOBILE, _, 1.0, _,_,clientpos);
}
CastSunlightSpear(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	if(applyArcaneRestrictions(client, attuneSlot, 30.0 + (20.0 * TF2Attrib_HookValueFloat(1.0, "arcane_damage", client)), 0.5))
		return; 

	float clientpos[3];
	GetClientEyePosition(client,clientpos);
	EmitSoundToAll(SOUND_CALLBEYOND_CAST, 0, client, SNDLEVEL_NORMAL, _, 0.8, _,_,clientpos);
	int projectileAmount[] = {0,1,2,5};
	float projectileSpeed[] = {0.0,2500.0,4000.0,6000.0};
	for(int i=0;i<projectileAmount[spellLevel];++i){
		int iEntity = CreateEntityByName("tf_projectile_arrow");
		if (!IsValidEntity(iEntity)) 
			continue;

		float fAngles[3],fOrigin[3], vBuffer[3],fVelocity[3],fwd[3],right[3];
		int iTeam = GetClientTeam(client);
		SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

		SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
		SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
		SetEntPropEnt(iEntity, Prop_Data, "m_hOwnerEntity", client);
		SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);
		//SetEntProp(iEntity, Prop_Send, "m_bCritical", 1);
					
		GetClientEyePosition(client, fOrigin);
		GetClientEyeAngles(client,fAngles);
		
		GetAngleVectors(fAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
		GetAngleVectors(fAngles,fwd, right, NULL_VECTOR);

		ScaleVector(fwd, 30.0);
		AddVectors(fOrigin, fwd, fOrigin);

		if(projectileAmount[spellLevel] > 2){
			ScaleVector(right, (-10.0*(projectileAmount[spellLevel]-1)) + (20.0*i));
			AddVectors(fOrigin, right, fOrigin);
		}else if(projectileAmount[spellLevel] == 2){
			ScaleVector(right, i == 0 ? -10.0 : 10.0);
			AddVectors(fOrigin, right, fOrigin);
		}

		fVelocity[0] = vBuffer[0]*projectileSpeed[spellLevel];
		fVelocity[1] = vBuffer[1]*projectileSpeed[spellLevel];
		fVelocity[2] = vBuffer[2]*projectileSpeed[spellLevel];
		SetEntPropVector(iEntity, Prop_Send, "m_vInitialVelocity", fVelocity );
		TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
		DispatchSpawn(iEntity);
		SDKHook(iEntity, SDKHook_StartTouch, OnStartTouchSunlightSpear);
		SDKHook(iEntity, SDKHook_Touch, AddArrowCollisionFunction);

		
		TE_SetupKillPlayerAttachments(iEntity);
		TE_SendToAll();
		int color[4]={255, 200, 0,225};
		TE_SetupBeamFollow(iEntity,Laser,0,0.2,3.0,3.0,1,color);
		TE_SendToAll();
		CreateParticleEx(iEntity, "raygun_projectile_red_crit", 1);
		CreateParticleEx(iEntity, "raygun_projectile_red", 1);
	}
}
CastLightningEnchantment(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;
	if(applyArcaneRestrictions(client, attuneSlot, 150.0 + (40.0 * TF2Attrib_HookValueFloat(1.0, "arcane_damage", client)), 30.0))
		return;
		
	LightningEnchantment[client] = ArcaneDamage[client] * 80.0;
	LightningEnchantmentLevel[client] = spellLevel;
	LightningEnchantmentDuration[client] = GetGameTime() + 20.0*ArcanePower[client];	
}
CastDarkmoonBlade(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;
	if(applyArcaneRestrictions(client, attuneSlot, 100.0 + (20.0 * TF2Attrib_HookValueFloat(1.0, "arcane_damage", client)), 25.0))
		return; 
	
	DarkmoonBlade[client] = ArcaneDamage[client] * 15.0;
	DarkmoonBladeLevel[client] = spellLevel;
	DarkmoonBladeDuration[client] = GetGameTime() + 20.0*ArcanePower[client];
}
CastAntisepticBlast(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	if(applyArcaneRestrictions(client, attuneSlot, 400.0 + (120.0 * TF2Attrib_HookValueFloat(1.0, "arcane_damage", client)), 120.0))
		return; 
	
	float clientpos[3], soundPos[3], clientAng[3];
	TracePlayerAim(client, clientpos);
	
	float splashRadius[] = {0.0,200.0,350.0,500.0}
	float aimAssist[] = {0.0,10.0,20.0,40.0}//In degrees

	for(int i=1;i<=MaxClients;++i)
	{
		if(!IsValidClient3(i))
			continue;
		
		if(!IsOnDifferentTeams(client,i))
			continue;
		
		if(!IsTargetInSightRange(client, i, aimAssist[spellLevel], 6000.0, true, false))
			continue;

		if(!IsAbleToSee(client,i, false))
			continue;
			
		GetClientEyePosition(i,clientpos);
		break;
	}
	
	GetClientEyePosition(client, soundPos);
	GetClientEyeAngles(client, clientAng);
	EmitSoundToAll(SOUND_ARCANESHOOT, 0, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,soundPos);
	// define the direction of the sparks
	float dir[3] = {0.0, 0.0, 0.0};
	
	TE_SetupEnergySplash(clientpos, dir, false);
	TE_SendToAll();
	
	TE_SetupSparks(clientpos, dir, 5000, 1000);
	TE_SendToAll();

	CreateParticle(-1, "mvm_soldier_shockwave", _, _, 2.0, clientpos);

	float LightningDamage = 15000.0 + ArcaneDamage[client] * 400.0;
	int i = -1;
	while ((i = FindEntityByClassname(i, "*")) != -1)
	{
		if(!IsValidForDamage(i))
			continue;
		if(!IsOnDifferentTeams(client,i))
			continue;

		float VictimPos[3];
		GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
		VictimPos[2] += 30.0;

		if(GetVectorDistance(clientpos,VictimPos, true) > splashRadius[spellLevel]*splashRadius[spellLevel])
			continue;

		if(!IsPointVisible(clientpos,VictimPos))
			continue;

		SDKHooks_TakeDamage(i,client,client,LightningDamage * (1.0 + 0.5*GetAmountOfDebuffs(i)), DMG_IGNOREHOOK,-1,NULL_VECTOR,NULL_VECTOR, false);
	}
}
CastSnowstorm(client, attuneSlot){
	if(applyArcaneRestrictions(client, attuneSlot, 0.0, 1.0))
		return;

	if(snowstormActive[client]){
		int particleEffect = EntRefToEntIndex(snowstormParticle[client]);
		if(IsValidEntity(particleEffect)){
			CreateTimer(0.1, Timer_KillParticle, snowstormParticle[client]);
		}
		snowstormActive[client] = false;
	}else{
		snowstormParticle[client] = EntIndexToEntRef(CreateParticle(client, "utaunt_snowring_icy_parent", true, _, 0.0));
		snowstormActive[client] = true;
	}
}
CastKarmicJustice(client, attuneSlot){

	if(applyArcaneRestrictions(client, attuneSlot, 60.0 + (40.0 * TF2Attrib_HookValueFloat(1.0, "arcane_damage", client)), 15.0))
		return;

	karmicJusticeScaling[client] = 8.0;
	int args[1];args[0] = EntIndexToEntRef(client);
	SetPawnTimer(FinishKarmicJustice, 8.0, args, 1);
	CreateParticleEx(client, "utaunt_portalswirl_purple_parent", 1, _, _, 7.0);
}
FinishKarmicJustice(client){
	client = EntRefToEntIndex(client)
	if(IsValidClient3(client) && IsPlayerAlive(client) && karmicJusticeScaling[client] > 0.0){
		KarmicJusticeExplosion(client);
	}	
}
KarmicJusticeExplosion(client){
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	float damageDealt = ArcaneDamage[client] * karmicJusticeScaling[client];
	
	float explosionRadius[] = {0.0, 500.0, 1000.0, 1250.0};
	float pos[3];
	GetEntPropVector(client, Prop_Data, "m_vecOrigin", pos);
	EntityExplosion(client, damageDealt, explosionRadius[spellLevel], pos, 1, _, client);
	CreateParticleEx(client, "drg_cow_explosioncore_charged_blue", -1, -1, pos);
	CreateParticleEx(client, "rd_robot_explosion", -1, -1, pos);

	int Ent = CreateEntityByName("env_shake");
	TeleportEntity(Ent, pos, NULL_VECTOR, NULL_VECTOR);
	DispatchSpawn(Ent)
	DispatchKeyValueFloat(Ent, "amplitude", 5.0);
	DispatchKeyValueFloat(Ent, "radius", 1200.0);
	DispatchKeyValueFloat(Ent, "duration", 3.0);
	DispatchKeyValueFloat(Ent, "frequency", 3.0);
	SetVariantString("spawnflags 8");
	AcceptEntityInput(Ent,"AddOutput");
	AcceptEntityInput(Ent, "StartShake", client);

	CreateTimer(10.0, Timer_RemoveEntity, Ent);

	karmicJusticeScaling[client] = 0.0;
}
CastInfernalEnchantment(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	if(applyArcaneRestrictions(client, attuneSlot, 400.0 + (120.0 * TF2Attrib_HookValueFloat(1.0, "arcane_damage", client)), 60.0))
		return; 
	
	int args[2];args[0] = EntIndexToEntRef(client);args[1] = spellLevel;
	SetPawnTimer(FinishCastInfernalEnchantment, 2.0, args, 2);
	CreateParticleEx(client, "spell_cast_wheel_red", _, _, _, 1.6);
}
FinishCastInfernalEnchantment(int client, int spellLevel)
{
	client = EntRefToEntIndex(client)
	if(IsValidClient3(client) && IsPlayerAlive(client)){
		InfernalEnchantment[client] = 80.0 * ArcaneDamage[client];
		InfernalEnchantmentLevel[client] = spellLevel;
		InfernalEnchantmentDuration[client] = GetGameTime() + 30.0*ArcanePower[client];
		CreateParticle(client, "utaunt_auroraglow_orange_parent", true, "", 30.0*ArcanePower[client],_,_,1);
		int clients[MAXPLAYERS+1], numClients = getClientParticleStatus(clients, client);
		TE_Send(clients,numClients)
	}
}

CastSplittingThunder(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	if(applyArcaneRestrictions(client, attuneSlot, 400.0 + (120.0 * TF2Attrib_HookValueFloat(1.0, "arcane_damage", client)), 50.0))
		return; 
	
	float clientpos[3];
	GetClientAbsOrigin(client, clientpos);
	EmitSoundToAll(SOUND_ARCANESHOOTREADY, 0, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,clientpos);
	int args[2];args[0] = EntIndexToEntRef(client);args[1] = spellLevel;
	SetPawnTimer(FinishCastSplittingThunder, 3.0, args, 2);
	CreateParticleEx(client, "utaunt_electricity_discharge");
	CreateParticleEx(client, "utaunt_electricity_purple_discharge");
}
FinishCastSplittingThunder(int client, int spellLevel)
{
	client = EntRefToEntIndex(client)
	if(IsValidClient3(client) && IsPlayerAlive(client)){
		CreateParticleEx(client, "utaunt_lightning_parent", _, _, _, 2.0);
		int projCount[] = {0,5,7,10};
		for(int i = 0;i<projCount[spellLevel];++i)
		{
			int iEntity = CreateEntityByName("tf_projectile_arrow");
			if (!IsValidEdict(iEntity)) 
				continue;

			float fAngles[3],fOrigin[3], vBuffer[3],fVelocity[3],fwd[3],right[3];
			int iTeam = GetClientTeam(client);
			SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

			SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
			SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
			SetEntPropEnt(iEntity, Prop_Data, "m_hOwnerEntity", client);
			SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);
			SetEntProp(iEntity, Prop_Send, "m_bCritical", 1);
						
			GetClientEyePosition(client, fOrigin);
			GetClientEyeAngles(client,fAngles);

			fAngles[1] += -15.0 + (i+1)*(30.0/(projCount[spellLevel]+1));
			
			GetAngleVectors(fAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
			GetAngleVectors(fAngles,fwd, right, NULL_VECTOR);

			ScaleVector(fwd, 50.0);
			AddVectors(fOrigin, fwd, fOrigin);			

			fVelocity[0] = vBuffer[0]*500.0;
			fVelocity[1] = vBuffer[1]*500.0;
			fVelocity[2] = vBuffer[2]*500.0;

			SetEntPropVector(iEntity, Prop_Send, "m_vInitialVelocity", fVelocity );
			TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
			DispatchSpawn(iEntity);
			SDKHook(iEntity, SDKHook_StartTouch, OnStartTouchSplittingThunder);
			SDKHook(iEntity, SDKHook_Touch, AddArrowCollisionFunction);
			
			CreateParticleEx(iEntity, "raygun_projectile_red_crit", 1);
			CreateParticleEx(iEntity, "raygun_projectile_red", 1);
			
			TE_SetupKillPlayerAttachments(iEntity);
			TE_SendToAll();
			int color[4]={255, 200, 0,225};
			TE_SetupBeamFollow(iEntity,Laser,0,0.2,3.0,3.0,1,color);
			TE_SendToAll();

			CreateTimer(GetRandomFloat(0.3,0.5), Timer_SplittingThunderThink, EntIndexToEntRef(iEntity), TIMER_REPEAT);
		}

		float clientpos[3];
		GetClientEyePosition(client,clientpos);
		EmitSoundToAll(SOUND_CALLBEYOND_ACTIVE, 0, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,clientpos);
	}
}

CastSnapFreeze(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	if(applyArcaneRestrictions(client, attuneSlot, 50.0 + (20.0 * TF2Attrib_HookValueFloat(1.0, "arcane_damage", client)), 18.0))
		return; 

	float clientpos[3];
	GetClientEyePosition(client, clientpos);
	EmitSoundToAll(SOUND_FREEZE, 0, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,clientpos);
	float damage = ArcaneDamage[client] * 100.0;
	int i = -1;
	while ((i = FindEntityByClassname(i, "*")) != -1)
	{
		if(!IsValidForDamage(i))
			continue;
		if(!IsOnDifferentTeams(client,i))
			continue;

		float VictimPos[3];
		GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
		VictimPos[2] += 15.0;

		if(GetVectorDistance(clientpos,VictimPos, true) > 250000.0)
			continue;
		
		if(!IsPointVisible(clientpos,VictimPos))
			continue;

		SDKHooks_TakeDamage(i,client,client,damage,DMG_BULLET|DMG_IGNOREHOOK,-1,NULL_VECTOR,NULL_VECTOR, false);
		if(IsValidClient3(i))
		{
			TF2_AddCondition(i, TFCond_FreezeInput, 0.4);
			TF2_StunPlayer(i, 0.4*spellLevel,1.0,TF_STUNFLAGS_NORMALBONK,client);
		}
	}
	TF2_AddCondition(client, TFCond_ObscuredSmoke, 0.4*spellLevel);
	GetClientAbsOrigin(client, clientpos);
	CreateSmoke(clientpos,0.3,255,255,255,"200","20");
	CreateParticleEx(client, "utaunt_snowring_icy_parent", 1, _, _, 3.5);

}
CastArcanePrison(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	if(applyArcaneRestrictions(client, attuneSlot, 50.0 + (35.0 * TF2Attrib_HookValueFloat(1.0, "arcane_damage", client)), 75.0))
		return; 

	float ClientPos[3];
	float ClientAngle[3];
	GetClientEyePosition(client,ClientPos);
	GetClientEyeAngles(client,ClientAngle);
	int iTeam = GetClientTeam(client)
	ClientPos[2] -= 20.0;
	EmitSoundToAll(SOUND_CALLBEYOND_ACTIVE, 0, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,ClientPos);
	
	float fAngles[3]
	float fOrigin[3]
	float vBuffer[3]

	int magnitude[] = {0,1,2,2};
	float damage = ArcaneDamage[client] * 10.0;
	if(spellLevel < 3){
		if(LookPoint(client,fOrigin))
		{
			for(int i=0;i<magnitude[spellLevel];++i){
				int iEntity = CreateEntityByName("tf_projectile_lightningorb");
				if (!IsValidEdict(iEntity)) 
					continue;
			
				SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

				SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
				SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
				SetEntPropEnt(iEntity, Prop_Data, "m_hOwnerEntity", client);
				SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);

				fOrigin[2] += 40.0
				GetClientEyeAngles(client,fAngles);
				
				GetAngleVectors(fAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
				
				TeleportEntity(iEntity, fOrigin, fAngles, NULL_VECTOR);
				DispatchSpawn(iEntity);
				projectileDamage[iEntity] = damage;
			}
		}
	}else{
		//Level 3 autotargets anyone within 35 degree radius
		int afflictedTargets=0;
		for(int i = 1; i<=MaxClients && afflictedTargets<=magnitude[spellLevel];++i)
		{
			if(!IsValidClient3(i))
				continue;
			
			if(!IsOnDifferentTeams(client,i))
				continue;
			
			if(!IsTargetInSightRange(client, i, 35.0, 6000.0, true, false))
				continue;

			if(!IsAbleToSee(client,i, false))
				continue;

			afflictedTargets++;
			GetClientAbsOrigin(i, fOrigin);
			for(int proj=0;proj<magnitude[spellLevel];proj++){
				int iEntity = CreateEntityByName("tf_projectile_lightningorb");
				if (!IsValidEdict(iEntity)) 
					continue;
			
				SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

				SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
				SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
				SetEntPropEnt(iEntity, Prop_Data, "m_hOwnerEntity", client);
				SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);
				
				TeleportEntity(iEntity, fOrigin, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(iEntity);
				projectileDamage[iEntity] = damage;
			}
		}
	}
}
CastSpeedAura(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	if(applyArcaneRestrictions(client, attuneSlot, fl_MaxFocus[client]*0.4, 40.0))
		return; 

	float ClientPos[3];
	GetClientEyePosition(client,ClientPos);
	int iTeam = GetClientTeam(client)
	ClientPos[2] -= 20.0;

	float radius[] = {0.0,800.0,100000.0,100000.0}
	float buffDuration[] = {0.0,8.0,16.0,60.0}

	for(int i = 1; i<=MaxClients;++i)
	{
		if(!IsValidClient3(i))
			continue;
		if(GetClientTeam(i) != iTeam)
			continue;
		float VictimPos[3];
		GetClientEyePosition(i,VictimPos);

		if(GetVectorDistance(ClientPos,VictimPos,true) > radius[spellLevel]*radius[spellLevel])
			continue;

		TF2_AddCondition(i, TFCond_SpeedBuffAlly, buffDuration[spellLevel]);
		TF2_AddCondition(i, TFCond_RuneAgility, buffDuration[spellLevel]);
		TF2_AddCondition(i, TFCond_DodgeChance, 0.5*buffDuration[spellLevel]);
	}
	EmitSoundToAll(SOUND_SPEEDAURA, 0, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,ClientPos);
}
CastAerialStrike(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	float cooldown[] = {0.0,50.0,30.0,10.0}
	if(applyArcaneRestrictions(client, attuneSlot, 50.0 + (45.0 * TF2Attrib_HookValueFloat(1.0, "arcane_damage", client)), cooldown[spellLevel]))
		return; 

	float delay[] = {0.0,1.0,0.6,0.2}
	float ClientPos[3];
	TracePlayerAim(client, ClientPos);
	int iTeam = GetClientTeam(client)
	float ProjectileDamage = ArcaneDamage[client] * 60.0;
	Handle hPack = CreateDataPack();
	WritePackCell(hPack, GetClientSerial(client));
	WritePackCell(hPack, iTeam);
	WritePackCell(hPack, spellLevel)
	WritePackFloat(hPack, ProjectileDamage);
	WritePackFloat(hPack, ClientPos[0]);
	WritePackFloat(hPack, ClientPos[1]);
	WritePackFloat(hPack, ClientPos[2]);
	
	CreateTimer(delay[spellLevel],aerialStrike,hPack);
	if(iTeam == 2)
	{
		EmitSoundToAll(SOUND_HORN_RED, 0, _, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,ClientPos);
		TE_SetupBeamRingPoint(ClientPos, 20.0, 800.0, g_LightningSprite, spriteIndex, 0, 5, 1.0, 10.0, 1.0, {255,0,0,180}, 400, 0);
		TE_SendToAll();
	}
	else
	{
		EmitSoundToAll(SOUND_HORN_BLUE, 0, _, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,ClientPos);
		TE_SetupBeamRingPoint(ClientPos, 20.0, 800.0, g_LightningSprite, spriteIndex, 0, 5, 1.0, 10.0, 1.0, {0,0,255,180}, 400, 0);
		TE_SendToAll();
	}
}
public Action:aerialStrike(Handle timer,any:data)
{
	ResetPack(data);
	int client = GetClientFromSerial(ReadPackCell(data));
	int iTeam = ReadPackCell(data);
	int spellLevel = ReadPackCell(data);
	float ProjectileDamage = ReadPackFloat(data);
	float ClientPos[3];
	ClientPos[0] = ReadPackFloat(data);
	ClientPos[1] = ReadPackFloat(data);
	ClientPos[2] = ReadPackFloat(data);

	if(!IsValidClient3(client)){CloseHandle(data);return;}

	int quantity[] = {0,30,40,50}
	float spread[] = {0.0,300.0,200.0,100.0}
	for(int i = 0;i<quantity[spellLevel];++i)
	{
		int iEntity = CreateEntityByName("tf_projectile_rocket");
		if (!IsValidEdict(iEntity)) 
			continue;

		float fAngles[3]
		float fOrigin[3]
		float vBuffer[3]
		float fVelocity[3]
		SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

		SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
		SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
		SetEntPropEnt(iEntity, Prop_Data, "m_hOwnerEntity", client);
		SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);
		
		fAngles[0] = 89.0;
		fAngles[1] = GetRandomFloat(-150.0,-10.0);
		fAngles[2] = 0.0;
		GetAngleVectors(fAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);

		fOrigin = ClientPos;
		fOrigin[0] += GetRandomFloat(-spread[spellLevel]/ArcanePower[client],spread[spellLevel]/ArcanePower[client]);
		fOrigin[1] += GetRandomFloat(-spread[spellLevel]/ArcanePower[client],spread[spellLevel]/ArcanePower[client]);
		fOrigin[2] += 1000.0;
		
		float Speed = 1500.0;
		fVelocity[0] = vBuffer[0]*Speed;
		fVelocity[1] = vBuffer[1]*Speed;
		fVelocity[2] = vBuffer[2]*Speed;
		SetEntDataFloat(iEntity, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, ProjectileDamage, true);  
		TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
		DispatchSpawn(iEntity);
	}
	CloseHandle(data);
	KillTimer(timer);
}
CastInferno(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	float cooldown[] = {0.0,20.0,15.0,10.0}
	if(applyArcaneRestrictions(client, attuneSlot, 50.0 + (45.0 * TF2Attrib_HookValueFloat(1.0, "arcane_damage", client)), cooldown[spellLevel]))
		return;

	float ClientPos[3];
	GetClientEyePosition(client,ClientPos);
		
	EmitSoundToAll(SOUND_INFERNO, client, _, SNDLEVEL_ROCKET, _, 1.0, _,_,ClientPos);
	//scripting god
	float flamePos[3];
	flamePos = ClientPos;
	flamePos[2] += 400.0;

	//ohhhhh myyyyy god!!!!!!
	CreateParticle(-1, "cinefx_goldrush_flames", _, _, _, flamePos);
	//
	flamePos[0] += 400.0;
	CreateParticle(-1, "cinefx_goldrush_flames", _, _, _, flamePos);
	//
	flamePos[1] += 400.0;
	CreateParticle(-1, "cinefx_goldrush_flames", _, _, _, flamePos);
	//
	flamePos[1] -= 800.0;
	CreateParticle(-1, "cinefx_goldrush_flames", _, _, _, flamePos);
	//
	flamePos[0] -= 400.0;
	CreateParticle(-1, "cinefx_goldrush_flames", _, _, _, flamePos);
	//
	flamePos[1] += 800.0;
	CreateParticle(-1, "cinefx_goldrush_flames", _, _, _, flamePos);
	//
	flamePos[0] -= 400.0;
	CreateParticle(-1, "cinefx_goldrush_flames", _, _, _, flamePos);
	//
	flamePos[1] -= 400.0;
	CreateParticle(-1, "cinefx_goldrush_flames", _, _, _, flamePos);
	//
	flamePos[1] -= 400.0;
	CreateParticle(-1, "cinefx_goldrush_flames", _, _, _, flamePos);
	
	
	float DMGDealt = ArcaneDamage[client] * 15.0;
	float range[] = {0.0,800.0,1200.0,1600.0}
	int maxHits[] = {0,20,30,40}
	int i = -1;
	while ((i = FindEntityByClassname(i, "*")) != -1)
	{
		if(!IsValidForDamage(i))
			continue;
		if(!IsOnDifferentTeams(client,i))
			continue;

		float VictimPos[3];
		GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
		if(GetVectorDistance(ClientPos,VictimPos,true) > range[spellLevel]*range[spellLevel])
			continue;

		CreateParticleEx(i, "dragons_fury_effect_parent", 1, _, _, 0.15*maxHits[spellLevel]);
		DOTStock(i,client,DMGDealt,-1,DMG_BURN,maxHits[spellLevel],1.0,0.15,true);
	}
}

CastMineField(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	if(applyArcaneRestrictions(client, attuneSlot, 50.0 + (45.0 * TF2Attrib_HookValueFloat(1.0, "arcane_damage", client)), 50.0))
		return;
		
	float ClientPos[3];
	TracePlayerAim(client, ClientPos);
	int iTeam = GetClientTeam(client)
	int quantity[] = {0,20,30,40}
	float spellRadius[] = {0.0,300.0,500.0,900.0}
	float spread[] = {0.0,300.0,200.0,100.0}
	float radius = spellRadius[spellLevel]*ArcanePower[client];
	float damage = ArcaneDamage[client] * 10.0;
	for(int i = 0;i<quantity[spellLevel];++i)
	{
		int iEntity = CreateEntityByName("tf_projectile_pipe_remote");
		if (!IsValidEdict(iEntity)) 
			continue;
		float fAngles[3]
		float fOrigin[3]
		float vBuffer[3]
		float fVelocity[3]
		SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

		SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
		SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
		SetEntPropEnt(iEntity, Prop_Data, "m_hOwnerEntity", client);
		SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);
		SetEntPropEnt(iEntity, Prop_Data, "m_hThrower", client)
		
		SetEntPropFloat(iEntity, Prop_Send, "m_DmgRadius", radius);
		SetEntPropFloat(iEntity, Prop_Send, "m_flDamage", damage);
		
		fAngles[0] = 89.0;
		fAngles[1] = GetRandomFloat(-150.0,-10.0);
		fAngles[2] = 0.0;
		GetAngleVectors(fAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);

		fOrigin = ClientPos;
		fOrigin[0] += GetRandomFloat(-spread[spellLevel]/ArcanePower[client],spread[spellLevel]/ArcanePower[client]);
		fOrigin[1] += GetRandomFloat(-spread[spellLevel]/ArcanePower[client],spread[spellLevel]/ArcanePower[client]);
		fOrigin[2] += 10.0;
		
		float Speed = 1500.0;
		fVelocity[0] = vBuffer[0]*Speed;
		fVelocity[1] = vBuffer[1]*Speed;
		fVelocity[2] = vBuffer[2]*Speed;
		TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
		DispatchSpawn(iEntity);
		RequestFrame(CheckMines, iEntity);
		SetEntityModel(iEntity, "models/weapons/w_models/w_stickybomb3.mdl");
	}
}
public void CheckMines(ref)
{
	int entity = EntRefToEntIndex(ref); 
	if(!IsValidEdict(entity))
		return;
	if(!HasEntProp(entity, Prop_Data, "m_hThrower"))
		return;
    
	int client = GetEntPropEnt(entity, Prop_Data, "m_hThrower"); 
	if (!IsValidClient(client))
		return;
	if(!IsPlayerAlive(client))
		return;
	
	CreateTimer(0.1,Timer_GrenadeMines,  EntIndexToEntRef(entity), TIMER_REPEAT);
	CreateTimer(20.0,SelfDestruct,  EntIndexToEntRef(entity));
	SetEntProp(entity, Prop_Data, "m_nNextThinkTick", -1);
	lastMinesTime[client] = GetGameTime();
}
public Action:Timer_GrenadeMines(Handle timer, any:ref) 
{ 
    int entity = EntRefToEntIndex(ref);
	if(!IsValidEdict(entity)){KillTimer(timer);return;}

	int client = GetEntPropEnt(entity, Prop_Data, "m_hThrower"); 
	if(!IsValidClient3(client)){KillTimer(timer);return;}

	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	float extraRadius[] = {0.0,1.1,1.3,1.5}
	float damageRate[] = {0.0,0.35,0.5,0.8}
	float maxDamageBonus[] = {0.0,8.0,9.0,10.0}

	float distance = GetEntPropFloat(entity, Prop_Send, "m_DmgRadius")
	float damage = GetEntPropFloat(entity, Prop_Send, "m_flDamage")
	float timeMod = 1.0+((GetGameTime()-lastMinesTime[client])*damageRate[spellLevel]);
	float grenadevec[3], targetvec[3];

	if(timeMod > maxDamageBonus[spellLevel]){timeMod=maxDamageBonus[spellLevel];}

	GetEntPropVector(entity, Prop_Data, "m_vecOrigin", grenadevec);
	
	for(int i=1; i<=MaxClients; ++i)
	{
		if(!IsValidClient3(i))
			continue;

		if(IsClientObserver(i))
			continue;

		if(GetClientTeam(i) == GetClientTeam(client))
			continue;

		GetClientAbsOrigin(i, targetvec);
		if(GetVectorDistance(grenadevec, targetvec, true) > distance*distance)
			continue;

		if(IsPlayerInSpawn(i))
			continue;

		if(!IsAbleToSee(client,i))
			continue;

		EntityExplosion(client, damage*timeMod, distance*extraRadius[spellLevel], grenadevec, 0,_,entity);
		RemoveEntity(entity);
		KillTimer(timer);
		break;
	}
}
CastShockwave(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	if(applyArcaneRestrictions(client, attuneSlot, 50.0, 20.0))
		return; 

	float ClientPos[3];
	GetClientEyePosition(client,ClientPos);
	ClientPos[2] -= 20.0;
		
	float damageDealt = ArcaneDamage[client] * 100.0;
	int i = -1;
	while ((i = FindEntityByClassname(i, "*")) != -1)
	{
		if(!IsValidForDamage(i))
			continue;
		if(!IsOnDifferentTeams(client,i))
			continue;

		float VictimPos[3];
		GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
		VictimPos[2] += 15.0;

		if(!IsPointVisible(ClientPos,VictimPos))
			continue;

		if(GetVectorDistance(ClientPos,VictimPos,true) > 250000.0)
			continue;

		SDKHooks_TakeDamage(i,client,client,damageDealt,DMG_BULLET|DMG_IGNOREHOOK,-1,NULL_VECTOR,NULL_VECTOR, false);
		if(IsValidClient3(i))
		{
			TF2_AddCondition(i, TFCond_FreezeInput, 0.4);
			TF2_StunPlayer(i, 2.25 + 0.4*spellLevel,1.0,TF_STUNFLAGS_NORMALBONK,client);
			PushEntity(i,client,900.0,200.0);
		}
	}
	TF2_AddCondition(client, TFCond_ObscuredSmoke, 0.4);
	EmitSoundToAll(SOUND_SHOCKWAVE, 0, _, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,ClientPos);
	CreateParticleEx(client, "bombinomicon_burningdebris");
}
CastAutoSentry(client, attuneSlot)
{
	if(applyArcaneRestrictions(client, attuneSlot, fl_MaxFocus[client], 80.0))
		return; 
	int iTeam = GetClientTeam(client)
		
	int iEntity = CreateEntityByName("obj_sentrygun");
	if(!IsValidEdict(iEntity))
		return;

	int iLink = CreateLink(client,true);
	float angles[3];
	float position[3];
	position[2] -= 75.0;
	
	SetVariantString("!activator");
	AcceptEntityInput(iEntity, "SetParent", iLink);  
	SetVariantString("head"); 
	AcceptEntityInput(iEntity, "SetParentAttachment", iLink); 
	SetEntPropEnt(iEntity, Prop_Send, "m_hEffectEntity", iLink);
	SetEntPropVector(iEntity, Prop_Send, "m_angRotation", angles);
	TeleportEntity(iLink, position, NULL_VECTOR, NULL_VECTOR);
	DispatchSpawn(iEntity);
	SetEntProp(iEntity, Prop_Data, "m_spawnflags", 8);
	SetEntProp(iEntity, Prop_Data, "m_takedamage", 0);
	SetEntProp(iEntity, Prop_Send, "m_iUpgradeLevel", 3);
	SetEntProp(iEntity, Prop_Send, "m_iHighestUpgradeLevel", 3);
	SetEntProp(iEntity, Prop_Send, "m_nSkin", iTeam);
	SetEntProp(iEntity, Prop_Send, "m_bBuilding", 1);
	SetEntProp(iEntity, Prop_Send, "m_nSolidType", 0);
	SetEntProp(iEntity, Prop_Send, "m_usSolidFlags", 0x0004);
	SetEntProp(iEntity, Prop_Send, "m_hBuiltOnEntity", client);

	SetEntPropFloat(iEntity, Prop_Send, "m_flModelScale", 0.3);
	SetVariantInt(iTeam);
	AcceptEntityInput(iEntity, "SetTeam");
	SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam)
	SetEntPropEnt(iEntity, Prop_Send, "m_hBuilder", client); 
	SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client); 
	
	CreateTimer(30.0,SelfDestruct,  EntIndexToEntRef(iEntity));
	CreateTimer(30.0,SelfDestruct,  EntIndexToEntRef(iLink));
	CreateTimer(30.0,RemoveAutoSentryID, EntIndexToEntRef(client));
	autoSentryID[client] = iEntity;
}
public Action:RemoveAutoSentryID(Handle timer, any:ref) 
{
	ref = EntRefToEntIndex(ref)
	autoSentryID[ref] = -1;
}
CastSoothingSunlight(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	float cooldown[] = {0.0,180.0,120.0,60.0}

	if(applyArcaneRestrictions(client, attuneSlot, fl_MaxFocus[client], cooldown[spellLevel]))
		return; 

	float ClientPos[3];
	GetClientEyePosition(client,ClientPos);
	ClientPos[2] -= 40.0;
		
	float duration[] = {0.0,4.0,3.0,1.0}

	CreateTimer(duration[spellLevel],SoothingSunlight,EntIndexToEntRef(client));
	TF2_StunPlayer(client,duration[spellLevel],0.0,TF_STUNFLAGS_BIGBONK,0);
	TE_SetupBeamRingPoint(ClientPos, 20.0, 800.0, g_LightningSprite, spriteIndex, 0, 5, duration[spellLevel], 10.0, 1.0, {255,255,0,180}, 400, 0);
	TE_SendToAll();
}
public Action:SoothingSunlight(Handle timer, client) 
{
	client = EntRefToEntIndex(client)
	if(!IsValidClient3(client))
		return;

	if(!IsPlayerAlive(client))
		return;

	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	int iTeam = GetClientTeam(client)
	float ClientPos[3];
	GetClientEyePosition(client,ClientPos);
	float radius[] = {0.0,900.0,1500.0,5000.0}
	float incHealDuration[] = {0.0,6.5,15.0,30.0}
	float overhealMax[] = {0.0,3.0,5.0,10.0}
	for(int i = 1; i<=MaxClients;++i)
	{
		if(!IsValidClient3(i))
			continue;

		if(GetClientTeam(i) != iTeam)
			continue;

		float VictimPos[3];
		GetClientEyePosition(i,VictimPos);
		if(GetVectorDistance(ClientPos,VictimPos,true) > radius[spellLevel]*radius[spellLevel])
			continue;

		float AmountHealing = TF2_GetMaxHealth(i) * ArcanePower[client];
		AddPlayerHealth(i, RoundToCeil(AmountHealing), overhealMax[spellLevel] * ArcanePower[client], true, client);
		TF2_AddCondition(i,TFCond_MegaHeal,incHealDuration[spellLevel], client);

		CreateParticleEx(i, "utaunt_glitter_parent_gold", 1, _, _, incHealDuration[spellLevel]);
	}
	EmitSoundToAll(SOUND_HEAL, 0, _, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,ClientPos);
}
CastArcaneHunter(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	if(applyArcaneRestrictions(client, attuneSlot, 200.0, 40.0))
		return; 

	float CPOS[3];
	GetClientEyePosition(client,CPOS)
	
	for(int i=0;i<30;++i)
	{
		EmitSoundToAll(SOUND_ARCANESHOOTREADY, 0, _, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,CPOS);
	}
	
	int MaxUses[] = {0, 5,10,30}
	float duration[] = {0.0,0.4,0.3,0.1}
	for(int i = 1;i<=MaxUses[spellLevel];++i)
	{
		CreateTimer(duration[spellLevel]*i,ArcaneHunter,client);
	}
}
public Action:ArcaneHunter(Handle timer, client) 
{
	if(!IsPlayerAlive(client))
		return;
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	float clientpos[3], soundPos[3], clientAng[3], fwd[3];
	TracePlayerAim(client, clientpos);
	
	float splashRadius[] = {0.0,200.0,350.0,500.0}
	float aimAssist[] = {0.0,10.0,20.0,40.0}//In degrees

	for(int i=1;i<=MaxClients;++i)
	{
		if(!IsValidClient3(i))
			continue;
			
		if(!IsPlayerAlive(i))
			continue;

		if(!IsOnDifferentTeams(client,i))
			continue;
		
		if(TF2_IsPlayerInCondition(i, TFCond_Ubercharged) || TF2_IsPlayerInCondition(i, TFCond_UberchargedHidden))
			continue;

		if(!IsTargetInSightRange(client, i, aimAssist[spellLevel], 6000.0, true, false))
			continue;

		if(!IsAbleToSee(client,i, false))
			continue;
			
		GetClientEyePosition(i,clientpos);
		break;
	}
	
	GetClientEyePosition(client, soundPos);
	GetClientEyeAngles(client, clientAng);
	EmitSoundToAll(SOUND_ARCANESHOOT, 0, _, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,soundPos);
	// define the direction of the sparks
	float dir[3] = {0.0, 0.0, 0.0};
	
	TE_SetupEnergySplash(clientpos, dir, false);
	TE_SendToAll();
	
	TE_SetupSparks(clientpos, dir, 5000, 1000);
	TE_SendToAll();
	
	float particleOffset[3] = {0.0,0.0,75.0};
	char particleName[32];
	particleName = GetClientTeam(client) == 2 ? "muzzle_raygun_red" : "muzzle_raygun_blue";
	
	GetAngleVectors(clientAng,fwd, NULL_VECTOR, NULL_VECTOR);
	ScaleVector(fwd, 30.0);
	AddVectors(particleOffset, fwd, particleOffset);
	
	CreateParticle(client, particleName, false, "", 0.5, particleOffset);
	
	int iParti = CreateEntityByName("info_particle_system");
	int iPart2 = CreateEntityByName("info_particle_system");

	if (IsValidEdict(iParti) && IsValidEdict(iPart2))
	{
		char szCtrlParti[32];
		Format(szCtrlParti, sizeof(szCtrlParti), "tf2ctrlpart%i", iPart2);
		DispatchKeyValue(iPart2, "targetname", szCtrlParti);
		DispatchKeyValue(iParti, "effect_name", "merasmus_zap");
		DispatchKeyValue(iParti, "cpoint1", szCtrlParti);
		DispatchSpawn(iParti);
		TeleportEntity(iParti, soundPos, clientAng, NULL_VECTOR);
		TeleportEntity(iPart2, clientpos, NULL_VECTOR, NULL_VECTOR);
		ActivateEntity(iParti);
		AcceptEntityInput(iParti, "Start");
		
		CreateTimer(0.5, Timer_KillParticle, EntIndexToEntRef(iParti));
		CreateTimer(0.5, Timer_KillParticle, EntIndexToEntRef(iPart2));
	}

	float LightningDamage = ArcaneDamage[client] * 100.0;
	int i = -1;
	while ((i = FindEntityByClassname(i, "*")) != -1)
	{
		if(!IsValidForDamage(i))
			continue;
		if(!IsOnDifferentTeams(client,i))
			continue;

		float VictimPos[3];
		GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
		VictimPos[2] += 30.0;

		if(GetVectorDistance(clientpos,VictimPos,true) > splashRadius[spellLevel]*splashRadius[spellLevel])
			continue;

		if(!IsPointVisible(clientpos,VictimPos))
			continue;

		SDKHooks_TakeDamage(i,client,client,LightningDamage,DMG_BULLET|DMG_IGNOREHOOK,-1,NULL_VECTOR,NULL_VECTOR, false);
	}
}
CastBlackskyEye(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	if(applyArcaneRestrictions(client, attuneSlot, 8.0, 0.5))
		return; 

	float clientpos[3];
	GetClientEyePosition(client,clientpos);
	EmitSoundToAll(SOUND_CALLBEYOND_CAST, 0, _, SNDLEVEL_NORMAL, _, 0.7, _,_,clientpos);
	//Properties
	int maxCount[] = {0,1,2,3};
	float projSpeed[] = {0.0,1200.0,2000.0,3000.0};
	float radius[] = {0.0,700.0,1200.0,1500.0};
	int tickRate[] = {0,4,2,0};
	for(int iter = 0;iter < maxCount[spellLevel];iter++)
	{
		int iEntity = CreateEntityByName("tf_projectile_arrow");
		if (!IsValidEdict(iEntity)) 
			continue;

		float fAngles[3]
		float fOrigin[3]
		float vBuffer[3]
		float fVelocity[3]
		float fwd[3]
		float right[3]
		int iTeam = GetClientTeam(client);
		SetEntityRenderColor(iEntity, 255, 255, 255, 0);
		SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

		SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
		SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
		SetEntPropEnt(iEntity, Prop_Data, "m_hOwnerEntity", client);
		SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);
					
		GetClientEyePosition(client, fOrigin);
		GetClientEyeAngles(client,fAngles);

		SetEntityRenderMode(iEntity, RENDER_NONE);
		
		GetAngleVectors(fAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
		GetAngleVectors(fAngles,fwd, right, NULL_VECTOR);
		ScaleVector(fwd, 60.0);

		switch(iter)
		{
			case 1:
			{
				ScaleVector(right, 50.0);
			}
			case 2:
			{
				ScaleVector(right, -50.0);
			}
		}

		AddVectors(fOrigin, right, fOrigin);
		AddVectors(fOrigin, fwd, fOrigin);
		
		float Speed = projSpeed[spellLevel];
		fVelocity[0] = vBuffer[0]*Speed;
		fVelocity[1] = vBuffer[1]*Speed;
		fVelocity[2] = vBuffer[2]*Speed;
		SetEntPropVector(iEntity, Prop_Send, "m_vInitialVelocity", fVelocity );
		TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
		DispatchSpawn(iEntity);

		CreateParticleEx(iEntity, "drg_cow_rockettrail_normal_blue", 1);
		
		SDKHook(iEntity, SDKHook_StartTouchPost, BlackskyEyeCollision);
		SDKHook(iEntity, SDKHook_Touch, AddArrowCollisionFunction);
		homingRadius[iEntity] = radius[spellLevel];
		homingTickRate[iEntity] = tickRate[spellLevel];
	}
}
CastACallBeyond(client, attuneSlot)
{
	if(applyArcaneRestrictions(client, attuneSlot, 50.0, 50.0))
		return; 


	TF2_StunPlayer(client,1.5,0.0,TF_STUNFLAGS_BIGBONK,0);
	TF2_AddCondition(client, TFCond_FreezeInput, 1.5);
	CreateTimer(1.5, ACallBeyond, EntIndexToEntRef(client));
	
	float clientpos[3];
	GetClientEyePosition(client,clientpos);
	EmitSoundToAll(SOUND_CALLBEYOND_CAST, 0, _, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,clientpos);
	CreateParticleEx(client, "merasmus_tp_bits", 1, _, _, 2.0);
	CreateParticleEx(client, "spellbook_major_burning", 1);
	CreateParticle(client, "unusual_meteor_cast_wheel_purple", true);
}
public Action:ACallBeyond(Handle timer, client) 
{
	client = EntRefToEntIndex(client)
	if(!IsValidClient3(client) || !IsPlayerAlive(client))
		return;
	
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	int projCount[] = {0,15,25,40};
	float radius[] = {0.0,1500.0,2500.0,2500.0};
	int tickRate[] = {0,5,2,0};
	for(int i = 0;i<projCount[spellLevel];++i)
	{
		int iEntity = CreateEntityByName("tf_projectile_arrow");
		if (!IsValidEdict(iEntity)) 
			continue;

		float fAngles[3]
		float fOrigin[3]
		float vBuffer[3]
		float fVelocity[3]
		float fwd[3]
		int iTeam = GetClientTeam(client);
		SetEntityRenderColor(iEntity, 255, 255, 255, 0);
		SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

		SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
		SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
		SetEntPropEnt(iEntity, Prop_Data, "m_hOwnerEntity", client);
		SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);
					
		GetClientEyePosition(client, fOrigin);
		GetClientEyeAngles(client,fAngles);
		
		fAngles[0] = -90.0 + GetRandomFloat(-120.0,120.0);
		fAngles[1] += GetRandomFloat(-60.0,60.0);

		GetAngleVectors(fAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
		GetAngleVectors(fAngles,fwd, NULL_VECTOR, NULL_VECTOR);
		ScaleVector(fwd, 130.0);
		
		AddVectors(fOrigin, fwd, fOrigin);
		
		float Speed = 1700.0;
		fVelocity[0] = vBuffer[0]*Speed;
		fVelocity[1] = vBuffer[1]*Speed;
		fVelocity[2] = vBuffer[2]*Speed;
		SetEntPropVector(iEntity, Prop_Send, "m_vInitialVelocity", fVelocity );
		TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
		DispatchSpawn(iEntity);
		SetEntityRenderMode(iEntity, RENDER_NONE);

		CreateParticleEx(iEntity, "drg_cow_rockettrail_charged_blue", 1);
		
		SDKHook(iEntity, SDKHook_StartTouchPost, CallBeyondCollision);
		SDKHook(iEntity, SDKHook_Touch, AddArrowCollisionFunction);
		
		homingRadius[iEntity] = radius[spellLevel];
		homingTickRate[iEntity] = tickRate[spellLevel];
		homingDelay[iEntity] = 0.15;
	}

	float clientpos[3];
	GetClientEyePosition(client,clientpos);
	EmitSoundToAll(SOUND_CALLBEYOND_ACTIVE, 0, _, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,clientpos);
}
CastZap(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	float focusCost = 5.0/ArcanePower[client];
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > GetGameTime())
		return;

	//zap yeah?
	int closestClient[MAXPLAYERS]; // Lets assume zap never targets more than max players.. hopefully.
	float clientpos[3];
	GetClientEyePosition(client,clientpos);
	clientpos[2] -= 15.0;
	float closestDistance = 100000000.0;
	int validCount = 0;
	int maximumTargets[] = {0,1,2,3};
	float range[] = {0.0,600.0,1500.0,1500.0};
	int i = -1;
	while ((i = FindEntityByClassname(i, "*")) != -1)
	{
		if(!IsValidForDamage(i))
			continue;
		if(!IsOnDifferentTeams(client,i))
			continue;
		if(validCount == maximumTargets[spellLevel])
			continue;

		float VictimPos[3];
		GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
		VictimPos[2] += 15.0;
		float Distance = GetVectorDistance(clientpos,VictimPos,true);

		if(Distance < closestDistance && Distance < range[spellLevel]*range[spellLevel])
		{
			if(IsPointVisible(clientpos,VictimPos))
			{
				closestClient[validCount] = i;
				closestDistance = Distance;
				validCount++;
			}
		}
	}

	if(validCount > 0)
	{
		applyArcaneRestrictions(client, attuneSlot, focusCost*ArcanePower[client], 0.5);
		for (int victim = 0;victim < validCount;victim++){
			DoZap(client,closestClient[victim], spellLevel);
		}
	}
	else
	{
		PrintHintText(client, "Zap found no valid targets!");
	}
}
DoZap(client,victim,spellLevel)
{
	if(!IsValidForDamage(victim))
		return;

	float clientpos[3];
	float VictimPosition[3];
	
	GetClientEyePosition(client,clientpos);
	GetEntPropVector(victim, Prop_Data, "m_vecOrigin", VictimPosition);
	VictimPosition[2] += 15.0;
	
	float range[] = {0.0,600.0,800.0,1000.0};
	
	TE_SetupBeamRingPoint(clientpos, 20.0, range[spellLevel]*1.25, g_LightningSprite, spriteIndex, 0, 5, 0.5, 10.0, 1.0, {255,0,255,133}, 140, 0);
	TE_SendToAll();
	TE_SetupBeamPoints(clientpos,VictimPosition,g_LightningSprite,spriteIndex,0,35,0.15,6.0,5.0,0,1.0,{255,000,255,255},20);
	TE_SendToAll();
	EmitSoundToAll(SOUND_ZAP, 0, _, SNDLEVEL_CONVO, _, 1.0, _,_,clientpos);
	
	float LightningDamage = 35.0 * ArcaneDamage[client];
	SDKHooks_TakeDamage(victim,client,client, LightningDamage, DMG_IGNOREHOOK, -1, NULL_VECTOR, NULL_VECTOR, false);
	float chance[] = {0.0,0.3,0.4,0.5};
		
	if(chance[spellLevel] >= GetRandomFloat(0.0, 1.0))
	{
		Handle hPack = CreateDataPack();
		WritePackCell(hPack, EntIndexToEntRef(client));
		WritePackCell(hPack, EntIndexToEntRef(victim));
		WritePackCell(hPack, spellLevel);
		CreateTimer(0.1,zapAgain,hPack);
	}
}
public Action:zapAgain(Handle timer,any:data)
{
	ResetPack(data);
	int client = EntRefToEntIndex(ReadPackCell(data));
	int victim = EntRefToEntIndex(ReadPackCell(data));
	int spellLevel = ReadPackCell(data);
	DoZap(client,victim,spellLevel);
	CloseHandle(data);
}
CastLightning(client, attuneSlot)
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	if(applyArcaneRestrictions(client, attuneSlot, 50.0, 11.0))
		return; 

	float clientpos[3];
	TracePlayerAim(client, clientpos);
	float temppos[3];
	TracePlayerAim(client, temppos);

	int quantity[] = {0,1,5,25}
	float afterburnDamage[] = {0.0,0.02,0.04,0.08}
	float range[] = {0.0,600.0,1200.0,1500.0}
	for(int iter = 0;iter < quantity[spellLevel];iter++)
	{
		// define where the lightning strike starts
		if(iter > 1)
		{
			clientpos[0] = temppos[0] + GetRandomFloat(-900.0,900.0);
			clientpos[1] = temppos[1] + GetRandomFloat(-900.0,900.0);
		}

		float startpos[3];
		startpos[0] = clientpos[0];
		startpos[1] = clientpos[1];
		startpos[2] = clientpos[2] + 1600;
		
		// define the color of the strike
		int iTeam = GetClientTeam(client);

		int color[4];
		color = iTeam == 2 ? {255, 0, 0, 255} : {0, 0, 255, 255};
		
		// define the direction of the sparks
		float dir[3] = {0.0, 0.0, 0.0};
		
		TE_SetupBeamPoints(startpos, clientpos, g_LightningSprite, 0, 0, 0, 0.2, 20.0, 10.0, 0, 1.0, color, 3);
		TE_SendToAll();
		
		TE_SetupSparks(clientpos, dir, 5000, 1000);
		TE_SendToAll();
		
		TE_SetupEnergySplash(clientpos, dir, false);
		TE_SendToAll();
		
		TE_SetupSmoke(clientpos, g_SmokeSprite, 5.0, 10);
		TE_SendToAll();
		
		TE_SetupBeamRingPoint(clientpos, 20.0, 650.0, g_LightningSprite, spriteIndex, 0, 5, 0.5, 10.0, 1.0, color, 200, 0);
		TE_SendToAll();
		
		int i = -1;
		float LightningDamage = 200.0 * ArcaneDamage[client];
		while ((i = FindEntityByClassname(i, "*")) != -1)
		{
			if(!IsValidForDamage(i)) 
				continue;
			if (!IsOnDifferentTeams(client,i))
				continue;

			float VictimPos[3];
			GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
			VictimPos[2] += 30.0;
			if(GetVectorDistance(clientpos,VictimPos,true) > range[spellLevel]*range[spellLevel])
				continue;

			if(!IsPointVisible(clientpos,VictimPos))
				continue;

			SDKHooks_TakeDamage(i,client,client,LightningDamage,DMG_SHOCK|DMG_IGNOREHOOK,_,_,_,false);
			
			if(IsValidClient3(i))
				TF2_IgnitePlayer(i, client, 3.0);

			DOTStock(i,client,LightningDamage*afterburnDamage[spellLevel],-1,0,20,1.0,0.1,true);//A fake afterburn. This allows for stacking of DOT & custom tick rates.
		}
	}
	EmitSoundToAll(SOUND_THUNDER, 0, _, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,clientpos);
}
CastHealing(client, attuneSlot)//Projected Healing
{
	int spellLevel = RoundToNearest(TF2Attrib_HookValueFloat(0.0, "arcane_spell_level", client)) + 1;

	if(applyArcaneRestrictions(client, attuneSlot, fl_MaxFocus[client]*0.65, 15.0))
		return; 

	float clientpos[3];
	GetClientEyePosition(client,clientpos);
	int iTeam = GetClientTeam(client);
	EmitSoundToAll(SOUND_HEAL, 0, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,clientpos);

	float fAngles[3],fOrigin[3],vBuffer[3],fVelocity[3], fwd[3];
	
	int projCount[] = {0,1,3,5};
	for(int i = 0;i<projCount[spellLevel];++i){
		int iEntity = CreateEntityByName("tf_projectile_flare");
		if (!IsValidEdict(iEntity)) 
			return;

		SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);
		SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
		SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
		SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);

		SetEntityRenderMode(iEntity, RENDER_NONE);
		GetClientEyePosition(client, fOrigin);
		GetClientEyeAngles(client,fAngles);

		if(projCount[spellLevel] > 1){
			fAngles[1] -= (projCount[spellLevel]-1)*4.0;
			fAngles[1] += i*8.0;
		}
		GetAngleVectors(fAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
		GetAngleVectors(fAngles,fwd, NULL_VECTOR, NULL_VECTOR);
		ScaleVector(fwd, 60.0);

		AddVectors(fOrigin, fwd, fOrigin);

		float Speed = 1800.0;
		fVelocity[0] = vBuffer[0]*Speed;
		fVelocity[1] = vBuffer[1]*Speed;
		fVelocity[2] = vBuffer[2]*Speed;
		SetEntPropVector(iEntity, Prop_Send, "m_vInitialVelocity", fVelocity );
		TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
		DispatchSpawn(iEntity);

		TE_SetupKillPlayerAttachments(iEntity);
		TE_SendToAll();

		int color[4] = {255, 220, 0, 255};

		TE_SetupBeamFollow(iEntity,Laser,0,0.5,4.0,8.0,3,color);
		TE_SendToAll();

		SDKHook(iEntity, SDKHook_StartTouchPost, ProjectedHealingCollision);
	}
}

CastWarp(client){
	warpCooldown[client] = GetGameTime()+(0.5/ArcanePower[client]);
	float focusCost = fl_MaxFocus[client]*0.1/ArcanePower[client];
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		return;
	}

	PrintHintText(client, "Used Warp! -%.2f focus.",focusCost);
	fl_CurrentFocus[client] -= focusCost;

    float vec[3], telepos[3], vecangles[3], vecorigin[3], fwd[3], mins[3], maxs[3];
    GetClientEyeAngles(client, vecangles);
    GetClientEyePosition(client, vecorigin);
	EmitSoundToAll(SOUND_TELEPORT, 0, client, _, _, 1.0, _,_,vecorigin);
	CreateParticle(client, "teleported_red");

	GetAngleVectors(vecangles,fwd, NULL_VECTOR, NULL_VECTOR);

	ScaleVector(fwd, 2000.0);
	AddVectors(vecorigin, fwd, telepos);

    for (int i = 0; i < 3; ++i){
        mins[i] -= 6;
        maxs[i] += 6;
    }

    TR_TraceHullFilter(vecorigin, telepos, mins, maxs, MASK_PLAYERSOLID,TraceEntityWarp, client);
    TR_GetEndPosition(vec);

    GetClientMins(client, mins);
    GetClientMaxs(client, maxs);
    
    for (int i = 0; i < 3; ++i){
        mins[i] -= 30;
        maxs[i] += 30;
    }

	float endpos[3];
	ScaleVector(fwd, -0.1);
	
	AddVectors(vec, fwd, endpos);

    TR_TraceHullFilter(endpos, vec, mins, maxs, MASK_PLAYERSOLID, TraceEntityFilterPlayers, client);
    TR_GetEndPosition(endpos);

	TeleportEntity(client, endpos, _, {0.0,0.0,0.0});

	int iPart1 = CreateEntityByName("info_particle_system");
	int iPart2 = CreateEntityByName("info_particle_system");

	if (IsValidEdict(iPart1) && IsValidEdict(iPart2))
	{
		char szCtrlParti[32];
		Format(szCtrlParti, sizeof(szCtrlParti), "tf2ctrlpart%i", iPart2);
		DispatchKeyValue(iPart2, "targetname", szCtrlParti);

		DispatchKeyValue(iPart1, "effect_name", "dxhr_sniper_rail_red");
		DispatchKeyValue(iPart1, "cpoint1", szCtrlParti);
		DispatchSpawn(iPart1);
		TeleportEntity(iPart1, vecorigin, NULL_VECTOR, NULL_VECTOR);
		TeleportEntity(iPart2, vec, NULL_VECTOR, NULL_VECTOR);
		ActivateEntity(iPart1);
		AcceptEntityInput(iPart1, "Start");
		
		CreateTimer(1.0, Timer_KillParticle, EntIndexToEntRef(iPart1));
		CreateTimer(1.0, Timer_KillParticle, EntIndexToEntRef(iPart2));
	}
	CreateParticle(client, "teleportedin_red");
}

CastStunShot(int client, int attuneSlot){
	if(applyArcaneRestrictions(client, attuneSlot, fl_MaxFocus[client]*0.1, 15.0))
		return;
	
	int CWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if(!IsValidWeapon(CWeapon))
		return;

	TF2Attrib_SetByName(client, "bullets per shot bonus", 5.0);
	refreshAllWeapons(client);
	SetEntPropFloat(CWeapon, Prop_Send, "m_flNextPrimaryAttack", GetGameTime());
	shouldAttack[client] = true;
	StunShotBPS[client] = true;
	StunShotStun[client] = true;
	RequestFrame(StunShotFunc, client);
}

CastFireballVolley(int client, int attuneSlot){
	if(applyArcaneRestrictions(client, attuneSlot, fl_MaxFocus[client]*0.1, 5.0))
		return;
	
	int CWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if(!IsValidWeapon(CWeapon))
		return;

	for(int i = 0;i<5;++i)
	{
		int iEntity = CreateEntityByName("tf_projectile_spellfireball");
		if (!IsValidEdict(iEntity)) 
			continue;

		int iTeam = GetClientTeam(client);
		float fAngles[3]
		float fOrigin[3]
		float vBuffer[3]
		float fVelocity[3]
		float fwd[3]
		SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);
		SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam);
		GetClientEyeAngles(client, fAngles);
		GetClientEyePosition(client, fOrigin);
		
		fAngles[1] -= 10.0*(5/2);
		fAngles[1] += i*10.0;

		GetAngleVectors(fAngles,fwd, NULL_VECTOR, NULL_VECTOR);
		ScaleVector(fwd, 30.0);
		
		AddVectors(fOrigin, fwd, fOrigin);
		GetAngleVectors(fAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
		
		float velocity = 1300.0;
		fVelocity[0] = vBuffer[0]*velocity;
		fVelocity[1] = vBuffer[1]*velocity;
		fVelocity[2] = vBuffer[2]*velocity;
		
		TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
		DispatchSpawn(iEntity);
		SDKHook(iEntity, SDKHook_StartTouch, OnStartTouchDragonsBreath);
		CreateTimer(10.0,SelfDestruct,EntIndexToEntRef(iEntity));
		homingRadius[iEntity] = 400.0;
		homingTickRate[iEntity] = 3;
	}
}

CastDash(int client, int attuneSlot){
	if(applyArcaneRestrictions(client, attuneSlot, 0.0, 1.0))
		return;
	
	float flSpeed = GetEntPropFloat(client, Prop_Data, "m_flMaxspeed") * 2.0;
	float flVel[3],flAng[3], vBuffer[3]
	GetClientEyeAngles(client,flAng)
	GetAngleVectors(flAng, vBuffer, NULL_VECTOR, NULL_VECTOR)
	flVel[0] = flSpeed * vBuffer[0] * 1.5;
	flVel[1] = flSpeed * vBuffer[1] * 1.5;
	flVel[2] = 100.0 + (flSpeed * (vBuffer[2] * 0.75));
	if(GetEntityFlags(client) & FL_ONGROUND)
		flVel[2] += 200;
	TeleportEntity(client, NULL_VECTOR,NULL_VECTOR, flVel)
	EmitSoundToAll(SOUND_DASH, client, -1, 80, 0, 1.0);
}

CastTransientMoonlight(int client, int attuneSlot){
	if(applyArcaneRestrictions(client, attuneSlot, fl_MaxFocus[client]*0.1, 5.0))
		return;
	
	int CWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if(!IsValidWeapon(CWeapon))
		return;

	float fAngles[3], fVelocity[3], fOrigin[3], vBuffer[3], fwd[3];
	char projName[32] = "tf_projectile_arrow";
	int iEntity = CreateEntityByName(projName);
	if (IsValidEdict(iEntity)) 
	{
		int iTeam = GetClientTeam(client);
		SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

		SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam);
		SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);
		GetClientEyePosition(client, fOrigin);
		GetClientEyeAngles(client, fAngles);
		GetAngleVectors(fAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
		GetAngleVectors(fAngles,fwd, NULL_VECTOR, NULL_VECTOR);
		ScaleVector(fwd, 50.0);
		AddVectors(fOrigin, fwd, fOrigin);
		float velocity = 5000.0;
		fVelocity[0] = vBuffer[0]*velocity;
		fVelocity[1] = vBuffer[1]*velocity;
		fVelocity[2] = vBuffer[2]*velocity;
		
		TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
		DispatchSpawn(iEntity);
		SetEntPropVector(iEntity, Prop_Send, "m_vInitialVelocity", fVelocity );
		if(HasEntProp(iEntity, Prop_Send, "m_hLauncher"))
		{
			SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", CWeapon);
		}
		SetEntPropEnt(iEntity, Prop_Send, "m_hOriginalLauncher", client);
		SetEntProp(iEntity, Prop_Send, "m_usSolidFlags", 0x0008);
		SetEntProp(iEntity, Prop_Data, "m_nSolidType", 6);
		SetEntProp(iEntity, Prop_Send, "m_CollisionGroup", 13);
		SDKHook(iEntity, SDKHook_StartTouch, OnStartTouchMoonveil);
		
		float vecBossMin[3], vecBossMax[3];
		GetEntPropVector(iEntity, Prop_Send, "m_vecMins", vecBossMin);
		GetEntPropVector(iEntity, Prop_Send, "m_vecMaxs", vecBossMax);
		
		float vecScaledBossMin[3], vecScaledBossMax[3];
		
		vecScaledBossMin = vecBossMin;
		vecScaledBossMax = vecBossMax;
		
		//PrintToChat(client, "%.2f | %.2f",vecScaledBossMin[0],vecScaledBossMax[0])
		//PrintToChat(client, "%.2f | %.2f",vecScaledBossMin[1],vecScaledBossMax[1])
		//PrintToChat(client, "%.2f | %.2f",vecScaledBossMin[2],vecScaledBossMax[2])

		vecScaledBossMin[0] -= 10.0;
		vecScaledBossMax[0] += 10.0;
		vecScaledBossMin[1] -= 10.0;
		vecScaledBossMax[1] += 10.0;
		vecScaledBossMin[2] -= 20.0;
		vecScaledBossMax[2] += 20.0;
		
		
		SetEntPropVector(iEntity, Prop_Send, "m_vecMins", vecScaledBossMin);
		SetEntPropVector(iEntity, Prop_Send, "m_vecMaxs", vecScaledBossMax);
		
		float particleOffset[3];
		CreateParticle(iEntity, "utaunt_auroraglow_purple_parent", true, _, 5.0, particleOffset);
		particleOffset[2] -= 20.0;
		CreateParticle(iEntity, "utaunt_auroraglow_purple_parent", true, _, 5.0, particleOffset);
		particleOffset[2] += 40.0;
		CreateParticle(iEntity, "utaunt_auroraglow_purple_parent", true, _, 5.0, particleOffset);
	}
}

CastCorpsePiler(int client, int attuneSlot){
	if(applyArcaneRestrictions(client, attuneSlot, 0.0, 30.0))
		return;
	
	int CWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if(!IsValidWeapon(CWeapon))
		return;

	shouldAttack[client] = true;
	SetEntPropFloat(CWeapon, Prop_Send, "m_flNextPrimaryAttack", GetGameTime()+1.5);

	for(int i=0;i<20;++i)
	{
		Handle hPack = CreateDataPack();
		WritePackCell(hPack, EntIndexToEntRef(CWeapon));
		WritePackCell(hPack, EntIndexToEntRef(client));
		CreateTimer(0.06*i, CreateBloodTracer, hPack);
	}
}

CastHomingFlares(int client, int attuneSlot){
	if(applyArcaneRestrictions(client, attuneSlot, 0.0, 7.0))
		return;
	
	int CWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if(!IsValidWeapon(CWeapon))
		return;
		
	int iTeam = GetClientTeam(client);
	float fAngles[3],fOrigin[3],vBuffer[3],vRight[3],fVelocity[3],fwd[3]
	for(int i=0;i<3;++i)
	{
		int iEntity = CreateEntityByName("tf_projectile_flare");
		if (!IsValidEdict(iEntity)) 
			continue;

		SetEntityRenderColor(iEntity, 255, 255, 255, 0);
		SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

		SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
		SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
		SetEntPropEnt(iEntity, Prop_Data, "m_hOwnerEntity", client);
		SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);
		SetEntProp(iEntity, Prop_Send, "m_usSolidFlags", 0x0008 + 0x0004);
		SetEntProp(iEntity, Prop_Data, "m_nSolidType", 6);
		SetEntProp(iEntity, Prop_Send, "m_CollisionGroup", 2);
					
		GetClientEyePosition(client, fOrigin);
		GetClientEyeAngles(client,fAngles);
		
		GetAngleVectors(fAngles, vBuffer, vRight, NULL_VECTOR);
		GetAngleVectors(fAngles,fwd, NULL_VECTOR, NULL_VECTOR);
		ScaleVector(fwd, 60.0);
		ScaleVector(vRight, 30.0*(i-1))
		AddVectors(fOrigin, vRight, fOrigin);
		AddVectors(fOrigin, fwd, fOrigin);
		
		float Speed = 1200.0;
		fVelocity[0] = vBuffer[0]*Speed;
		fVelocity[1] = vBuffer[1]*Speed;
		fVelocity[2] = vBuffer[2]*Speed;
		SetEntPropVector(iEntity, Prop_Send, "m_vInitialVelocity", fVelocity );
		TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
		DispatchSpawn(iEntity);
		SetEntityGravity(iEntity,0.01);
		
		SDKHook(iEntity, SDKHook_Touch, OnCollisionPhotoViscerator);
		homingRadius[iEntity] = 400.0;
		CreateParticle(iEntity, "utaunt_auroraglow_green_parent", true, _, 5.0);
		CreateTimer(5.0, SelfDestruct, EntIndexToEntRef(iEntity));
	}
}

CastSilentDash(int client, int attuneSlot){
	if(applyArcaneRestrictions(client, attuneSlot, 0.0, 1.0))
		return;

	float flSpeed = GetEntPropFloat(client, Prop_Data, "m_flMaxspeed") * 2.0
	float flVel[3],flAng[3],vBuffer[3]
	GetClientEyeAngles(client,flAng)
	GetAngleVectors(flAng, vBuffer, NULL_VECTOR, NULL_VECTOR)
	flVel[0] = flSpeed * vBuffer[0] * 1.5;
	flVel[1] = flSpeed * vBuffer[1] * 1.5;
	flVel[2] = 100.0 + (flSpeed * vBuffer[2]);
	
	if(flVel[2] < -100.0)
		flVel[2] *= 2.5;

	if(GetEntityFlags(client) & FL_ONGROUND)
		flVel[2] += 200;

	TeleportEntity(client, NULL_VECTOR,NULL_VECTOR, flVel)
}