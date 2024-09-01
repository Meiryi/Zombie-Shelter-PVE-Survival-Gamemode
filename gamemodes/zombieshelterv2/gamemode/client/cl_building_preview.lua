--[[
	EN :
	Zombie Shelter v2.0 by Meiryi / Meika / Shiro / Shigure
	You SHOULD NOT edit / modify / reupload the codes, it includes editing gamemode's name
	If you have any problems, feel free to contact me on steam, thank you for reading this

	ZH-TW :
	夜襲生存戰 v2.0 by Meiryi  / Meika / Shiro / Shigure
	任何的修改是不被允許的 (包括模式的名稱)，有問題請在Steam上聯絡我, 謝謝!
	
	ZH-CN :
	昼夜求生 v2.0 by Meiryi  / Meika / Shiro / Shigure
	任何形式的编辑是不被允许的 (包括模式的名称), 若有问题请在Steam上联络我
]]

ZShelter.Building = false
ZShelter.PreviewEntity = ZShelter.PreviewEntity || nil

net.Receive("ZShelter_SyncBuildingHP", function()
	local index = net.ReadInt(32)
	local hp = net.ReadInt(32)
	local ent = Entity(index)
	if(!IsValid(ent)) then return end
	ent:SetHealth(hp)
end)

function ZShelter:CreatePreview(model, offset, cat, index, tdata)
	if(IsValid(ZShelter.PreviewEntity)) then
		ZShelter.PreviewEntity:Remove()
	end
	ZShelter.PreviewEntity = ClientsideModel(model, RENDERGROUP_TRANSLUCENT)
	ZShelter.PreviewEntity:SetRenderMode(RENDERMODE_TRANSCOLOR)
	ZShelter.PreviewEntity:SetColor(Color(255, 255, 255, 120))

	ZShelter.Building = true

	ZShelter.PreviewEntity.Category = cat
	ZShelter.PreviewEntity.BuildIndex = index
	ZShelter.PreviewEntity.yaw = 0

	ZShelter.PreviewEntity.AttackRange = tdata.attackrange || false
	ZShelter.PreviewEntity.ActiveRange = tdata.activerange || false

	if(tdata.faceforward) then
		local yaw = math.Round(LocalPlayer():EyeAngles().yaw / 90, 0) * 90
		if(tdata.faceforward_offset) then
			yaw = yaw + tdata.faceforward_offset
		end
		ZShelter.PreviewEntity.yaw = yaw
		ZShelter.PreviewEntity:SetAngles(Angle(0, yaw, 0))
		ZShelter.PreviewEntity.UpdateYaw = true
	end

	ZShelter.PreviewEntity.CanBuild = false
	ZShelter.PreviewEntity.Offset = offset
	ZShelter.PreviewEntity.CanBuildInsideShelter = (tdata.insideshelter || false) || GetConVar("zshelter_build_in_shelter"):GetInt() == 1

	ZShelter.PreviewEntity.waitForRelease_Attack = true
	ZShelter.PreviewEntity.waitForRelease_Attack2 = true
	ZShelter.PreviewEntity.waitForRelease_Reload = false

	ZShelter.PreviewEntity.Destroy = function()
		ZShelter.PreviewEntity:Remove()
		ZShelter.Building = false
	end
end

surface.CreateFont("ZShelter-HUDHint", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(14),
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont("ZShelter-HUDHintSmall", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(10),
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont("ZShelter-HUDUpgrade", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(8),
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont("ZShelter-HUDUpgradeDesc", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(10),
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

ZShelter_NoDraw = false
if(EnhancedCameraTwo) then -- Enhanced Camera 2 compatibilty
	EnhancedCameraTwo.ORender = EnhancedCameraTwo.ORender || EnhancedCameraTwo.Render
	function EnhancedCameraTwo:Render()
		if(ZShelter_NoDraw) then return end
		EnhancedCameraTwo:ORender()
	end
end

local attack = Material("zsh/icon/attack.png", "smooth")
local health_mat = Material("zsh/icon/health.png", "smooth")
local kill = Material("zsh/icon/skull.png")

local woods, irons, powers = Material("zsh/icon/woods_white.png", "smooth"), Material("zsh/icon/irons_white.png", "smooth"), Material("zsh/icon/powers_white.png", "smooth")

local upgradeHoldTime = 0
local waitforrelease = false
local middledown = false
local upgradingEntity = nil
local hintalpha = 0
local texture = Material("zsh/icon/footer.png", "smooth")
hook.Add("HUDPaint", "ZShelter-BuildingHints", function()
	if(!IsValid(LocalPlayer())) then return end
	if(ZShelter.Building) then
		hintalpha = math.Clamp(hintalpha + ZShelter.GetFixedValue(15), 0, 255)
	else
		hintalpha = math.Clamp(hintalpha - ZShelter.GetFixedValue(15), 0, 255)
	end

	local entity = LocalPlayer():GetEyeTrace().Entity
	local m2down = LocalPlayer():KeyDown(32)

	if(!m2down) then
		waitforrelease = false
		upgradeHoldTime = CurTime()
	else
		if(waitforrelease) then
			upgradeHoldTime = CurTime()
		end
	end

	if(entity != upgradingEntity) then
		upgradeHoldTime = CurTime()
	end

	if(IsValid(entity) && entity:GetNWBool("IsBuilding", false) && !entity:GetNWBool("NoHUD", false)) then
		local health = entity:GetNWInt("ZShelter-Health", entity:Health())
		if(!entity.hlen || !entity.olen) then
			entity.hlen = health
			entity.olen = 0
		end
		local name = ZShelter_GetTranslate("#"..entity:GetNWString("Name", "Friendly Building"))
		if(entity == GetGlobalEntity("ShelterEntity")) then
			name = ZShelter_GetTranslate_Var("#ShelterNick", GetGlobalInt("ShelterLevel", 0) + 1)
		end
		local completed = entity:GetNWBool("Completed", false)
		local w, h = ScreenScaleH(185), ScreenScaleH(50)
		local imgsx = ScreenScaleH(2)
		local x, y =  ScrW() / 2 - w / 2, ScrH() * 0.635
		local hpbar = ScreenScaleH(6)
		local side = ScreenScaleH(10)
		local startX, maxW = x + side, w - (side * 2)
		local damage, kills = math.floor(entity:GetNWInt("ZShelter_DamageDealt", 0)), entity:GetNWInt("ZShelter_KillCount", 0)

		if(damage > 0 || kills > 0) then
			local dmginfow, dmginfoh = ScreenScaleH(185), ScreenScaleH(18)
			local textpadding = ScreenScaleH(3)
			local basey = y - (dmginfoh + imgsx)
			local sx = ScreenScaleH(16)
			local textxpadding = sx * 0.5
			local sidepadding = ScreenScaleH(8)
			draw_RoundedBox(0, x, basey, dmginfow, dmginfoh, Color(0, 0, 0, 100))
			basey = basey + ScreenScaleH(1)
			surface_SetDrawColor(255, 255, 255, 255)
			surface_SetMaterial(attack)
			surface_DrawTexturedRect(x + sidepadding, basey, sx, sx)
			draw_DrawText(damage, "ZShelter-HUDUpgradeDesc", x + w * 0.25 + textxpadding, basey + textpadding, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			surface_SetMaterial(kill)
			surface_DrawTexturedRect(x + w * 0.5 + sidepadding, basey, sx, sx)
			draw_DrawText(kills, "ZShelter-HUDUpgradeDesc", x + w * 0.75 + textxpadding, basey + textpadding, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end

		if(entity:GetNWBool("Upgradable", false)) then
			name = name.." [+"..entity:GetNWInt("UpgradeCount", 0).."]"
		end

		draw_RoundedBox(0, x, y, w, h, Color(0, 0, 0, 100))
		if(!completed) then
			surface_SetDrawColor(255, 255, 255, 45)
			surface_SetMaterial(texture)
			surface_DrawTexturedRect(x, y, w, imgsx)
			surface_DrawTexturedRect(x, (y + h + ScreenScaleH(18))  - imgsx, w, imgsx)
		else
			if(entity:GetNWBool("HasManualControl")) then
				ZShelter.ShadowText(ZShelter_GetTranslate("#ManualControl"), "ZShelter-HUDHintSmall", ScrW() *0.5, ScrH() * 0.55, Color(220, 220, 220, 255), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, 1)
				if(input.IsMouseDown(109) && !middledown) then
					ZShelter.StartControlMortar(entity)
				end
			end
		end
		local drawY = y + h * 0.775
		draw_DrawText(name, "ZShelter-HUDHint", ScrW() / 2, y + h * 0.125, Color(220, 220, 220, 255), TEXT_ALIGN_CENTER)

		local inp = (health / entity:GetMaxHealth())
		local scale = math.Clamp(inp, 0, 1)
		local scale2 = math.Round(math.max(inp, 0), 2)
		draw_DrawText(health.." / "..entity:GetMaxHealth().." ( "..(scale2 * 100).."% )", "ZShelter-HUDHintSmall", ScrW() / 2, y + h * 0.475, Color(220, 220, 220, 255), TEXT_ALIGN_CENTER)
		draw_RoundedBox(0, startX, drawY, maxW, hpbar, Color(0, 0, 0, 200))
		local currentLength = maxW * scale
		local colorVar = 165 * scale
		local colorVar2 = 165 - colorVar
		entity.hlen = math.Clamp(entity.hlen + ZShelter.GetFixedValue((currentLength - entity.hlen) * 0.1), 0, maxW)
		draw_RoundedBox(0, startX, drawY, entity.hlen, hpbar, Color(255 - colorVar, 255 - colorVar2, 90, 255))

		local overheal = math.Clamp((entity:Health() - entity:GetMaxHealth()) / entity:GetMaxHealth(), 0, 1) * maxW
		entity.olen = math.Clamp(entity.olen + ZShelter.GetFixedValue((overheal - entity.olen) * 0.1), 0, maxW)
		draw_RoundedBox(0, startX, drawY, entity.olen, hpbar, Color(40, 240, 230, 255))
		if(entity:GetNWBool("Upgradable", false) && entity:GetNWBool("Completed", false) && entity:GetNWInt("UpgradeCount", 0) < entity:GetNWInt("MaxUpgrade", 2)) then
			local fraction = math.Clamp(CurTime() - upgradeHoldTime, 0, 1)
			if(fraction == 1) then
				net.Start("ZShelter-UpgradeTurret")
				net.WriteEntity(entity)
				net.SendToServer()
				waitforrelease = true
			end
			local y = y + h
			local h = ScreenScaleH(45)
			draw_RoundedBox(0, x, y, w, h, Color(0, 0, 0, 100))
			local side = ScreenScaleH(12)

			local _w = w - side * 2
			draw_RoundedBox(0, x + side, y, _w, ScreenScaleH(1), Color(150, 150, 150, 255))
			draw_RoundedBox(0, x + side, y, (_w * 0.5) * fraction, ScreenScaleH(1), Color(255, 221, 0, 255))
			draw_RoundedBox(0, (x + (w - side)) - ((_w * 0.5) * fraction), y, (_w * 0.5) * fraction, ScreenScaleH(1), Color(255, 221, 0, 255))

			local drawX = x + side
			local drawY = y + ScreenScaleH(3)
			local sx = ScreenScaleH(12)
			surface_SetDrawColor(255, 255, 255, 255)
			surface_SetMaterial(attack)
			surface_DrawTexturedRect(drawX, drawY, sx, sx)

			local pad = ScreenScaleH(1)
			local tx = x + w * 0.25 + sx * 0.5
			local atk, hp = entity:GetNWInt("AttackDamage", 10), entity:GetMaxHealth()
			draw_DrawText(atk.." >> "..math.floor(atk + entity:GetNWInt("oAttackDamage", atk) * entity:GetNWFloat("AttackScale", 0)), "ZShelter-HUDUpgradeDesc", tx, drawY + pad, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			drawY = drawY + sx
			surface_SetMaterial(health_mat)
			surface_DrawTexturedRect(drawX, drawY, sx, sx)
			draw_DrawText(hp.." >> "..math.floor(hp + (entity:GetNWInt("oMaxHealth", hp) * entity:GetNWFloat("HealthScale", 0))), "ZShelter-HUDUpgradeDesc", tx, drawY + pad, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

			draw_RoundedBox(0, x + w / 2, y + ScreenScaleH(5), ScreenScaleH(1), h * 0.5, Color(255, 255, 255, 20))

			sx = ScreenScaleH(14)

			drawX = (x + w / 2) + ScreenScaleH(3)
			drawY = (y + h * 0.265) - sx * 0.5

			local resSc, powSc = 0.4, 0.65

			surface_SetDrawColor(255, 255, 255, 255)

			local _x = drawX + w * 0.1
			surface_SetMaterial(woods)
			surface_DrawTexturedRect(_x, drawY, sx, sx)
			draw_DrawText(math.floor(math.max(entity:GetNWInt("Woods", 0), 1)), "ZShelter-HUDUpgrade", _x + sx * 0.5, drawY + sx, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

			surface_SetMaterial(irons)
			_x = drawX + w * 0.23
			surface_DrawTexturedRect(_x, drawY, sx, sx)
			draw_DrawText(math.floor(math.max(entity:GetNWInt("Irons", 0) * 0.5, 1)), "ZShelter-HUDUpgrade", _x + sx * 0.5, drawY + sx, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

			local str = ZShelter_GetTranslate("#UpgradeHint")
			if(fraction > 0) then
				str = str.." ["..(math.Round(fraction, 2) * 100).."%]"
			end
			draw_DrawText(str, "ZShelter-HUDUpgrade", x + w / 2, y + h * 0.75, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		else
			local y = y + h
			local h = ScreenScaleH(18)
			draw_RoundedBox(0, x, y, w, h, Color(0, 0, 0, 100))
			local side = ScreenScaleH(12)
			draw_RoundedBox(0, x + side, y, w - side * 2, ScreenScaleH(1), Color(150, 150, 150, 255))

			local drawX = x + side
			local drawY = y + ScreenScaleH(3)
			local sx = ScreenScaleH(12)
			local pad = ScreenScaleH(1)
			local tx = x + w * 0.4
			local atk, hp = entity:GetNWInt("AttackDamage", 0), entity:GetMaxHealth()
			surface_SetDrawColor(255, 255, 255, 255)
			surface_SetMaterial(attack)
			surface_DrawTexturedRect(tx - sx, drawY, sx, sx)
			draw_DrawText(atk, "ZShelter-HUDUpgradeDesc", tx, drawY + pad, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

			tx = x + w * 0.6

			surface_SetMaterial(health_mat)
			surface_DrawTexturedRect(tx - sx, drawY, sx, sx)
			draw_DrawText(hp, "ZShelter-HUDUpgradeDesc", tx, drawY + pad, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		end
	else
		upgradeHoldTime = CurTime()
	end

	middledown = input.IsMouseDown(109)
	upgradingEntity = entity

	--[[
	if(IsValid(ZShelter.PreviewEntity) && (ZShelter.PreviewEntity.AttackRange || ZShelter.PreviewEntity.ActiveRange)) then
		if(ZShelter.PreviewEntity.NoOffsPos) then
			local scl = 0.25
			local w, h = ScrW() * scl, ScrH() * scl
			local x, y = ScrW() - w, 0
			ZShelter_NoDraw = true
			ZShelter_StopFog = true
			render.RenderView({
				origin = ZShelter.PreviewEntity.NoOffsPos + Vector(0, 0, 2000),
				angles = Angle(90, 0, 0),
				x = x, y = y,
				w = w, h = h,
				drawviewmodel = false,
			})
			ZShelter_NoDraw = false
			ZShelter_StopFog = false
		end
	end
	]]
	ZShelter.ShadowText(ZShelter_GetTranslate("#BuildingHint"), "ZShelter-HUDHint", ScrW() / 2, ScrH() * 0.75, Color(255, 255, 255, hintalpha), Color(0, 0, 0, hintalpha), TEXT_ALIGN_CENTER, 1.5)
end)

local maximumBuildDst = 256
hook.Add("Think", "ZShelter-PreviewController", function()
	if(!IsValid(ZShelter.PreviewEntity)) then return end
	local snapToGrid = GetConVar("zshelter_snap_to_grid"):GetInt() == 1
	local gridSize = GetConVar("zshelter_snap_to_grid_size"):GetInt()
	local ply = LocalPlayer()
	local tr = {
		start = LocalPlayer():EyePos(),
		endpos = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 256,
		mask = MASK_PLAYERSOLID,
		filter = ply,
	}
	local pos = util.TraceLine(tr).HitPos
	local trace = util.QuickTrace(pos, Vector(0, 0, -1024000), ply)
	local pos = trace.HitPos
	if(snapToGrid) then
		local offs = gridSize / 2
		pos.x = (math.floor(pos.x / gridSize) * gridSize) + offs
		pos.y = (math.floor(pos.y / gridSize) * gridSize) + offs
	end
	ZShelter.PreviewEntity.NoOffsPos = pos
	ZShelter.PreviewEntity:SetPos(pos + ZShelter.PreviewEntity.Offset)
	if(!ply:Alive()) then
		ZShelter.PreviewEntity.Destroy()
	end
	if(!ply:KeyDown(1)) then
		ZShelter.PreviewEntity.waitForRelease_Attack = false
	else
		if(!ZShelter.PreviewEntity.waitForRelease_Attack) then
			if(ZShelter.PreviewEntity.CanBuild) then
				net.Start("ZShelter_BuildRequest")
				net.WriteString(ZShelter.PreviewEntity.Category)
				net.WriteInt(ZShelter.PreviewEntity.BuildIndex, 32)
				net.WriteVector(pos)
				net.WriteInt(ZShelter.PreviewEntity.yaw, 32)
				net.SendToServer()
				ZShelter.PreviewEntity.Destroy()
			else
				sound.PlayFile("sound/shigure/build_reject.mp3", "noplay", function(station, errCode, errStr)
					station:Play()
				end)
			end
		end
		ZShelter.PreviewEntity.waitForRelease_Attack = true
	end
	if(!ply:KeyDown(2048)) then
		ZShelter.PreviewEntity.waitForRelease_Attack2 = false
	else
		if(!ZShelter.PreviewEntity.waitForRelease_Attack2) then
			ZShelter.PreviewEntity.Destroy()
		end
		ZShelter.PreviewEntity.waitForRelease_Attack2 = true
	end
	if(!ply:KeyDown(8192)) then
		ZShelter.PreviewEntity.waitForRelease_Reload = false
	else
		if(!ZShelter.PreviewEntity.waitForRelease_Reload) then
			ZShelter.PreviewEntity.yaw = ZShelter.PreviewEntity.yaw + 45
			if(ZShelter.PreviewEntity.yaw >= 360) then ZShelter.PreviewEntity.yaw = 0 end
			ZShelter.PreviewEntity:SetAngles(Angle(0, ZShelter.PreviewEntity.yaw, 0))
		end
		ZShelter.PreviewEntity.waitForRelease_Reload = true
	end

	local canbuild = true

	if(pos:Distance(ply:GetPos()) > maximumBuildDst) then
		canbuild = false
	end
	if(Vector(0, 0, pos.z):Distance(Vector(0, 0, ply:GetPos().z)) > 10) then
		canbuild = false
	end
	if(IsValid(trace.Entity)) then
		canbuild = false
	end


	local mins, maxs = ZShelter.PreviewEntity:GetModelBounds()
	local rotatedA,rotatedB = ZShelter.PreviewEntity:GetRotatedAABB(mins, maxs)
--[[
	local tr = {
		start = pos,
		endpos = pos,
		ignoreworld = true,
		mins = rotatedA,
		maxs = rotatedB,
		mask = MASK_SHOT_HULL,
	}
	local ret = util.TraceHull(tr)
	if(IsValid(ret.Entity)) then
		canbuild = false
	end
]]
	local shelter = GetGlobalEntity("ShelterEntity")
	if(IsValid(shelter) && !ZShelter.PreviewEntity.CanBuildInsideShelter) then
		local shelterpos = shelter:GetPos()
		local mins, maxs = shelter:GetCollisionBounds()
		local ra, rb = shelter:GetRotatedAABB(mins, maxs)
		local a, b = shelterpos + rb, shelterpos + ra
		local aa, bb = rotatedA + pos, rotatedB + pos
		if(aa:WithinAABox(a, b) || bb:WithinAABox(a, b)) then
			canbuild = false
		end
	end
	if(canbuild) then
		ZShelter.PreviewEntity:SetColor(Color(255, 255, 255, 180))
	else
		ZShelter.PreviewEntity:SetColor(Color(255, 0, 0, 180))
	end

	ZShelter.PreviewEntity.CanBuild = canbuild
end)

local rangemat = Material("arknights/torappu/sprite_attack_range.png", "noclamp")
local fraction = 0
local animtime = 2
local textureSX = 48
hook.Add("PreDrawOpaqueRenderables", "ZShelter-BuildingPreviewRange", function(depth, skybox, skybox3d)
	if(!IsValid(ZShelter.PreviewEntity) || !ZShelter.PreviewEntity.NoOffsPos) then return end

		surface.SetMaterial(rangemat)
		cam.Start3D2D(ZShelter.PreviewEntity.NoOffsPos + Vector(0, 0, 1), Angle(0, 0, 0), 1)
		surface.SetDrawColor(255, 140, 40, 50)
		fraction = (SysTime() % animtime) / animtime
		local rev_fraction = 1 - fraction
		if(ZShelter.PreviewEntity.AttackRange) then
			local rg = ZShelter.PreviewEntity.AttackRange * 2
			local rghalf = rg * 0.5
			local anim = fraction
			surface.DrawTexturedRectUV(-rghalf, -rghalf, rg, rg, anim, anim, (rg / textureSX) + anim, (rg / textureSX) + anim)
		end
		surface.SetDrawColor(64, 204, 255, 255)
		if(ZShelter.PreviewEntity.ActiveRange) then
			local rg = ZShelter.PreviewEntity.ActiveRange * 2
			local rghalf = rg * 0.5
			local anim = fraction
			surface.DrawTexturedRectUV(-rghalf, -rghalf, rg, rg, anim, anim, (rg / textureSX) + anim, (rg / textureSX) + anim)
		end
		cam.End3D2D()

	--[[
	render.SetColorMaterial()
	fraction = (SysTime() % animtime) / animtime
	local rev_fraction = 1 - fraction
	if(ZShelter.PreviewEntity.AttackRange) then
		local rg = ZShelter.PreviewEntity.AttackRange * 2
		local rghalf = rg * 0.5
		local anim = fraction
		render.DrawBox(ZShelter.PreviewEntity.NoOffsPos, Angle(0, 0, 0), -Vector(rghalf, rghalf, 0), Vector(rghalf, rghalf, 1), Color(255, 140, 40, 35))
	end
	if(ZShelter.PreviewEntity.ActiveRange) then
		local rg = ZShelter.PreviewEntity.ActiveRange * 2
		local rghalf = rg * 0.5
		local anim = fraction
		render.DrawBox(ZShelter.PreviewEntity.NoOffsPos, Angle(0, 0, 0), -Vector(rghalf, rghalf, 0), Vector(rghalf, rghalf, 1), Color(64, 204, 255, 85))
	end
	]]
end)