AddCSLuaFile()

ENT.Base 			= "base_anim"
ENT.Type 			= "anim"
ENT.Category		= "None"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false
ENT.Model = "models/ovr_load/force_shield.mdl"
ENT.PlayerFriendly = true
ENT.Color = Color(255, 255, 255, 255)
ENT.HP = 8500

if(SERVER) then

	function ENT:RemoveSelf()
		self:EmitSound("ambient/levels/labs/electric_explosion5.wav", 100)
		local mins, maxs = self:OBBMins(), self:OBBMaxs()
		local e = EffectData()
		e:SetMagnitude(2)
		e:SetScale(1)
		e:SetRadius(2)
		for i = 1, 10 do
			e:SetOrigin(self:GetPos() + Vector(math.random(mins.x, maxs.x), math.random(mins.x, maxs.x), math.random(mins.z, maxs.z)))
			util.Effect("Sparks", e)
		end
		self:Remove()
	end

	function ENT:Initialize()
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(false)
		self:SetCollisionGroup(2)
		self:SetTrigger(true)
		self:SetCustomCollisionCheck(true)
		if(self:GetPhysicsObject()) then
			self:GetPhysicsObject():EnableMotion(false)
		end
		self:SetColor(Color(125, 125, 255, 255))
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		self:SetHealth(self.HP)
		self:SetMaxHealth(self.HP)
	end

	function ENT:Think()
		if(!IsValid(self:GetOwner())) then
			self:RemoveSelf()
			return
		end
		self:NextThink(CurTime() + 0.2)
		return true
	end

	function ENT:OnTakeDamage(dmginfo)
		local damage = dmginfo:GetDamage()
		self:SetHealth(self:Health() - damage)
		local attacker = dmginfo:GetAttacker()
		local scale = math.Clamp(self:Health() / self:GetMaxHealth(), 0, 1)
		self:SetColor(Color(125 + (125 * (1 - scale)), 125 * scale, 255 * scale, 255))
		if(self:Health() <= 0) then
			self:RemoveSelf()
		end
		if(IsValid(self.Owner) && IsValid(dmginfo:GetInflictor()) && ZShelter.IsMeleeWeapon(dmginfo:GetInflictor():GetClass())) then
			self.Owner:TakeDamageInfo(dmginfo)
		end
	end
end