--[[
	EN :
	Zombie Shelter v2.0 by Meiryi / Meika / Shiro / Shigure
	You SHOULD NOT edit / modify / reupload the codes, it includes editing gamemode's name
	If you have any problems, feel free to contact me on steam, thank you for reading this

	ZH-TW :
	夜襲生存戰 v2.0 by Meiryi  / Meika / Shiro / Shigure
	任何的修改是不被允許的 (包括模式的名稱)，有問題請在Steam上聯絡我, 謝謝!
	
	ZH-CN :
	昼夜求生 v2.0 by Meiryi  / Meika / Shiro / Shigure
	任何形式的编辑是不被允许的 (包括模式的名称), 若有问题请在Steam上联络我
]]

util.AddNetworkString("ZShelter-DayPassed")
ZShelter.StartedDifficulty = ZShelter.StartedDifficulty || -1

function ZShelter.HandleWin(title, desc)
	ZShelter.AddWinCount(GetGlobalInt("Day", 1), GetConVar("zshelter_difficulty"):GetInt())
	ZShelter.BroadcastEnd(true, title, desc)

	hook.Run("ZShelter-OnWinningRound")
end

function ZShelter.ToggleBarricadeCollision(toggle)
	for k,v in pairs(ZShelter.Barricades) do
		if(!IsValid(v)) then continue end
		v.IgnoreCollision = toggle
		if(toggle) then
			v:SetColor(Color(255, 255, 255, 150))
		else
			v:SetColor(Color(255, 255, 255, 255))
		end
	end
end

function ZShelter.OnNightSwitch()
	ZShelter.ToggleBarricadeCollision(true)
	ZShelter.KillDayEnemies()

	hook.Run("ZShelter-NightSwitch")
end

function ZShelter.RestoreConVars()
	RunConsoleCommand("ai_disabled", "0")
end

function ZShelter.OnDayPassed()
	for k,v in pairs(player.GetAll()) do
		v:SetNWInt("SkillPoints", v:GetNWInt("SkillPoints", 0) + 1, 0)
		if(!v.Callbacks.OnDayPassed) then continue end
		for x,y in pairs(v.Callbacks.OnDayPassed) do
			y(v)
		end
	end

	if(ZShelter.DayMessages[GetGlobalInt("Day")]) then
		local d = ZShelter.DayMessages[GetGlobalInt("Day")]
		timer.Simple(3.5, function()
			ZShelter.BroadcastMessage(d.msg, d.clr, d.style)
		end)
	end

	ZShelter.ClearResources()
	ZShelter.ToggleBarricadeCollision(false)

	ZShelter.SpawnLootbox()
	ZShelter.FilteEnemy()
	ZShelter.FilteBlueprint()
	ZShelter.HighlightBuildings()

	ZShelter.SetupTreasureArea()
	ZShelter.SpawnBlueprints()
	ZShelter.SpawnBonusResource()

	net.Start("ZShelter-DayPassed")
	net.WriteInt(GetGlobalInt("Day"), 32)
	net.Broadcast()

	if(GetGlobalInt("Day") > 30 && GetConVar("zshelter_endless"):GetInt() == 0) then
		ZShelter.HandleWin("#Victory", "#Survived30Day")
	end

	hook.Run("ZShelter-DaySwitch")
end

local nextTick = 0
local nextFilte = 0
hook.Add("Think", "ZShelter-Think", function()
	if(IsValid(ZShelter.Shelter)) then
		ZShelter.Shelter:SetCollisionGroup(0)
	end
	if(nextTick < CurTime()) then
		ZShelter.RunPathCheck()
		if(GetGlobalBool("ReadyState")) then
			ZShelter.CheckStart()
		end
		if(GetGlobalBool("GameStarted", false)) then
			ZShelter.RestoreConVars()
			if(ZShelter.StartedDifficulty != -1 && GetConVar("zshelter_difficulty"):GetInt() != ZShelter.StartedDifficulty) then
				GetConVar("zshelter_difficulty"):SetInt(ZShelter.StartedDifficulty)
			end
			SetGlobalInt("Time", GetGlobalInt("Time") - 1)
			if(GetGlobalInt("Time") <= 0) then
				if(GetGlobalBool("Rescuing")) then
					ZShelter.HandleWin("#Victory", "#Survived15Day")
				end
				if(!GetGlobalBool("Night")) then
					ZShelter.PlayMusic(GetConVarString("zshelter_music_night"))
					SetGlobalInt("Time", 100 + (GetConVar("zshelter_difficulty"):GetInt() * 5))
					SetGlobalBool("Night", true)
					ZShelter.OnNightSwitch()
				else
					SetGlobalInt("Day", GetGlobalInt("Day", 1) + 1)
					SetGlobalInt("Time", 240 - (GetConVar("zshelter_difficulty"):GetInt() * 5))
					SetGlobalBool("Night", false)
					ZShelter.OnDayPassed()
				end
				ZShelter.SyncNightState()
			end
		end
		if(GetGlobalBool("Rescuing")) then
			ZShelter.RestorePaths()
		end
		hook.Run("ZShelter-SecondPassed")
		nextTick = CurTime() + 1
	end
end)