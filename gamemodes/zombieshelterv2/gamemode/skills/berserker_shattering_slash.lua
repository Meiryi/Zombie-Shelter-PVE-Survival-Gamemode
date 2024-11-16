local ClassName = "Berserker"

ZShelter.AddSkills(ClassName, "MultipleHook", {
	OnSkillCalled = function(player)
		player:SetNWInt("ShatteringSlashCount", player:GetNWInt("ShatteringSlashCount", 0) + 1)
	end,
	OnSkillCalled_Client = function(player)
		player:SetNWInt("ShatteringSlashCount", player:GetNWInt("ShatteringSlashCount", 0) + 1)
	end,
	OnMeleeStrike = function(player, melee2)
		local count = player:GetNWInt("ShatteringSlashCount", 0)
		if(count <= 0) then return end

		if(count >= 3) then
			player:SetNWFloat("UltimateCooldown", CurTime() + 15)
		end

		player:EmitSound("shigure/slash_fire.wav", 40)
		player:SetNWInt("ShatteringSlashCount", count - 1)

		local e = EffectData()
			e:SetOrigin(player:EyePos())
			e:SetEntity(player)
		util.Effect("zshelter_shatteringslash", e)

		if(SERVER) then
			local maxAngle = 25
			local playerPos = player:GetPos()
			local playerAngle = player:EyeAngles()

			for _, ent in ipairs(ents.FindInSphere(player:GetPos(), 512)) do
				if(!ZShelter.HurtableTarget(ent) || ent == player) then continue end
				local dst = ent:GetPos():Distance(playerPos)
				local ang = (ent:GetPos() - playerPos):Angle()
				local yaw = math.abs(math.NormalizeAngle(playerAngle.y - ang.y))
				local pitch = math.abs(math.NormalizeAngle(playerAngle.p - ang.p))
				if((yaw > maxAngle || pitch > maxAngle) && dst > 86) then continue end

				ZShelter.DealNoScaleDamage(player, ent, 1200)
			end
		end
	end,
	OnUltimateHUDPaint = function(x, y, w, h)
		local cd = math.Round(LocalPlayer():GetNWFloat("UltimateCooldown", 0) - CurTime(), 1)
		local count = LocalPlayer():GetNWInt("ShatteringSlashCount", 0)
		if(count <= 0) then return end
		local padding = ScreenScaleH(4)
		draw.DrawText(count.."/".."3", "ZShelter-HUDElemFont", x + padding, y + padding, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	end,
	OnSkillPreCall = function()
		return LocalPlayer():GetNWInt("ShatteringSlashCount", 0) < 3
	end,
	},
	function(player, current)
	end, 1, "slash", 4, "Blazing Slash", nil, 15)

if(CLIENT) then
	local slashmat = CreateMaterial("slashmaterial_9", "VertexLitGeneric", {
		["$basetexture"] = "models/effects/splode_sheet",
		["$additive"] = 1,
		["$envmap"] = "models/effects/cube_white",
		["$envmaptint"] = "[1 1 1]",
		["$envmapfresnel"] = 1,
		["$envmapfresnelminmaxexp"] = "[1 1 2]",
		["$alpha"] = 0.33,
	    ["$model"] = 1,
	    ["$additive"] = 1,
	    ["$nocull"] = 1,

	    ["$emissiveBlendEnabled"] = 1,
		["$emissiveBlendTexture"] = "models/OvR_Load/energy_mist2",
		["$emissiveBlendBaseTexture"] = "models/OvR_Load/energy_mist",
		["$emissiveBlendFlowTexture"] =	"models/OvR_Load/force_shield_flow",
		["$emissiveBlendTint"] = "[255 55 55]",
		["$emissiveBlendStrength"] = 0.25,
		["$emissiveBlendScrollVector"] = "[0.4 0.25]",

	    Proxies = {
	        TextureScroll = {
	            texturescrollvar = "$basetexturetransform",
	            texturescrollrate = 1,
	            texturescrollangle = 90,
	        }
	    }
	})
	local draw = false

	local clr1 = Color(0, 0, 0, 255)
	local clr2 = Color(255, 255, 255, 255)
	hook.Add("PostDrawViewModel", "ZShelter_ShatteringSlashVFX", function(vm, ply, wpn)
		if(draw || LocalPlayer():GetNWInt("ShatteringSlashCount") <= 0 || !ZShelter.IsHoldingMelee(LocalPlayer())) then
			return
		end
		render.SuppressEngineLighting(true)
		render.MaterialOverride(slashmat)

		draw = true
		vm:DrawModel()
		draw = false

		render.MaterialOverride()
		render.SuppressEngineLighting(false)
	end)
end