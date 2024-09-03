ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self.KillTime = CurTime() + 13
		self.WarningDelay = CurTime() + 3
		self.NextMissileTime = 0
		self.TargetVec = Vector(0, 0, 0)
		self.NextSoundTime = 0
		self:SetNoDraw(true)
		sound.Play("shigure/airstrike.mp3", self:GetPos(), 160, 100, 1)
		sound.Play("shigure/airstrike.mp3", self:GetPos(), 160, 100, 1)
	end

	function ENT:Think()
		if(self.KillTime < CurTime()) then
			self:Remove()
			return
		end
		if(self.WarningDelay > CurTime()) then
			local ef = EffectData()
				ef:SetStart(self:GetPos())
				ef:SetOrigin(self.TargetVec)
				ef:SetFlags(1)
				util.Effect("HL1GaussBeamReflect", ef)
		else
			local owner = self:GetOwner()
			if(!IsValid(owner)) then
				owner = self
			end
			if(self.NextMissileTime < CurTime()) then
				local randPos = self.TargetVec + Vector(math.random(-512, 512), math.random(-512, 512))
				local missile = ents.Create("obj_mortar_missile")
					missile:SetOwner(owner)
					missile:SetPos(randPos + Vector(0, 0, 2048))
					missile.Target = nil
					missile.TargetPos = randPos
					missile.StartZAxis = self.TargetVec.z
					missile.ReachedHeight = true
					missile.Damage = 400
					missile:Spawn()
					missile:SetAngles(Angle(90, 0, 0))
				self.NextMissileTime = CurTime() + 0.1
			end
		end
		self:NextThink(CurTime() + 0.05)
		return true
	end
end