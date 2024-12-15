ZShelter.Melees = {}
ZShelter.RankMelees = {
	[1] = {
		name = "souldagger",
		class = "tfa_zsh_cso_combatknife",
		desc = "souldagger",
		icon = "tfa_cso_combatknife",
	},
	[2] = {
		name = "kujang",
		class = "tfa_zsh_cso_kujang",
		desc = "kujang",
		icon = "tfa_cso_kujang",
	},
	[3] = {
		name = "nata",
		class = "tfa_zsh_cso_nata",
		desc = "nata",
		icon = "tfa_cso_nata",
	},
	[4] = {
		name = "tomahawk",
		class = "tfa_zsh_cso_tomahawk",
		desc = "tomahawk",
		icon = "tfa_cso_tomahawk",
	},
	[5] = {
		name = "horseaxe",
		class = "tfa_zsh_cso_horseaxe",
		desc = "horseaxe",
		icon = "tfa_cso_horseaxe",
	},
	[6] = {
		name = "crowbarcraft",
		class = "tfa_zsh_cso_crowbarcraft",
		desc = "crowbarcraft",
		icon = "tfa_cso_crowbarcraft",
	},
	[7] = {
		name = "janus9",
		class = "tfa_zsh_cso_janus9",
		desc = "janus9",
		icon = "tfa_cso_janus9",
	},
	[8] = {
		name = "dualkatana",
		class = "tfa_zsh_cso_dualkatana",
		desc = "dualkatana",
		icon = "tfa_cso_dualkatana",
	},
	[9] = {
		name = "runebreaker",
		class = "tfa_zsh_cso_runebreaker",
		desc = "runebreaker",
		icon = "tfa_cso_runebreaker",
	},
	[10] = {
		name = "dualsword",
		class = "tfa_zsh_cso_dualsword",
		desc = "dualsword",
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

function ZShelter.IsMeleeWeapon(class)
	return ZShelter.Melees[class]
end

function ZShelter.IsHoldingMelee(player)
	local wep = player:GetActiveWeapon()
	return IsValid(wep) && ZShelter.IsMeleeWeapon(wep:GetClass())
end

function ZShelter.RegisterMeleeWeapon(class)
	ZShelter.Melees[class] = true
end

ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_shelteraxe")
ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_machete")
ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_crowbar")
ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_clawhammer")
ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_skull9")
ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_mastercombatknife")
ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_tritacknife")
ZShelter.RegisterMeleeWeapon("tfa_zsh_cso_miracle_prism")

for _, meleedata in pairs(ZShelter.RankMelees) do
	ZShelter.RegisterMeleeWeapon(meleedata.class)
end