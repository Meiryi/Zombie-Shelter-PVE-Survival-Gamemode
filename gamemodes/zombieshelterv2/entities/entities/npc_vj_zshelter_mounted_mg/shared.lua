ENT.Base 			= "base_ai"
ENT.Type 			= "ai"
ENT.PrintName 		= "ZShelter Mini Turret"
ENT.Author 			= "Meika"
ENT.Contact 		= ""
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "ZShelter"

ENT.Controller = nil
ENT.UserKeyDown = false

function ENT:RemoveOwnerWeapon()
	if(!IsValid(self.Controller)) then return end
	for k,v in pairs(self.Controller:GetWeapons()) do
		if(v:GetClass() == "tfa_zsh_cso_mounted_machine_gun") then
			self.Controller:DropWeapon(v)
			v:Remove()
			return
		end
	end
end

function ENT:SelectLastWeapon()
	if(!IsValid(self.Controller)) then return end
	if(!IsValid(self.Controller.LastActiveWeapon)) then return end
	local player = self.Controller
	timer.Simple(0, function()
		player:SetActiveWeapon(player.LastActiveWeapon)
	end)
end

function ENT:Unmount()
	self.Controller = user
	self.UserKeyDown = false
end

ENT.UnmountDistance = 64
ENT.StartCheckTime = 0
ENT.NextMountTime = 0

ENT.Ammos = 250
ENT.AmmoRegenTimer = 0
ENT.AmmoRegenDelay = 0

function ENT:Think()
	if(CLIENT) then
		if(IsValid(LocalPlayer())) then
			if(self:GetNWEntity("Controller", nil) == LocalPlayer()) then
				self:SetNoDraw(true)
			else
				self:SetNoDraw(false)
			end
		end
		self:SetNextClientThink(CurTime() + 0.1)
		return true
	end
	if(SERVER) then
		self:SetNWEntity("Controller", self.Controller || self)
	end
	if(self.Ammos < 250 && self.AmmoRegenTimer < CurTime() && self.AmmoRegenDelay < CurTime()) then
		self.Ammos = math.Clamp(self.Ammos + 1, 0, 250)
		if(IsValid(self.Controller)) then
			local wep = self.Controller:GetActiveWeapon()
			if(IsValid(wep) && wep:GetClass() == "tfa_zsh_cso_mounted_machine_gun") then
				wep:SetClip1(self.Ammos)
			end
		end
		self.AmmoRegenTimer = CurTime() + (0.33 - (self:GetNWInt("UpgradeCount", 0) * 0.075))
	end
	if(IsValid(self.Controller)) then
		self.Controller:SetPos(self:GetPos())
		if(self.Controller:KeyDown(32)) then
			if(!self.UserKeyDown) then
				self:SelectLastWeapon()
				self:RemoveOwnerWeapon()
				self:Unmount()
				self.NextMountTime = CurTime() + 1
				return
			end
		end

		if(self.Controller:GetPos():Distance(self:GetPos()) > self.UnmountDistance) then
			self:SelectLastWeapon()
			self:RemoveOwnerWeapon()
			self:Unmount()
			self.NextMountTime = CurTime() + 1
			return
		end
		local wep = self.Controller:GetActiveWeapon()
		if(self.StartCheckTime < CurTime()) then
			if(IsValid(wep)) then
				if(wep:GetClass() != "tfa_zsh_cso_mounted_machine_gun") then
					self:SelectLastWeapon()
					self:RemoveOwnerWeapon()
					self:Unmount()
					self.NextMountTime = CurTime() + 1
					return
				else
					if(SERVER) then
						wep.DamageScaling = self.AttackScaling || 1
					end
					local ammo = wep:Clip1()
					if(ammo < self.Ammos) then
						self.AmmoRegenDelay = CurTime() + 2
					end
					self.Ammos = ammo
				end
			else
				self:SelectLastWeapon()
				self:RemoveOwnerWeapon()
				self:Unmount()
				self.NextMountTime = CurTime() + 1
				return
			end
		end

		self.UserKeyDown = self.Controller:KeyDown(32)
		if(!self.Controller:Alive()) then
			self:Unmount()
		end
	end

	self:NextThink(CurTime() + 0.05)
	return true
end

function ENT:Use(user)
	if(!user:IsPlayer() || !user:Alive() || self.NextMountTime > CurTime() || !self:GetNWBool("Completed")) then return end
	if(IsValid(self.Controller)) then return end
	self.Controller = user
	self.UserKeyDown = true
	self.StartCheckTime = CurTime() + 0.33
	user.LastActiveWeapon = user:GetActiveWeapon()
	user:SetActiveWeapon(nil)
	timer.Simple(0.0, function()
		local wep = ents.Create("tfa_zsh_cso_mounted_machine_gun")
			user:PickupWeapon(wep)
			wep:SetClip1(self.Ammos)
	end)
end

function ENT:OnRemove()
	self:SelectLastWeapon()
	self:RemoveOwnerWeapon()
	self:Unmount()
end