//IF Front Menu
public Action Menu_BuyUpgrade(client, args)
{
	if (IsValidClient(client) && IsPlayerAlive(client) && !client_respawn_checkpoint[client] )
	{
		menuBuy = CreateMenu(MenuHandler_BuyUpgrade);
		SetMenuTitle(menuBuy, "Incremental Fortress - /buy or +SHOWSCORES");
		if(current_class[client] != TFClass_Engineer)
			AddMenuItem(menuBuy, "upgrade_player", "Upgrade Body");
		else
			AddMenuItem(menuBuy, "upgrade_player", "Upgrade Body / Building");

		AddMenuItem(menuBuy, "upgrade_primary", "Upgrade Primary Slot");
		AddMenuItem(menuBuy, "upgrade_secondary", "Upgrade Secondary Slot");
		AddMenuItem(menuBuy, "upgrade_melee", "Upgrade Melee Slot");

		if(current_class[client] == TFClass_Engineer)
			AddMenuItem(menuBuy, "upgrade_buildings", "Upgrade Buildings");

		if (currentitem_level[client][3] != 242)
			AddMenuItem(menuBuy, "upgrade_buyoneweap", "Buy a Unique Weapon");
		else
			AddMenuItem(menuBuy, "upgrade_upgradeoneweap", "Upgrade Unique Weapon");

		AddMenuItem(menuBuy, "upgrade_dispcurrups", "Upgrade Manager");
		AddMenuItem(menuBuy, "use_arcane", "Use Arcane Spells");
		
		AddMenuItem(menuBuy, "upgrade_stats", "View Stats");

		AddMenuItem(menuBuy, "preferences", "Change Preferences/Settings");
		
		AddMenuItem(menuBuy, "wiki", "Display In-Game Wiki");
		
		DisplayMenuAtItem(menuBuy, client, args, MENU_TIME_FOREVER)

	}
	return Plugin_Handled;
}
public Action Menu_ConfirmWeapon(client, param2)
{
	Handle menu = CreateMenu(MenuHandler_BuyNewWeapon);

	char TitleStr[64]
	char Description[512]
	Format(TitleStr, sizeof(TitleStr), "%s - Costs $%.0f", upgrades_weapon[param2],upgrades_weapon_cost[param2])
	Format(Description, sizeof(Description), "%s",upgrades_weapon_description[param2])
	ReplaceString(Description, sizeof(Description), "\\n", "\n");
	AddMenuItem(menu, "buyWeapon", "Confirm Purchase");

	SetMenuTitle(menu, "%s\n \n%s\n",TitleStr,Description);
	SetMenuExitBackButton(menu, true);
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		DisplayMenu(menu, client, MENU_TIME_FOREVER);
	}
	return Plugin_Handled;
}
//When you purchase an upgrade
Action:Menu_UpgradeChoice(client, subcat_choice, cat_choice, char[] TitleStr, int page = 0)
{
	int i

	Handle menu = CreateMenu(MenuHandler_UpgradeChoice, MENU_ACTIONS_DEFAULT|MenuAction_DisplayItem);
	playerUpgradeMenus[client] = view_as<int>(menu);
	int rate = getUpgradeRate(client);
	if (cat_choice != -1)
	{
		int w_id = current_w_list_id[client]

		int tmp_up_idx
		int tmp_ref_idx
		int up_cost
		float tmp_val
		float tmp_ratio
		int slot
		current_w_sc_list_id[client] = subcat_choice;
		current_w_c_list_id[client] = cat_choice;
		float m_val;
		//PrintToServer("%i | %i", cat_choice, subcat_choice)

		for (i = 0; (tmp_up_idx = given_upgrd_list[w_id][cat_choice][subcat_choice][i]); ++i)
		{
			slot = current_slot_used[client]
			if(upgrades[tmp_up_idx].is_global)
				slot = 4;

			up_cost = upgrades[tmp_up_idx].cost;
			if (slot == 1)
				up_cost = RoundToCeil(up_cost*SecondaryCostReduction);

			tmp_ref_idx = upgrades_ref_to_idx[client][slot][tmp_up_idx];
			m_val = upgrades[tmp_up_idx].m_val - upgrades[tmp_up_idx].i_val;
			if (tmp_ref_idx != 20000)
			{
				tmp_val = currentupgrades_val[client][slot][tmp_ref_idx] - upgrades[tmp_up_idx].i_val;
				if(currentupgrades_i[client][slot][tmp_ref_idx] != 0.0){
					tmp_val = currentupgrades_val[client][slot][tmp_ref_idx] - currentupgrades_i[client][slot][tmp_ref_idx];
					m_val = upgrades[tmp_up_idx].m_val - currentupgrades_i[client][slot][tmp_ref_idx];
				}
			}
			else
			{
				tmp_val = 0.0;
			}
			tmp_ratio = upgrades[tmp_up_idx].ratio;
			float t_up_cost = 0.0;
			int times = 0;
			if(tmp_ref_idx != 20000)
			{
				float upgrades_val = currentupgrades_val[client][slot][tmp_ref_idx];
				int idx_currentupgrades_val
				if(currentupgrades_i[client][slot][tmp_ref_idx] != 0.0){
					idx_currentupgrades_val = RoundFloat((currentupgrades_val[client][slot][tmp_ref_idx] - currentupgrades_i[client][slot][tmp_ref_idx])/ upgrades[tmp_up_idx].ratio)
				}
				else{
					idx_currentupgrades_val = RoundFloat((currentupgrades_val[client][slot][tmp_ref_idx] - upgrades[tmp_up_idx].i_val)/ upgrades[tmp_up_idx].ratio)
				}
				if(rate > 0)
				{
					for (; times < rate; ++times)
					{
						float nextcost = t_up_cost + up_cost + up_cost * (idx_currentupgrades_val * upgrades[tmp_up_idx].cost_inc_ratio)
						if(nextcost < CurrencyOwned[client] && upgrades[tmp_up_idx].ratio > 0.0 && 
						(canBypassRestriction[client] == true || RoundFloat(upgrades_val*100.0)/100.0 < m_val))
						{
							t_up_cost += up_cost + RoundFloat(up_cost * (idx_currentupgrades_val* upgrades[tmp_up_idx].cost_inc_ratio))
							++idx_currentupgrades_val		
							upgrades_val += upgrades[tmp_up_idx].ratio
						}
						else if(nextcost < CurrencyOwned[client] && upgrades[tmp_up_idx].ratio < 0.0 && 
						(canBypassRestriction[client] == true || RoundFloat(upgrades_val*100.0)/100.0 > upgrades[tmp_up_idx].m_val))
						{
							t_up_cost += up_cost + RoundFloat(up_cost * (idx_currentupgrades_val * upgrades[tmp_up_idx].cost_inc_ratio))
							++idx_currentupgrades_val	
							upgrades_val += upgrades[tmp_up_idx].ratio
						}
						else{
							break;
						}
					}
				}
				else
				{
					if(upgrades_val == m_val)
					{
						idx_currentupgrades_val--
						float temp = currentupgrades_i[client][slot][tmp_ref_idx] != 0.0 ? currentupgrades_i[client][slot][tmp_ref_idx] : upgrades[tmp_up_idx].i_val;
						t_up_cost -= up_cost + RoundFloat(up_cost * (idx_currentupgrades_val* upgrades[tmp_up_idx].cost_inc_ratio));
						upgrades_val = temp+(idx_currentupgrades_val * upgrades[tmp_up_idx].ratio);
						times--;
					}
					for (; times > rate;)
					{
						if(idx_currentupgrades_val > 0 && upgrades[tmp_up_idx].ratio > 0.0 && 
						(canBypassRestriction[client] == true || (RoundFloat(upgrades_val*100.0)/100.0 <= m_val
						&& client_spent_money[client][slot] + t_up_cost > client_tweak_highest_requirement[client][slot] - 1.0)))
						{
							idx_currentupgrades_val--
							t_up_cost -= up_cost + RoundFloat(up_cost * (idx_currentupgrades_val* upgrades[tmp_up_idx].cost_inc_ratio))		
							upgrades_val -= upgrades[tmp_up_idx].ratio
						}
						else if(idx_currentupgrades_val > 0 && upgrades[tmp_up_idx].ratio < 0.0 && 
						(canBypassRestriction[client] == true || (RoundFloat(upgrades_val*100.0)/100.0 >= m_val
						&& client_spent_money[client][slot] + t_up_cost > client_tweak_highest_requirement[client][slot] - 1.0)))
						{
							idx_currentupgrades_val--
							t_up_cost -= up_cost + RoundFloat(up_cost * (idx_currentupgrades_val * upgrades[tmp_up_idx].cost_inc_ratio))	
							upgrades_val -= upgrades[tmp_up_idx].ratio
						}
						else{
							break;
						}
						times--;
					}
				}
			}
			if (tmp_val && tmp_ratio)
			{
				up_cost += RoundFloat(up_cost * (tmp_val / tmp_ratio) * upgrades[tmp_up_idx].cost_inc_ratio)
				if (up_cost < 0.0)
				{
					up_cost *= -1;
					if (up_cost < upgrades[tmp_up_idx].cost)
						up_cost = upgrades[tmp_up_idx].cost
				}
			}
			if(times == 0){
				times = 1;
				t_up_cost = float(up_cost);
			}


			char Buffer[128];
			char DisplayBuffer[64];
			char TotalDisplayBuffer[64];
			char MaximumDisplayBuffer[64];

            Format(DisplayBuffer, sizeof(DisplayBuffer), upgrades[tmp_up_idx].display, StrContains(upgrades[tmp_up_idx].display, "%%") != -1 ? float(RoundFloat(tmp_ratio*times*100.0)) : tmp_ratio*times);

            Format(TotalDisplayBuffer, sizeof(TotalDisplayBuffer), upgrades[tmp_up_idx].display, StrContains(upgrades[tmp_up_idx].display, "%%") != -1 ? float(RoundFloat(tmp_val*100.0)) : tmp_val);
            
            Format(MaximumDisplayBuffer, sizeof(MaximumDisplayBuffer), upgrades[tmp_up_idx].display, StrContains(upgrades[tmp_up_idx].display, "%%") != -1 ? float(RoundFloat(m_val*100.0)) : m_val);

            Format(Buffer, sizeof(Buffer), "%t | $%.0f\n %s%s [%s%s/%s]", upgrades[tmp_up_idx].name, t_up_cost, tmp_ratio*times > 0 ? "+" : "", DisplayBuffer, tmp_val > 0 ? "+" : "", TotalDisplayBuffer, MaximumDisplayBuffer);

			bool isEnabled = true;
			if(upgrades[tmp_up_idx].requirement > (StartMoney + additionalstartmoney))
				isEnabled = false;

			if(canBypassRestriction[client] == false && (tmp_ref_idx == 20000 || upgrades[tmp_up_idx].i_val == currentupgrades_val[client][slot][tmp_ref_idx]) && upgrades[tmp_up_idx].restriction_category != 0){
				for(int req = 1;req<5;++req){
					if(currentupgrades_restriction[client][slot][req] == upgrades[tmp_up_idx].restriction_category){
						isEnabled = false;
						break;
					}
				}
			}

			AddMenuItem(menu, "upgrade", Buffer, isEnabled ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
		}
		SetMenuTitle(menu, TitleStr);
		SetMenuExitBackButton(menu, true);
		DisplayMenuAtItem(menu, client, page, MENU_TIME_FOREVER)
	}
}
//Category Selection
public Action:Menu_ChooseCategory(client, char[] TitleStr)
{
	int w_id
	
	Handle menu = CreateMenu(MenuHandler_Choosecat);
	int slot = current_slot_used[client];

	if (slot != 4)
	{
		w_id = currentitem_catidx[client][slot];
	}
	else
	{
		w_id = _:TF2_GetPlayerClass(client) - 1;
		if(w_id < 0)
		{
			w_id = 0;
		}
	}
	if (w_id >= -1)
	{
		current_w_list_id[client] = w_id
		char buf[128]
		for (int i = 0; i < given_upgrd_list_nb[w_id] <= 10 ; ++i)
		{
			Format(buf, sizeof(buf), "%T", given_upgrd_classnames[w_id][i], client)
			AddMenuItem(menu, "upgrade", buf);
		}
	}
	SetMenuTitle(menu, TitleStr);
	SetMenuExitBackButton(menu, true);
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		DisplayMenu(menu, client, 20);
	}
}
//Subcategory Selection
public Action:Menu_ChooseSubcat(client, subcat_choice, const char[] TitleStr)
{
	int w_id = current_w_list_id[client];
	int slot = current_slot_used[client];
	int cat_id = currentitem_catidx[client][slot]
	Handle menu = CreateMenu(MenuHandler_ChooseSubcat);
	if (w_id >= -1)
	{
		current_w_sc_list_id[client] = subcat_choice;
		char buf[128]

		for(int j = 0; j < given_upgrd_subcat_nb[w_id][subcat_choice];++j)
		{
			//PrintToServer("%s", given_upgrd_subclassnames[w_id][j])
			Format(buf, sizeof(buf), "%T", given_upgrd_subclassnames[cat_id][subcat_choice][j], client);
			AddMenuItem(menu, "subcat", buf);
		}
	}
	SetMenuTitle(menu, TitleStr);
	SetMenuExitBackButton(menu, true);
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		DisplayMenu(menu, client, 20);
	}
}
//Tweak menu
public Action:Menu_SpecialUpgradeChoice(client, cat_choice, char[] TitleStr, selectidx)
{
	int i, j
	Handle menu = CreateMenu(MenuHandler_SpecialUpgradeChoice);
	SetMenuPagination(menu, 2);
	SetMenuExitBackButton(menu, true);
	
	if (cat_choice != -1)
	{
		char desc_str[512]
		int w_id = current_w_list_id[client]
		int tmp_up_idx
		int tmp_spe_up_idx
		int tmp_ref_idx
		float tmp_val
		float tmp_ratio
		int slot
		char plus_sign[4]
		char buft[256]
	
		current_w_c_list_id[client] = cat_choice
		slot = current_slot_used[client]
		for (i = 0; i < given_upgrd_classnames_tweak_nb[w_id]; ++i)
		{
			bool restricted = false;
			tmp_spe_up_idx = given_upgrd_list[w_id][cat_choice][0][i]

			for(int k = 0;k < 5;++k){
				if(currentupgrades_restriction[client][slot][k] == 0)
					continue;

				if(currentupgrades_restriction[client][slot][k] == tweaks[tmp_spe_up_idx].restriction){
					restricted = true;
					break;
				}
			}

			Format(buft, sizeof(buft), "%T",  tweaks[tmp_spe_up_idx].tweaks, client);
			if(tweaks[tmp_spe_up_idx].cost > 0.0)
			{
				Format(buft, sizeof(buft), "%s\nCost: $%.0f",  buft, tweaks[tmp_spe_up_idx].cost)
			}
			if(tweaks[tmp_spe_up_idx].requirement > 0.0)
			{
				Format(buft, sizeof(buft), "%s\nRequirement: $%.0f spent",  buft, tweaks[tmp_spe_up_idx].requirement)
			}
			if(tweaks[tmp_spe_up_idx].gamestage_requirement > gameStage)
			{
				Format(buft, sizeof(buft), "%s\nStage: %i",  buft, tweaks[tmp_spe_up_idx].gamestage_requirement)
				restricted = true;
			}
			
			if(canBypassRestriction[client])
				restricted = false;

			desc_str = buft;
			for (j = 0; j < tweaks[tmp_spe_up_idx].nb_att; ++j)
			{
				tmp_up_idx = tweaks[tmp_spe_up_idx].att_idx[j]
				tmp_ref_idx = upgrades_ref_to_idx[client][slot][tmp_up_idx]
				if (tmp_ref_idx != 20000)
				{	
					tmp_val = currentupgrades_val[client][slot][tmp_ref_idx] - upgrades[tmp_up_idx].i_val
				}
				else
				{
					tmp_val = 0.0
				}
				tmp_ratio = upgrades[tmp_up_idx].ratio
				if (tmp_ratio > 0.0)
				{
					plus_sign = "+"
				}
				else
				{
					tmp_ratio *= -1.0
					plus_sign = "-"
				}

				tmp_ratio *= tweaks[tmp_spe_up_idx].att_ratio[j]

				char buf[64]
				char DisplayIncreaseBuffer[32];
				char DisplayCurrentBuffer[32];
				Format(buf, sizeof(buf), "%T", upgrades[tmp_up_idx].name, client)
				Format(DisplayIncreaseBuffer, sizeof(DisplayIncreaseBuffer), upgrades[tmp_up_idx].display, StrContains(upgrades[tmp_up_idx].display, "%%") != -1 ? float(RoundFloat(tmp_ratio*100.0)) : tmp_ratio);
				Format(DisplayCurrentBuffer, sizeof(DisplayCurrentBuffer), upgrades[tmp_up_idx].display, StrContains(upgrades[tmp_up_idx].display, "%%") != -1 ? float(RoundFloat(tmp_val*100.0)) : tmp_val);
				
				Format(desc_str, sizeof(desc_str), "%s\n% -%s\n   %s%s (%s)",desc_str, buf, plus_sign, DisplayIncreaseBuffer, DisplayCurrentBuffer);
			}
			AddMenuItem(menu, "upgrade", desc_str, restricted ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
		}
	}
	else{
	CloseHandle(menu);
	}
	SetMenuTitle(menu, TitleStr);
	DisplayMenuAtItem(menu, client, selectidx, MENU_TIME_FOREVER);

	return; 
}
public	Menu_TweakUpgrades_slot(client, arg, page)
{
	if (arg > -1 && arg < 5
	&& IsValidClient(client) 
	&& IsPlayerAlive(client))
	{
		Handle menu = CreateMenu(MenuHandler_AttributesTweak_action);
		int i, s
			
		s = arg;
		current_slot_used[client] = s;
		SetMenuTitle(menu, "$%.0f ***%s - Choose attribute:", CurrencyOwned[client], current_slot_name[s]);
		SetMenuExitBackButton(menu, true);
		char buf[256]
		char fstr[512]
		if(currentupgrades_number[client][s] != 0)
		{
			for (i = 0; i < currentupgrades_number[client][s]; ++i)
			{
				int u = currentupgrades_idx[client][s][i]
				Format(buf, sizeof(buf), "%T", upgrades[u].name, client)
				if (upgrades[u].cost < -0.1)
				{
					int nb_time_upgraded = RoundToNearest((upgrades[u].i_val - currentupgrades_val[client][s][i]) / upgrades[u].ratio);
					float up_cost = float(upgrades[u].cost*nb_time_upgraded);
					if(up_cost > 200.0)
					{
						Format(fstr, sizeof(fstr), "[%s] :\n  %10.3f\n%.0f", buf, currentupgrades_val[client][s][i],up_cost)
					}
					else
					{
						Format(fstr, sizeof(fstr), "[%s] :\n  %10.3f", buf, currentupgrades_val[client][s][i])
					}
				}
				else if (upgrades[u].cost > 1.0)
				{
					int nb_time_upgraded;
					if(currentupgrades_i[client][s][i] != 0.0)
					{
						nb_time_upgraded = RoundToNearest((currentupgrades_i[client][s][i] - currentupgrades_val[client][s][i]) / upgrades[u].ratio)
					}
					else
					{
						nb_time_upgraded = RoundToNearest((upgrades[u].i_val - currentupgrades_val[client][s][i]) / upgrades[u].ratio)
					}
					nb_time_upgraded *= -1
					float up_cost = ((upgrades[u].cost+((upgrades[u].cost_inc_ratio*upgrades[u].cost)*(nb_time_upgraded-1))/2)*nb_time_upgraded)
					if(s == 1)
						up_cost *= SecondaryCostReduction;
						
					if(up_cost > 200.0)
					{
						Format(fstr, sizeof(fstr), "[%s] :\n  %10.3f\n+%.0f", buf, currentupgrades_val[client][s][i],up_cost)
					}
					else
					{
						Format(fstr, sizeof(fstr), "[%s] :\n  %10.3f", buf, currentupgrades_val[client][s][i])
					}
				}
				else
				{
					Format(fstr, sizeof(fstr), "[%s] :\n  %10.3f", buf, currentupgrades_val[client][s][i])
				}
				AddMenuItem(menu, "yep", fstr);
			}
			DisplayMenuAtItem(menu, client, page, MENU_TIME_FOREVER);
		}
		else
		{
			PrintToChat(client, "This weapon has no changeable attributes.");
			CloseHandle(menu);
			Menu_TweakUpgrades(client);
		}
	}
}
public Menu_TweakUpgrades(client)
{
	Handle menu = CreateMenu(MenuHandler_AttributesTweak);
	int s
	
	SetMenuExitBackButton(menu, true);
	
	SetMenuTitle(menu, "Display Upgrades Or Remove downgrades");
	for (s = 0; s < 5; ++s)
	{
		char fstr[100]
		Format(fstr, sizeof(fstr), "$%.0f of upgrades | Refund & Remove my %s attributes", client_spent_money[client][s], current_slot_name[s])
		AddMenuItem(menu, "tweak", fstr);
	}
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		DisplayMenu(menu, client, MENU_TIME_FOREVER);
	}
	return;
}
public Menu_ChangePreferences(client)
{
	if (IsValidClient3(client))
	{
		Handle menu = CreateMenu(MenuHandler_Preferences);
		SetMenuExitBackButton(menu, true);
		SetMenuTitle(menu, "Set Preferences");
		AddMenuItem(menu, "increaseX", "+1 X to armor hud.");
		AddMenuItem(menu, "decreaseX", "-1 X to armor hud.");
		AddMenuItem(menu, "increaseY", "+1 Y to armor hud.");
		AddMenuItem(menu, "decreaseY", "-1 Y to armor hud.");
		AddMenuItem(menu, "ifrespawn", "Toggle buy menu on spawn.");
		AddMenuItem(menu, "particleToggle", "Toggle self-viewable particles.");
		AddMenuItem(menu, "knockbackToggle", "Change knockback preferences.");
		AddMenuItem(menu, "resetTutorial", "Reset all tutorial HUD elements.");
		DisplayMenu(menu, client, MENU_TIME_FOREVER);
	}
}
public Menu_ChangeKnockbackPreferences(client)
{
	if (IsValidClient3(client))
	{
		Menu menu = CreateMenu(MenuHandler_KnockbackPreferences, MENU_ACTIONS_DEFAULT|MenuAction_DisplayItem);
		SetMenuExitBackButton(menu, true);
		SetMenuTitle(menu, "Set Knockback Resistance Preferences");
		AddMenuItem(menu, "selfkb", "Self Inflicted: ");
		AddMenuItem(menu, "playerkb", "Player Damage: ");
		AddMenuItem(menu, "truekb", "True Knockback: ");
		AddMenuItem(menu, "horizontal", "Horizontal Axis: ");
		AddMenuItem(menu, "vertical", "Vertical Axis: ");
		DisplayMenu(menu, client, MENU_TIME_FOREVER);
	}
}
Menu_ShowWiki(client, int item = 0)
{
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		Handle menu = CreateMenu(MenuHandler_Wiki);
		
		SetMenuExitBackButton(menu, true);
		SetMenuTitle(menu, "★ Incremental Fortress Wiki ★");
		AddMenuItem(menu, "UpgradeInfo", "Upgrades Explanation");
		AddMenuItem(menu, "DamageInfo", "Damage Math Explanation");
		AddMenuItem(menu, "ArmorInfo", "Armor Math Explanation");
		AddMenuItem(menu, "SpecialTweaksInfo", "Special Tweaks Explanation");
		AddMenuItem(menu, "SpecialAbilitiesInfo", "Special Abilities Explanation #1");
		AddMenuItem(menu, "SpecialAbilitiesInfo2", "Special Abilities Explanation #2");
		AddMenuItem(menu, "ArcaneInfo", "Arcane Explanation");
		if (IsValidClient(client) && IsPlayerAlive(client))
		{
			DisplayMenuAtItem(menu, client, item, MENU_TIME_FOREVER);
		}
	}
}
public Action:ShowMults(client, args)
{
	if(IsPlayerAlive(client))
	{
		Menu_ShowStatsMenu(client);
	}
	return Plugin_Handled;
}
public Menu_ShowStatsMenu(client)
{
	Handle menu = CreateMenu(MenuHandler_StatsViewer);
	SetMenuExitBackButton(menu, true);
	SetMenuTitle(menu, "Display weapon stats by slot.");
	AddMenuItem(menu, "slot", "View stats for body");
	AddMenuItem(menu, "slot", "View stats for primary");
	AddMenuItem(menu, "slot", "View stats for secondary");
	AddMenuItem(menu, "slot", "View stats for melee");
	
	if (currentitem_level[client][3] == 242)
	{
		AddMenuItem(menu, "slot", "View stats for bought weapon");
	}
	
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		DisplayMenu(menu, client, 20);
	}
	return;
}
public Menu_ShowStatsSlot(client, param2)
{
	Handle menu = CreateMenu(MenuHandler_StatsSlotViewer);
	SetMenuExitBackButton(menu, true);
	int primary = -1;
	int secondary = -1;
	int melee = -1;
	if(TF2_GetPlayerClass(client) == TFClass_Spy)
	{
		primary = GetWeapon(client,1);
		secondary = GetWeapon(client,2);
		melee = GetPlayerWeaponSlot(client,2);
	}
	else 
	{
		primary = GetWeapon(client,0);
		secondary = GetWeapon(client,1);
		melee = GetWeapon(client,2);
	}
	int CWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if(param2 == 0)
	{
		SetMenuTitle(menu, "Displaying Body Stats");
		char Description[512];
		float DelayAmount = 1.0;
		Address armorDelay = TF2Attrib_GetByName(client, "tmp dmgbuff on hit");
		if(armorDelay != Address_Null)
		{
			DelayAmount /= TF2Attrib_GetValue(armorDelay) + 1.0;
		}

		Format(Description, sizeof(Description), "Body Health = %s\nBody Total Resistance = %s\nArmor Recharge Delay = %.2f\nMovespeed = %sHU/S\nFocus Regeneration = %s/S",
		GetAlphabetForm(float(TF2_GetMaxHealth(client))),
		GetAlphabetForm(GetResistance(client, true)),
		DelayAmount,
		GetAlphabetForm(GetEntPropFloat(client, Prop_Data, "m_flMaxspeed")),
		GetAlphabetForm(fl_RegenFocus[client]*66.6)); 
		
		Address zapActive = TF2Attrib_GetByName(client, "arcane zap");
		if(zapActive != Address_Null && TF2Attrib_GetValue(zapActive) > 0.0)
		{
			Format(Description, sizeof(Description), "%s\nZap Damage = %s", 
			Description, GetAlphabetForm(20.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 3.0)))
		}
		Address lightningActive = TF2Attrib_GetByName(client, "arcane lightning strike");
		if(lightningActive != Address_Null && TF2Attrib_GetValue(lightningActive) > 0.0)
		{
			Format(Description, sizeof(Description), "%s\nLightning Strike Damage = %s", 
			Description, GetAlphabetForm(200.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 80.0)))
		}
		Address callBeyondActive = TF2Attrib_GetByName(client, "arcane a call beyond");
		if(callBeyondActive != Address_Null && TF2Attrib_GetValue(callBeyondActive) > 0.0)
		{
			Format(Description, sizeof(Description), "%s\nA Call Beyond Damage = %s x 25", 
			Description, GetAlphabetForm(200.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 120.0)))
		}
		Address BlackskyEyeActive = TF2Attrib_GetByName(client, "arcane blacksky eye");
		if(BlackskyEyeActive != Address_Null && TF2Attrib_GetValue(BlackskyEyeActive) > 0.0)
		{
			Format(Description, sizeof(Description), "%s\nBlacksky Eye Damage = %s", 
			Description, GetAlphabetForm(10.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 7.5)))
		}
		Address SunlightSpearActive = TF2Attrib_GetByName(client, "arcane sunlight spear");
		if(SunlightSpearActive != Address_Null && TF2Attrib_GetValue(SunlightSpearActive) > 0.0)
		{
			Format(Description, sizeof(Description), "%s\nSunlight Spear Damage = %s", 
			Description, GetAlphabetForm(100.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 40.0)))
		}
		Address lightningenchantmentActive = TF2Attrib_GetByName(client, "arcane lightning enchantment");
		if(lightningenchantmentActive != Address_Null && TF2Attrib_GetValue(lightningenchantmentActive) > 0.0)
		{
			Format(Description, sizeof(Description), "%s\nLightning Enchantment DPS = %s", 
			Description, GetAlphabetForm(20.0*(10.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 4.0))))
		}
		Address darkmoonbladeActive = TF2Attrib_GetByName(client, "arcane darkmoon blade");
		if(darkmoonbladeActive != Address_Null && TF2Attrib_GetValue(darkmoonbladeActive) > 0.0)
		{
			Format(Description, sizeof(Description), "%s\nDarkmoon Blade Damage = %s", 
			Description, GetAlphabetForm(10.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 4.5)))
		}
		Address snapfreezeActive = TF2Attrib_GetByName(client, "arcane snap freeze");
		if(snapfreezeActive != Address_Null && TF2Attrib_GetValue(snapfreezeActive) > 0.0)
		{
			Format(Description, sizeof(Description), "%s\nSnap Freeze Damage = %s", 
			Description, GetAlphabetForm(10.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 60.0)))
		}
		Address arcaneprisonActive = TF2Attrib_GetByName(client, "arcane prison");
		if(arcaneprisonActive != Address_Null && TF2Attrib_GetValue(arcaneprisonActive) > 0.0)
		{
			Format(Description, sizeof(Description), "%s\nArcane Prison Damage = %s", 
			Description, GetAlphabetForm(10.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 5.0)))
		}
		Address classSpecificActive = TF2Attrib_GetByName(client, "arcane aerial strike");
		if(classSpecificActive != Address_Null && TF2Attrib_GetValue(classSpecificActive) > 0.0)
		{
			Format(Description, sizeof(Description), "%s\nAerial Strike Damage = %s x 30", 
			Description, GetAlphabetForm(10.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 25.0)))
		}
		Address classSpecificActive2 = TF2Attrib_GetByName(client, "arcane inferno");
		if(classSpecificActive2 != Address_Null && TF2Attrib_GetValue(classSpecificActive2) > 0.0)
		{
			Format(Description, sizeof(Description), "%s\nInferno Damage = %s x 20", 
			Description, GetAlphabetForm(20.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 12.5)))
		}
		Address classSpecificActive3 = TF2Attrib_GetByName(client, "arcane mine field");
		if(classSpecificActive3 != Address_Null && TF2Attrib_GetValue(classSpecificActive3) > 0.0)
		{
			Format(Description, sizeof(Description), "%s\nMine Field Damage = %s x 20", 
			Description, GetAlphabetForm(90.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 6.5)))
		}
		Address classSpecificActive4 = TF2Attrib_GetByName(client, "arcane hunter");
		if(classSpecificActive4 != Address_Null && TF2Attrib_GetValue(classSpecificActive4) > 0.0)
		{
			Format(Description, sizeof(Description), "%s\nArcane Hunter Damage = %s x 5", 
			Description, GetAlphabetForm(200.0 + (Pow(ArcaneDamage[client] * Pow(ArcanePower[client], 4.0), 2.45) * 80.0)))
		}
		AddMenuItem(menu, "body_description", Description, ITEMDRAW_DISABLED);
	}
	else if(param2 == 1 && IsValidWeapon(primary))
	{
		char strName[64];
		GetEntityClassname(primary, strName, 64)
		if(StrContains(strName, "weapon") != -1)
		{
			SetMenuTitle(menu, "Displaying Primary Stats");
			char Description[1024];
			
			Format(Description, sizeof(Description), "Weapon Damage Modifier = %s\nWeapon DPS Modifier = %s\nWeapon Base DPS = %.2f\nWeapon DPS = %s",
			GetAlphabetForm(TF2_GetDamageModifiers(client, primary)),
			GetAlphabetForm(TF2_GetDPSModifiers(client, primary)),
			TF2_GetWeaponclassDPS(client, primary),
			GetAlphabetForm(TF2_GetWeaponclassDPS(client, primary) * TF2_GetDPSModifiers(client, primary))); 

			if(weaponFireRate[primary] != -1.0)
			{
				Format(Description, sizeof(Description), "%s\nWeapon Fire Rate = %.2f RPS",Description, weaponFireRate[primary]);
				int i = RoundToCeil(TICKRATE/weaponFireRate[primary]);
				if(i <= 6)
				{
					if(i == 0) i = 1;
					Format(Description, sizeof(Description), "%s\nWeapon Fire Rate Delta (bonus damage)= %.2fx",Description, i*weaponFireRate[primary]/TICKRATE);
				}
			}

			AddMenuItem(menu, "primary_description", Description, ITEMDRAW_DISABLED);
		}
		else
		{
			SetMenuTitle(menu, "Displaying Primary Wearable Stats");
			char Description[512];
			Format(Description, sizeof(Description), "Look in chat for a list of attributes."); 
			TF2_AttribListAttributesBySlot(client,0);
			AddMenuItem(menu, "primary_description", Description, ITEMDRAW_DISABLED);
		}
	}
	else if(param2 == 2 && IsValidWeapon(secondary))
	{
		char strName[64];
		GetEntityClassname(secondary, strName, 64)
		if(StrContains(strName, "medigun") != -1)
		{
			SetMenuTitle(menu, "Displaying Medigun Stats");
			char Description[512];
			
			float healRateMult = 1.0;
			float armorRateMult = 1.0;
			Address Healrate1 = TF2Attrib_GetByName(secondary, "heal rate bonus");
			if(Healrate1 != Address_Null)
			{
				healRateMult *= TF2Attrib_GetValue(Healrate1);
			}
			Address Healrate2 = TF2Attrib_GetByName(secondary, "heal rate penalty");
			if(Healrate2 != Address_Null)
			{
				healRateMult *= TF2Attrib_GetValue(Healrate2);
			}
			Address Healrate3 = TF2Attrib_GetByName(secondary, "overheal fill rate reduced");
			if(Healrate3 != Address_Null)
			{
				healRateMult *= TF2Attrib_GetValue(Healrate3);
			}
			Address overhealBonus = TF2Attrib_GetByName(secondary, "overheal bonus");
			if(overhealBonus != Address_Null)
			{
				armorRateMult *= TF2Attrib_GetValue(overhealBonus);
			}
			
			Format(Description, sizeof(Description), "Medigun Base Heal Rate = %s/S\nMedigun Armor Recharge Bonus For Patient = %sx\nMedigun Range = 2k HU",
			GetAlphabetForm(healRateMult*24.0),
			GetAlphabetForm(armorRateMult)); 
			AddMenuItem(menu, "secondary_description", Description, ITEMDRAW_DISABLED);
		}
		else if(StrContains(strName, "weapon") != -1)
		{
			SetMenuTitle(menu, "Displaying Secondary Stats");
			char Description[1024];
			
			Format(Description, sizeof(Description), "Weapon Damage Modifier = %s\nWeapon DPS Modifier = %s\nWeapon Base DPS = %.2f\nWeapon DPS = %s",
			GetAlphabetForm(TF2_GetDamageModifiers(client, secondary)),
			GetAlphabetForm(TF2_GetDPSModifiers(client, secondary)),
			TF2_GetWeaponclassDPS(client, secondary),
			GetAlphabetForm(TF2_GetWeaponclassDPS(client, secondary) * TF2_GetDPSModifiers(client, secondary))); 

			if(weaponFireRate[secondary] != -1.0)
			{
				Format(Description, sizeof(Description), "%s\nWeapon Fire Rate = %.2f RPS",Description, weaponFireRate[secondary]);
				int i = RoundToCeil(TICKRATE/weaponFireRate[secondary]);
				if(i <= 6)
				{
					if(i == 0) i = 1;
					Format(Description, sizeof(Description), "%s\nWeapon Fire Rate Delta (bonus damage)= %.2fx",Description, i*weaponFireRate[secondary]/TICKRATE);
				}
			}

			AddMenuItem(menu, "secondary_description", Description, ITEMDRAW_DISABLED);
		}
		else if(StrContains(strName, "demoshield") != -1)
		{
			SetMenuTitle(menu, "Displaying Secondary Wearable Stats");
			char Description[512];
			
			Format(Description, sizeof(Description), "Shield Explosion Damage = %s\nLook in chat for a list of attributes.",
			GetAlphabetForm(TF2_GetDPSModifiers(client,CWeapon)*70.0));
			TF2_AttribListAttributesBySlot(client,1);
			AddMenuItem(menu, "secondary_description", Description, ITEMDRAW_DISABLED);
		}
		else
		{
			SetMenuTitle(menu, "Displaying Secondary Wearable Stats");
			char Description[512];
			Format(Description, sizeof(Description), "Look in chat for a list of attributes."); 
			TF2_AttribListAttributesBySlot(client,1);
			AddMenuItem(menu, "secondary_description", Description, ITEMDRAW_DISABLED);
		}
	}
	else if(param2 == 3 && IsValidWeapon(melee))
	{
		char strName[64];
		GetEntityClassname(melee, strName, 64)
		if(StrContains(strName, "weapon") != -1)
		{
			SetMenuTitle(menu, "Displaying Melee Stats");
			char Description[1024];
			
			Format(Description, sizeof(Description), "Weapon Damage Modifier = %s\nWeapon DPS Modifier = %s\nWeapon Base DPS = %.2f\nWeapon DPS = %s",
			GetAlphabetForm(TF2_GetDamageModifiers(client, melee)),
			GetAlphabetForm(TF2_GetDPSModifiers(client, melee)),
			TF2_GetWeaponclassDPS(client, melee),
			GetAlphabetForm(TF2_GetWeaponclassDPS(client, melee) * TF2_GetDPSModifiers(client, melee))); 
			
			if(current_class[client] == TFClass_Engineer)
			{
				float SentryDPS = 180.0;
				
				Address miniSentryActive = TF2Attrib_GetByName(melee, "mod wrench builds minisentry");
				if(miniSentryActive != Address_Null && TF2Attrib_GetValue(miniSentryActive) > 0.0)
				{
					SentryDPS = 32.0;
				}
				else
				{
					Address sentryRocketMult = TF2Attrib_GetByName(melee, "dmg penalty vs nonstunned");
					if(sentryRocketMult != Address_Null)
					{
						SentryDPS += 40.0*TF2Attrib_GetValue(sentryRocketMult);
					}
				}
				float override = GetAttribute(melee, "override projectile type", 0.0);
				switch(override){
					case 33.0:{
						SentryDPS *= 1.25;
					}
				}
				
				SentryDPS *= TF2_GetSentryDPSModifiers(client, melee);
				
				Format(Description, sizeof(Description), "%s\nSentry DPS = %s/each", Description, GetAlphabetForm(SentryDPS));
			}
			if(weaponFireRate[melee] != -1.0)
			{
				Format(Description, sizeof(Description), "%s\nWeapon Fire Rate = %.2f RPS",Description, weaponFireRate[melee]);
				int i = RoundToCeil(TICKRATE/weaponFireRate[melee]);
				if(i <= 6)
				{
					if(i == 0) i = 1;
					Format(Description, sizeof(Description), "%s\nWeapon Fire Rate Delta (bonus damage)= %.2fx",Description, i*weaponFireRate[melee]/TICKRATE);
				}
			}
			
			AddMenuItem(menu, "melee_description", Description, ITEMDRAW_DISABLED);
		}
		else
		{
			SetMenuTitle(menu, "Displaying Melee Wearable Stats");
			char Description[512];
			Format(Description, sizeof(Description), "Look in chat for a list of attributes."); 
			TF2_AttribListAttributesBySlot(client,2);
			AddMenuItem(menu, "melee_description", Description, ITEMDRAW_DISABLED);
		}
	}
	else if(param2 == 4 && IsValidWeapon(client_new_weapon_ent_id[client]))
	{
		char strName[64];
		int weapon = client_new_weapon_ent_id[client];
		GetEntityClassname(weapon, strName, 64)
		if(StrContains(strName, "weapon") != -1)
		{
			SetMenuTitle(menu, "Displaying Bought Weapon Stats");
			char Description[1024];
			
			Format(Description, sizeof(Description), "Weapon Damage Modifier = %s\nWeapon DPS Modifier = %s\nWeapon Base DPS = %.2f\nWeapon DPS = %s",
			GetAlphabetForm(TF2_GetDamageModifiers(client, weapon)),
			GetAlphabetForm(TF2_GetDPSModifiers(client, weapon)),
			TF2_GetWeaponclassDPS(client, weapon),
			GetAlphabetForm(TF2_GetWeaponclassDPS(client, weapon) * TF2_GetDPSModifiers(client, weapon))); 

			if(weaponFireRate[weapon] != -1.0)
			{
				Format(Description, sizeof(Description), "%s\nWeapon Fire Rate = %.2f RPS",Description, weaponFireRate[weapon]);
				int i = RoundToCeil(TICKRATE/weaponFireRate[weapon]);
				if(i <= 6)
				{
					if(i == 0) i = 1;
					Format(Description, sizeof(Description), "%s\nWeapon Fire Rate Delta (bonus damage)= %.2fx",Description, i*weaponFireRate[weapon]/TICKRATE);
				}
			}

			AddMenuItem(menu, "primary_description", Description, ITEMDRAW_DISABLED);
		}
		else
		{
			SetMenuTitle(menu, "Displaying Bought Wearable Stats");
			char Description[512];
			Format(Description, sizeof(Description), "Look in chat for a list of attributes."); 
			TF2_AttribListAttributesBySlot(client,0);
			AddMenuItem(menu, "primary_description", Description, ITEMDRAW_DISABLED);
		}
	}
	else
	{
		PrintToChat(client, "Was unable to display player stats. Most likely that the class doesn't have a weapon in that slot.");
	}
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}
public Menu_ShowStats(client)
{
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		ClientCommand(client, "sm_stats");
	}
	return;
}
public CreateBuyNewWeaponMenu(client)
{
	Handle BuyNWmenu = CreateMenu(MenuHandler_ConfirmNewWeapon);
	
	SetMenuTitle(BuyNWmenu, "Buy A Unique Weapon:");
	SetMenuExitBackButton(BuyNWmenu, true);
	int i = 0;
	int it = 0;
	char strTotal[64];
	char playerClass[16]
	switch(current_class[client])
	{
		case TFClass_Scout:
		{
			playerClass = "scout"
		}
		case TFClass_Soldier:
		{
			playerClass = "soldier"
		}
		case TFClass_Pyro:
		{
			playerClass = "pyro"
		}
		case TFClass_DemoMan:
		{
			playerClass = "demo"
		}
		case TFClass_Heavy:
		{
			playerClass = "heavy"
		}
		case TFClass_Engineer:
		{
			playerClass = "engineer"
		}
		case TFClass_Medic:
		{
			playerClass = "medic"
		}
		case TFClass_Sniper:
		{
			playerClass = "sniper"
		}
		case TFClass_Spy:
		{
			playerClass = "spy"
		}
	}
	for (i = 0; i < upgrades_weapon_nb; ++i)
	{
		if(StrContains(upgrades_weapon_class_restrictions[i],playerClass) != -1 || StrEqual(upgrades_weapon_class_restrictions[i],"none",false))
		{
			Format(strTotal, sizeof(strTotal), "%s | $%.0f",upgrades_weapon[i],upgrades_weapon_cost[i]); 
			AddMenuItem(BuyNWmenu, "tweak", strTotal);
			buyableIndexOffParam[client][it] = i
			++it
		}
	}
	if(it == 0)
		PrintToChat(client,"There aren't any unique weapons for this class yet.")
	else if (IsValidClient(client) && IsPlayerAlive(client))
		DisplayMenu(BuyNWmenu, client, 20);
	
}