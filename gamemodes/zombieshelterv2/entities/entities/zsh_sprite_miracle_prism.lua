AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Category		= ""
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.StartTime = 0

ENT.Start = Material("sprites/ef_mgknife_start")
ENT.Loop = Material("sprites/ef_mgknife_loop")
ENT.End = Material("sprites/ef_mgknife_end")
ENT.Explode = Material("sprites/ef_mgknife_exp")
ENT.CurrentMaterial = ENT.Start
ENT.LastMaterial = nil
ENT.Size = 1
ENT.Frame = 1
ENT.FPS = 30

if(SERVER) then
	function ENT:Initialize()
		self:SetModel("models/items/ar2_grenade.mdl")
		self:SetMaterial("sprites/ef_mgknife_start")
		self.KillTime = CurTime() + 2
	end

	ENT.StopUpdate = false

	function ENT:End()
		self:SetMaterial("sprites/ef_mgknife_end")
		self.StopUpdate = true
		self.KillTime = CurTime() + 2
		self.KillAnim = true
	end

	function ENT:Slash()
		if(!IsValid(self:GetOwner()) || self.KillAnim) then
			return
		else
			local dmginfo = DamageInfo()
				dmginfo:SetAttacker(self.Creator)
				dmginfo:SetInflictor(self._Inflictor)
				dmginfo:SetDamage(self.Damage)
				dmginfo:SetDamagePosition(self:GetOwner():GetPos() + self:GetOwner():OBBCenter())
				dmginfo:SetDamageType(DMG_SLASH)

				self:GetOwner():TakeDamageInfo(dmginfo)

			self.StopUpdate = true
			self.KillTime = CurTime() + 2
			self.KillAnim = true
			self:SetMaterial("sprites/ef_mgknife_exp")
			sound.Play("weapons/tfa_cso/magicknife/magic_hit.wav", self:GetOwner():GetPos(), 100, 100, 1)
		end
	end

	ENT.KillAnim = false
	function ENT:Think()
		local owner = self:GetOwner()
		if(self.KillTime < CurTime()) then
			if(!self.KillAnim) then
				self.KillAnim = true
				self.StopUpdate = true
				self.KillTime = CurTime() + 2
				self:SetMaterial("sprites/ef_mgknife_end")
				return
			end
			self:Remove()
		end
		if(IsValid(owner) && !self.StopUpdate) then
			self:SetPos(owner:GetPos() + owner:OBBCenter())
			local t = CurTime() - self.StartTime
			if(t < 1.15) then
				self:SetMaterial("sprites/ef_mgknife_start")
			else
				if(t < 2) then
					self:SetMaterial("sprites/ef_mgknife_loop")
				end
			end
		end

		self:NextThink(CurTime())
		return true
	end
end

ENT.StringToMaterial = {
	["sprites/ef_mgknife_start"] = ENT.Start,
	["sprites/ef_mgknife_loop"] = ENT.Loop,
	["sprites/ef_mgknife_end"] = ENT.End,
	["sprites/ef_mgknife_exp"] = ENT.Explode
}

ENT.AnimationLoop = {
	["sprites/ef_mgknife_start"] = false,
	["sprites/ef_mgknife_loop"] = true,
	["sprites/ef_mgknife_end"] = false,
	["sprites/ef_mgknife_exp"] = false
}

ENT.MaxFrame = {
	["sprites/ef_mgknife_start"] = 45,
	["sprites/ef_mgknife_loop"] = -1,
	["sprites/ef_mgknife_end"] = 40,
	["sprites/ef_mgknife_exp"] = 68
}

function ENT:GetStringMaterial()
	return self.StringToMaterial[self:GetMaterial()] || self.Start
end

ENT.LastDrawPos = Vector(0, 0, 0)
function ENT:Draw()
	local owner = self:GetOwner()
	if(IsValid(owner)) then
		self.LastDrawPos = owner:GetPos() + owner:OBBCenter()
	end
	local size = 100
	local material = self:GetStringMaterial()
	local loop = self.AnimationLoop[self:GetMaterial()]
	local maxframe_override = self.MaxFrame[self:GetMaterial()] || -1
	local tex = material:GetTexture("$basetexture")
	local maxframe = tex:GetNumAnimationFrames()

	if(material != self.LastMaterial) then
		self.Frame = 1
	else
		local maxf = maxframe
		if(maxframe_override != -1) then
			maxf = maxframe_override
		end
		self.Frame = math.Clamp(self.Frame + (RealFrameTime() * self.FPS), 1, maxf)
		if(loop && self.Frame >= maxf) then
			self.Frame = 1
		end
	end

	self.LastMaterial = material

	render.SetMaterial(material)
	material:SetInt("$frame", math.floor(self.Frame))
	render.DrawSprite(self.LastDrawPos, size, size, Color(255, 255, 255, 255))
end