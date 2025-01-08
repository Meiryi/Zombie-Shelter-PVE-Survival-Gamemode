AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/kd_box.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.ResourceType = "Woods"
ENT.Woods = 0
ENT.Irons = 0

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetCollisionGroup(2)
	self:SetTrigger(true)
	self:SetModelScale(0.33, 0)
	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
	end
end

function ENT:Think()
	self:NextThink(CurTime() + 1)
	return true
end

function ENT:StartTouch(ent)
	if(!ent:IsPlayer() || !ent:Alive()) then return end
	ZShelter.AddResourceToPlayer(ent, "Woods", math.random(1, 20))
	ZShelter.AddResourceToPlayer(ent, "Irons", math.random(1, 20))
	if(GetConVar("zshelter_shared_skillbox"):GetInt() != 1) then
		ent:SetNWInt("SkillPoints", ent:GetNWInt("SkillPoints", 0) + 1, 0)
	else
		for _, player in ipairs(player.GetAll()) do
			player:SetNWInt("SkillPoints", player:GetNWInt("SkillPoints", 0) + 1)
		end
	end
	self:Remove()
end