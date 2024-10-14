ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "PlasmaEXA"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.MyModel = "models/items/ar2_grenade.mdl"
ENT.MyModelScale = 0
ENT.Damage = 130
ENT.Radius = 128

if SERVER then
	AddCSLuaFile()
	function ENT:Initialize()
		self:AddEFlags(EFL_IN_SKYBOX)
	end

	function ENT:Think()
		local ply = self:GetOwner()
		if(!IsValid(ply) || !ply:Alive()) then
			self:Remove()
			return
		end
		self:SetPos(ply:GetPos())
		self:NextThink(CurTime())
		return true
	end
else
	ENT.Mat1 = Material("models/ovr_load/force_shield_phase_2")
	ENT.Mat2 = Material("models/ovr_load/force_shield_phase_3")
	ENT.Mat3 = Material("models/ovr_load/force_shield_phase_4")
	ENT.Flash = 255
	ENT.PlayerOwner = nil
	local sx = 128
	local bounds = Vector(sx, sx, sx)
	function ENT:Think()
	end
	function ENT:Draw()
		local ply = self:GetOwner()
		if(!self.PlayerOwner) then
			if(IsValid(ply)) then
				self.PlayerOwner = ply
			end
		end
		if(!IsValid(self.PlayerOwner) || self.PlayerOwner == LocalPlayer()) then return end
		local state = self.PlayerOwner:GetNWInt("ZShelter_ShieldState", 0)
		if(self.State != state) then
			self.State = state
			self.Flash = 200
		end
		local size = self.PlayerOwner:OBBMaxs().z * 0.5
		render.SetMaterial(self.Mat1)
		if(self.State == 1) then
			render.SetMaterial(self.Mat1)
		elseif(self.State == 2) then
			render.SetMaterial(self.Mat2)
		else
			render.SetMaterial(self.Mat3)
		end
		render.DrawSphere(self.PlayerOwner:GetPos() + Vector(0, 0, size), size, 12, 12, Color(255, 255, 255, 255))

		if(self.Flash > 0) then
			render.SetColorMaterial()
			render.DrawSphere(ply:GetPos() + Vector(0, 0, size), size, 12, 12, Color(150, 150, 150, self.Flash))
			self.Flash = math.Clamp(self.Flash - ZShelter.GetFixedValue(10), 0, 255)
		end
	end
end