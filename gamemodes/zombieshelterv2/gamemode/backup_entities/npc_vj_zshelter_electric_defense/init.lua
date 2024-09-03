AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/shelter_b_electric_defense.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 180
ENT.AimTarget = nil

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

function ENT:FindEnemy()
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v)) then continue end
		self.AimTarget = v
		return
	end
end

ENT.IsCurrentlyAttacking = false
ENT.EndAttackTime = 0
ENT.NextAttackTime = 0
ENT.NextAttackInterval = 0
ENT.Delay = 0
ENT.VFXModel = nil

function ENT:RemoveVFX()
	if(IsValid(self.VFXModel)) then
		self.VFXModel:Remove()
	end
end

function ENT:CreateVFX()
	if(IsValid(self.VFXModel)) then
		self.VFXModel:Remove()
	end
	local fx = ents.Create("prop_dynamic")
		fx:SetPos(self:GetPos() + self:OBBCenter() - Vector(0, 0, 20))
		fx:SetModel("models/zshelter/shelter_b_electric_defensefx.mdl")
		fx:Spawn()
		fx:SetOwner(self)
	self.VFXModel = fx
end

ENT.LoopSound = "shigure/electrotower_fx_loop.wav"
ENT.LoopNumber = 0

function ENT:PlayVFXSequence(sequence)
	if(!IsValid(self.VFXModel)) then return end
	self.VFXModel:ResetSequence(sequence)
end

function ENT:Think()
	local sequence = self:GetSequence()
	self:SetPlaybackRate(0.5)
	if(!IsValid(self.AimTarget)) then
		if(self.NextAttackTime < CurTime() && sequence == 0) then
			self:FindEnemy()
		end
	else
		self.IsCurrentlyAttacking = true
		self.NextAttackTime = CurTime() + 5.5
		self.EndAttackTime = CurTime() + 2.25
		self:ResetSequence(1)
		self:EmitSound("shigure/electrotower_shoot_start.wav")
		self.Delay = CurTime() + 0.75
		self.AimTarget = nil
	end

	if(self.IsCurrentlyAttacking) then
		if(sequence == 1 && self.Delay < CurTime()) then
			self:ResetSequence(2)
			self:CreateVFX()
			self:PlayVFXSequence(1)
			self.LoopNumber = self:StartLoopingSound(self.LoopSound)
		end
		if(sequence == 2) then
			if(self.EndAttackTime > CurTime()) then
				if(self.NextAttackInterval < CurTime()) then
					for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
						if(!ZShelter.ValidateEntity(self, v)) then continue end
						v:SetMoveVelocity(v:GetMoveVelocity() * 0.85)
						v:TakeDamage(10, self, self)
					end
					self.NextAttackInterval = CurTime() + 0.08
				end
			else
				self:ResetSequence(1) -- Had to add this so aniamtion works correctly
				self:ResetSequence(3)
				self:StopLoopingSound(self.LoopNumber)
				self:EmitSound("shigure/electrotower_fx_end.wav")
				sound.Play("shigure/electrotower_shoot_end.wav", self:GetPos(), 100, 100, 1)
				self.Delay = CurTime() + 0.75
			end
		end
		if(sequence == 3 && self.Delay < CurTime()) then
			self:ResetSequence(0)
			self:RemoveVFX()
		end
	end


	self:NextThink(CurTime() + 0.05)
	return true
end

function ENT:OnRemove()
	self:StopLoopingSound(self.LoopNumber)
	self:RemoveVFX()
end