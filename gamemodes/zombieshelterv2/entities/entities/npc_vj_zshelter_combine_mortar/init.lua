AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/props_combine/combine_mortar01a.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 4096
ENT.AimTarget = nil

ENT.NextManualFireTime = 0
ENT.ManualFireRate = 3
ENT.NextFireTime = 0

function ENT:RunAI() -- Disable VJ Base's AI
	return
end

function ENT:ManualControlling()
	return IsValid(self.CurrentController)
end

function ENT:RunControllerCode()
	if(IsValid(self.CurrentController)) then
		if(!self.CurrentController:Alive()) then
			ZShelter.UnSetControllingMortar(self.CurrentController, self)
			return
		end
		--self.CurrentController:SetPos(self:GetPos())
	end
end

function ENT:FindEnemy()
	local hp = 0
	local td = 0
	local highhp = false
	for k,v in pairs(ents.FindInSphere(self:GetPos(), self.MaximumDistance)) do
		if(!ZShelter.ValidateEntity(self, v) || (v.IsBoss && !v.Awake)) then continue end
		local h = v:Health()
		if(h >= 2000) then
			if(!highhp) then
				hp = h
				self.AimTarget = v
				highhp = true
			end
			if(hp == 0) then
				hp = h
				self.AimTarget = v
			else
				if(h > hp) then
					hp = h
					self.AimTarget = v
				end
			end
		else -- So they will attack multiple target if there's currently no tanky enemy
			if(highhp) then continue end
			if(!v.LastTargetedTime) then
				v.LastTargetedTime = math.random(0, 65536)
			end
			if(hp == 0) then
				hp = v.LastTargetedTime
				self.AimTarget = v
			else
				if(v.LastTargetedTime > hp) then
					hp = v.LastTargetedTime
					self.AimTarget = v
				end
			end
		end
	end
end

function ENT:ShootManual(ply, vec)
	self.NextFireTime = CurTime() + 4.5
	if(self.NextManualFireTime > CurTime()) then return end
	sound.Play("weapons/mortar/mortar_fire1.wav", self:GetPos(), 120, 100, 1)
	local e = EffectData()
		e:SetOrigin(self:GetPos() + self:GetUp() * 100 + self:GetForward() * 15 + self:GetRight() * 7)
	util.Effect("zshelter_mortar_prefire", e)
		e:SetOrigin(vec)
	util.Effect("zshelter_mortar_prefire", e)
	util.Effect("zshelter_mortar_impact", e)
	timer.Simple(0.5, function()
		sound.Play("weapons/mortar/mortar_shell_incomming1.wav", vec, 140, 100, 1)
	end)
	timer.Simple(1.5, function()
		sound.Play("weapons/mortar/mortar_explode"..math.random(1, 3)..".wav", vec, 100, 100, 1)
		local e = EffectData()
		e:SetOrigin(vec + Vector(0, 0, 1))
		e:SetNormal(Vector(0, 0, 1))
		e:SetRadius(100)
		util.Effect("AR2Explosion", e)
		for k,v in ipairs(ents.FindInSphere(vec, 86)) do
			if(!ZShelter.ValidateTarget(v)) then continue end
			ZShelter.DealNoScaleDamage(ply, v, self.AttackDamage)
		end
	end)
	self.NextManualFireTime = CurTime() + self.ManualFireRate
	return true
end

function ENT:Think()
	if(!self:ManualControlling()) then
		if(!IsValid(self.AimTarget)) then
			self:FindEnemy()
		else
			if(self.NextFireTime < CurTime()) then
				sound.Play("weapons/mortar/mortar_fire1.wav", self:GetPos(), 120, 100, 1)
				local target = self.AimTarget
				target.LastTargetedTime = CurTime()
				local e = EffectData()
					e:SetOrigin(self:GetPos() + self:GetUp() * 100 + self:GetForward() * 15 + self:GetRight() * 7)
				util.Effect("zshelter_mortar_prefire", e)
					e:SetOrigin(target:GetPos())
				util.Effect("zshelter_mortar_prefire", e)
				util.Effect("zshelter_mortar_impact", e)
				timer.Simple(0.5, function()
					if(!IsValid(target)) then return end
					sound.Play("weapons/mortar/mortar_shell_incomming1.wav", target:GetPos(), 140, 100, 1)
				end)
				local pos = target:GetPos()
				timer.Simple(1.5, function()
					sound.Play("weapons/mortar/mortar_explode"..math.random(1, 3)..".wav", pos, 100, 100, 1)
					local e = EffectData()
					e:SetOrigin(pos + Vector(0, 0, 1))
					e:SetNormal(Vector(0, 0, 1))
					e:SetRadius(100)
					util.Effect("AR2Explosion", e)
					if(IsValid(target)) then
						pos = target:GetPos()
						local e = EffectData()
						e:SetOrigin(pos + Vector(0, 0, 1))
						e:SetNormal(Vector(0, 0, 1))
						e:SetRadius(100)
						util.Effect("AR2Explosion", e)
						target:TakeDamage(400, self, self)
					end
				end)
				self.NextFireTime = CurTime() + 4.5
			end
		end
	else
		self:RunControllerCode()
		self:NextThink(CurTime())
		return true
	end
	self:NextThink(CurTime() + 0.5)
	return true
end

function ENT:OnRemove()
	if(IsValid(self.CurrentController)) then
		ZShelter.UnSetControllingMortar(self.CurrentController, self)
	end
end