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

local nextProcess = 0
local immunitySounds = 0
local lastShoottime = 0
local bypassChecks = false
hook.Add("Think", "ZShelter-Noise", function()
	if(nextProcess > SysTime() || ZShelter.PanicEnemySpawnTime > CurTime() || lastShoottime > CurTime()) then return end
	SetGlobalFloat("NoiseLevel", math.max(GetGlobalFloat("NoiseLevel", 0) - 1.25, 0))
	nextProcess = SysTime() + 0.075
end)

function ZShelter.TriggerHorde()
	ZShelter.PlayMusic(GetConVarString("zshelter_music_horde"))
	ZShelter.PanicEnemySpawnTime = CurTime() + 4 + (GetConVar("zshelter_difficulty"):GetInt() * 0.55)
	immunitySounds = SysTime() + GetGlobalInt("Time") + 1
	ZShelter.ToggleBarricadeCollision(true)
	hook.Run("ZShelter_TriggerHorde")
end

hook.Add("ZShelter_TriggerHorde", "ZShelter_SpawnHordeBoss", function()
	local ret = hook.Call("ZShelter_PreTriggerHorde")
	if(ret == true) then return end

	local bossdata = ZShelter.TreasureAreaEnemy
	local pos = ZShelter.ValidRaiderSpawnPoints[math.random(1, #ZShelter.ValidRaiderSpawnPoints)]
	if(table.Count(bossdata) <= 0 || !pos) then return end
	local boss = ents.Create(bossdata.class)
		boss.damage = bossdata.attack * 2
		boss:Spawn()
		boss:SetPos(pos)
		boss:SetMaxHealth(bossdata.hp * 2.5)
		boss:SetHealth(bossdata.hp * 2.5)
		boss:SetRenderMode(RENDERMODE_TRANSCOLOR)
		boss:SetColor(Color(255, 0, 0, 255))

		boss:SetNWBool("IsZShelterEnemy", true)
		boss:SetNWBool("ZShelterDisplayHP", true)
		boss.IsBoss = true
		boss.IsZShelterEnemy = true

		boss:SetCollisionGroup(COLLISION_GROUP_NPC_SCRIPTED)
		boss.ImmunityNightDamage = true
end)

function ZShelter.AddNoise(amount, player)
	if((immunitySounds > SysTime() || GetGlobalBool("Night", false) || !GetGlobalBool("GameStarted", false) || GetGlobalBool("Rescuing") || ZShelter.PanicEnemySpawnTime > CurTime()) && !bypassChecks) then return end
	if(IsValid(player)) then
		amount = amount * player:GetNWFloat("NoiseScale", 1)
	end
	SetGlobalFloat("NoiseLevel", math.min(GetGlobalFloat("NoiseLevel", 0) + amount, 100))
	lastShoottime = CurTime() + 0.25
	if(GetGlobalFloat("NoiseLevel", 0) >= 100) then
		ZShelter.TriggerHorde()
	end
end

local scaleSD = {
	["weapons/zsh/melees/wall.wav"] = 0.15,
	["weapons/zsh/melees/slash.wav"] = 0,
	["weapons/zsh/melees/hit1.wav"] = 0.15,
	["weapons/zsh/melees/hit2.wav"] = 0.15,
	["items/flashlight1.wav"] = 0.5,
}
hook.Add("EntityEmitSound", "ZShelter-GetSounds", function(t)
	if((immunitySounds > SysTime() || GetGlobalBool("Night", false) || !GetGlobalBool("GameStarted", false) || GetGlobalBool("Rescuing") || ZShelter.PanicEnemySpawnTime > CurTime()) && !bypassChecks) then return end
	local ent = t.Entity
	if(!IsValid(ent) || !ent:IsPlayer()) then return end
	if(string.sub(t.SoundName, 1, 17) == "player/footsteps/") then return end
	local vol = t.Volume
	local scale = scaleSD[t.SoundName]
	if(!scale) then return end
	if(vol <= 0.5) then return end
	SetGlobalFloat("NoiseLevel", math.min(GetGlobalFloat("NoiseLevel", 0) + (1.25 * (1 + vol)) * scale, 100))
	lastShoottime = CurTime() + 0.1
	if(GetGlobalFloat("NoiseLevel", 0) >= 100) then
		ZShelter.TriggerHorde()
	end
end)

local scaledownTime = 2
hook.Add("EntityFireBullets", "ZShelter-Noise", function(ent, data)
	if(ent.LastNoiseTime && ent.LastNoiseTime > CurTime()) then return end
	if((GetGlobalBool("Night", false) || !GetGlobalBool("GameStarted") || GetGlobalBool("Rescuing") || !IsValid(ent) || immunitySounds > SysTime() || ZShelter.PanicEnemySpawnTime > CurTime() || !ent:IsPlayer()) && !bypassChecks) then return end
	local wep = ent:GetActiveWeapon()
	if(!IsValid(wep)) then
		wep = ent
	else
		if(wep.Callbacks && wep.Callbacks.OnFireWeapon) then
			for k,v in pairs(wep.Callbacks.OnFireWeapon) do
				v(owner, wep)
			end
		end
	end
	local firstshot = math.abs((wep.LastShotTime || 0) - CurTime()) > 1
	local scale = wep.VolumeMultiplier || 1
	local noise = (2.5 * scale)
	if(firstshot && scale < 3) then
		wep.ScaleDownTime = CurTime() + scaledownTime
	else
		if(wep.ScaleDownTime && math.abs((wep.LastShotTime || 0) - CurTime()) < 0.15 && wep.Category != "Pistol") then
			local fraction = math.Clamp(1 - (wep.ScaleDownTime - CurTime()) / scaledownTime, 0.15, 1)
			noise = noise * fraction
		end
	end
	ZShelter.AddNoise(noise, ent)
	wep.LastShotTime = CurTime()
	ent.LastNoiseTime = CurTime() + 0.02
end)

hook.Add("OnEntityCreated", "ZShelter-ProjectileNoise", function(ent)
	timer.Simple(0, function()
		if(!IsValid(ent)) then return end
		local class = ent:GetClass()
		local owner = ent.Owner
		if(!IsValid(owner) || !owner:IsPlayer()) then return end
		if((!GetGlobalBool("GameStarted") || GetGlobalBool("Rescuing") || immunitySounds > SysTime() || ZShelter.PanicEnemySpawnTime > CurTime() || (owner.LastNoiseTime && owner.LastNoiseTime > CurTime())) && !bypassChecks) then return end
		local wep = owner:GetActiveWeapon()
		if(!IsValid(wep) || !wep.Primary || wep.Primary.Projectile != class) then return end
		local scale = wep.VolumeMultiplier || 1
		local noise = (2.5 * scale)
		if(!GetGlobalBool("Night", false)) then
			ZShelter.AddNoise(noise, owner)
		end
		if(owner.Callbacks && owner.Callbacks.OnFireProjectile) then
			for k,v in pairs(owner.Callbacks.OnFireProjectile) do
				v(owner)
			end
		end
		if(wep.Callbacks && wep.Callbacks.OnFireWeapon) then
			for k,v in pairs(wep.Callbacks.OnFireWeapon) do
				v(owner, wep)
			end
		end
		owner.LastNoiseTime = CurTime() + 0.01
	end)
end)