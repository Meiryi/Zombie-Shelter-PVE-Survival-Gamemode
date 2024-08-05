ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName 		= "ZShelter Mini Turret"
ENT.Author 			= "Meika"
ENT.Contact 		= ""
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "ZShelter"

function ENT:Initialize()
	if(SERVER) then
		self:SetModel(self.Model)
	end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetNWBool("IsBuilding", true)
	if(SERVER) then
		self:SetTrigger(true)
	end
end

ENT.OpenTime = 0
ENT.DoorOpened = false
ENT.Opening = false
ENT.Closing = false
ENT.BaitProp = nil

function ENT:Think()
	self:SetOwner(self)
	self:SetCollisionBounds(Vector(-20, -140, -1), Vector(20, 180, 150))
	self:NextThink(CurTime() + 0.05)
	self:SetPlaybackRate(5)
	local mins, maxs = self:GetCollisionBounds()
	local pos = self:GetPos()
	if(SERVER) then
		if(self.OpenTime > CurTime()) then
			self:SetCollisionGroup(2)
			self:SetSequence(3)
		else
			if(CurTime() - self.OpenTime > 0.15) then
				self:SetCollisionGroup(0)
			end
			self:SetSequence(1)
		end
	end
	self:NextThink(CurTime() + 0.1)
	return true
end

function ENT:Use(ent)
	if(!ent:IsPlayer()) then return end
	self.OpenTime = CurTime() + 2
	self.Opening = true
	self.Closing = true
end

ENT.LastDamageTime = 0
function ENT:Touch(entity)
	if(self.LastDamageTime > CurTime() || ZShelter.ValidateEntity(nil, entity) || entity.IsPathTester || entity:IsPlayer()) then return end
	ZShelter.ApplyDamageFast(self, 20, true)
	self.LastDamageTime = CurTime() + 0.33
end