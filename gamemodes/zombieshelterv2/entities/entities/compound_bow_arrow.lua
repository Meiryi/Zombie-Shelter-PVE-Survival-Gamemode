AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = ""
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""

ENT.damage = 65
if(SERVER) then
	function ENT:Initialize()
			if(CLIENT) then return end
			self:SetModel("models/vj_hlr/hl1/crossbow_bolt.mdl")
	        self:PhysicsInit(SOLID_VPHYSICS)
	        self:SetMoveType(MOVETYPE_VPHYSICS)
	        self:SetSolid(SOLID_VPHYSICS)
	        local phys = self:GetPhysicsObject()
	 		self.BaseAngle = self:GetAngles()
	 		local wep = self.Owner:GetActiveWeapon()
	 		if(IsValid(wep)) then
	 			self.damage = wep.ProjectileDamage
				self.inflictor = wep
	 		end
	        if (phys:IsValid()) then
	        	phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
				phys:Wake()
				phys:SetMass(1)
				phys:EnableDrag(false)
				phys:EnableGravity(false)
				phys:SetBuoyancyRatio(0)
	        end
	    self.KillTime = CurTime() + 2
	end

	ENT.KillTime = 0
	function ENT:Think()
		if(self.KillTime < CurTime()) then
			self:Remove()
		end
	end

	function ENT:PhysicsCollide(data, phys)
		local ent = data.HitEntity
		if(ent == game.GetWorld()) then
			local phys = self:GetPhysicsObject()
			if(IsValid(phys)) then
				self:SetAngles(self.BaseAngle)
				self:SetPos(self:GetPos() + self.BaseAngle:Forward())
				phys:EnableMotion(false)
			end
		else
			if(IsValid(ent)) then
				self:Remove()
				local attacker = self.Owner
				local inflictor = self.inflictor
				if(!IsValid(inflictor)) then
					inflictor = self
				end
				ent:TakeDamage(self.damage, attacker, inflictor)
			end
		end
	end
end