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

ZShelter.RecordedPosition = ZShelter.RecordedPosition || {}
ZShelter.PathBlockedCount = 0
ZShelter.NextValidateTime = 0
ZShelter.PathValidTime = 0

local run = true

function ZShelter.RestorePaths()
	game.ConsoleCommand("ai_clear_bad_links\n")
	ZShelter.PathValidTime = ZShelter.PathValidTime + 30
end

function ZShelter.ShelterUnreachable()
	ZShelter.PathBlockedCount = ZShelter.PathBlockedCount + 1
	if(ZShelter.PathBlockedCount < 16) then return end
	ZShelter.RestorePaths()
	for k,v in pairs(ents.FindByClass("logic_zshelter_path_tester")) do
		v:Remove()
	end
	ZShelter.PathBlockedCount = 0
	ZShelter.NextValidateTime = CurTime() + 30
end

function ZShelter.RemovePathFinder()
	for k,v in pairs(ents.FindByClass("logic_zshelter_path_tester")) do
		v:Remove()
	end
end

function ZShelter_Fits(pos)
	local tr = {
		start = pos,
		endpos = pos,
		mins = Vector(-16, -16, 0),
		maxs = Vector(16, 16, 16)
	}
	return !util.TraceHull(tr).HitWorld
end

local offsets = {
	Vector(86, 0, 0),
	Vector(-86, 0, 0),
	Vector(0, 86, 0),
	Vector(0, -86, 0),
}

function ZShelter.ValidPath(pos, index)
	if(!run) then return end
	for i = 1, #offsets do
		local position = pos + offsets[i]
		if(!ZShelter_Fits(position)) then continue end
		local validator = ents.Create("logic_zshelter_path_tester")
			validator:SetPos(position)
			validator:Spawn()
	end
	ZShelter.RecordedPosition[index] = {
		time = CurTime(),
		pos = pos,
	}
end

local checkAmount = 1
local count = 0
local nextDecrease = 0
function ZShelter.RunPathCheck()
	if(GetConVar("zshelter_path_validate"):GetInt() == 0 || ZShelter.NextValidateTime > CurTime() || GetGlobalBool("Rescuing")) then return end
	if(nextDecrease < CurTime()) then
		ZShelter.PathBlockedCount = math.max(ZShelter.PathBlockedCount - 1, 0)
		nextDecrease = CurTime() + 1.5
	end
	if(count > 2) then
		local mIndex = #ZShelter.ValidRaiderSpawnPoints
		if(mIndex <= 0) then return end
		for i = 1, checkAmount do
			local pos = ZShelter.ValidRaiderSpawnPoints[math.random(1, mIndex)]
			if(!pos) then continue end
			local validator = ents.Create("logic_zshelter_path_tester")
				validator:SetPos(pos)
				validator:Spawn()
		end
		count = 0
	end
	count = count + 1
end