ENT.Base 			= "base_ai"
ENT.Type 			= "ai"
ENT.PrintName 		= "ZShelter Mini Turret"
ENT.Author 			= "Meika"
ENT.Contact 		= ""
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "ZShelter"

ENT.Model = "models/items/ar2_grenade.mdl"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if(SERVER) then
		self:SetTrigger(true)
	end
	self:DrawShadow(false)
	self:SetCollisionGroup(2)
	self:SetCollisionBounds(Vector(-8, -8, 0), Vector(8, 8, 8))
	self:AddFlags(65536)
	if(self:GetPhysicsObject()) then
		self:GetPhysicsObject():EnableMotion(false)
	end
end

local mat = Material("zsh/icon/blueprint.png", "smooth")
local size = 32
ENT.RenderModel = nil
function ENT:Draw()
	if(!IsValid(LocalPlayer()) || !LocalPlayer():Alive()) then return end
	if(!IsValid(self.RenderModel)) then
		if(self:GetNWString("BlueprintModel", "none") != "none") then
			self.RenderModel = ClientsideModel(self:GetNWString("BlueprintModel", "none"), RENDERGROUP_TRANSLUCENT)
			self.RenderModel:SetPos(self:GetPos())
			self.RenderModel:SetModelScale(0.33, 0)
		end
	else
		self.RenderModel:SetPos(self:GetPos() + Vector(0, 0, 5))
	end
	local offs = size / 2
	cam.Start3D2D(self:GetPos(), Angle(0, 0, 0), 1)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(-offs, -offs, size, size)
	cam.End3D2D()
end

function ENT:OnRemove()
	if(IsValid(self.RenderModel)) then
		self.RenderModel:Remove()
	end
end

function ENT:StartTouch(ent)
	if(!ent:IsPlayer()) then return end
	self:Remove()

	if(SERVER) then
		SetGlobalBool("BP_"..self:GetNWString("BlueprintID", "none"), true)
		ZShelter.BlueprintHint(self:GetNWString("BlueprintID", "Undefined"))
	end
end