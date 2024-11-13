ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Thanatos7 Blade"
ENT.Author = "Meiryi"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Hull = 32
ENT.BaseAngle = Angle(0, 0, 0)
ENT.KillTime = 0
ENT.Stucked = false
ENT.DamageInterval = 0
ENT.SlashDamage = 30

if(CLIENT) then return end

function ENT:Initialize()
    if SERVER then
        if not IsValid(self.myowner) then
            self.myowner = self:GetOwner()
            if not IsValid(myowner) then
                self.myowner = self
            end
        end
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(1)
			phys:EnableDrag(false)
			phys:EnableGravity(false)
			phys:SetBuoyancyRatio(0)
            if self.velocity then
                phys:SetVelocityInstantaneous(self.velocity)
			end
            phys:EnableCollisions(true)
            self:StartMotionController()
            phys:SetVelocity(self.BaseAngle:Forward() * 2500)
        end
		local mins, maxs = self:GetCollisionBounds()
		self:SetCollisionBounds(mins * 0.5, maxs * 0.5)
    end
    self.KillTime = CurTime() + 15
end

function ENT:Think()
	if(self.KillTime < CurTime()) then self:Remove() end
	local phys = self:GetPhysicsObject()
	if(!self.Stucked) then
		phys:SetVelocity(self.BaseAngle:Forward() * 2500)
	else
		local attacker = self.Owner
		if(!IsValid(attacker)) then
			attacker = self
		end
		if(self.DamageInterval < CurTime()) then
			for k,v in pairs(ents.FindInSphere(self:GetPos(), 64)) do
				if(!IsValid(v)) then continue end
				if(v == self || v == self.Owner) then continue end
				local inf = self.Owner:GetActiveWeapon()
				if(inf == nil) then inf = self.Owner end
				v:TakeDamage(35, attacker, attacker)
			end
			self.DamageInterval = CurTime() + 0.1
		end
	end
	local a = self:GetAngles()
	a:RotateAroundAxis(self.BaseAngle:Up(), 30)
	self:SetAngles(a)
	self:NextThink(CurTime())
	return true
end

function ENT:PhysicsCollide(data, phys)
	phys:EnableMotion(false)
	phys:EnableCollisions(false)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	local offs = data.HitPos - self:GetPos()
	self:SetPos(self:GetPos() + offs * 0.5)
	self.Stucked = true
	self:SetAngles(self.BaseAngle)
end