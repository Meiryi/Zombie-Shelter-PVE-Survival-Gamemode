local ClassName = "Berserker"

ZShelter.AddSkills(ClassName, "MultipleHook", {
	OnSkillCalled = function(player)
		player:SetNWInt("ShatteringSlashCount", player:GetNWInt("ShatteringSlashCount", 0) + 1)
	end,
	OnSkillCalled_Client = function(player)
		player:SetNWFloat("UltimateCooldown", CurTime() + 7)
		player:SetNWInt("ShatteringSlashCount", player:GetNWInt("ShatteringSlashCount", 0) + 1)
	end,
	OnMeleeStrike = function(player, melee2)
		local count = player:GetNWInt("ShatteringSlashCount", 0)
		if((!player:KeyDown(IN_ATTACK) && melee2) || (!player:KeyDown(IN_ATTACK2) && !melee2)) then return end
		if(count <= 0) then return end
		if(count >= 3) then
			player:SetNWFloat("UltimateCooldown", CurTime() + 7)
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
	OnMeleeDamage = function(attacker, victim, dmginfo, melee2)
		local count = attacker:GetNWInt("ShatteringSlashCount", 0)
		if(count <= 0) then return end
		if(!victim:IsNPC() && !victim:IsNextBot() && !victim:IsPlayer()) then return end
		if(victim.IsBoss) then return end
		if(SERVER) then
			local dmgBoost = 0.15 * count
			victim:TakeDamage(dmginfo:GetDamage() * dmgBoost, attacker, attacker)
			if(count > 1) then
				ZShelter.Ignite(victim, attacker, 3, 8)
			end
		end
	end,
	OnMeleeImpact = function(attacker, trace, melee2)
		local count = attacker:GetNWInt("ShatteringSlashCount", 0)
		if(count <= 0) then return end
		local pos = trace.HitPos
		local e = EffectData()
			e:SetOrigin(pos)
		util.Effect("zshelter_shatteringslash_impact", e)
	end,
	OnUltimateHUDPaint = function(x, y, w, h)
		local cd = LocalPlayer():GetNWFloat("UltimateCooldown", 0) - CurTime()
		local count = LocalPlayer():GetNWInt("ShatteringSlashCount", 0)
		if(cd <= 0) then
			local skill = ZShelter.SkillDatas[LocalPlayer():GetNWString("Tier4Skill", "")]
			if(skill && LocalPlayer():GetNWInt("ShatteringSlashCount", 0) < 3) then
				ZShelter.UltimateSkill(skill)
			end
		end
		if(count >= 3) then -- quick fix because im lazy
			LocalPlayer():SetNWFloat("UltimateCooldown", 0)
		end
		
		if(count <= 0) then return end
		local padding = ScreenScaleH(4)
		draw.DrawText(count.."/".."3", "ZShelter-HUDElemFont", x + padding, y + padding, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	end,
	OnSkillPreCall = function()
		return false
	end,
	OnSkillRequestReceived = function(player)
		return true
	end,
	},
	function(player, current)
	end, 1, "slash", 4, "Blazing Slash", nil, 8)

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

	local blend = 0
	local flash_blend = 1
	local flash_material = Material("models/debug/debugwhite")

	hook.Add("PostDrawViewModel", "ZShelter_ShatteringSlashVFX", function(vm, ply, wpn)
		local count = LocalPlayer():GetNWInt("ShatteringSlashCount")

		if(draw || count <= 0 || !ZShelter.IsHoldingMelee(LocalPlayer())) then
			if(count <= 0) then
				flash_blend = 1
			end
			return
		end

		render.SuppressEngineLighting(true)
		render.MaterialOverride(slashmat)

		draw = true
		vm:DrawModel(3)
		draw = false

		render.MaterialOverride()
		render.SuppressEngineLighting(false)
		render.SetBlend(1)
	end)

	hook.Add("PostDrawOpaqueRenderables", "ZShelter_ShatteringSlashVFX", function()

		render.SuppressEngineLighting(true)
		render.MaterialOverride(slashmat)

		for _, ent in ipairs(ents.GetAll()) do
			if(!ent:IsWeapon()) then continue end
			local owner = ent:GetOwner()
			if(!IsValid(owner)) then continue end
			if(ent != owner:GetActiveWeapon() || owner:GetNWInt("ShatteringSlashCount") <= 0 || !ZShelter.IsHoldingMelee(owner)) then continue end
			ent:DrawModel()
		end

		render.MaterialOverride()
		render.SuppressEngineLighting(false)

	end)
end