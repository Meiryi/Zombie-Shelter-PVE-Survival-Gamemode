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

util.AddNetworkString("ZShelter-RequestReadyStatus")
util.AddNetworkString("ZShelter-StartMessage")
util.AddNetworkString("ZShelter-Ready")

function ZShelter.UnReady()
	for k,v in pairs(player.GetAll()) do
		v:SetNWBool("Ready", false)
	end
end

function ZShelter.ShouldStart(minReadyCount)
	local readyCount = 0
	for k,v in pairs(player.GetAll()) do
		if(v:GetNWBool("Ready")) then
			readyCount = readyCount + 1
		end
	end

	local a = (minReadyCount - readyCount)
	if(a <= 0) then
		SetGlobalFloat("ReadyTime", CurTime() + 10)
	else
		if(a <= 1) then
			if(GetGlobalFloat("ReadyTime", -1) == -1) then
				SetGlobalFloat("ReadyTime", CurTime() + 60)
			end
		end
	end
end

function ZShelter.ForceDay(day)
	SetGlobalInt("Day", day)
	SetGlobalBool("Night", true)
	ZShelter.FilteEnemy()
end

function ZShelter.ForceStart()
	local diff = GetConVar("zshelter_difficulty"):GetInt()
	local fullres = GetConVar("zshelter_start_with_resources"):GetInt() == 1
	local resources = math.floor(24 / player.GetCount())
	ZShelter.FilteEnemy()
	ZShelter.SetupTreasureArea()
	ZShelter.SpawnLootbox()
	net.Start("ZShelter-StartMessage")
	net.Broadcast()
	SetGlobalBool("GameStarted", true)
	SetGlobalInt("TStart", CurTime())
end

function ZShelter.ForceSTD(day)
	ZShelter.ForceStart()
	ZShelter.ForceDay(day)
end

function ZShelter.CheckStart()
	if(GetGlobalFloat("ReadyTime", -1) == -1 || !GetGlobalBool("RunSequence")) then return end
	local t = math.max(GetGlobalFloat("ReadyTime", -1) - CurTime(), 0)
	if(t <= 10) then
		ZShelter.PlayMusic(GetConVarString("zshelter_music_countdown"))
		if(ZShelter.SpawnPos) then
			for k,v in pairs(player.GetAll()) do
				v:SetPos(ZShelter.SpawnPos + Vector(math.random(-128, 128), math.random(-128, 128), 0))
				v:Freeze(true)
			end
		end
		timer.Simple(10, function()
			if(#ZShelter.AiNodes <= 0) then
				ParseFile()
				ZShelter.ForceReloadPoints()
			end
			local diff = GetConVar("zshelter_difficulty"):GetInt()
			local fullres = GetConVar("zshelter_start_with_resources"):GetInt() == 1
			local resources = math.floor(24 / player.GetCount())
			local skills = ZShelter.CalcStartSkillPoints(player.GetCount())
			if(diff >= 9) then
				SetGlobalInt("Time", 270)
				SetGlobalInt("Capacity", 40)
			end
			if(diff >= 9 || fullres) then
				SetGlobalInt("Woods", GetGlobalInt("Capacity", 0))
				SetGlobalInt("Irons", GetGlobalInt("Capacity", 0))
			end
			for k,v in pairs(player.GetAll()) do
				v:Freeze(false)
				v:SetNWInt("SkillPoints", skills)
			end
			ZShelter.FilteEnemy()
			ZShelter.SetupTreasureArea()
			ZShelter.SpawnLootbox()
			ZShelter.StartTime = CurTime()
			net.Start("ZShelter-StartMessage")
			net.Broadcast()
			ZShelter.StartedDifficulty = GetConVar("zshelter_difficulty"):GetInt()
			SetGlobalBool("GameStarted", true)
			SetGlobalInt("TStart", CurTime())
		end)
		SetGlobalBool("RunSequence", false)
		SetGlobalBool("ReadyState", false)
	end
end

net.Receive("ZShelter-Ready", function(len, ply)
	if(!GetGlobalBool("ReadyState") || ZShelter.UnsupportedMap) then return end
	ply:SetNWBool("Ready", true)
	ZShelter.ShouldStart(player.GetCount())
end)

hook.Add("PlayerDisconnected", "ZShelter-DisconnectCheck", function(ply)
	if(player.GetCount() <= 1) then
		ZShelter.ResetServer()
	end
	if(!GetGlobalBool("ReadyState")) then return end
	ZShelter.ShouldStart(player.GetCount())
end)