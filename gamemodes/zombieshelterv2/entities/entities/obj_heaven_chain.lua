ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "PlasmaEXA"
ENT.Category		= "None"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false
ENT.MyModel = "models/items/ar2_grenade.mdl"

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self:SetModel("models/items/ar2_grenade.mdl")
		self.ExplodeCount = 0
		self.NextExplode = CurTime() + 0.33
		self:Think()
	end

function ENT:ApplyDamage(ent)
	local attacker = self.Attacker
	if(!IsValid(attacker)) then
		attacker = self
	end
	ent:TakeDamage(35, attacker, attacker)
end

	ENT.CurrentChain = 0
	ENT.MaxTargets = 6
	ENT.ChainedTargets = {}
	function ENT:ChainAttack(startTarget)
		if(self.CurrentChain >= self.MaxTargets || !IsValid(startTarget)) then return end
		self.CurrentChain = self.CurrentChain + 1
		print(self.CurrentChain)
		local effectdata = EffectData()
			effectdata:SetOrigin(startTarget:GetPos() + startTarget:OBBCenter())
			util.Effect("exp_heavenscorcher", effectdata)

		self:ApplyDamage(startTarget)
		for _, ent in ipairs(ents.FindInSphere(startTarget:GetPos(), 256)) do
			if((!ent:IsNPC() && !ent:IsPlayer() && !ent:IsNextBot()) || ent.IsBuilding) then continue end
			if(ent == self:GetOwner() || ent == startTarget || self.ChainedTargets[ent:EntIndex()]) then continue end
			self.ChainedTargets[ent:EntIndex()] = true
			self:ApplyDamage(ent)
			self:ChainAttack(ent)
			if(self.CurrentChain >= self.MaxTargets) then return end
			return
		end
	end

	function ENT:Think()
		local owner = self:GetOwner()
		if(!IsValid(owner)) then self:Remove() return end
		if(self.NextExplode < CurTime()) then
			self.NextExplode = CurTime() + 0.33

			self:SetPos(owner:GetPos() + owner:OBBCenter())
			self.ChainedTargets = {
				[owner:EntIndex()] = true
			}
			self.CurrentChain = 0
			self:ChainAttack(owner)

			self.ExplodeCount = self.ExplodeCount + 1
			if(self.ExplodeCount >= 4) then
				self:Remove()
			end
		end

		self:NextThink(CurTime())
		return true
	end
end


ENT.Mat = Material("sprites/spr_boomer")
ENT.Frame = 0
function ENT:Draw()
	return
end