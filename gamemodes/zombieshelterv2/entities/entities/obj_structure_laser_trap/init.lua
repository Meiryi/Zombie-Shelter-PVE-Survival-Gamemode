AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/props_combine/combine_light001a.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 256
ENT.AimTarget = nil

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetTrigger(true)
	self:SetCollisionGroup(2)
	self:AddFlags(65536)
	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
		self:GetPhysicsObject():Wake()
	end
end

ENT.ConnectedTowers = {}
ENT.ConnectedPoints = {}
ENT.NextCheckPointTime = 0
ENT.NativePoints = {
	Vector(256, 0, 0),
	Vector(-256, 0, 0),
	Vector(0, 256, 0),
	Vector(0, -256, 0),
}

function ENT:Think()
	local pos = self:GetPos()
	if(self:Health() <= 0) then return end
	if(self.NextCheckPointTime < CurTime()) then -- Less lag
		self.ConnectedPoints = {}
		for k,v in ipairs(ents.FindByClass("obj_structure_laser_trap")) do
			if(pos:Distance(v:GetPos()) > self.MaximumDistance || v == self) then continue end
			table.insert(self.ConnectedPoints, v)
		end
		self.NextCheckPointTime = CurTime() + 1
	end
	if(#self.ConnectedPoints <= 0) then
			local e = EffectData()
				e:SetOrigin(pos)
				local tr = {
					start = pos,
					mask = MASK_SHOT,
					ignoreworld = true,
					filter = {"obj_structure_laser_trap"},
				}
		for k,v in ipairs(self.NativePoints) do
			local epos = pos + v
			e:SetStart(epos)
			util.Effect("zshelter_warden_tower", e)
			tr.endpos = epos
			local ent = util.TraceLine(tr).Entity
			if(IsValid(ent)) then
				ent:TakeDamage(5, self, self)
			end
		end
	else
		self.ConnectedTowers = {}
		local e = EffectData()
			e:SetOrigin(pos)
		local tr = {
			start = pos,
			mask = MASK_SHOT,
			ignoreworld = true,
			filter = {"obj_structure_laser_trap"},
		}
		for k,v in ipairs(self.ConnectedPoints) do
			if(!IsValid(v) || v.ConnectedTowers[self:EntIndex()]) then continue end
				local epos = v:GetPos()
				e:SetStart(epos)
				util.Effect("zshelter_warden_tower", e)
			tr.endpos = epos
			local ent = util.TraceLine(tr).Entity
			if(IsValid(ent)) then
				ent:TakeDamage(5, self, self)
			end
			self.ConnectedTowers[v:EntIndex()] = true
		end
	end
	self:NextThink(CurTime() + 0.15)
	return true
end