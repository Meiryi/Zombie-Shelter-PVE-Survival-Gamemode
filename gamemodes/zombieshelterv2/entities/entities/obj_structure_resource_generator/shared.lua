ENT.Base 			= "base_ai"
ENT.Type 			= "anim"
ENT.PrintName 		= "ZShelter Mini Turret"
ENT.Author 			= "Meika"
ENT.Contact 		= ""
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "ZShelter"

local wide = 140
local offsx = wide * 0.5
local offsy = 2
local baroffs = 15
local barwide = 110
local bartall = 10
ENT.OFFSET = Vector(0, 0, 0)
local woodmat = Material("zsh/icon/woods_white.png", "smooth")
local ironmat = Material("zsh/icon/irons_white.png", "smooth")
function ENT:Draw()
	self:DrawModel()
	if(!self:GetNWBool("Completed", false)) then return end

	if(self.OFFSET == Vector(0, 0, 0)) then
		self.OFFSET = self:GetRight() * -7 + self:GetUp() * 24 + self:GetForward() * 28
	end

	local ply = LocalPlayer()
	local time = math.max(math.floor(self:GetNWInt("NextProvideTime", 0) - CurTime()), 0)
	local fra = 1 - math.Clamp((time / 30), 0, 1)
	local prov = "x"..self:GetNWInt("ProvideAmount", 4)
	surface.SetDrawColor(48, 56, 65, 255)
	cam.Start3D2D(self:GetPos() + self.OFFSET, self:GetAngles() - Angle(0, 180, -35), 0.15)
		surface.DrawRect(0, 0, wide, 80)
		surface.SetDrawColor(20, 20, 20, 255)
		surface.DrawOutlinedRect(baroffs, 50, barwide, bartall, 1)
		surface.SetDrawColor(50, 255, 50, 255)
		surface.DrawRect(baroffs + 1, 50 + 1, (barwide - 2) * fra, bartall - 2)
		draw.DrawText(time, "TargetID", offsx, offsy, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(woodmat)
		surface.DrawTexturedRect(30, 25, 16, 16)
		draw.DrawText(prov, "DefaultSmall", 46, 25, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		surface.SetMaterial(ironmat)
		surface.DrawTexturedRect(80, 25, 16, 16)
		draw.DrawText(prov, "DefaultSmall", 96, 25, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	cam.End3D2D()
end