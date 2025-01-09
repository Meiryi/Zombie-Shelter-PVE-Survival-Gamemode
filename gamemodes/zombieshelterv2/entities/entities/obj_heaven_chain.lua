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
		ZShelter.DealNoScaleDamage(attacker, ent, 65)
	end

	local vvis = function(vec, ent)
		return util.TraceLine({
			start = ent:GetPos() + ent:OBBCenter(),
			endpos = vec,
			filter = ent,
			mask = MASK_SHOT,
			collisiongroup = COLLISION_GROUP_DEBRIS,
		}).Fraction == 1
	end

	--[[
		local effectdata = EffectData()
			effectdata:SetOrigin(startTarget:GetPos() + startTarget:OBBCenter())
			util.Effect("exp_heavenscorcher", effectdata)
	]]

	ENT.CurrentChain = 0
	ENT.MaxTargets = 8
	ENT.ChainedTargets = {}
	function ENT:ChainAttack(startTarget)
		if(self.CurrentChain >= self.MaxTargets) then return end
		self.CurrentChain = self.CurrentChain + 1

		if(startTarget != self) then
			local effectdata = EffectData()
				effectdata:SetOrigin(startTarget:GetPos() + startTarget:OBBCenter())
				util.Effect("exp_heavenscorcher", effectdata)
		end

		self:ApplyDamage(startTarget)

		local startvec = startTarget:GetPos() + startTarget:OBBCenter()
		local maxDST = 386
		local target = nil
		local dst = 0
		for _, ent in ipairs(ents.FindInSphere(startTarget:GetPos(), maxDST)) do
			if(ent == self:GetOwner() || ent:Health() <= 0 || (!ent:IsNPC() && !ent:IsPlayer() && !ent:IsNextBot()) || ent.IsBuilding) then continue end
			if(self.ChainedTargets[ent:EntIndex()]) then continue end
			if(!vvis(startvec, ent)) then continue end
			local d = ent:GetPos():Distance(startTarget:GetPos())
			if(!target || d < dst) then
				target = ent
				dst = d
			end
		end

		if(IsValid(target)) then
			self.ChainedTargets[target:EntIndex()] = true
			self:ChainAttack(target)
			self.CurrentChain = self.CurrentChain + 1
		end
	end

	function ENT:Think()
		local owner = self:GetOwner()
		if(IsValid(self.AttachTarget)) then
			self:SetPos(self.AttachTarget:GetPos())
		end
		if(!IsValid(owner)) then self:Remove() return end
		if(self.NextExplode < CurTime()) then
			self.NextExplode = CurTime() + 0.33

			self.ChainedTargets = {
				[owner:EntIndex()] = true,
				[self:EntIndex()] = true,
			}
			self.CurrentChain = 0
			self:ChainAttack(self)

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