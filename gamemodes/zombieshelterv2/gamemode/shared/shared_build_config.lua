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

ZShelter.BuildingConfig = {}
ZShelter.BuildingData = {}
ZShelter.WeaponConfig = {}
ZShelter.IngredientConfig = {}
ZShelter.TurretClasses = {}

function ZShelter.AddBuildItem(cat, name, wood, iron, power, health, class, model, shelterlvl, offset, tdata, specialreq, finddata) -- Note to myself, rewrite this shit when I got time
	if(!ZShelter.BuildingConfig[cat]) then
		ZShelter.BuildingConfig[cat] = {}
	end
	if(!tdata) then tdata = {} end
	if(!specialreq) then specialreq = {} end
	table.insert(ZShelter.BuildingConfig[cat], {
		category = cat,
		title = name,
		woods = wood,
		irons = iron,
		powers = power,
		health = health,
		class = class,
		model = model,
		shelterlvl = shelterlvl,
		offset = offset,
		tdata = tdata,
		specialreq = specialreq,
		finddata = finddata,
	})
	if(cat == "Turret") then
		table.insert(ZShelter.TurretClasses, class)
	end
	ZShelter.BuildingData[name] = {
		woods = wood,
		irons = iron,
		powers = power,
		model = model,
		offset = offset,
		shelterlvl = shelterlvl,
	}
end

function ZShelter.RemoveBuildings(cat, name)
	if(!ZShelter.BuildingConfig[cat]) then return end
	for k,v in pairs(ZShelter.BuildingConfig[cat]) do
		if(v.title != name) then continue end
		table.remove(ZShelter.BuildingConfig[cat], k)
		return
	end
end

local str = [[
	AddBuildItems(1, "obstacle", "Wooden Wall", 4, 0, 0, 0, 0, 400, 0, "models/galaxy/rust/wood_wall.mdl", "")
	AddBuildItems(2, "obstacle", "Wooden Spike Wall", 6, 1, 0, 0, 0, 700, 0, "models/galaxy/rust/spike_wall.mdl", "")
	AddBuildItems(3, "obstacle", "Large Wooden Spike Wall", 8, 3, 0, 0, 0, 1050, 0, "models/galaxy/rust/spike_wall_large.mdl", "")
	AddBuildItems(4, "obstacle", "Metal Wall", 2, 3, 0, 0, 0, 1150, 1, "models/galaxy/rust/metal_wall.mdl", "")
	AddBuildItems(5, "obstacle", "Windowed Metal Wall", 2, 4, 0, 0, 1, 1150, 0, "models/galaxy/rust/metal_window.mdl", "")
	AddBuildItems(6, "obstacle", "Metal Stairs", 2, 7, 0, 0, 1, 1250, 0, "models/galaxy/rust/metal_stairs.mdl", "")
	AddBuildItems(7, "obstacle", "Concrete Wall", 3, 3, 0, 0, 2, 2050, 50, "models/nickmaps/rostok/bar_parede_uniq.mdl", "")
	AddBuildItems(8, "obstacle", "Metal Gate", 3, 10, 0, 0, 2, 2350, 0, "models/props_lab/blastdoor001c.mdl", "")
	AddBuildItems(9, "obstacle", "Reinforced Concrete Wall", 5, 12, 0, 0, 3, 2750, 0, "models/shigure/shelter_b_wall03.mdl", "")
	AddBuildItems(10, "obstacle", "Wooden Ramp", 8, 3, 0, 0, 0, 550, 0, "models/galaxy/rust/wood_ramp.mdl", "")
	AddBuildItems(11, "obstacle", "Wooden Stairs", 10, 4, 0, 0, 0, 700, 0, "models/galaxy/rust/wood_stairs.mdl", "")
	AddBuildItems(12, "obstacle", "Wooden Platform", 12, 3, 0, 0, 0, 900, 0, "models/galaxy/rust/wood_foundation.mdl", "")
	AddBuildItems(13, "obstacle", "Campfire", 3, 1, 0, 0, 0, 50, 0, "models/galaxy/rust/campfire.mdl", "")
	AddBuildItems(1, "generator", "Basic Generator", 5, 5, 0, 0, 0, 350, 0, "models/shigure/shelter_b_generator01.mdl", "")
	AddBuildItems(2, "generator", "Medium Generator", 8, 8, 0, 0, 1, 450, 0, "models/shigure/shelter_b_generator02.mdl", "")
	AddBuildItems(3, "generator", "Large Generator", 10, 10, 0, 0, 2, 550, 0, "models/shigure/shelter_b_generator03.mdl", "")
	AddBuildItems(4, "generator", "Mega Generator", 12, 12, 0, 0, 3, 650, 0, "models/shigure/shelter_b_generator04.mdl", "")
	AddBuildItems(1, "public", "Basic Storage", 10, 8, 15, 0, 0, 600, 15, "models/items/ammocrate_ar2.mdl", "")
	AddBuildItems(2, "public", "Medium Storage", 15, 12, 20, 0, 1, 750, 0, "models/shigure/shelter_b_warehouse01.mdl", "")
	AddBuildItems(3, "public", "Large Storage", 28, 19, 35, 0, 2, 1050, 75, "models/nickmaps/rostok/p19_casa2.mdl", "")
	AddBuildItems(4, "public", "Workstation", 35, 28, 35, 1, 0, 1250, 0, "models/props_lab/workspace004.mdl", "")
	AddBuildItems(5, "public", "Tele' tower", 45, 51, 50, 2, 1, 1500, 0, "models/shigure/shelter_b_antenna01.mdl", "")
	AddBuildItems(6, "public", "Cement Mixer", 55, 68, 60, 3, 2, 2250, 0, "models/shigure/shelter_b_concrete01.mdl", "")
	AddBuildItems(7, "public", "Healing Station", 10, 10, 15, 0, 0, 450, 15, "models/shigure/medibed.mdl", "")
	AddBuildItems(1, "defense", "Basic Turret", 5, 5, 15, 0, 0, 300, 0, "models/vj_hlr/hl1/gturret_mini.mdl", "npc_vj_zshelter_mini_turret")
	AddBuildItems(2, "defense", "Landmine", 2, 3, 0, 0, 0, 100, 5, "models/lambda/traps/zsht_landmine.mdl", "")
	AddBuildItems(3, "defense", "Spike Trap", 3, 7, 0, 0, 0, 350, 0, "models/lambda/traps/zsht_spiketrap.mdl", "")
	AddBuildItems(4, "defense", "Flame Turret", 10, 8, 20, 0, 1, 450, 0, "models/vj_hlr/decay/sentry.mdl", "npc_vj_zshelter_sentry_flame")
	AddBuildItems(5, "defense", "Freeze Bomb", 5, 5, 0, 0, 1, 125, 0, "models/shigure/gastank.mdl", "")
	AddBuildItems(6, "defense", "Mounted Machine Gun", 18, 18, 40, 0, 1, 600, 0, "models/shigure/shelter_mountgun.mdl", "zshelter_cso_mounted_gun")
	AddBuildItems(7, "defense", "Minigun Turret", 15, 10, 30, 0, 2, 700, 0, "models/vj_hlr/hl1/gturret.mdl", "npc_vj_zshelter_minigun_turret")
	AddBuildItems(8, "defense", "Blast Turret", 20, 15, 35, 0, 2, 750, 0, "models/vj_hlr/hl1/sentry.mdl", "npc_vj_zshelter_sentry")
	AddBuildItems(10, "defense", "Railgun Cannon", 28, 25, 40, 0, 3, 900, 0, "models/vj_hlr/hl1/alien_cannon.mdl", "npc_vj_zshelter_xen_cannon")
	AddBuildItems(11, "defense", "Mortar Cannon", 35, 31, 40, 0, 3, 900, 0, "models/props_combine/combinethumper002.mdl", "")
	AddBuildItems(12, "defense", "Electric Defense Tower", 31, 28, 40, 0, 3, 1200, 0, "models/shigure/electric_defense.mdl", "npc_vj_zshelter_electric_defense")
]]

--ZShelter.AddBuildItem(cat, name, wood, iron, power, health, class, model, shelterlvl, zoffset, turretdata)
function ZShelter.ParseOldBuildData()
	local ctx = string.Explode("\n", str)
	local output = ""
	ctx[#ctx] = nil
	for k,v in next, ctx do 
		local line = string.Replace(v, "AddBuildItems(", "")
		line = string.Replace(line, ")", "")
		-- old format
		-- AddBuildItems(idx 1, type_ 2, name 3, wood 4, iron 5, power 6, engi_lvl 7, base_lvl 8, hp 9, zoffs 10, mdl 11, class 12)
		local se = string.Explode(",", line)
		local ret = [[ZShelter.AddBuildItem("", ]]..se[3]..[[, ]]..se[4]..[[, ]]..se[5]..[[, ]]..se[6]..[[, ]]..se[9]..[[, ]]..se[12]..[[, ]]..se[11]..[[, ]]..se[8]..[[, ]]..se[10]..[[, {})]]

		output = output..ret.."\n"
	end
	SetClipboardText(output)
end

--[[
	-- Variables --

	forcecollide = Enables collide for entity, might be buggy if you stand on top of it, recommended to use it for something cannot get on top of it
	dothink = Enable ENT:Think() even it's incomplete
	noowner = Don't set the owner, could fix the collison problem to the owner with the objects
	forceowner = Force sets owner, it can fix the problem where damage is not dealt by players
	insideshelter = Allow to build inside of shelter
	playercount = Limit the amount of this building with player count
	yawoffset = Yaw offset when placed this building
	activerange = Minimum range of this turret to be active, used for displaying range in building preview
	attackrange = Minimum attack of this turret to be active, used for displaying range in building preview
	circlerange = Shows the range with circle
	notarget = won't be targeted by zombies

	maxamount = Maximum amount of this building
	bait = Creates a bait entity so enemy will attack this building

	damage = Every damage done by this entity will be override with this value
	buildspeed = Building speed scale, 0.5 = 50% slower, 2 = 100% faster

	highlight_day = Day to highlight this building
	highlight_color = Color for highlighting

	faceforward = Face player's direction
	faceforward_offset = Yaw offset

	upgradable = Enable upgrade system for this building
	upgrade_attackscale = Scaling for attack when upgrading, def 0.25
	upgrade_healthscale = Ditto, def 0.1
	upgradecount = Maximum upgrade count, default 2

	canstun = Can be stunned even it's not turret

	durability = Use durability system for the building, entity no longer takes damage from all sources
	durability_cost = Health cost every time this entity deal damage
	durability_cost_interval = Time until next durability cost
	durability_repair_hits = How many hits required to repair this building
	durability_repair_amount = How many health for repairing

	nodestroymessage = Disable destroyed message

	-- Functions --

	oncomplete(self)
	ondestroy(self)
	onuse(player, self)
	onshelterupgrade(self)
	ondamaged(self, attacker)

	thinkfunc(self)
	thinkinterval = interval of thinking
]]

ZShelter.AddBuildItem("Barricade",  "Wooden Wall",  2,  0,  0,  600,  "prop_physics",  "models/galaxy/rust/wood_wall.mdl",  0,  Vector(0, 0, 0), {buildspeed = 1.5})
ZShelter.AddBuildItem("Barricade",  "Wooden Spike Wall",  3,  1,  0,  750,  "prop_physics",  "models/galaxy/rust/spike_wall.mdl",  0,  Vector(0, 0, 0), {
	buildspeed = 1.5,
	damage = 12,
	ondamaged = function(self, attacker, dmginfo)
		local a = self.Builder
		if(!IsValid(a)) then a = self end
		ZShelter.DealNoScaleDamage(a, attacker, self.AttackDamage)
	end,
})
ZShelter.AddBuildItem("Barricade",  "Wire Fence",  0,  3,  0,  1000,  "prop_physics",  "models/zshelter/shelter_b_wall01.mdl",  0,  Vector(0, 0, 0), {buildspeed = 1.5})

ZShelter.AddBuildItem("Barricade",  "Metal Wall",  2,  3,  0,  850,  "prop_physics",  "models/galaxy/rust/metal_wall.mdl",  1,  Vector(0, 0, 1), {buildspeed = 2})
ZShelter.AddBuildItem("Barricade",  "Reinforced Wire Fence",  1,  4,  0,  1450,  "prop_physics",  "models/zshelter/shelter_b_wall02.mdl",  1,  Vector(0, 0, 0), {buildspeed = 2})
ZShelter.AddBuildItem("Barricade",  "Metal Gate",  3,  10,  2,  2200,  "prop_physics",  "models/zshelter/shelter_b_metaldoor01.mdl",  1,  Vector(0, 0, 0), {
	buildspeed = 4,
	forcecollide = true,
	dothink = true,
	noowner = true,
	thinkfunc = function(self)
		self:SetPlaybackRate(5)
		if(self.OpenTime && self.OpenTime > CurTime()) then
			self:SetCollisionGroup(2)
			self:SetSequence(3)
		else
			if(self.OpenTime && CurTime() - self.OpenTime > 0.15) then
				self:SetCollisionGroup(0)
			end
			self:SetSequence(1)
		end
	end,
	onuse = function(player, self)
		self.OpenTime = CurTime() + 3
	end,
	thinkinterval = 0.05,
})

ZShelter.AddBuildItem("Barricade",  "Metal Barricade",  2,  5,  0,  2400,  "prop_physics",  "models/zshelter/zb_barricade.mdl",  2,  Vector(0, 0, 83), {buildspeed = 3})
ZShelter.AddBuildItem("Barricade",  "Concrete Wall",  2,  4,  0,  2800,  "prop_physics",  "models/nickmaps/rostok/bar_parede_uniq.mdl",  2,  Vector(0, 0, 50), {buildspeed = 3})
ZShelter.AddBuildItem("Barricade",  "Concrete Gate",  4,  12,  2,  4000,  "prop_physics",  "models/zshelter/shelter_b_metaldoor02.mdl",  2,  Vector(0, 0, 0), {
	buildspeed = 5,
	forcecollide = true,
	dothink = true,
	noowner = true,
	thinkfunc = function(self)
		self:SetPlaybackRate(5)
		if(self.OpenTime && self.OpenTime > CurTime()) then
			self:SetCollisionGroup(2)
			self:SetSequence(3)
		else
			if(self.OpenTime && CurTime() - self.OpenTime > 0.15) then
				self:SetCollisionGroup(0)
			end
			self:SetSequence(1)
		end
	end,
	onuse = function(player, self)
		self.OpenTime = CurTime() + 3
	end,
	thinkinterval = 0.05,
})

ZShelter.AddBuildItem("Barricade",  "Concrete Barricade",  4,  6,  0,  3300,  "prop_physics",  "models/props_phx/construct/concrete_barrier00.mdl",  3,  Vector(0, 0, 0), {buildspeed = 3.5,})
ZShelter.AddBuildItem("Barricade",  "Reinforced Concrete Wall",  4,  6,  0,  5500,  "prop_physics",  "models/shigure/shelter_b_wall03.mdl",  3,  Vector(0, 0, 0), {buildspeed = 5.5})

ZShelter.AddBuildItem("Recovery",  "Healing Station",  5,  5,  0,  250,  "prop_physics",  "models/shigure/medibed.mdl",  0,  Vector(0, 0, 15), {
	thinkfunc = function(self)
		local heal = 5 + (3 * self:GetNWInt("UpgradeCount", 0))
		for k,v in pairs(player.GetAll()) do
			if(!ZShelter.ValidatePlayerDistance(self, v, 128)) then continue end
			v:SetHealth(math.min(v:Health() + heal, v:GetMaxHealth()))
		end
	end,
	thinkinterval = 1,
	upgradable = true,
	upgrade_attackscale = 0,
	upgrade_healthscale = 0.1,
	upgradecount = 2,
})
ZShelter.AddBuildItem("Recovery",  "Armor Box",  5,  15,  0,  250,  "prop_physics",  "models/zshelter/bg_armorbox_group.mdl",  0,  Vector(0, 0, 0), {
	thinkfunc = function(self)
		local heal = 5 + (2 * self:GetNWInt("UpgradeCount", 0))
		for k,v in pairs(player.GetAll()) do
			if(!ZShelter.ValidatePlayerDistance(self, v, 86)) then continue end
			v:SetArmor(math.min(v:Armor() + heal, v:GetMaxArmor()))
		end
	end,
	upgradable = true,
	upgrade_attackscale = 0,
	upgrade_healthscale = 0.1,
	upgradecount = 2,
	thinkinterval = 1.5,
	cboxoffset = true,
})
ZShelter.AddBuildItem("Recovery",  "Ammo Supply Crate",  3,  15,  0,  300,  "obj_structure_ammo_crate",  "models/zshelter/shelter_b_ammobox01.mdl",  0,  Vector(0, 0, 0), {
	maxamount = 2,
})
ZShelter.AddBuildItem("Recovery",  "Campfire",  2,  1,  0,  50,  "prop_physics",  "models/galaxy/rust/campfire.mdl",  0,  Vector(0, 0, 0), {
	thinkfunc = function(self)
		for k,v in pairs(player.GetAll()) do
			if(!ZShelter.ValidatePlayerDistance(self, v, 128)) then continue end
			ZShelter.AddSanity(v, 15)
		end
	end,
	thinkinterval = 1,
	cboxoffset = true,
}, {"Campfire"})
local powergain = 60
ZShelter.AddBuildItem("Generator",  "Generator",  5,  5,  0, 120,  "prop_physics",  "models/shigure/shelter_b_generator04.mdl",  0,  Vector(0, 0, 0), {
		maxamount = 4,
		bait = true,
		oncomplete = function(self)
			local power = 90 + (GetGlobalInt("ShelterLevel", 0) * powergain)
			self.Power = power
			SetGlobalInt("Powers", GetGlobalInt("Powers", 0) + self.Power)
			for k,v in pairs(ents.GetAll()) do
				if(!v.IsTurret || !v.IsBuilding) then continue end
				ZShelter.RemoveStun(v)
			end
		end,
		ondestroy = function(self)
			if(!self.Power) then self.Power = 0 end
			SetGlobalInt("Powers", GetGlobalInt("Powers", 0) - self.Power)

			if(GetGlobalInt("Powers", 0) < 0) then
				for k,v in pairs(ents.GetAll()) do
					if(!v.IsTurret || !v.IsBuilding) then continue end
					ZShelter.StunBuilding(v, 1024000)
				end
			end
		end,
		onshelterupgrade = function(self)
			self.Power = self.Power + powergain
			SetGlobalInt("Powers", GetGlobalInt("Powers", 0) + powergain)
		end
	}, {}, nil)
ZShelter.AddBuildItem("Generator",  "Resource Generator",  12,  12,  65,  300,  "obj_structure_resource_generator",  "models/props_wasteland/laundry_washer003.mdl",  0,  Vector(0, 0, 25), {
	maxamount = 2,
}, {"Advanced Engineering"})
ZShelter.AddBuildItem("Storage",  "Basic Storage",  4,  6,  0,  600,  "prop_physics",  "models/items/ammocrate_ar2.mdl",  0,  Vector(0, 0, 15), {
	onuse = function(player, building)
		if(!building:GetNWBool("Completed")) then return end
		net.Start("ZShelter-OpenStorage")
		net.Send(player)
	end,
	ondestroy = function(self)
		if(!self:GetNWBool("Completed", false)) then return end
		SetGlobalInt("Capacity", math.max(GetGlobalInt("Capacity", 0) - 12, 0))
	end,
	oncomplete = function()
		SetGlobalInt("Capacity", GetGlobalInt("Capacity", 0) + 12)
	end
})
ZShelter.AddBuildItem("Storage",  "Medium Storage",  7,  11,  0,  750,  "prop_physics",  "models/shigure/shelter_b_warehouse01.mdl",  1,  Vector(0, 0, 0), {
	onuse = function(player, building)
		if(!building:GetNWBool("Completed")) then return end
		net.Start("ZShelter-OpenStorage")
		net.Send(player)
	end,
	ondestroy = function(self)
		if(!self:GetNWBool("Completed", false)) then return end
		SetGlobalInt("Capacity", math.max(GetGlobalInt("Capacity", 0) - 25, 0))
	end,
	oncomplete = function()
		SetGlobalInt("Capacity", GetGlobalInt("Capacity", 0) + 25)
	end
})
ZShelter.AddBuildItem("Storage",  "Large Storage",  10,  16,  0,  1050,  "prop_physics",  "models/nickmaps/rostok/p19_casa2.mdl",  2,  Vector(0, 0, 75), {
	onuse = function(player, building)
		if(!building:GetNWBool("Completed")) then return end
		net.Start("ZShelter-OpenStorage")
		net.Send(player)
	end,
	ondestroy = function(self)
		if(!self:GetNWBool("Completed", false)) then return end
		SetGlobalInt("Capacity", math.max(GetGlobalInt("Capacity", 0) - 40, 0))
	end,
	oncomplete = function()
		SetGlobalInt("Capacity", GetGlobalInt("Capacity", 0) + 40)
	end
})
ZShelter.AddBuildItem("Public Construction",  "Worktable",  20,  24,  0,  700,  "prop_physics",  "models/zshelter/shelter_b_tool01.mdl",  0,  Vector(0, 0, 0), {
	bait = true,
	onuse = function(player, building)
		if(!building:GetNWBool("Completed")) then return end
		net.Start("ZShelter-OpenWorktable")
		net.Send(player)
	end
})
ZShelter.AddBuildItem("Public Construction",  "Cement Mixer",  32,  40,  3,  1050,  "prop_physics",  "models/shigure/shelter_b_concrete01.mdl",  1,  Vector(0, 0, 0), {
	bait = true,
})
ZShelter.AddBuildItem("Public Construction",  "Comm Tower",  42,  51,  5,  1450,  "prop_physics",  "models/shigure/shelter_b_antenna01.mdl",  2,  Vector(0, 0, 0), {
	bait = true,
	highlight_day = 15,
	highlight_color = Color(150, 255, 150, 255),

	onuse = function(player, building)
		if(!building:GetNWBool("Completed") || GetGlobalInt("Day", 0) < 15) then return end
		ZShelter.ProcessRescue(player)
	end
})

ZShelter.AddBuildItem("Trap",  "Landmine",  1,  2,  0,  150,  "npc_vj_zshelter_mine",  "models/zshelter/shelter_b_mine01.mdl",  0,  Vector(0, 0, 0), {
	damage = 325,
	buildspeed = 1,
	forceowner = true,
	insideshelter = true,
	activerange = 64,
	attackrange = 64 * 2.5,
})
ZShelter.AddBuildItem("Trap",  "Razorwire",  1,  4,  0, 130,  "obj_structure_wiretrap",  "models/zshelter/barricade_wire.mdl",  0,  Vector(0, 0, 0), {
	damage = 3,
	forceowner = true,
	durability = true,
	upgrade_attackscale = 0.33,
	upgrade_healthscale = 0.25,
	upgradable = true,
	upgradecount = 2,
	durability_cost = 1,
	durability_cost_interval = 0.15,
	nodestroymessage = true,
	insideshelter = true,
})
ZShelter.AddBuildItem("Trap",  "Claymore",  2,  3,  0,  175,  "npc_vj_zshelter_clay",  "models/zshelter/shelter_b_claymore01.mdl",  0,  Vector(0, 0, 5), {
	damage = 850,
	buildspeed = 1,
	forceowner = true,
	faceforward = true,
	faceforward_offset = 0,
	insideshelter = true,
	activerange = 86,
	attackrange = 86 * 2,
}, {"Claymore"})
ZShelter.AddBuildItem("Trap",  "Freeze Bomb",  1,  3,  0,  155,  "npc_vj_zshelter_freeze_bomb",  "models/shigure/gastank.mdl",  1,  Vector(0, 0, 0), {
	damage = 5,
	forceowner = true,
	insideshelter = true,
	activerange = 100,
	attackrange = 200,
})
ZShelter.AddBuildItem("Trap",  "Spike Trap",  3,  5,  10,  150,  "npc_vj_zshelter_spike_trap",  "models/zshelter/shelter_b_thron01.mdl",  1,  Vector(0, 0, 0), {
	damage = 35,
	forceowner = true,
	upgrade_attackscale = 0.25,
	upgrade_healthscale = 0.25,
	upgradable = true,
	upgradecount = 2,
	durability = true,
	durability_cost = 6,
	durability_cost_interval = 0.2,
	nodestroymessage = true,
	insideshelter = true,
	attackrange = 45,
})
ZShelter.AddBuildItem("Trap",  "Flame Trap",  5,  3,  0,  120,  "obj_structure_flame_trap",  "models/combine_helicopter/helicopter_bomb01.mdl",  2,  Vector(0, 0, -7), {
	damage = 25,
	forceowner = true,
	nodestroymessage = true,
	insideshelter = true,
	activerange = 80,
	attackrange = 120,
})
ZShelter.AddBuildItem("Trap",  "Propeller Trap",  4,  8,  15,  330,  "obj_structure_propeller_trap",  "models/props_c17/trappropeller_engine.mdl",  2,  Vector(0, 0, 18), {
	damage = 5,
	forceowner = true,
	upgrade_attackscale = 0.2,
	upgrade_healthscale = 0.2,
	upgradable = true,
	upgradecount = 2,
	canstun = true,
	durability = true,
	durability_cost = 2,
	durability_cost_interval = 0.25,
	nodestroymessage = true,
	insideshelter = true,
	attackrange = 64,
})
ZShelter.AddBuildItem("Trap",  "CMB Trap",  6,  6,  0,  200,  "obj_structure_cmb_mine",  "models/props_combine/combine_mine01.mdl",  3,  Vector(0, 0, 0), {
	damage = 0,
	forceowner = true,
	nodestroymessage = true,
	insideshelter = true,
	activerange = 86,
	attackrange = 186,
})
ZShelter.AddBuildItem("Trap",  "Gravity Mine",  10,  10,  0,  450,  "obj_structure_gravity_mine",  "models/roller_spikes.mdl",  3,  Vector(0, 0, -5), {
	damage = 100,
	forceowner = true,
	nodestroymessage = true,
	insideshelter = true,
	durability = true,
	durability_cost = 1,
	durability_cost_interval = 1,
	activerange = 86,
	attackrange = 360,
})
ZShelter.AddBuildItem("Trap",  "Laser Trap",  11,  10,  5,  600,  "obj_structure_laser_trap",  "models/props_combine/combine_light001a.mdl",  3,  Vector(0, 0, 5), {
	damage = 7,
	forceowner = true,
	nodestroymessage = true,
	insideshelter = true,
	durability = true,
	durability_cost = 1,
	durability_cost_interval = 1,
})
ZShelter.AddBuildItem("Turret",  "Basic Turret",  3,  4,  10,  300,  "npc_vj_zshelter_turret",  "models/zshelter/zb_turret.mdl",  0,  Vector(0, 0, 0), {
	upgradable = true,
	upgrade_attackscale = 0.2,
	upgrade_healthscale = 0.25,
	upgradecount = 2,
	damage = 14,
	insideshelter = true,
	attackrange = 1500,
})
ZShelter.AddBuildItem("Turret",  "Freeze Turret",  5,  4,  12,  450,  "npc_vj_zshelter_ice_turret",  "models/vj_hlr/decay/sentry.mdl",  0,  Vector(0, 0, 0), {
	damage = 1,
	insideshelter = true,
	attackrange = 450,
}, nil, {find = true, day = 1})
ZShelter.AddBuildItem("Turret",  "Mounted Machine Gun",  12,  12,  0,  500,  "npc_vj_zshelter_mounted_mg",  "models/tfa_cso/emplacement/w_csomountgun.mdl",  0,  Vector(0, 0, 0), {
	playercount = true,
	damage = 40,
	upgradable = true,
	upgrade_attackscale = 0,
	upgrade_healthscale = 0.2,
	upgradecount = 3,

	oncomplete = function(self)
		local buff = 1 + (GetGlobalInt("ShelterLevel", 0) * 0.2933)
		self.AttackScaling = buff
		self.AttackDamage = math.floor(40 * buff)
		self:SetNWInt("AttackDamage", math.floor(40 * buff))
	end,
	onshelterupgrade = function(self)
		local buff = 1 + (GetGlobalInt("ShelterLevel", 0) * 0.2933)
		self.AttackScaling = buff
		self.AttackDamage = math.floor(40 * buff)
		self:SetNWInt("AttackDamage", math.floor(40 * buff))
	end,
}, {}, {find = true, day = 1})
ZShelter.AddBuildItem("Turret",  "Burst Shotgun Turret",  4,  6,  15,  525,  "npc_vj_zshelter_burst_turret",  "models/vj_hlr/hl1/sentry.mdl",  1,  Vector(0, 0, 0), {
	upgradable = true,
	upgrade_attackscale = 0.25,
	upgrade_healthscale = 0.10,
	upgradecount = 3,
	damage = 5,
	insideshelter = true,
	attackrange = 700,
}, {}, {find = true, day = 2})
ZShelter.AddBuildItem("Turret",  "Flame Turret",  6,  6,  15,  600,  "npc_vj_zshelter_flame_turret",  "models/zshelter/shelter_b_firegun01.mdl",  1,  Vector(0, 0, 0), {
	upgrade_attackscale = 0.42,
	upgrade_healthscale = 0.3,
	upgradable = true,
	upgradecount = 2,
	damage = 5,
	insideshelter = true,
	attackrange = 360,
})
ZShelter.AddBuildItem("Turret",  "Enemy Scanner",  4,  7,  10,  800,  "obj_structure_scanner",  "models/zshelter/obj_decoy01.mdl",  1,  Vector(0, 0, 20), {
	notarget = true,
	circlerange = true,
	attackrange = 400,
}, nil, {find = true, day = 1})
ZShelter.AddBuildItem("Turret",  "Mending Tower",  18,  18,  40,  150,  "npc_vj_zshelter_repairer",  "models/props_lab/reciever_cart.mdl",  1,  Vector(0, 0, 32.5), {
	upgradable = true,
	upgrade_attackscale = 0,
	upgrade_healthscale = 0.3,
	upgradecount = 4,
	forcecollide = true,
	noowner = true,
	insideshelter = true,
	activerange = 250,
	notarget = true,
}, {}, {find = true, day = 1})
ZShelter.AddBuildItem("Turret",  "Blast Turret",  3,  5,  18,  450,  "npc_vj_zshelter_blast_turret",  "models/vj_hlr/hl1/sentry.mdl",  2,  Vector(0, 0, 0), {
	upgradable = true,
	upgrade_attackscale = 0.25,
	upgrade_healthscale = 0.35,
	upgradecount = 2,
	damage = 20,
	insideshelter = true,
	attackrange = 1500,
}, {})
ZShelter.AddBuildItem("Turret",  "Minigun Turret",  7,  8,  25,  500,  "npc_vj_zshelter_minigun_turret",  "models/zshelter/shelter_b_turret_bg01.mdl",  2,  Vector(0, 0, 0), {
	upgradable = true,
	upgrade_attackscale = 0.33,
	upgrade_healthscale = 0.1,
	upgradecount = 3,
	damage = 10,
	insideshelter = true,
	attackrange = 1500,
}, {})
ZShelter.AddBuildItem("Turret",  "Pusher Tower",  10, 12,  15,  500,  "obj_structure_pusher",  "models/props_combine/combine_light001b.mdl",  2,  Vector(0, 0, 20), {
	damage = 0,
	insideshelter = true,
	activerange = 256,
}, nil, {find = true, day = 4})
ZShelter.AddBuildItem("Turret",  "Railgun Cannon",  8,  11,  30,  750,  "npc_vj_zshelter_railgun_turret",  "models/vj_hlr/hl1/alien_cannon.mdl",  2,  Vector(0, 0, 0), {
	upgradable = true,
	upgrade_attackscale = 0.4,
	upgrade_healthscale = 0.1,
	upgradecount = 2,
	yawoffset = -90,
	damage = 250,
	insideshelter = true,
	attackrange = 2000,
}, nil, {find = true, day = 4})
ZShelter.AddBuildItem("Turret",  "Mortar Cannon",  16,  16,  35,  500,  "npc_vj_zshelter_mortar",  "models/zshelter/shelter_b_turret01.mdl",  2,  Vector(0, 0, 0), {
	upgradable = true,
	upgrade_attackscale = 0.2,
	upgrade_healthscale = 0.05,
	upgradecount = 3,
	damage = 70,
	insideshelter = true,
	attackrange = 3072,
	manual = true,
}, {})
ZShelter.AddBuildItem("Turret",  "Plasma Turret",  13,  14,  25,  700,  "npc_vj_zshelter_plasma_turret",  "models/zshelter/shelter_b_laser_tower.mdl",  3,  Vector(0, 0, 0), {
	upgradable = true,
	upgradecount = 3,
	upgrade_attackscale = 0.35,
	upgrade_healthscale = 0.1,
	damage = 120,
	insideshelter = true,
	attackrange = 2500,
}, {})
ZShelter.AddBuildItem("Turret",  "Electric Defense Tower",  16,  16,  30,  1500,  "npc_vj_zshelter_electric_defense",  "models/zshelter/shelter_b_electric_defense.mdl",  3,  Vector(0, 0, 0), {
	upgradable = true,
	upgrade_attackscale = 0.1,
	upgrade_healthscale = 0.25,
	upgradecount = 2,
	damage = 10,
	insideshelter = true,
	attackrange = 180,
}, {})
ZShelter.AddBuildItem("Turret",  "Laser Turret",  17,  18,  20,  400,  "npc_vj_zshelter_laser_turret",  "models/combine_turrets/ground_turret.mdl",  3,  Vector(0, 0, 25), {
	upgradable = true,
	upgradecount = 2,
	upgrade_attackscale = 0.25,
	upgrade_healthscale = 0.3,
	damage = 60,
	insideshelter = true,
	attackrange = 3000,
}, {})
ZShelter.AddBuildItem("Turret",  "Laser Minigun Turret",  21,  21,  30,  750,  "npc_vj_zshelter_minigun_plasma_turret",  "models/zshelter/turret_laser.mdl",  3,  Vector(0, 0, 0), {
	upgradable = true,
	upgradecount = 2,
	upgrade_attackscale = 0.15,
	upgrade_healthscale = 0.05,
	damage = 24,
	insideshelter = true,
	attackrange = 2048,
}, nil, {find = true, day = 8})
ZShelter.AddBuildItem("Turret",  "Gauss Turret",  24,  22,  30,  650,  "npc_vj_zshelter_combine_turret",  "models/combine_turrets/floor_turret.mdl",  3,  Vector(0, 0, 0), {
	upgradable = true,
	upgradecount = 1,
	upgrade_attackscale = 0.33,
	upgrade_healthscale = 0.5,
	damage = 40,
	attackrange = 900,
	insideshelter = true,
}, nil, {find = true, day = 5})
ZShelter.AddBuildItem("Turret",  "Combine Mortar Cannon",  24,  24,  50,  450,  "npc_vj_zshelter_combine_mortar",  "models/props_combine/combine_mortar01a.mdl",  3,  Vector(0, 0, 0), {
	upgradable = true,
	upgradecount = 2,
	upgrade_attackscale = 0.5,
	upgrade_healthscale = 0,
	damage = 300,
	attackrange = 4096,
	insideshelter = true,
	manual = true,
}, nil, {find = true, day = 7})

function ZShelter:SetupIngredients()
	ZShelter.IngredientConfig = {}
	for k,v in pairs(ZShelter.BuildingConfig) do
		for x,y in pairs(v) do
			if(y.finddata) then
				table.insert(ZShelter.IngredientConfig, {
					day = y.finddata.day,
					model = y.model,
					id = y.title,
				})
			end
		end
	end
end

ZShelter:SetupIngredients()

local CameraOffset = Vector(-1050, 0, 80) -- They are basically the same
local ModelOffset = Vector(0, 0, 0)
local ModelAngle = Angle(0, 1, 0)
ZShelter.ShelterUpgrade = {
	[1] = {
		sheltermodel = "models/shigure/shelter_b_shelter03.mdl",
		woods = 40,
		irons = 40,
		powers = 15,
		Offset = ModelOffset,
		Angle = ModelAngle,
		CameraOffset = CameraOffset,
		required_building = {
			["Worktable"] = {
				Offset = Vector(0, 0, 0),
				Angle = Angle(0, 0, 0),
				CameraOffset = Vector(0, 0, 0),
			},
		},
	},
	[2] = {
		sheltermodel = "models/shigure/shelter_b_shelter04.mdl",
		woods = 90,
		irons = 90,
		powers = 20,
		Offset = ModelOffset,
		Angle = ModelAngle,
		CameraOffset = CameraOffset,
		required_building = {
			["Cement Mixer"] = {
				Offset = Vector(0, -80, -100),
				Angle = Angle(0, 45, 0),
				CameraOffset = Vector(0, 0, 0),
			}
		},
	},
	[3] = {
		sheltermodel = "models/shigure/shelter_b_shelter05.mdl",
		woods = 140,
		irons = 140,
		powers = 30,
		Offset = ModelOffset,
		Angle = ModelAngle,
		CameraOffset = CameraOffset,
		required_building = {
			["Comm Tower"] = {
				Offset = Vector(0, -80, -130),
				Angle = Angle(0, 0, 0),
				CameraOffset = Vector(0, 0, 0),
			},
		},
	},
}