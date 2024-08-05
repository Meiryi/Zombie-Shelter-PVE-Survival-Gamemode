AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/shelter_b_ammobox01.mdl"
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
	self:SetTrigger(true)

	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
	end

	self:SetNWInt("MaxAmmos", 3000)
	self:SetNWInt("CurrentAmmos", 3000)
	self:SetNWBool("IsBuilding", true)

	self.KillTime = CurTime() + 120
end

ENT.CurTime = 0
ENT.LastTakeTime = 0
function ENT:Think()
	if(self.CurTime < CurTime() && self:GetNWInt("CurrentAmmos", 3000) > 0) then
		for k,v in pairs(player.GetAll()) do
			if(!ZShelter.ValidatePlayerDistance(self, v, 86)) then continue end
			local wep = v:GetActiveWeapon()
			if(!IsValid(wep) || wep:GetPrimaryAmmoType() == -1 || !wep.CanGetAmmoSupply) then continue end
			local ammos = math.min(wep:GetMaxClip1() * 2, self:GetNWInt("CurrentAmmos", 3000))
			v:GiveAmmo(ammos, wep:GetPrimaryAmmoType(), true)

			self:SetNWInt("CurrentAmmos", math.max(self:GetNWInt("CurrentAmmos", 3000) - ammos, 0))
			self.LastTakeTime = CurTime() + 1
			sound.Play("items/ammo_pickup.wav", v:GetPos(), 100, 100, 1)
		end
		self.CurTime = CurTime() + 0.75
	end
	if(self.LastTakeTime < CurTime()) then
		self:SetNWInt("CurrentAmmos", math.min(self:GetNWInt("CurrentAmmos", 3000) + 3, 3000))
	end
	self:NextThink(CurTime() + 0.33)
	return true
end