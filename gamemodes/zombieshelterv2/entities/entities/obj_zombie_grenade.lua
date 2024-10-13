ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "PlasmaEXA"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.KillTime = 0
ENT.StartCheckTime = 0
ENT.TriggerRadius = 256

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self.NoCollide = true
		self:SetModel("models/cso_zbs/misc/zombibomb.mdl")
		self:PhysicsInitBox(Vector(-1, -1, -1), Vector(1, 1, 1))
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(false)
		self:SetCollisionGroup(COLLISION_GROUP_NPC_SCRIPTED)
        local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(24)
			phys:EnableDrag(false)
			phys:SetBuoyancyRatio(0)
			phys:SetDamping(1, 1)
		end
		self.KillTime = CurTime() + 3.5
		self.StartCheckTime = CurTime() + 0.1
		local phys = self:GetPhysicsObject()
		
		if (phys:IsValid()) then
			phys:Wake()
		end
	end

	function ENT:Think()
		if(self.KillTime < CurTime() || (self.StartCheckTime < CurTime() && self:GetVelocity():Length2D() < 5)) then
			self:Explode()
		end

		local target = self.Target
		if(IsValid(target) && target:GetPos():Distance(self:GetPos()) < self.TriggerRadius * 0.45) then
			self:Explode()
		end
		self:NextThink(CurTime())
		return true
	end

	function ENT:Explode()
		local ef = EffectData()
			ef:SetOrigin(self:GetPos())
			ef:SetMagnitude(3)
			ef:SetScale(1)
			util.Effect("Sparks", ef)

		util.ScreenShake(self:GetPos(), 10, 40, 1, 256)
		local damage = 15 * (1 + (GetConVar("zshelter_difficulty"):GetInt() * 0.115))

		for k,v in ipairs(ents.FindInSphere(self:GetPos(), self.TriggerRadius)) do
			local isbuilding = v:GetNWBool("IsBuilding")
			if(!v:IsPlayer() && !isbuilding) then continue end
			if(isbuilding) then
				ZShelter.ApplyDamageFast(v, damage, true)
			else
				v:TakeDamage(15, self, self)
			end
		end

		sound.Play("zshelter/zombies/zombi_bomb_exp.wav", self:GetPos(), 100, 100)
		self:Remove()
	end

	function ENT:PhysicsCollide(data, physobj)	
	    self:EmitSound("zshelter/zombies/zombi_bomb_bounce_"..math.random(1, 2)..".wav", 100, 100)
	end
end