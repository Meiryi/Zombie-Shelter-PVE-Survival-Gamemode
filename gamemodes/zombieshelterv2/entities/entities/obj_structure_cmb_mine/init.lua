AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/props_combine/combine_mine01.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 86
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

function ENT:FindEnemy()
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		self.AimTarget = v
		return
	end
end

ENT.AimTarget = nil

function ENT:Think()
	self:FindEnemy()
	if(IsValid(self.AimTarget)) then
		local pos = self:GetPos()
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetMagnitude(12)
			effectdata:SetScale(2)
			effectdata:SetRadius(5)
			util.Effect("Sparks", effectdata)
		sound.Play("ambient/explosions/explode_8.wav", pos, 120, 100, 1)
		for i = 1, 12 do
			timer.Simple((i - 1) * 0.4, function()
				local e = EffectData()
				e:SetOrigin(pos)
				util.Effect("zshelter_cyro_field", e)
				for i = 1, 15 do
					local e = EffectData()
					e:SetOrigin(pos + Vector(math.random(-186, 186), math.random(-186, 186), math.random(10, 25)))
					util.Effect("zshelter_emp", e, true, true)
				end
				for k,v in ipairs(ents.FindInSphere(pos, 186)) do
					if(!ZShelter.ValidTarget(nil, v)) then continue end
					v:SetMoveVelocity(v:GetMoveVelocity() * 0.2)
					v:SetNWFloat("DefenseNerfTime", CurTime() + 8)
					v.LastFreezeTime = 0
					v.FreezeCount = 10
					ZShelter.Freeze(v)
					if(!v.LastApplyEffectTime || v.LastApplyEffectTime < CurTime()) then
						local e = EffectData()
							e:SetOrigin(v:GetPos())
							e:SetEntity(v)
						util.Effect("zshelter_defnerf", e)
						v.LastApplyEffectTime = CurTime() + 3
					end
				end
			end)
		end
		if(ZShelter.ShouldDetonate(self:GetOwner(), self)) then
			self:Remove()
		else
			self.AimTarget = nil
			self:NextThink(CurTime() + 10)
			return true
		end
	end
	self:NextThink(CurTime() + 0.3)
	return true
end