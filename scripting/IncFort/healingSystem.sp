public Action TF2_OnTakeHealthGetMultiplier(int client, float &flMultiplier){
	float amt = GetPlayerHealingMultiplier(client);
	if(amt != 1.0){
		flMultiplier = amt;
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

public Action TF2_OnTakeHealthPre(int client, float &flAmount, int &flags){
	if(hasBuffIndex(client, Buff_Leech)){
		AddPlayerHealth(playerBuffs[client][getBuffInArray(client, Buff_Leech)].inflictor, RoundToCeil(flAmount*0.334));
	}
	if(GetAttribute(client, "king powerup", 0.0) == 2.0){
		if(IsValidClient3(tagTeamTarget[client]) && IsPlayerAlive(tagTeamTarget[client]) && !IsOnDifferentTeams(client, tagTeamTarget[client]) ){
			AddPlayerHealth(tagTeamTarget[client], RoundToCeil(flAmount), _, true, client);
		}
	} 
	return Plugin_Continue;
}

float GetPlayerHealingMultiplier(client){
	float multiplier = 1.0;
	float playerOrigin[3];

	GetClientAbsOrigin(client, playerOrigin);

	if(TF2_IsPlayerInCondition(client, TFCond_Bleeding)){
		if(GetAttribute(client, "inverter powerup", 0.0) == 1.0){
			multiplier *= 2.0;
		}
		else{
			int inflictor = TF2Util_GetPlayerConditionProvider(client, TFCond_Bleeding);
			if(IsValidClient3(inflictor) && GetAttribute(client, "knockout powerup", 0.0) == 2)
				multiplier *= 0.1667;
			else
				multiplier *= 0.5;
		}
	}
	if(TF2_IsPlayerInCondition(client, TFCond_MegaHeal)){
		float effectMult = 1.0;
		
		int healers = GetEntProp(client, Prop_Send, "m_nNumHealers");
		for(int i = 0;i<healers;++i){
			int healer = TF2Util_GetPlayerHealer(client,i);
			if(!IsValidClient3(healer))
				continue;

			int healingWeapon = GetWeapon(healer, 1);
			if(!IsValidWeapon(healingWeapon))
				continue;

			effectMult += GetAttribute(healingWeapon, "ubercharge effectiveness", 1.0)-1.0;
		}
		multiplier *= 1.0 + effectMult;
	}
	if(GetAttribute(client, "regeneration powerup", 0.0) == 3.0)
		multiplier *= 1.6;
	if(hasBuffIndex(client, Buff_Stronghold))
		multiplier *= 1.33;
	if(hasBuffIndex(client, Buff_Leech))
		multiplier *= 0.5;
	if(hasBuffIndex(client, Buff_Decay))
		multiplier *= 0.25;
	if(GetAttribute(client, "revenge powerup", 0.0) == 2.0)
		multiplier *= 1.0 + RageBuildup[client]*0.5;
	
	return multiplier;
}
void AddPlayerHealth(client, iAdd, float flOverheal = 1.5, bool bEvent = false, healer = -1)
{
	if(hasBuffIndex(client, Buff_Leech)){
		Buff leechInfo; leechInfo = playerBuffs[client][getBuffInArray(client, Buff_Leech)];
		AddPlayerHealth(leechInfo.inflictor, RoundToCeil(iAdd*0.5));
	}
	flOverheal *= TF2Attrib_HookValueFloat(1.0, "mult_patient_overheal_penalty", client);
	
	iAdd = RoundToCeil(iAdd * GetPlayerHealingMultiplier(client));
    int iHealth = GetClientHealth(client);
    int iNewHealth = iHealth + iAdd;
    int iMax = RoundFloat(float(TF2_GetMaxHealth(client)) * flOverheal)
	if(iNewHealth > iMax && iHealth < iMax)
	{
		iNewHealth = iMax;
	}
    if (iNewHealth <= iMax && iHealth != iMax)
    {
        if (bEvent)
        {
            ShowHealthGain(client, iNewHealth-iHealth, healer);
        }
        SetEntityHealth(client, iNewHealth);
    }
}