if (SERVER) then
	AddCSLuaFile("cl_init.lua")
	AddCSLuaFile("shared.lua")
end

include("shared.lua")

ENT.Set = false
ENT.SetVec = Vector(0, 0, 0)
ENT.LightSprite = nil
ENT.LightSprite2 = nil
ENT.EXPSprite = nil
ENT.pOwner = nil -- Since owner cannot collide with it's now entity, I had to do it in this way
ENT.Damage = 1000

function ENT:Initialize()
	self:SetModel("models/weapons/tfa_cso/w_heaven_bomb.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetAngles(Angle(0, 0, 0))
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(0)
	self:PhysicsInitBox(Vector(-5, -4, -4), Vector(7, 4, 4), "default")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	local phys = self:GetPhysicsObject()
	self:ResetSequenceInfo()
	self:SetSequence("idle_off")
	if(IsValid(phys)) then
		phys:Wake()
		self:PhysWake()
	end
end

function ENT:Think()
	if(!self.Set) then
		local tr = {
			start = self:GetPos(),
			endpos = self:GetPos() - Vector(0, 0, 12),
			filter = self, self.pOwner,
		}
		local tr_ = util.TraceLine(tr)
		if(tr_.HitWorld) then
			sound.Play("weapons/tfa_cso/heaven_scorcher/mine_set.wav", self:GetPos() + Vector(0, 0, 5), 100, 100, 1)
			self.Set = true
			self:SetAngles(Angle(0, 0, 0))
			self:GetPhysicsObject():EnableMotion(false)
			self:SetPos(tr_.HitPos)
			self.LightSprite = ents.Create("env_sprite_oriented")
			self.LightSprite:SetKeyValue("model","materials/sprites/heavenscorcher_mine_set.vmt")
			self.LightSprite:SetKeyValue("scale", "0.2")
			self.LightSprite:SetPos(self:GetPos() + Vector(0, 0, 6))
			self.LightSprite:Spawn()
			self:SetOwner(nil)
			self:SetSequence("set")
			timer.Simple(0.15, function() self:SetSequence("idle_on") end)
		end
	else
		self:SetVelocity(Vector(0, 0, 0))
		self:SetAngles(Angle(0, 0, 0))
	end
	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos() + self:OBBCenter())
		util.Effect("exp_heavenscorcher", effectdata)
	sound.Play("weapons/tfa_cso/heaven_scorcher/mine_exp.wav", self:GetPos() + Vector(0, 0, 5), 100, 100, 1)
	local owner = self.pOwner
	if(IsValid(owner)) then
		for k,v in pairs(ents.FindInSphere(self:GetPos() + Vector(0,0,1), 150)) do
			if(!IsValid(v)) then continue end
			if(owner == v) then
				local vel = owner:GetVelocity() -- *-1 on vel.z, so owner can do some cool movement
				owner:SetVelocity(Vector(vel.x, vel.y, vel.z * -1) + Angle(-80, owner:EyeAngles().y, 0):Forward() * 300)
				continue
			end
			local d = DamageInfo()
				d:SetDamage(self.Damage)
				d:SetDamageType(64)
				d:SetDamagePosition(v:GetPos())
				d:SetAttacker(owner)
				d:SetInflictor(owner)
			v:TakeDamageInfo(d)
		end
	else
		util.BlastDamage(self, self, self:GetPos() + Vector(0, 0, 5), 150, 500)
	end
	if(IsValid(self.LightSprite)) then
		self.LightSprite:Remove()
	end
	if(IsValid(self.LightSprite2)) then
		self.LightSprite2:Remove()
	end
end

function ENT:Touch( entity )
	if(!IsValid(entity)) then return end
	if(!entity:IsNPC() && !entity:IsPlayer()) then return end
	self:Remove()
end