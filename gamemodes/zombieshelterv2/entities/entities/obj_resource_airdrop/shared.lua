ENT.Base 			= "base_gmodentity"
ENT.Type 			= "ai"
ENT.PrintName 		= "ZShelter Mini Turret"
ENT.Author 			= "Meika"
ENT.Contact 		= ""
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "ZShelter"

ENT.EndDrawTime = 0

if(CLIENT) then
	local woodmat = Material("zsh/icon/woods_white.png", "smooth")
	local ironmat = Material("zsh/icon/irons_white.png", "smooth")
	local powermat = Material("zsh/icon/powers_white.png", "smooth")
	function ENT:Draw()
		self:DrawModel()
		local angle = LocalPlayer():EyeAngles() + Angle(0, -90, 90)
		angle.x = 0
		local ent = LocalPlayer():GetEyeTrace().Entity
		if(ent != self) then return end
		local amount = math.min(math.max(math.floor(GetGlobalInt("Capacity", 32) * 0.4), 20), 86)
		local powers = (GetGlobalInt("ShelterLevel") + 1) * 30
		cam.IgnoreZ(true)
			cam.Start3D2D(self:GetPos() + Vector(-20, 20, 48), angle, 0.33)
				draw.SimpleText("[E]", "TargetID", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(woodmat)
				draw.SimpleText(amount, "TargetID", -48, 64, Color(255, 255, 255), TEXT_ALIGN_CENTER)
				surface.DrawTexturedRect(-64, 32, 32, 32)
				surface.SetMaterial(ironmat)
				draw.SimpleText(amount, "TargetID", 0, 64, Color(255, 255, 255), TEXT_ALIGN_CENTER)
				surface.DrawTexturedRect(-16, 32, 32, 32)
				surface.SetMaterial(powermat)
				draw.SimpleText(powers, "TargetID", 48, 64, Color(255, 255, 255), TEXT_ALIGN_CENTER)
				surface.DrawTexturedRect(32, 32, 32, 32)
			cam.End3D2D()
		cam.IgnoreZ(false)
	end

	local mat = Material("zsh/icon/supply.png", "smooth")
	hook.Add("HUDPaint", "ZShelter-SupplyCrate", function()
		for k,v in ipairs(ents.FindByClass("obj_resource_airdrop")) do
			if(v.EndDrawTime == 0) then
				v.EndDrawTime = CurTime() + 2.5
			end
			local f = math.Clamp((v.EndDrawTime - CurTime()) * 255, 0, 255)
			surface.SetDrawColor(255, 255, 255, f)
			surface.SetMaterial(mat)
			local pos = (v:GetPos() + v:OBBCenter()):ToScreen()
			surface.DrawTexturedRect(pos.x - 24, pos.y - 24, 48, 48)
		end
	end)
else

	function ENT:GetRandomWeapon()
		local wep = ZShelter.ItemConfig[math.random(1, #ZShelter.ItemConfig)]
		return wep
	end

	function ENT:Use(ent)
		if(!IsValid(ent) || !ent:IsPlayer()) then return end
		sound.Play("shigure/pickup.wav", ent:GetPos())
		local max = GetGlobalInt("Capacity", 32)
		local amount = math.min(math.max(math.floor(GetGlobalInt("Capacity", 32) * 0.4), 20), 86)
		local powers = 30 + ((GetGlobalInt("ShelterLevel") + 1) * 10)
		SetGlobalInt("Woods", math.min(GetGlobalInt("Woods") + amount, max))
		SetGlobalInt("Irons", math.min(GetGlobalInt("Irons") + amount, max))
		SetGlobalInt("Powers", GetGlobalInt("Powers") + powers)
		local wep = self:GetRandomWeapon()
		if(!ent:HasWeapon(wep.class)) then
			local wepent = ents.Create(wep.class)
				wepent:Spawn()
				wepent.DamageScaling = wep.dmgscale
				wepent.CanGetAmmoSupply = wep.ammo_supply
				wepent.VolumeMultiplier = wep.volume || 1
				wepent.AmmoCapacity = wep.ammo_capacity || -1
				wepent.AmmoRegenSpeed = wep.ammoregen || -1
				ent:PickupWeapon(wepent)
				ent:GiveAmmo(wepent:GetMaxClip1(), wepent:GetPrimaryAmmoType(), true)
		end
		sound.Play("shigure/gunpickup2.wav", ent:GetPos())
		self:Remove()
		local blueprints = {}
		for k,v in pairs(ZShelter.IngredientConfig) do
			if(GetGlobalBool("BP_"..v.id, false)) then continue end
			table.insert(blueprints, v)
		end
		if(#blueprints <= 0) then return end
		local selected = blueprints[math.random(1, #blueprints)]
		ZShelter.BlueprintHint(selected.id)
		SetGlobalBool("BP_"..selected.id, true)
	end
end