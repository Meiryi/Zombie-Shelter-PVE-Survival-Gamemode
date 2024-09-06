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
hook.Add("Think", "ZShelter-Noise", function()
	if(nextProcess > SysTime() || ZShelter.PanicEnemySpawnTime > CurTime() || lastShoottime > CurTime()) then return end
	SetGlobalFloat("NoiseLevel", math.max(GetGlobalFloat("NoiseLevel", 0) - 1, 0))
	nextProcess = SysTime() + 0.075
end)

local scaleSD = {
	["weapons/zsh/melees/wall.wav"] = 0.15,
	["weapons/zsh/melees/slash.wav"] = 0,
	["weapons/zsh/melees/hit1.wav"] = 0.15,
	["weapons/zsh/melees/hit2.wav"] = 0.15,
	["items/flashlight1.wav"] = 0.33,
}
hook.Add("EntityEmitSound", "ZShelter-GetSounds", function(t)
	if(immunitySounds > SysTime() || GetGlobalBool("Night", false) || GetGlobalBool("Rescuing") || !GetGlobalBool("GameStarted") || ZShelter.PanicEnemySpawnTime > CurTime()) then return end
	local ent = t.Entity
	if(!IsValid(ent) || !ent:IsPlayer()) then return end
	if(string.sub(t.SoundName, 1, 17) == "player/footsteps/") then return end
	local vol = t.Volume
	local scale = scaleSD[t.SoundName]
	if(!scale) then scale = 1 end
	if(vol <= 0.5) then return end
	SetGlobalFloat("NoiseLevel", math.min(GetGlobalFloat("NoiseLevel", 0) + (1.25 * (1 + vol)) * scale, 100))
	lastShoottime = CurTime() + 0.1
	if(GetGlobalFloat("NoiseLevel", 0) >= 100) then
		ZShelter.PlayMusic(GetConVarString("zshelter_music_horde"))
		ZShelter.PanicEnemySpawnTime = CurTime() + 4 + (GetConVar("zshelter_difficulty"):GetInt() * 0.55)
		immunitySounds = SysTime() + 60
	end
end)