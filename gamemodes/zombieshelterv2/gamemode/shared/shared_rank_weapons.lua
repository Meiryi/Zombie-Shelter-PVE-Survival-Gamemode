ZShelter.RankMelees = {
	[1] = {
		name = "Soul Bane Dagger",
		class = "tfa_zsh_cso_combatknife",
		desc = "+5 Primary attack damage, +15 Secondary attack damage",
		icon = "tfa_cso_combatknife",
	},
	[2] = {
		name = "Kujang",
		class = "tfa_zsh_cso_kujang",
		desc = "+10 Primary attack damage, +30 Secondary attack damage",
		icon = "tfa_cso_kujang",
	},
	[3] = {
		name = "Nata Knife",
		class = "tfa_zsh_cso_nata",
		desc = "+35 Primary attack damage, +120 Secondary attack damage and 60% range",
		icon = "tfa_cso_nata",
	},
	[4] = {
		name = "Tomahawk",
		class = "tfa_zsh_cso_tomahawk",
		desc = "+25 Primary attack damage, +50 Secondary attack damage, +25 Build speed",
		icon = "tfa_cso_tomahawk",
	},
	[5] = {
		name = "Flame Tomahawk",
		class = "tfa_zsh_cso_horseaxe",
		desc = "+30 Primary attack damage, +60 Secondary attack damage, Set target on fire with 8 afterburn damage",
		icon = "tfa_cso_horseaxe",
	},
	[6] = {
		name = "Electric Crowbar",
		class = "tfa_zsh_cso_crowbarcraft",
		desc = "+30 Primary attack damage, +60 Secondary attack damage and 20% attack speed, Secondary attack stuns target for 0.4s",
		icon = "tfa_cso_crowbarcraft",
	},
	[7] = {
		name = "Janus-9",
		class = "tfa_zsh_cso_janus9",
		desc = "+30 Primary attack damage, +100 Secondary attack damage, Secondary attack can knockback enemies",
		icon = "tfa_cso_janus9",
	},
	[8] = {
		name = "Dual Wakizashi",
		class = "tfa_zsh_cso_dualkatana",
		desc = "Primary attack slash two times, each slash will be more powerful, +100 Secondary attack damage, Hitting on same enemy will increase damage",
		icon = "tfa_cso_dualkatana",
	},
	[9] = {
		name = "Blade Runebreaker",
		class = "tfa_zsh_cso_runebreaker",
		desc = "+230 Primary attack damage, +50 Secondary attack damage, Secondary attack are ranged and can pierce through enemies",
		icon = "tfa_cso_runebreaker",
	},
	[10] = {
		name = "Dual Sword Phantom Slayer",
		class = "tfa_zsh_cso_dualsword",
		desc = "Both primary and secondary have combo attacks, only first attack can gather resources",
		icon = "tfa_cso_dualsword",
	},
}

if(SERVER) then
	util.AddNetworkString("ZShelter-SyncMeleeWeapon")
	util.AddNetworkString("ZShelter-SelectMeleeWeapon")

	net.Receive("ZShelter-SelectMeleeWeapon", function(len, ply)
		local index = net.ReadInt(32)
		if(index <= 0) then return end
		local prevWeapon = ply:GetNWInt("SelectedMelee", 0)
		if(prevWeapon != index) then
			ply:SetNWInt("SelectedMelee", index)
			ZShelter.SyncMelee(ply, ply:GetNWInt("SelectedMelee", 0))
			file.Write("zombie shelter v2/playerdata/"..ply:SteamID64()..".txt", index)
		else
			ply:SetNWInt("SelectedMelee", 0)
			ZShelter.SyncMelee(ply, ply:GetNWInt("SelectedMelee", 0))
			file.Write("zombie shelter v2/playerdata/"..ply:SteamID64()..".txt", "0")
		end
	end)

	function ZShelter.SyncMelee(player, weaponID)
		net.Start("ZShelter-SyncMeleeWeapon")
		net.WriteInt(weaponID, 32)
		net.Send(player)
	end

	function ZShelter.GetDefaultMelee(player)
		if(GetConVar("zshelter_enable_ranks"):GetInt() == 0) then
			return "tfa_zsh_cso_shelteraxe"
		else
			local exp = player:GetNWInt("ZShelterEXP", 0)
			if(exp == 0) then
				ZShelter.ReadPlayerEXP(player)
				exp = player:GetNWInt("ZShelterEXP", 0)
			end
			local _, rank = ZShelter.CalculateRank(exp)
			if(rank <= 0) then
				player:SetNWInt("SelectedMelee", 0)
				return "tfa_zsh_cso_shelteraxe"
			else
				local data = file.Read("zombie shelter v2/playerdata/"..player:SteamID64()..".txt", "DATA")
				if(!data) then
					rank = math.min(rank, 10)
					file.Write("zombie shelter v2/playerdata/"..player:SteamID64()..".txt", rank)
					player:SetNWInt("SelectedMelee", rank)
					return ZShelter.RankMelees[rank].class
				else
					local num = tonumber(data)
					if(num <= 0) then
						player:SetNWInt("SelectedMelee", 0)
						return "tfa_zsh_cso_shelteraxe"
					else
						if(num > rank) then
							num = rank
							file.Write("zombie shelter v2/playerdata/"..player:SteamID64()..".txt", num)
						end
						player:SetNWInt("SelectedMelee", num)
						return ZShelter.RankMelees[num].class
					end
				end
			end
		end
	end
end