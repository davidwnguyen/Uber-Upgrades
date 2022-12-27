//Arcane Menu
public Menu_ShowArcane(client)
{
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		new Handle:menu = CreateMenu(MenuHandler_ArcaneCast);
		new attunement = 1;
		new Address:attuneActive = TF2Attrib_GetByName(client, "arcane attunement slots");
		if(attuneActive != Address_Null)
		{
			attunement += RoundToNearest(TF2Attrib_GetValue(attuneActive));
		}
		
		SetMenuExitBackButton(menu, true);
		SetMenuTitle(menu, "Use Arcane Spells");
		for (new s = 0; s < attunement; s++)
		{
			decl String:fstr[100]
			Format(fstr, sizeof(fstr), "Use Arcane Spell #%i", s+1);
			AddMenuItem(menu, "spell", fstr);
		}
		if (IsValidClient(client) && IsPlayerAlive(client))
		{
			DisplayMenu(menu, client, MENU_TIME_FOREVER);
		}
	}
	return;
}
public MenuHandler_ArcaneCast(Handle:menu, MenuAction:action, client, param2)
{
	if (action == MenuAction_Select && IsValidClient(client) && IsPlayerAlive(client))
	{
		if(param2 >= 0 && param2 <= Max_Attunement_Slots)
		{
			if(AttunedSpells[client][param2] != 0.0)
			{
				if(!TF2_IsPlayerInCondition(client, TFCond_Cloaked))
				{
					if(TF2_IsPlayerInCondition(client, TFCond_Disguised))
					{
						TF2_RemoveCondition(client, TFCond_Disguised);
					}
					switch(AttunedSpells[client][param2])
					{
						case 1.0:
						{
							CastZap(client, param2);
						}
						case 2.0:
						{
							CastLightning(client, param2);
						}
						case 3.0:
						{
							CastHealing(client, param2);
						}
						case 4.0:
						{
							CastACallBeyond(client, param2);
						}
						case 5.0:
						{
							CastBlackskyEye(client, param2);
						}
						case 6.0:
						{
							CastSunlightSpear(client, param2);
						}
						case 7.0:
						{
							CastLightningEnchantment(client, param2);
						}
						case 8.0:
						{
							CastSnapFreeze(client, param2);
						}
						case 9.0:
						{
							CastArcanePrison(client, param2);
						}
						case 10.0:
						{
							CastDarkmoonBlade(client, param2);
						}
						case 11.0:
						{
							CastSpeedAura(client, param2);
						}
						case 12.0:
						{
							CastAerialStrike(client, param2);
						}
						case 13.0:
						{
							CastInferno(client, param2);
						}
						case 14.0:
						{
							CastMineField(client, param2);
						}
						case 15.0:
						{
							CastShockwave(client, param2);
						}
						case 16.0:
						{
							CastAutoSentry(client, param2);
						}						
						case 17.0:
						{
							CastSoothingSunlight(client, param2);
						}
						case 18.0:
						{
							CastArcaneHunter(client, param2);
						}
						case 19.0:
						{
							CastMarkForDeath(client, param2);
						}
						default:
						{
							PrintHintText(client, "Sorry, we havent implemented this yet!");
						}
					}
				}
				else
				{
					PrintHintText(client, "You cannot cast spells while invisible.");
				}
			}
			else
			{
				PrintHintText(client, "You have nothing attuned to this slot!");
			}
		}

		Menu_ShowArcane(client);
		CloseHandle(menu);
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
	new String:arg1[128];
	new param2;
	if (GetCmdArg(1, arg1, sizeof(arg1)))
	{
		param2 = StringToInt(arg1)-1;
		if (IsValidClient(client) && IsPlayerAlive(client))
		{
			new attuneSlots = 0
			new Address:slotActive = TF2Attrib_GetByName(client, "arcane attunement slots");
			if(slotActive != Address_Null)
			{
				attuneSlots += RoundToNearest(TF2Attrib_GetValue(slotActive))
			}
			if(param2 >= 0 && param2 <= attuneSlots)
			{
				if(AttunedSpells[client][param2] != 0.0)
				{
					if(!TF2_IsPlayerInCondition(client, TFCond_Cloaked))
					{
						if(TF2_IsPlayerInCondition(client, TFCond_Disguised))
						{
							TF2_RemoveCondition(client, TFCond_Disguised);
						}
						switch(AttunedSpells[client][param2])
						{
							case 1.0:
							{
								CastZap(client, param2);
							}
							case 2.0:
							{
								CastLightning(client, param2);
							}
							case 3.0:
							{
								CastHealing(client, param2);
							}
							case 4.0:
							{
								CastACallBeyond(client, param2);
							}
							case 5.0:
							{
								CastBlackskyEye(client, param2);
							}
							case 6.0:
							{
								CastSunlightSpear(client, param2);
							}
							case 7.0:
							{
								CastLightningEnchantment(client, param2);
							}
							case 8.0:
							{
								CastSnapFreeze(client, param2);
							}
							case 9.0:
							{
								CastArcanePrison(client, param2);
							}
							case 10.0:
							{
								CastDarkmoonBlade(client, param2);
							}
							case 11.0:
							{
								CastSpeedAura(client, param2);
							}
							case 12.0:
							{
								CastAerialStrike(client, param2);
							}
							case 13.0:
							{
								CastInferno(client, param2);
							}
							case 14.0:
							{
								CastMineField(client, param2);
							}
							case 15.0:
							{
								CastShockwave(client, param2);
							}
							case 16.0:
							{
								CastAutoSentry(client, param2);
							}						
							case 17.0:
							{
								CastSoothingSunlight(client, param2);
							}
							case 18.0:
							{
								CastArcaneHunter(client, param2);
							}
							case 19.0:
							{
								CastMarkForDeath(client, param2);
							}
							default:
							{
								PrintHintText(client, "Sorry, we havent implemented this yet!");
							}
						}
					}
					else
					{
						PrintHintText(client, "You cannot cast spells while invisible.");
					}
				}
				else
				{
					PrintHintText(client, "You have nothing attuned to this slot!");
				}
			}
		}
	}
	return Plugin_Handled;
}


//Arcane Spells
CastMarkForDeath(client, attuneSlot)
{
	new Address:classSpecificActive = TF2Attrib_GetByName(client, "arcane mark for death");
	int spellLevel = classSpecificActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(classSpecificActive));
	if(spellLevel < 1)
		return;

	new Float:focusCost = (fl_MaxFocus[client]*0.50)
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[18],focusCost);
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 25.0;
	applyArcaneCooldownReduction(client, attuneSlot);

	new Float:clientpos[3];
	TracePlayerAim(client, clientpos);
	new Float:Range = 900.0*ArcanePower[client];
	for(new i = 1; i<MAXENTITIES;i++)
	{
		if(!IsValidForDamage(i))
			continue;
		if(!IsOnDifferentTeams(client,i))
			continue;

		new Float:VictimPos[3];
		GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
		VictimPos[2] += 30.0;
		new Float:Distance = GetVectorDistance(clientpos,VictimPos);
		if(Distance > Range)
			continue;

		if(!IsPointVisible(clientpos,VictimPos))
			continue;

		if(IsValidClient3(i))
		{
			TF2_AddCondition(i, TFCond_Sapped, 10.0);
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
	EmitSoundToAll(SOUND_SABOTAGE, _, client, SNDLEVEL_SNOWMOBILE, _, 1.0, _,_,clientpos);
}
CastSunlightSpear(client, attuneSlot)
{
	new Address:SunlightSpearActive = TF2Attrib_GetByName(client, "arcane sunlight spear");
	int spellLevel = SunlightSpearActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(SunlightSpearActive));
	if(spellLevel < 1)
		return;
	new Float:level = ArcaneDamage[client];
	new Float:focusCost = (30.0 + (20.0 * level))/ArcanePower[client]
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 0.4;
	applyArcaneCooldownReduction(client, attuneSlot);

	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[5],focusCost);

	new Float:clientpos[3];
	GetClientEyePosition(client,clientpos);
	EmitSoundToAll(SOUND_CALLBEYOND_CAST, _, client, SNDLEVEL_NORMAL, _, 0.8, _,_,clientpos);
	new iEntity = CreateEntityByName("tf_projectile_arrow");
	if (!IsValidEdict(iEntity)) 
		return;
	new Float:fAngles[3]
	new Float:fOrigin[3]
	new Float:vBuffer[3]
	new Float:fVelocity[3]
	new Float:fwd[3]
	new iTeam = GetClientTeam(client);
	SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

	SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
	SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
	SetEntPropEnt(iEntity, Prop_Data, "m_hOwnerEntity", client);
	SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);
	//SetEntProp(iEntity, Prop_Send, "m_bCritical", 1);
				
	GetClientEyePosition(client, fOrigin);
	GetClientEyeAngles(client,fAngles);
	
	GetAngleVectors(fAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
	GetAngleVectors(fAngles,fwd, NULL_VECTOR, NULL_VECTOR);
	ScaleVector(fwd, 30.0);
	
	AddVectors(fOrigin, fwd, fOrigin);
	
	new Float:Speed = 3000.0;
	fVelocity[0] = vBuffer[0]*Speed;
	fVelocity[1] = vBuffer[1]*Speed;
	fVelocity[2] = vBuffer[2]*Speed;
	SetEntPropVector(iEntity, Prop_Send, "m_vInitialVelocity", fVelocity );
	TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
	DispatchSpawn(iEntity);
	SDKHook(iEntity, SDKHook_Touch, OnSunlightSpearCollision);
	
	for(new it = 0;it < 3;it++)
	{
		new iParticle = CreateParticle(iEntity, "raygun_projectile_red_crit_trail", true, "", 4.0);
		TeleportEntity(iParticle, NULL_VECTOR, fAngles, NULL_VECTOR);
	}
	
	new iParticle2 = CreateParticle(iEntity, "raygun_projectile_red_trail", true, "", 4.0);
	TeleportEntity(iParticle2, NULL_VECTOR, fAngles, NULL_VECTOR);
	
	TE_SetupKillPlayerAttachments(iEntity);
	TE_SendToAll();
	new color[4]={255, 200, 0,225};
	TE_SetupBeamFollow(iEntity,Laser,0,0.5,3.0,3.0,1,color);
	TE_SendToAll();
}
CastLightningEnchantment(client, attuneSlot)
{
	new Address:lightningenchantmentActive = TF2Attrib_GetByName(client, "arcane lightning enchantment");
	int spellLevel = lightningenchantmentActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(lightningenchantmentActive));
	if(spellLevel < 1)
		return;

	new Float:focusCost = (150.0 + (40.0 * ArcaneDamage[client]))/ArcanePower[client];
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;
		
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 30.0;
	applyArcaneCooldownReduction(client, attuneSlot);

	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[6],focusCost);
	
	LightningEnchantment[client] = (10.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 4.0));
	LightningEnchantmentDuration[client] = 20.0 * ArcanePower[client];	
}
CastDarkmoonBlade(client, attuneSlot)
{
	new Address:darkmoonbladeActive = TF2Attrib_GetByName(client, "arcane darkmoon blade");
	int spellLevel = darkmoonbladeActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(darkmoonbladeActive));
	if(spellLevel < 1)
		return;

	new Float:focusCost = (100.0 + (20.0 * ArcaneDamage[client]))/ArcanePower[client];
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 25.0;
	applyArcaneCooldownReduction(client, attuneSlot);
	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[9],focusCost);
	
	DarkmoonBlade[client] = (10.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 4.5));
	DarkmoonBladeDuration[client] = 20.0 * ArcanePower[client];
}
CastSnapFreeze(client, attuneSlot)
{
	new Address:snapfreezeActive = TF2Attrib_GetByName(client, "arcane snap freeze");
	int spellLevel = snapfreezeActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(snapfreezeActive));
	if(spellLevel < 1)
		return;

	new Float:level = ArcaneDamage[client];
	new Float:focusCost = (40.0 + (20.0 * level))/ArcanePower[client]
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	new Float:clientpos[3];
	GetClientEyePosition(client, clientpos);
	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[7],focusCost);
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 9.0;
	applyArcaneCooldownReduction(client, attuneSlot);

	EmitSoundToAll(SOUND_FREEZE, _, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,clientpos);
	float damage = 100.0 + (Pow(level * Pow(ArcanePower[client], 4.0), 2.45) * 60.0);
	for(new i = 1; i<MAXENTITIES;i++)
	{
		if(!IsValidForDamage(i))
			continue;
		if(!IsOnDifferentTeams(client,i))
			continue;

		new Float:VictimPos[3];
		GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
		VictimPos[2] += 15.0;

		if(GetVectorDistance(clientpos,VictimPos) > 500.0)
			continue;
		
		if(!IsPointVisible(clientpos,VictimPos))
			continue;

		SDKHooks_TakeDamage(i,client,client,damage,DMG_BULLET,-1,NULL_VECTOR,NULL_VECTOR, !IsValidClient3(i));
		if(IsValidClient3(i))
		{
			TF2_AddCondition(i, TFCond_FreezeInput, 0.4);
			TF2_StunPlayer(i, 0.4,1.0,TF_STUNFLAGS_NORMALBONK,client);
		}
	}
	TF2_AddCondition(client, TFCond_ObscuredSmoke, 0.4);
	GetClientAbsOrigin(client, clientpos);
	CreateSmoke(clientpos,0.3,255,255,255,"200","20");
	CreateParticle(client, "utaunt_snowring_icy_parent", true);

}
CastArcanePrison(client, attuneSlot)
{
	new Address:arcaneprisonActive = TF2Attrib_GetByName(client, "arcane prison");
	int spellLevel = arcaneprisonActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(arcaneprisonActive));
	if(spellLevel < 1)
		return;
	new Float:level = ArcaneDamage[client];
	new Float:focusCost = (60.0 + (35.0 * level))/ArcanePower[client]
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	new Float:ClientPos[3];
	new Float:ClientAngle[3];
	GetClientEyePosition(client,ClientPos);
	GetClientEyeAngles(client,ClientAngle);
	new iTeam = GetClientTeam(client)
	ClientPos[2] -= 20.0;

	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[8],focusCost);
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 20.0;

	applyArcaneCooldownReduction(client, attuneSlot);
	EmitSoundToAll(SOUND_CALLBEYOND_ACTIVE, _, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,ClientPos);
	
	new iEntity = CreateEntityByName("tf_projectile_lightningorb");
	if (!IsValidEdict(iEntity)) 
		return;

	new Float:fAngles[3]
	new Float:fOrigin[3]
	new Float:vBuffer[3]
	new Float:fVelocity[3]
	
	if(LookPoint(client,fOrigin))
	{
		SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

		SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
		SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
		SetEntPropEnt(iEntity, Prop_Data, "m_hOwnerEntity", client);
		SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);

		fOrigin[2] += 40.0
		GetClientEyeAngles(client,fAngles);
		
		GetAngleVectors(fAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
		
		new Float:Speed = 0.0;
		fVelocity[0] = vBuffer[0]*Speed;
		fVelocity[1] = vBuffer[1]*Speed;
		fVelocity[2] = vBuffer[2]*Speed;
		SetEntPropVector(iEntity, Prop_Send, "m_vInitialVelocity", fVelocity );
		TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
		DispatchSpawn(iEntity);
	}
}
CastSpeedAura(client, attuneSlot)
{
	new Address:classSpecificActive = TF2Attrib_GetByName(client, "arcane speed aura");
	int spellLevel = classSpecificActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(classSpecificActive));
	if(spellLevel < 1)
		return;
	new Float:focusCost = (fl_MaxFocus[client]*0.4)/ArcanePower[client]
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	new Float:ClientPos[3];
	GetClientEyePosition(client,ClientPos);
	new iTeam = GetClientTeam(client)
	ClientPos[2] -= 20.0;

	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[10],focusCost);
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 35.0;
	applyArcaneCooldownReduction(client, attuneSlot);
	for(new i = 1; i<MaxClients;i++)
	{
		if(!IsValidClient3(i))
			continue;
		if(GetClientTeam(i) != iTeam)
			continue;
		new Float:VictimPos[3];
		GetClientEyePosition(i,VictimPos);
		new Float:Distance = GetVectorDistance(ClientPos,VictimPos);
		new Float:Range = 800.0;
		if(Distance > Range)
			continue;

		TF2_AddCondition(i, TFCond_SpeedBuffAlly, 8.0);
		TF2_AddCondition(i, TFCond_RuneAgility, 8.0);
		TF2_AddCondition(i, TFCond_DodgeChance, 1.5);
	}
	EmitSoundToAll(SOUND_SPEEDAURA, _, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,ClientPos);
}
CastAerialStrike(client, attuneSlot)
{
	new Address:classSpecificActive = TF2Attrib_GetByName(client, "arcane aerial strike");
	int spellLevel = classSpecificActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(classSpecificActive));
	if(spellLevel < 1)
		return;

	new Float:level = ArcaneDamage[client];
	new Float:focusCost = (150.0 + (45.0 * level))/ArcanePower[client]
	if(fl_CurrentFocus[client] < focusCost)
	{			
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	new Float:ClientPos[3];
	TracePlayerAim(client, ClientPos);
	new iTeam = GetClientTeam(client)

	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[11],focusCost);
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 60.0;
	applyArcaneCooldownReduction(client, attuneSlot);
	new Float:ProjectileDamage = 90.0 + (Pow(level*Pow(ArcanePower[client], 4.0),2.45) * 25.0);
	new Handle:hPack = CreateDataPack();
	WritePackCell(hPack, client);
	WritePackCell(hPack, iTeam);
	WritePackFloat(hPack, ProjectileDamage);
	
	WritePackFloat(hPack, ClientPos[0]);
	WritePackFloat(hPack, ClientPos[1]);
	WritePackFloat(hPack, ClientPos[2]);
	
	CreateTimer(1.0,aerialStrike,hPack);
	if(iTeam == 2)
	{
		EmitSoundToAll(SOUND_HORN_RED, _, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,ClientPos);
		TE_SetupBeamRingPoint(ClientPos, 20.0, 800.0, g_LightningSprite, spriteIndex, 0, 5, 1.0, 10.0, 1.0, {255,0,0,180}, 400, 0);
		TE_SendToAll();
	}
	else
	{
		EmitSoundToAll(SOUND_HORN_BLUE, _, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,ClientPos);
		TE_SetupBeamRingPoint(ClientPos, 20.0, 800.0, g_LightningSprite, spriteIndex, 0, 5, 1.0, 10.0, 1.0, {0,0,255,180}, 400, 0);
		TE_SendToAll();
	}
}
public Action:aerialStrike(Handle:timer,any:data)
{
	ResetPack(data);
	new client = ReadPackCell(data);
	new iTeam = ReadPackCell(data);
	new Float:ProjectileDamage = ReadPackFloat(data);
	new Float:ClientPos[3];
	ClientPos[0] = ReadPackFloat(data);
	ClientPos[1] = ReadPackFloat(data);
	ClientPos[2] = ReadPackFloat(data);
	for(new i = 0;i<30;i++)
	{
		new iEntity = CreateEntityByName("tf_projectile_rocket");
		if (!IsValidEdict(iEntity)) 
			continue;

		new Float:fAngles[3]
		new Float:fOrigin[3]
		new Float:vBuffer[3]
		new Float:fVelocity[3]
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
		fOrigin[0] += GetRandomFloat(-300.0/ArcanePower[client],300.0/ArcanePower[client]);
		fOrigin[1] += GetRandomFloat(-300.0/ArcanePower[client],300.0/ArcanePower[client]);
		fOrigin[2] += 1000.0;
		
		new Float:Speed = 1500.0;
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
	new Address:classSpecificActive = TF2Attrib_GetByName(client, "arcane inferno");
	int spellLevel = classSpecificActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(classSpecificActive));
	if(spellLevel < 1)
		return;
	new Float:level = ArcaneDamage[client];
	new Float:focusCost = (150.0 + (45.0 * level))/ArcanePower[client]
	if(fl_CurrentFocus[client] >= focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] <= 0.0)
		return;

	new Float:ClientPos[3];
	GetClientEyePosition(client,ClientPos);
	ClientPos[2] -= 20.0;

	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[12],focusCost);
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 60.0;
	applyArcaneCooldownReduction(client, attuneSlot);
		
	EmitSoundToAll(SOUND_INFERNO, _, client, SNDLEVEL_ROCKET, _, 1.0, _,_,ClientPos);
	
	//scripting god
	new Float:flamePos[3];
	flamePos = ClientPos;
	flamePos[2] += 400.0;
	//ohhhhh myyyyy god!!!!!!
	CreateParticle(-1, "cinefx_goldrush_flames", false, "", 3.5,flamePos);
	//
	flamePos[0] += 400.0;
	CreateParticle(-1, "cinefx_goldrush_flames", false, "", 3.5,flamePos);
	//
	flamePos[1] += 400.0;
	CreateParticle(-1, "cinefx_goldrush_flames", false, "", 3.5,flamePos);
	//
	flamePos[1] -= 800.0;
	CreateParticle(-1, "cinefx_goldrush_flames", false, "", 3.5,flamePos);
	//
	flamePos[0] -= 400.0;
	CreateParticle(-1, "cinefx_goldrush_flames", false, "", 3.5,flamePos);
	//
	flamePos[1] += 800.0;
	CreateParticle(-1, "cinefx_goldrush_flames", false, "", 3.5,flamePos);
	//
	flamePos[0] -= 400.0;
	CreateParticle(-1, "cinefx_goldrush_flames", false, "", 3.5,flamePos);
	//
	flamePos[1] -= 400.0;
	CreateParticle(-1, "cinefx_goldrush_flames", false, "", 3.5,flamePos);
	//
	flamePos[1] -= 400.0;
	CreateParticle(-1, "cinefx_goldrush_flames", false, "", 3.5,flamePos);
	
	
	new Float:DMGDealt = 20.0 + (Pow(level*Pow(ArcanePower[client], 4.0),2.45) * 12.5);
	for(new i = 1; i<MAXENTITIES;i++)
	{
		if(!IsValidForDamage(i))
			continue;
		if(!IsOnDifferentTeams(client,i))
			continue;

		new Float:VictimPos[3];
		GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
		new Float:Distance = GetVectorDistance(ClientPos,VictimPos);
		if(Distance > 800.0)
			continue;

		CreateParticle(i, "dragons_fury_effect_parent", true, "", 2.0);
		CreateParticle(i, "utaunt_glowyplayer_orange_glow", true, "", 2.0,_,_,1);
		DOTStock(i,client,DMGDealt,-1,DMG_BURN,20,1.0,0.12,true);
	}
}

CastMineField(client, attuneSlot)
{
	new Address:classSpecificActive = TF2Attrib_GetByName(client, "arcane mine field");
	int spellLevel = classSpecificActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(classSpecificActive));
	if(spellLevel < 1)
		return;

	new Float:level = ArcaneDamage[client];
	new Float:focusCost = (120.0 + (50.0 * level))/ArcanePower[client]
	if(fl_CurrentFocus[client] < focusCost)
	{			
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;
		
	new Float:ClientPos[3];
	TracePlayerAim(client, ClientPos);
	new iTeam = GetClientTeam(client)
	
	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[13],focusCost);
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 50.0;
	applyArcaneCooldownReduction(client, attuneSlot);
		
	new Float:radius = 300.0*ArcanePower[client];
	new Float:damage = 90.0 + (Pow(level*Pow(ArcanePower[client], 4.0),2.45) * 6.5);
	for(new i = 0;i<20;i++)
	{
		new iEntity = CreateEntityByName("tf_projectile_pipe_remote");
		if (!IsValidEdict(iEntity)) 
			continue;
		new Float:fAngles[3]
		new Float:fOrigin[3]
		new Float:vBuffer[3]
		new Float:fVelocity[3]
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
		fOrigin[0] += GetRandomFloat(-300.0/ArcanePower[client],300.0/ArcanePower[client]);
		fOrigin[1] += GetRandomFloat(-300.0/ArcanePower[client],300.0/ArcanePower[client]);
		fOrigin[2] += 10.0;
		
		new Float:Speed = 1500.0;
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
	new entity = EntRefToEntIndex(ref); 
	if(!IsValidEntity(entity))
		return;
	if(!HasEntProp(entity, Prop_Data, "m_hThrower"))
		return;
    
	new client = GetEntPropEnt(entity, Prop_Data, "m_hThrower"); 
	if (!IsValidClient(client))
		return;
	if(!IsPlayerAlive(client))
		return;
	
	CreateTimer(0.1,Timer_GrenadeMines,  EntIndexToEntRef(entity), TIMER_REPEAT);
	CreateTimer(20.0,SelfDestruct,  EntIndexToEntRef(entity));
	SetEntProp(entity, Prop_Data, "m_nNextThinkTick", -1);
	lastMinesTime[client] = GetGameTime();
}
public Action:Timer_GrenadeMines(Handle:timer, any:ref) 
{ 
    new entity = EntRefToEntIndex(ref);
	if(!IsValidEntity(entity)){KillTimer(timer);return;}

	new client = GetEntPropEnt(entity, Prop_Data, "m_hThrower"); 
	if(!IsValidClient3(client)){KillTimer(timer);return;}

	new Float:distance = GetEntPropFloat(entity, Prop_Send, "m_DmgRadius")
	new Float:damage = GetEntPropFloat(entity, Prop_Send, "m_flDamage")
	new Float:timeMod = 1.0+((GetGameTime()-lastMinesTime[client])*0.35);
	new Float:grenadevec[3], Float:targetvec[3];
	GetEntPropVector(entity, Prop_Data, "m_vecOrigin", grenadevec);
	
	for(new i=1; i<=MaxClients; i++)
	{
		if(!IsValidClient3(i))
			continue;

		if(IsClientObserver(i))
			continue;

		if(GetClientTeam(i) == GetClientTeam(client))
			continue;

		GetClientAbsOrigin(i, targetvec);
		if(GetVectorDistance(grenadevec, targetvec, false) > distance)
			continue;

		if(TF2Spawn_IsClientInSpawn(i))
			continue;

		if(!IsAbleToSee(client,i))
			continue;

		EntityExplosion(client, damage*timeMod, distance, grenadevec, 0,_,entity);
		RemoveEntity(entity);
		KillTimer(timer);
		break;
	}
}
CastShockwave(client, attuneSlot)
{
	new Address:classSpecificActive = TF2Attrib_GetByName(client, "arcane shockwave");
	int spellLevel = classSpecificActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(classSpecificActive));
	if(spellLevel < 1)
		return;
	new Float:focusCost = (50.0 + (30.0 * ArcaneDamage[client]))/ArcanePower[client]
	if(fl_CurrentFocus[client] < focusCost)
	{			
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	new Float:ClientPos[3];
	GetClientEyePosition(client,ClientPos);
	ClientPos[2] -= 20.0;

	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[14],focusCost);
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 20.0;
	applyArcaneCooldownReduction(client, attuneSlot);
		
	new Float:damageDealt = (100.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 60.0));
	for(new i = 1; i<MAXENTITIES;i++)
	{
		if(!IsValidForDamage(i))
			continue;
		if(!IsOnDifferentTeams(client,i))
			continue;

		new Float:VictimPos[3];
		GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
		VictimPos[2] += 15.0;

		if(!IsPointVisible(ClientPos,VictimPos))
			continue;

		if(GetVectorDistance(ClientPos,VictimPos) > 500.0)
			continue;

		SDKHooks_TakeDamage(i,client,client,damageDealt,DMG_BULLET,-1,NULL_VECTOR,NULL_VECTOR, !IsValidClient3(i));
		if(IsValidClient3(i))
		{
			TF2_AddCondition(i, TFCond_FreezeInput, 0.4);
			TF2_StunPlayer(i, 2.25,1.0,TF_STUNFLAGS_NORMALBONK,client);
			PushEntity(i,client,900.0,200.0);
		}
	}
	TF2_AddCondition(client, TFCond_ObscuredSmoke, 0.4);
	EmitSoundToAll(SOUND_SHOCKWAVE, _, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,ClientPos);
	CreateParticle(client, "bombinomicon_burningdebris", true, "", 1.0);
}
CastAutoSentry(client, attuneSlot)
{
	new Address:classSpecificActive = TF2Attrib_GetByName(client, "arcane autosentry");
	int spellLevel = classSpecificActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(classSpecificActive));
	if(spellLevel < 1)
		return;
	new Float:focusCost = (fl_MaxFocus[client])
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;
	
	new iTeam = GetClientTeam(client)

	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[15],focusCost);
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 120.0;
	applyArcaneCooldownReduction(client, attuneSlot);
		
	new iEntity = CreateEntityByName("obj_sentrygun");
	if(!IsValidEntity(iEntity))
		return;

	new iLink = CreateLink(client,true);
	new Float:angles[3];
	new Float:position[3];
	//angles[0] -= 180.0;
	//angles[1] -= 90.0;
	//angles[2] += 90.0;
	
	//position[0] -= 30.0;
	//position[1] += 20.0;
	position[2] -= 75.0;
	
	SetVariantString("!activator");
	AcceptEntityInput(iEntity, "SetParent", iLink);  
	SetVariantString("head"); 
	AcceptEntityInput(iEntity, "SetParentAttachment", iLink); 
	SetEntPropEnt(iEntity, Prop_Send, "m_hEffectEntity", iLink);
	SetEntPropVector(iEntity, Prop_Send, "m_angRotation", angles);
	TeleportEntity(iEntity, position, NULL_VECTOR, NULL_VECTOR);
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
	
	CreateTimer(10.0,SelfDestruct,  EntIndexToEntRef(iEntity));
	CreateTimer(10.0,SelfDestruct,  EntIndexToEntRef(iLink));
	CreateTimer(10.0,RemoveAutoSentryID, EntIndexToEntRef(client));
	autoSentryID[client] = iEntity;
}
public Action:RemoveAutoSentryID(Handle:timer, any:ref) 
{
	ref = EntRefToEntIndex(ref)
	autoSentryID[ref] = -1;
}
CastSoothingSunlight(client, attuneSlot)
{
	new Address:classSpecificActive = TF2Attrib_GetByName(client, "arcane soothing sunlight");
	int spellLevel = classSpecificActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(classSpecificActive));
	if(spellLevel < 1)
		return;

	new Float:focusCost = (fl_MaxFocus[client])/ArcanePower[client]
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	new Float:ClientPos[3];
	GetClientEyePosition(client,ClientPos);
	ClientPos[2] -= 40.0;

	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[16],focusCost);
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 200.0;
	applyArcaneCooldownReduction(client, attuneSlot);
		
	CreateTimer(4.0,SoothingSunlight,EntIndexToEntRef(client));
	TF2_StunPlayer(client,5.0,0.0,TF_STUNFLAGS_BIGBONK,0);
	TE_SetupBeamRingPoint(ClientPos, 20.0, 800.0, g_LightningSprite, spriteIndex, 0, 5, 4.0, 10.0, 1.0, {255,255,0,180}, 400, 0);
	TE_SendToAll();
}
public Action:SoothingSunlight(Handle:timer, client) 
{
	client = EntRefToEntIndex(client)
	if(!IsPlayerAlive(client))
		return;

	new iTeam = GetClientTeam(client)
	new Float:ClientPos[3];
	GetClientEyePosition(client,ClientPos);
	for(new i = 1; i<MaxClients;i++)
	{
		if(!IsValidClient3(i))
			continue;

		if(GetClientTeam(i) != iTeam)
			continue;

		new Float:VictimPos[3];
		GetClientEyePosition(i,VictimPos);
		new Float:Distance = GetVectorDistance(ClientPos,VictimPos);
		if(Distance > 1350.0)
			continue;

		new Float:AmountHealing = TF2_GetMaxHealth(i) * 4.0 * ArcanePower[client];
		AddPlayerHealth(i, RoundToCeil(AmountHealing), 4.0 * ArcanePower[client], true, client);
		fl_CurrentArmor[i] += AmountHealing * 3.0 * ArcanePower[client];
		if(fl_AdditionalArmor[i] < fl_MaxArmor[i] * ArcanePower[client])
			fl_AdditionalArmor[i] = fl_MaxArmor[i] * ArcanePower[client];
		TF2_AddCondition(i,TFCond_MegaHeal,6.5);
	
		new Float:particleOffset[3] = {0.0,0.0,15.0};
		CreateParticle(i, "utaunt_glitter_parent_gold", true, "", 5.0, particleOffset);
	}
	EmitSoundToAll(SOUND_HEAL, _, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,ClientPos);
}
CastArcaneHunter(client, attuneSlot)
{
	new Address:classSpecificActive = TF2Attrib_GetByName(client, "arcane hunter");
	int spellLevel = classSpecificActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(classSpecificActive));
	if(spellLevel < 1)
		return;
	
	new Float:focusCost = (200.0 + (65.0 * ArcaneDamage[client]))/ArcanePower[client]
	if(fl_CurrentFocus[client] >= focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[17],focusCost);
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 30.0;
	applyArcaneCooldownReduction(client, attuneSlot);
	new Float:CPOS[3];
	GetClientEyePosition(client,CPOS)
	
	for(new i=0;i<30;i++)
	{
		EmitSoundToAll(SOUND_ARCANESHOOTREADY, _, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,CPOS);
	}
	
	new Float:particleOffset[3] = {0.0,0.0,90.0};
	new iParticle = CreateParticle(client, "unusual_psychic_eye", true, "", 3.5, particleOffset);
	if(!IsValidEdict(iParticle))
	{
		new Handle:pack;
		CreateDataTimer(3.0, Timer_MoveParticle, pack);
		WritePackCell(pack, EntIndexToEntRef(iParticle));
	}

	CreateTimer(0.4,ArcaneHunter,client);
	CreateTimer(0.8,ArcaneHunter,client);
	CreateTimer(1.2,ArcaneHunter,client);
	CreateTimer(1.6,ArcaneHunter,client);
	CreateTimer(2.0,ArcaneHunter,client);
}
public Action:ArcaneHunter(Handle:timer, client) 
{
	if(!IsPlayerAlive(client))
		return;

	new Float:clientpos[3];
	new Float:soundPos[3];
	new Float:clientAng[3];
	new Float:fwd[3];
	TracePlayerAim(client, clientpos);
	
	for(new i=1;i<MaxClients;i++)
	{
		if(!IsValidClient3(i))
			continue;
		
		if(!IsOnDifferentTeams(client,i))
			continue;
		
		if(!IsTargetInSightRange(client, i, 10.0, 6000.0, true, false))
			continue;

		if(!IsAbleToSee(client,i, false))
			continue;
			
		GetClientEyePosition(i,clientpos);
		break;
	}
	
	GetClientEyePosition(client, soundPos);
	GetClientEyeAngles(client, clientAng);
	EmitSoundToAll(SOUND_ARCANESHOOT, _, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,soundPos);
	// define the direction of the sparks
	new Float:dir[3] = {0.0, 0.0, 0.0};
	
	TE_SetupEnergySplash(clientpos, dir, false);
	TE_SendToAll();
	
	TE_SetupSparks(clientpos, dir, 5000, 1000);
	TE_SendToAll();
	
	new Float:particleOffset[3] = {0.0,0.0,75.0};
	new String:particleName[32];
	particleName = GetClientTeam(client) == 2 ? "muzzle_raygun_red" : "muzzle_raygun_blue";
	
	GetAngleVectors(clientAng,fwd, NULL_VECTOR, NULL_VECTOR);
	ScaleVector(fwd, 30.0);
	AddVectors(particleOffset, fwd, particleOffset);
	
	CreateParticle(client, particleName, false, "", 0.5, particleOffset);
	
	new iParti = CreateEntityByName("info_particle_system");
	new iPart2 = CreateEntityByName("info_particle_system");

	if (IsValidEntity(iParti) && IsValidEntity(iPart2))
	{ 
		decl String:szCtrlParti[32];
		Format(szCtrlParti, sizeof(szCtrlParti), "tf2ctrlpart%i", iPart2);
		DispatchKeyValue(iPart2, "targetname", szCtrlParti);
		DispatchKeyValue(iParti, "effect_name", "merasmus_zap");
		DispatchKeyValue(iParti, "cpoint1", szCtrlParti);
		DispatchSpawn(iParti);
		TeleportEntity(iParti, soundPos, clientAng, NULL_VECTOR);
		TeleportEntity(iPart2, clientpos, NULL_VECTOR, NULL_VECTOR);
		ActivateEntity(iParti);
		AcceptEntityInput(iParti, "Start");
		
		new Handle:pack;
		CreateDataTimer(1.0, Timer_KillParticle, pack);
		WritePackCell(pack, EntIndexToEntRef(iParti));
		new Handle:pack2;
		CreateDataTimer(1.0, Timer_KillParticle, pack2);
		WritePackCell(pack2, EntRefToEntIndex(iPart2));
	}

	new Float:LightningDamage = (200.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 80.0));
	for(new i = 1; i<MAXENTITIES;i++)
	{
		if(!IsValidForDamage(i))
			continue;
		if(!IsOnDifferentTeams(client,i))
			continue;

		new Float:VictimPos[3];
		GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
		VictimPos[2] += 30.0;
		new Float:Distance = GetVectorDistance(clientpos,VictimPos);
		new Float:Range = 200.0;

		if(Distance > Range)
			continue;

		if(!IsPointVisible(clientpos,VictimPos))
			continue;

		SDKHooks_TakeDamage(i,client,client,LightningDamage,1073741824,-1,NULL_VECTOR,NULL_VECTOR, !IsValidClient3(i));
	}
}
CastBlackskyEye(client, attuneSlot)
{
	new Address:BlackskyEyeActive = TF2Attrib_GetByName(client, "arcane blacksky eye");
	int spellLevel = BlackskyEyeActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(BlackskyEyeActive));

	if(spellLevel < 1)
		return;

	new Float:level = ArcaneDamage[client];
	new Float:focusCost = (8.0 + (3.0 * level))/ArcanePower[client]

	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 0.3;

	applyArcaneCooldownReduction(client, attuneSlot);
	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[4],focusCost);

	new Float:clientpos[3];
	GetClientEyePosition(client,clientpos);
	EmitSoundToAll(SOUND_CALLBEYOND_CAST, _, client, SNDLEVEL_NORMAL, _, 0.7, _,_,clientpos);
	//Properties
	int maxCount[] = {0,1,2,3};
	float projSpeed[] = {0.0,1200.0,2000.0,3000.0};
	float radius[] = {0.0,700.0,1200.0,1500.0};
	int tickRate[] = {0,2,1,0};
	for(int iter = 0;iter < maxCount[spellLevel];iter++)
	{
		new iEntity = CreateEntityByName("tf_projectile_arrow");
		if (!IsValidEdict(iEntity)) 
			continue;

		new Float:fAngles[3]
		new Float:fOrigin[3]
		new Float:vBuffer[3]
		new Float:fVelocity[3]
		new Float:fwd[3]
		new Float:right[3]
		new iTeam = GetClientTeam(client);
		SetEntityRenderColor(iEntity, 255, 255, 255, 0);
		SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

		SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
		SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
		SetEntPropEnt(iEntity, Prop_Data, "m_hOwnerEntity", client);
		SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);
					
		GetClientEyePosition(client, fOrigin);
		GetClientEyeAngles(client,fAngles);
		
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
		
		new Float:Speed = projSpeed[spellLevel];
		fVelocity[0] = vBuffer[0]*Speed;
		fVelocity[1] = vBuffer[1]*Speed;
		fVelocity[2] = vBuffer[2]*Speed;
		SetEntPropVector(iEntity, Prop_Send, "m_vInitialVelocity", fVelocity );
		TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
		DispatchSpawn(iEntity);
		
		TE_SetupKillPlayerAttachments(iEntity);
		TE_SendToAll();
		new color[4]={100, 100, 100,255};
		TE_SetupBeamFollow(iEntity,Laser,0,2.5,4.0,8.0,3,color);
		TE_SendToAll();
		SDKHook(iEntity, SDKHook_StartTouchPost, BlackskyEyeCollision);
		SDKHook(iEntity, SDKHook_Touch, AddArrowCollisionFunction);
		homingRadius[iEntity] = radius[spellLevel];
		homingTickRate[iEntity] = tickRate[spellLevel];
	}
}
CastACallBeyond(client, attuneSlot)
{
	new Address:callBeyondActive = TF2Attrib_GetByName(client, "arcane a call beyond");
	int spellLevel = callBeyondActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(callBeyondActive));

	if(spellLevel < 1)
		return;
	
	new Float:level = ArcaneDamage[client];
	new Float:focusCost = (200.0 + (70.0 * level))/ArcanePower[client]

	if(fl_CurrentFocus[client] >= focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	TF2_StunPlayer(client,1.5,0.0,TF_STUNFLAGS_BIGBONK,0);
	TF2_AddCondition(client, TFCond_FreezeInput, 1.5);
	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 50.0;
	applyArcaneCooldownReduction(client, attuneSlot);
	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[3],focusCost);
	CreateTimer(1.5, ACallBeyond, EntIndexToEntRef(client));
	
	new Float:clientpos[3];
	GetClientEyePosition(client,clientpos);
	EmitSoundToAll(SOUND_CALLBEYOND_CAST, _, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,clientpos);
	CreateParticle(client, "merasmus_tp_bits", true);
	CreateParticle(client, "spellbook_major_burning", true);
	CreateParticle(client, "unusual_meteor_cast_wheel_purple", true);
}
public Action:ACallBeyond(Handle:timer, client) 
{
	client = EntRefToEntIndex(client)
	if(!IsPlayerAlive(client))
		return;
	
	new Address:callBeyondActive = TF2Attrib_GetByName(client, "arcane a call beyond");
	int spellLevel = callBeyondActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(callBeyondActive));

	int projCount[] = {0,15,25,40};
	float radius[] = {0.0,1500.0,2500.0,2500.0};
	int tickRate[] = {0,2,1,0};
	for(new i = 0;i<projCount[spellLevel];i++)
	{
		new iEntity = CreateEntityByName("tf_projectile_arrow");
		if (!IsValidEdict(iEntity)) 
			continue;

		new Float:fAngles[3]
		new Float:fOrigin[3]
		new Float:vBuffer[3]
		new Float:fVelocity[3]
		new Float:fwd[3]
		new iTeam = GetClientTeam(client);
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
		
		new Float:Speed = 1700.0;
		fVelocity[0] = vBuffer[0]*Speed;
		fVelocity[1] = vBuffer[1]*Speed;
		fVelocity[2] = vBuffer[2]*Speed;
		SetEntPropVector(iEntity, Prop_Send, "m_vInitialVelocity", fVelocity );
		TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
		DispatchSpawn(iEntity);
		TE_SetupKillPlayerAttachments(iEntity);
		TE_SendToAll();
		new color[4]={255, 255, 255,225};
		TE_SetupBeamFollow(iEntity,Laser,0,2.5,4.0,8.0,3,color);
		TE_SendToAll();
		SDKHook(iEntity, SDKHook_StartTouchPost, CallBeyondCollision);
		SDKHook(iEntity, SDKHook_Touch, AddArrowCollisionFunction);
		
		homingRadius[iEntity] = radius[spellLevel];
		homingTickRate[iEntity] = tickRate[spellLevel];

	}

	new Float:clientpos[3];
	GetClientEyePosition(client,clientpos);
	EmitSoundToAll(SOUND_CALLBEYOND_ACTIVE, _, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,clientpos);
}
CastZap(client, attuneSlot)
{
	new Address:zapActive = TF2Attrib_GetByName(client, "arcane zap");
	int spellLevel = zapActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(zapActive));

	if(spellLevel < 1)
		return;

	new Float:level = ArcaneDamage[client];
	new Float:focusCost = (3.0 + (0.5 * level))/ArcanePower[client]
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	//zap yeah?
	new closestClient[MAXENTITIES];
	new Float:clientpos[3];
	GetClientEyePosition(client,clientpos);
	clientpos[2] -= 15.0;
	new Float:closestDistance = 2000.0;
	new validCount = 0;
	new maximumTargets[] = {0,1,2,3};
	new Float:range[] = {0.0,600.0,1500.0,1500.0};
	for(new i = 1; i<MAXENTITIES;i++)
	{
		if(!IsValidForDamage(i))
			continue;
		if(!IsOnDifferentTeams(client,i))
			continue;

		new Float:VictimPos[3];
		GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
		VictimPos[2] += 15.0;
		new Float:Distance = GetVectorDistance(clientpos,VictimPos);

		if(Distance < closestDistance && Distance < range[spellLevel])
		{
			if(IsPointVisible(clientpos,VictimPos))
			{
				PrintToServer("%f", Distance);
				closestClient[validCount] = i;
				closestDistance = Distance;
				validCount++;
			}
		}
	}
	validCount = 0;
	for(int it = MAXENTITIES-1;it>=0 && validCount < maximumTargets[spellLevel];it--)
	{
		if(closestClient[it] != 0){
			validCount++;
			DoZap(client,closestClient[it], spellLevel);
		}
	}
	if(validCount > 0)
	{
		fl_CurrentFocus[client] -= focusCost;
		if(DisableCooldowns != 1)
			SpellCooldowns[client][attuneSlot] = 0.1;
		applyArcaneCooldownReduction(client, attuneSlot);
		PrintHintText(client, "Used %s! -%.2f focus.",SpellList[0],focusCost);
	}
}
DoZap(client,victim,spellLevel)
{
	if(!IsValidForDamage(victim))
		return;

	new Float:clientpos[3];
	new Float:VictimPosition[3];
	new Float:level = ArcaneDamage[client];
	
	GetClientEyePosition(client,clientpos);
	GetEntPropVector(victim, Prop_Data, "m_vecOrigin", VictimPosition);
	VictimPosition[2] += 15.0;
	
	new Float:range[] = {0.0,600.0,1500.0,1500.0};
	
	TE_SetupBeamRingPoint(clientpos, 20.0, range[spellLevel]*1.25, g_LightningSprite, spriteIndex, 0, 5, 0.5, 10.0, 1.0, {255,0,255,133}, 140, 0);
	TE_SendToAll();
	TE_SetupBeamPoints(clientpos,VictimPosition,g_LightningSprite,spriteIndex,0,35,0.15,6.0,5.0,0,1.0,{255,000,255,255},20);
	TE_SendToAll();
	EmitSoundToAll(SOUND_ZAP, _, client, SNDLEVEL_CONVO, _, 1.0, _,_,clientpos);
	
	new Float:LightningDamage = (20.0 + (Pow(level * Pow(ArcanePower[client], 4.0), spellScaling[spellLevel]) * 3.0));
	new Float:radiationAmount[] = {0.0,6.0,10.0,25.0};
	SDKHooks_TakeDamage(victim,client,client, radiationAmount[spellLevel], (DMG_RADIATION+DMG_DISSOLVE), -1, NULL_VECTOR, NULL_VECTOR);
	SDKHooks_TakeDamage(victim,client,client, LightningDamage, 1073741824, -1, NULL_VECTOR, NULL_VECTOR, !IsValidClient3(victim));
	new Float:chance[] = {0.0,0.3,0.6,0.9};
		
	if(chance[spellLevel] >= GetRandomFloat(0.0, 1.0))
	{
		new Handle:hPack = CreateDataPack();
		WritePackCell(hPack, EntIndexToEntRef(client));
		WritePackCell(hPack, EntIndexToEntRef(victim));
		WritePackCell(hPack, EntIndexToEntRef(spellLevel));
		CreateTimer(0.1,zapAgain,hPack);
	}
}
public Action:zapAgain(Handle:timer,any:data)
{
	ResetPack(data);
	new client = EntRefToEntIndex(ReadPackCell(data));
	new victim = EntRefToEntIndex(ReadPackCell(data));
	new spellLevel = EntRefToEntIndex(ReadPackCell(data));
	DoZap(client,victim,spellLevel);
	CloseHandle(data);
}
CastLightning(client, attuneSlot)
{
	new Address:lightningActive = TF2Attrib_GetByName(client, "arcane lightning strike");
	int spellLevel = lightningActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(lightningActive));

	if(spellLevel < 1)
		return;

	new Float:focusCost = (60.0 + (30.0 * ArcaneDamage[client]))/ArcanePower[client];
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 11.0;
	applyArcaneCooldownReduction(client, attuneSlot);
	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[1],focusCost);
	new Float:clientpos[3];
	TracePlayerAim(client, clientpos);
	new Float:temppos[3];
	TracePlayerAim(client, temppos);

	int quantity[] = {0,1,5,25}
	float afterburnDamage[] = {0.0,0.02,0.04,0.08}
	float range[] = {0.0,600.0,1200.0,1500.0}
	for(new iter = 0;iter < quantity[spellLevel];iter++)
	{
		// define where the lightning strike starts
		if(iter > 1)
		{
			clientpos[0] = temppos[0] + GetRandomFloat(-900.0,900.0);
			clientpos[1] = temppos[1] + GetRandomFloat(-900.0,900.0);
		}

		new Float:startpos[3];
		startpos[0] = clientpos[0];
		startpos[1] = clientpos[1];
		startpos[2] = clientpos[2] + 1600;
		
		// define the color of the strike
		int iTeam = GetClientTeam(client);

		int color[4];
		color = iTeam == 2 ? {255, 0, 0, 255} : {0, 0, 255, 255};
		
		// define the direction of the sparks
		new Float:dir[3] = {0.0, 0.0, 0.0};
		
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
		
		for(new i = 1; i<MAXENTITIES;i++)
		{
			if(!IsValidForDamage(i)) 
				continue;
			if (!IsOnDifferentTeams(client,i))
				continue;

			new Float:VictimPos[3];
			GetEntPropVector(i, Prop_Data, "m_vecOrigin", VictimPos);
			VictimPos[2] += 30.0;
			new Float:Distance = GetVectorDistance(clientpos,VictimPos);
			if(Distance > range[spellLevel])
				continue;

			if(!IsPointVisible(clientpos,VictimPos))
				continue;

			new Float:LightningDamage = (200.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), spellScaling[spellLevel]) * 80.0));
			SDKHooks_TakeDamage(i,client,client,LightningDamage,DMG_SHOCK,-1,NULL_VECTOR,NULL_VECTOR, !IsValidClient3(i));

			CreateParticle(i, "utaunt_auroraglow_orange_parent", true, "", 3.25);
			
			if(IsValidClient3(i))
				TF2_IgnitePlayer(i, client, 3.0);

			DOTStock(i,client,LightningDamage*afterburnDamage[spellLevel],-1,0,20,1.0,0.1,true);//A fake afterburn. This allows for stacking of DOT & custom tick rates.
		}
	}
	EmitSoundToAll(SOUND_THUNDER, _, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,clientpos);
}
CastHealing(client, attuneSlot)//Projected Healing
{
	new Address:healAuraActive = TF2Attrib_GetByName(client, "arcane projected healing");
	int spellLevel = healAuraActive == Address_Null ? 0 : RoundToNearest(TF2Attrib_GetValue(healAuraActive));

	if(spellLevel < 1)
		return;

	new Float:focusCost = (fl_MaxFocus[client]*0.65)/ArcanePower[client];
	
	if(fl_CurrentFocus[client] < focusCost)
	{
		PrintHintText(client, "Not enough focus! Requires %.2f focus.",focusCost);
		EmitSoundToClient(client, SOUND_FAIL);
		return;
	}
	if(SpellCooldowns[client][attuneSlot] > 0.0)
		return;

	fl_CurrentFocus[client] -= focusCost;
	if(DisableCooldowns != 1)
		SpellCooldowns[client][attuneSlot] = 15.0;

	PrintHintText(client, "Used %s! -%.2f focus.",SpellList[2],focusCost);
	new Float:clientpos[3];
	GetClientEyePosition(client,clientpos);
	new iTeam = GetClientTeam(client);
	EmitSoundToAll(SOUND_HEAL, _, client, SNDLEVEL_RAIDSIREN, _, 1.0, _,_,clientpos);
	new iEntity = CreateEntityByName("tf_projectile_flare");
	if (!IsValidEdict(iEntity)) 
		return;

	new Float:fAngles[3]
	new Float:fOrigin[3]
	new Float:vBuffer[3]
	new Float:fVelocity[3]
	new Float:fwd[3]
	SetEntityRenderColor(iEntity, 255, 255, 255, 0);
	SetEntPropEnt(iEntity, Prop_Send, "m_hOwnerEntity", client);

	SetEntProp(iEntity, Prop_Send, "m_iTeamNum", iTeam, 1);
	SetEntProp(iEntity, Prop_Send, "m_nSkin", (iTeam-2));
	SetEntPropEnt(iEntity, Prop_Data, "m_hOwnerEntity", client);
	SetEntPropEnt(iEntity, Prop_Send, "m_hLauncher", client);
	new g_offsCollisionGroup = FindSendPropInfo("CBaseEntity", "m_CollisionGroup");
	SetEntData(iEntity, g_offsCollisionGroup, 5, 4, true);
				
	GetClientEyePosition(client, fOrigin);
	GetClientEyeAngles(client,fAngles);

	GetAngleVectors(fAngles, vBuffer, NULL_VECTOR, NULL_VECTOR);
	GetAngleVectors(fAngles,fwd, NULL_VECTOR, NULL_VECTOR);
	ScaleVector(fwd, 60.0);

	AddVectors(fOrigin, fwd, fOrigin);

	new Float:Speed = 1800.0;
	fVelocity[0] = vBuffer[0]*Speed;
	fVelocity[1] = vBuffer[1]*Speed;
	fVelocity[2] = vBuffer[2]*Speed;
	SetEntPropVector(iEntity, Prop_Send, "m_vInitialVelocity", fVelocity );
	TeleportEntity(iEntity, fOrigin, fAngles, fVelocity);
	DispatchSpawn(iEntity);

	TE_SetupKillPlayerAttachments(iEntity);
	TE_SendToAll();

	int color[4];
	color = iTeam == 2 ? {255, 0, 0, 255} : {0, 0, 255, 255};

	TE_SetupBeamFollow(iEntity,Laser,0,2.5,4.0,8.0,3,color);
	TE_SendToAll();
	SDKHook(iEntity, SDKHook_StartTouchPost, ProjectedHealingCollision);
	SDKHook(iEntity, SDKHook_Touch, AddArrowCollisionFunction);
	CreateTimer(0.03, HeavyFriendlyHoming, EntIndexToEntRef(iEntity), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}