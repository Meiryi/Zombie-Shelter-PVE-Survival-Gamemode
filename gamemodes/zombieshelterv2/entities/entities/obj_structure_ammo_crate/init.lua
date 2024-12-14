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
			if(!IsValid(wep) || wep:GetPrimaryAmmoType() == -1 || !wep.CanGetAmmoSupply || (wep.AmmoRegenSpeed != -1 && wep.NextAmmoRegen && wep.NextAmmoRegen > CurTime())) then continue end
			local plyCapacity = ZShelter.AmmoCapacity * v:GetNWFloat("ZShelter-AmmoCapacity", 1)
			local currentAmmos = v:GetAmmoCount(wep:GetPrimaryAmmoType())
			if(currentAmmos >= plyCapacity) then continue end
			if(wep.AmmoCapacity == -1) then
				local ammos = math.min(wep:GetMaxClip1() * 2, self:GetNWInt("CurrentAmmos", 3000))
				if(ammos <= 1) then
					ammos = math.min(1, self:GetNWInt("CurrentAmmos", 3000))
				end
				v:GiveAmmo(ammos, wep:GetPrimaryAmmoType(), true)
				local take = math.Clamp(ammos, 0, plyCapacity - currentAmmos)
				self:SetNWInt("CurrentAmmos", math.max(self:GetNWInt("CurrentAmmos", 3000) - take, 0))
			else
				local ammos = 1
				local cammos = v:GetAmmoCount(wep:GetPrimaryAmmoType())
				if(cammos >= wep.AmmoCapacity) then continue end
				v:SetAmmo(math.min(cammos + ammos, wep.AmmoCapacity), wep:GetPrimaryAmmoType())
				self:SetNWInt("CurrentAmmos", math.max(self:GetNWInt("CurrentAmmos", 3000) - ammos, 0))
			end
			wep.NextAmmoRegen = CurTime() + (wep.AmmoRegenSpeed || 0)
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