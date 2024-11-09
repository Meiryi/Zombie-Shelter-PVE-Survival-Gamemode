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

surface.CreateFont("ZShelter-HUDFont", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(20),
	weight = 500,
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

surface.CreateFont("ZShelter-HUDWeapon", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(16),
	weight = 500,
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

surface.CreateFont("ZShelter-HUDElemFont", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(12),
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

surface.CreateFont("ZShelter-HUDFontSmall", {
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

surface.CreateFont("ZShelter-HUDFontMedium", {
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

surface.CreateFont("ZShelter-HUDNotifyFont", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(12),
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

surface.CreateFont("ZShelter-HUDDamageFont", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(12),
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

surface.CreateFont("ZShelter-HUDDamageSmallFont", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(8),
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

surface.CreateFont("ZShelter-HUDNameTag", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(8),
	weight = 500,
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

surface.CreateFont("ZShelter-HUDDetails", {
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

local mats = {}
for i = 0, 15 do
	mats[i] = Material("zsh/power/E"..i..".png", "smooth")
end

math_Clamp = math.Clamp
draw_RoundedBox = draw.RoundedBox
surface_SetDrawColor = surface.SetDrawColor
surface_SetMaterial = surface.SetMaterial
surface_DrawTexturedRect = surface.DrawTexturedRect
surface_DrawRect = surface.DrawRect
draw_DrawText = draw.DrawText

local currentImage = mats[0]
local currentIndex = 0
local currentTime = 0
local interval = 0.03
local shouldDisplay = false
local shouldenablehud = true
local nextcheckhud = 0
function ZShelter.DrawPowerOutage()
	if(currentTime < SysTime()) then
		currentIndex = currentIndex + 1
		if(currentIndex > 15) then
			currentIndex = 0
		end
		currentImage = mats[currentIndex]
		currentTime = SysTime() + interval
	end
	local size = ScreenScaleH(24)
	local offs = size / 2
	surface_SetMaterial(currentImage)

	if(shouldDisplay) then
		for k,v in pairs(ents.GetAll()) do
			if(!v:IsNPC()) then continue end
			local pos = v:GetPos()
			local offs = Vector(0, 0, v:EyePos().z)
			local p1, p2, p3 = pos:ToScreen(), pos:ToScreen(), pos:ToScreen()
			draw.DrawText(v:GetClass(), "DermaDefault", p3.x, p3.y, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
	end

	for _, building in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 1024)) do
		if(building:GetNWFloat("StunTime", 0) < CurTime()) then continue end
		if(!building:GetNWBool("IsBuilding", false)) then continue end
			local pos = (building:GetPos() + Vector(0, 0, building:OBBMaxs().z + 5)):ToScreen()
			surface_DrawTexturedRect(pos.x - offs, pos.y - offs, size, size)
	end
end

local dmgs = {}
local cvar = GetConVar("zshelter_damage_number")
net.Receive("ZShelter-DamageNumber", function()
	if(cvar:GetInt() == 0) then return end
	local eindex = net.ReadInt(32)
	local dmg = net.ReadInt(32)
	local vec = net.ReadVector()
	local offset = ScreenScaleH(24)
	local time = 0.5
	if(dmgs[eindex]) then
		local prev = dmgs[eindex]
		local new = {
			damage = dmg + prev.damage,
			prev = "(+"..dmg..")",
			time = SysTime() + time,
			alpha = 255,

			target_offs = offset,
			current_offs = 0,

			target_scale = 1.15,
			current_scale = 0,

			pos = vec,
		}

		dmgs[eindex] = new
	else
		dmgs[eindex] = {
			damage = dmg,
			time = SysTime() + time,
			alpha = 0,

			target_offs = offset,
			current_offs = 0,

			target_scale = 1.15,
			current_scale = 0,

			pos = vec,
		}
	end
end)

function ZShelter.PaintDamageNumber()
	local sw, sh = ScrW() * 0.5, ScrH() * 0.5
	for k,v in pairs(dmgs) do
		if(v.time < SysTime()) then
			v.alpha = math_Clamp(v.alpha - ZShelter.GetFixedValue(35), 0, 255)
			v.current_offs = math_Clamp(v.current_offs - ZShelter.GetFixedValue(v.current_offs * 0.165), 0, v.target_offs)
			v.current_scale = math_Clamp(v.current_scale - ZShelter.GetFixedValue(v.current_scale * 0.165), 0, v.target_scale)
			if(v.alpha <= 0) then
				dmgs[k] = nil
			end
		else
			v.alpha = math_Clamp(v.alpha + ZShelter.GetFixedValue(50), 0, 255)
			v.current_offs = math_Clamp(v.current_offs + ZShelter.GetFixedValue((v.target_offs - v.current_offs) * 0.165), 0, v.target_offs)
			v.current_scale = math_Clamp(v.current_scale + ZShelter.GetFixedValue((v.target_scale - v.current_scale) * 0.165), 0, v.target_scale)
		end
		local pos = v.pos:ToScreen()
		local matrix = Matrix()

		matrix:Translate(Vector(pos.x, pos.y))
		matrix:Scale(Vector(v.current_scale, v.current_scale, 1))
		matrix:Translate(-Vector(pos.x, pos.y))

		cam.PushModelMatrix(matrix)
		draw.DrawText(v.damage, "ZShelter-HUDDamageFont", pos.x, pos.y - v.current_offs, Color(255, 25, 25, v.alpha), TEXT_ALIGN_CENTER)
		--[[
		if(v.prev) then
			draw.DrawText(v.prev, "ZShelter-HUDDamageSmallFont", pos.x, pos.y - (v.current_offs - ScreenScaleH(10)), Color(255, 25, 25, v.alpha), TEXT_ALIGN_CENTER)
		end
		]]
		cam.PopModelMatrix()
	end
end

if(ArcCW) then
	function ArcCW:ShouldDrawHUDElement(ele)
		if(!shouldenablehud) then return true end
	    if ele == "CHudHealth" then return false end
	    if ele == "CHudBattery" then return false end
	    return true
	end
end

local elem = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
}
hook.Add("HUDShouldDraw", "ZShelter-HideHUD", function(name)
	if(!shouldenablehud) then return end
	if(elem[name]) then
		return false
	end
end)

function ZShelter.DrawBar(r, x, y, w, h, t, color, bgcolor)
	draw_RoundedBox(r, x, y, w, h, bgcolor)
	w = w * t
	draw_RoundedBox(r, x, y, w, h, color)
end

local vol = Material("zsh/icon/volume.png", "smooth")
local hpmat = Material("zsh/icon/health.png", "smooth")
local armormat = Material("zsh/icon/armor.png", "smooth")
local sanitymat = Material("zsh/icon/sanity.png", "smooth")
local powermat = Material("zsh/icon/powers_white.png", "smooth")
local woodmat = Material("zsh/icon/woods_white.png", "smooth")
local ironmat = Material("zsh/icon/irons_white.png", "smooth")
local v1 = 0
local v2 = 0
local v3 = 0
local skillkey = 92
local skillkeydown = false
local spawnAlpha = 0
local run = false
local shouldWarn = false
local pts = {}
local calpha = 0
local shadow = Material("zsh/icon/bordershadow04.png")

net.Receive("ZShelter-SendPoints", function()
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	pts = util.JSONToTable(util.Decompress(data))
end)

function ZShelter.DebugDrawing()
	if(!run) then return end
	surface.SetDrawColor(255, 255, 255, 255)
	for k,v in pairs(pts) do
		local pos = v:ToScreen()
		surface.DrawRect(pos.x, pos.y, 4, 4)
	end
end

local killed = Material("zsh/icon/destroyed.png", "smooth")
local build = Material("zsh/icon/building.png", "smooth")

local list = {}
net.Receive("ZShelter-Notify", function()
	local death = net.ReadBool()
	local ncolor = net.ReadColor()
	local isplayer = net.ReadBool()
	local title = net.ReadString()
	if(!isplayer) then
		title = ZShelter_GetTranslate("#"..title)
	end
	local color = Color(220, 55, 58, 255)
	local tall = ScreenScaleH(16)
	local wide = ScreenScaleH(64) + tall
	local tw = ZShelter.GetTextSize("ZShelter-HUDNotifyFont", title)
	local mat = killed
	if(!death) then
		color = Color(55, 170, 220, 255)
		mat = build
	end
	if(ncolor != Color(0, 0, 0, 0)) then
		color = ncolor
	end
	if((wide - tall) <= tw) then wide = tw + tall + ScreenScaleH(4) end
	table.insert(list, 1, {
		title = title,
		killtime = SysTime() + 6,
		tall = tall,
		wide = wide,
		alpha = 0,
		cy = 0,
		bgcolor = color,
		material = mat,
	})
end)

function ZShelter.PaintNotify()
	if(#list <= 0) then return end
	local nextY = ScrH() * 0.085
	local gap = ScreenScaleH(2)
	for k,v in ipairs(list) do
		if(v.killtime < SysTime()) then
			v.alpha = math_Clamp(v.alpha - ZShelter.GetFixedValue(15), 0, 255)
			if(v.alpha <= 0) then
				table.remove(list, k)
			end
		else
			if(v.alpha != 255) then
				v.alpha = math_Clamp(v.alpha + ZShelter.GetFixedValue(15), 0, 255)
			end
		end
		if(v.cy == 0) then
			v.cy = nextY
		end
		v.cy = math.Clamp(v.cy + ZShelter.GetFixedValue((nextY - v.cy) * 0.25), nextY - (v.tall + gap), nextY)
		v.bgcolor.a = v.alpha
		local x = ScrW() - (v.wide + gap)
		draw_RoundedBox(0, x, v.cy, v.wide, v.tall, v.bgcolor)
		draw_DrawText(v.title, "ZShelter-HUDNotifyFont", x + gap + v.tall, v.cy + gap, Color(255, 255, 255, v.alpha), TEXT_ALIGN_LEFT)

		surface_SetDrawColor(255, 255, 255, v.alpha)
		surface_SetMaterial(v.material)
		surface_DrawTexturedRect(x, v.cy, v.tall, v.tall)
		nextY = nextY + gap + v.tall
	end
end

local shouldDraw = true
local nextCheckTime = 0
function ZShelter.PaintHUD()
	local centX, centY = ScrW() * 0.5, ScrH() * 0.5
	local padding = ScreenScaleH(6)
	local padding2x = ScreenScaleH(3)
	local padding3x = ScreenScaleH(5)
	local padding4x = ScreenScaleH(4)
	local wide, tall = ScreenScaleH(130), ScreenScaleH(70)
	local imagesx = ScreenScaleH(20)
	local startX, startY = padding, ScrH() - (tall + padding)
	local oY = startY
	local barwide, bartall = wide - ((padding2x * 3) + imagesx), ScreenScaleH(7)
	local barX = startX + padding3x + imagesx
	local resWide, resTall = wide, tall * 0.35 
	local ply, pos = LocalPlayer(), LocalPlayer():GetPos()

	for k,v in ipairs(player.GetAll()) do
		if(!v:Alive() || v == ply) then continue end
		if(!v.nameAlpha) then
			v.nameAlpha = 0
		end
		local opos = v:GetPos()
		if(v:IsDormant() || pos:Distance(opos) > 2048) then
			if(v.nameAlpha > 35) then
				v.nameAlpha = math_Clamp(v.nameAlpha - ZShelter.GetFixedValue(8), 35, 255)
			end
		else
			if(v.nameAlpha < 255) then
				v.nameAlpha = math_Clamp(v.nameAlpha + ZShelter.GetFixedValue(15), 0, 255)
			end
		end
		local pos = (opos + Vector(0, 0, 8 + v:OBBMaxs().z)):ToScreen()
		draw_DrawText(v:Nick(), "ZShelter-HUDNameTag", pos.x, pos.y, Color(255, 255, 255, v.nameAlpha), TEXT_ALIGN_CENTER)
	end


	if(!GetGlobalBool("GameStarted") && GetGlobalFloat("ReadyTime", -1) > CurTime()) then
		local t = math.floor(math.max(GetGlobalFloat("ReadyTime", -1) - CurTime(), 0))
		ZShelter.ShadowText(ZShelter_GetTranslate_Var("#GameStartAfter", t), "ZShelter-HUDFontMedium", centX, ScrH() * 0.5, Color(255, 255, 255, 255), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, 1)
	end

	if(!LocalPlayer():Alive()) then
		spawnAlpha = math_Clamp(spawnAlpha + ZShelter.GetFixedValue(15), 0, 255)
	else
		spawnAlpha = math_Clamp(spawnAlpha - ZShelter.GetFixedValue(15), 0, 255)
	end

	if(spawnAlpha > 0) then
		ZShelter.ShadowText(ZShelter_GetTranslate_Var("#RespawnAfter", string.format("%1.1f", math.max(math.Round(LocalPlayer():GetNWFloat("RespawnTime", 0) - CurTime(), 1), 0))), "ZShelter-HUDFontMedium", centX, ScrH() * 0.525, Color(255, 255, 255, spawnAlpha), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, 1)
	end

	if(LocalPlayer():GetNWInt("SkillPoints") > 0 && !IsValid(ZShelter.BuildUI) && !IsValid(ZShelter.SkillUI)) then
		local wide = ScreenScaleH(180)
		local x, y = centX - wide * 0.5, ScrH() * 0.575
		draw_RoundedBox(padding, x, y, wide, resTall, Color(30, 30, 30, 130))
		ZShelter.ShadowText(ZShelter_GetTranslate("#SkillPTS")..LocalPlayer():GetNWInt("SkillPoints"), "ZShelter-HUDFontMedium", centX, y + padding, Color(255, 255, 255, 255), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, 1)
	end

	local ypos = startY - (resTall + padding) * 2
	draw_RoundedBox(padding, padding, ypos, wide, resTall, Color(30, 30, 30, 200))

	surface_SetDrawColor(255, 255, 255, 255)
	surface_SetMaterial(vol)
	surface_DrawTexturedRect(startX + padding2x, ypos + padding2x, imagesx, imagesx)
	local f = 1 - math.Clamp(GetGlobalFloat("NoiseLevel", 0) / 100, 0, 1)
	ZShelter.DrawBar(padding2x, barX, ypos + padding + padding2x, barwide, bartall, 1 - f, Color(255, 255 * f, 255 * f, 255), Color(20, 20, 20, 255))


	draw_RoundedBox(padding, padding, startY - (resTall + padding), wide, resTall, Color(30, 30, 30, 200))

	surface_SetDrawColor(102, 73, 35, 255)
	surface_SetMaterial(woodmat)
	surface_DrawTexturedRect(startX + padding, startY - (resTall + padding4x), imagesx, imagesx)
	draw_DrawText(LocalPlayer():GetNWInt("Woods", 0).." / "..LocalPlayer():GetNWInt("ResourceCapacity", 0), "ZShelter-HUDElemFont", startX + wide * 0.35, startY - (resTall), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	surface_SetDrawColor(84, 89, 95, 255)
	surface_SetMaterial(ironmat)
	surface_DrawTexturedRect(startX + wide / 2, startY - (resTall + padding4x), imagesx, imagesx)
	draw_DrawText(LocalPlayer():GetNWInt("Irons", 0).." / "..LocalPlayer():GetNWInt("ResourceCapacity", 0), "ZShelter-HUDElemFont", startX + wide * 0.8, startY - (resTall), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

	if(shouldenablehud) then
		draw_RoundedBox(padding, padding, startY, wide, tall, Color(30, 30, 30, 200))
		local ply = LocalPlayer()
		startX = startX + padding2x
		startY = startY + padding2x
		v1 = math_Clamp(v1 + ZShelter.GetFixedValue(((ply:Health() / ply:GetMaxHealth()) - v1) * 0.2), 0, 1)
		v2 = math_Clamp(v2 + ZShelter.GetFixedValue(((ply:Armor() / ply:GetMaxArmor()) - v2) * 0.2), 0, 1)
		v3 = math_Clamp(v3 + ZShelter.GetFixedValue(((ply:GetNWFloat("Sanity", 0) / 100) - v3) * 0.2), 0, 1)

		local offset = ScreenScaleH(0.5)
		local textX = barX + barwide - ScreenScaleH(2)
		local textY = startY + padding - offset

		surface_SetDrawColor(255, 255, 255, 255)
		surface_SetMaterial(sanitymat)
		surface_DrawTexturedRect(startX, startY, imagesx, imagesx)
		ZShelter.DrawBar(padding2x, barX, startY + padding, barwide, bartall, v3, Color(255, 255 * v3, 255 * v3, 255), Color(20, 20, 20, 255))
		local clr = 255 * (1 - v3) * 2
		draw.DrawText(math.Round(ply:GetNWFloat("Sanity", 0), 2).."/100", "ZShelter-HUDDetails", textX, textY, Color(clr, clr, clr, 255), TEXT_ALIGN_RIGHT)

		startY = startY + imagesx + padding2x

		surface_SetDrawColor(255, 255, 255, 255)
		surface_SetMaterial(armormat)
		surface_DrawTexturedRect(startX, startY, imagesx, imagesx)
		ZShelter.DrawBar(padding2x, barX, startY + padding, barwide, bartall, v2, Color(255, 255 * v2, 255 * v2, 255), Color(20, 20, 20, 255))
		local clr = 255 * (1 - v2) * 2
		draw.DrawText(ply:Armor().."/"..ply:GetMaxArmor(), "ZShelter-HUDDetails", textX, startY + padding - offset, Color(clr, clr, clr, 255), TEXT_ALIGN_RIGHT)

		startY = startY + imagesx + padding2x

		surface_SetDrawColor(255, 255, 255, 255)
		surface_SetMaterial(hpmat)
		surface_DrawTexturedRect(startX, startY, imagesx, imagesx)
		ZShelter.DrawBar(padding2x, barX, startY + padding, barwide, bartall, v1, Color(255, 255 * v1, 255 * v1, 255), Color(20, 20, 20, 255))
		local clr = 255 * (1 - v1) * 2
		draw.DrawText(ply:Health().."/"..ply:GetMaxHealth(), "ZShelter-HUDDetails", textX, startY + padding - offset, Color(clr, clr, clr, 255), TEXT_ALIGN_RIGHT)
	end

	local skill = ply:GetNWString("Tier4Skill", "")
	local skTable = ZShelter.SkillDatas[skill]
	if(skill != "" && skTable && skTable.callbackhook == "OnSkillCalled") then
		local bx, by = wide + padding * 2, oY
		draw_RoundedBox(padding, bx, by, tall, tall, Color(30, 30, 30, 200))
		local f = padding * 2
		local cd = ply:GetNWFloat("UltimateCooldown", 0)
		surface_SetDrawColor(255, 255, 255, 255)
		if(!skillkeydown && input.IsKeyDown(92) && cd < CurTime()) then
			ZShelter.UltimateSkill(skTable)
		end
		local pad = tall * 0.5
		surface_SetMaterial(skTable.icon)
		if(cd > CurTime()) then
			local time = (cd - CurTime())
			local fraction = 1 - math_Clamp(time / skTable.cooldown, 0, 1)
			local rad = tall * 0.4
			surface_SetDrawColor(100, 100, 100, 100)
			surface_DrawTexturedRect(wide + padding * 3, oY + padding, tall - f, tall - f)
			ZShelter:CircleTimerAnimation(bx + pad, by + pad, rad, padding3x, fraction, Color(255, 255, 255, 255))
			draw_DrawText(string.format("%1.1f", math.Round(time, 1)), "ZShelter-HUDElemFont", bx + pad, by + pad - padding, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			surface_SetMaterial(skTable.icon)
			draw_DrawText("F1", "ZShelter-HUDElemFont", bx + tall * 0.85, by + tall * 0.8, Color(100, 100, 100, 100), TEXT_ALIGN_CENTER)
		else
			surface_DrawTexturedRect(wide + padding * 3, oY + padding, tall - f, tall - f)
			draw_DrawText("F1", "ZShelter-HUDElemFont", bx + tall * 0.85, by + tall * 0.8, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
		skillkeydown = input.IsKeyDown(skillkey)
	end

	local ply = LocalPlayer()
	if(ply.Callbacks && ply.Callbacks.OnHUDPaint) then
		for k,v in pairs(ply.Callbacks.OnHUDPaint) do
			v(ply)
		end
	end

	surface_SetDrawColor(255, 255, 255, 255) -- Reset draw color
end

local day_mat = Material("zsh/icon/day.png", "smooth")
local night_mat = Material("zsh/icon/night.png", "smooth")
local escape_mat = Material("zsh/icon/escape.png", "smooth")
local home_mat = Material("zsh/icon/home.png", "smooth")
local nextcheckpos = 0
local homealpha = 0
local homepos = Vector(0, 0, 0)
local centWide = ScreenScaleH(1)
local nextupdate = 0
local shelterstring = "Tier 1 Shelter"
hook.Add("HUDPaint", "ZShelter-HUD", function()
	if(IsValid(ZShelter.ReadyPanel)) then
		ZShelter.ReadyPanel:SetVisible(GetGlobalBool("ReadyState"))
	end

	local ply = LocalPlayer()
	local sanity = ply:GetNWFloat("Sanity", 0)
	if(sanity > 40) then
		shouldWarn = true
	else
		if(sanity < 30) then
			if(shouldWarn) then
				ZShelter.PlaySound("sound/shigure/warning.mp3")
			end
			shouldWarn = false
		end
	end
	local baseValue = 0
	if(sanity < 30) then
		baseValue = 220
	end
	local targetAlpha = math_Clamp((35 * (1 - math_Clamp(sanity / 30, 0, 1))), 0, 225 + ((1 - (ply:Health() / ply:GetMaxHealth())) * 30)) + baseValue
	calpha = math_Clamp(calpha + ZShelter.GetFixedValue((targetAlpha - calpha) * 0.1), 0, 255)
	if(calpha > 0 && ply:Alive()) then
		surface_SetMaterial(shadow)
		surface_SetDrawColor(0, 0, 0, calpha)
		surface_DrawTexturedRect(0, 0, ScrW(), ScrH())
	end

	local centX, centY = ScrW() * 0.5, ScrH() * 0.5
	local wide = ScreenScaleH(200)
	local padding = ScreenScaleH(6)
	local padding1x = ScreenScaleH(1)
	local padding2x = ScreenScaleH(2)
	local padding3x = ScreenScaleH(3)
	local _4_1 = wide / 4
	local tall = ScreenScaleH(24)
	local time = GetGlobalInt("Time", 0)
	local formatted = string.FormattedTime(time, "%02i:%02i")
	draw_RoundedBox(padding3x, centX - wide / 2, 0, wide, tall, Color(30, 30, 30, 200))
	draw_RoundedBox(0, centX - centWide / 2, padding2x, centWide, tall - (padding2x * 2), Color(15, 15, 15, 200))
	draw_DrawText(formatted, "ZShelter-HUDFont", centX + _4_1, padding3x, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	local sx = ScreenScaleH(18)
	surface_SetDrawColor(255, 255, 255, 255)
	if(GetGlobalBool("Night")) then
		surface_SetMaterial(night_mat)
	else
		surface_SetMaterial(day_mat)
	end
	if(GetGlobalBool("Rescuing")) then
		surface_SetMaterial(escape_mat)
	end
	surface_DrawTexturedRect(centX - (wide / 2) + ScreenScaleH(32), tall / 2 - (sx / 2), sx, sx)
	draw_DrawText(GetGlobalInt("Day", 1), "ZShelter-HUDFont", centX - _4_1 * 0.725, padding3x, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

	local wide = ScreenScaleH(160)
	local tall2 = ScreenScaleH(10)
	local tall3 = ScreenScaleH(6)
	local tall4 = ScreenScaleH(17)
	local wide2 = wide - (padding2x * 2)

	local hp = 0
	local maxhp = 0
	local shelter = GetGlobalEntity("ShelterEntity")
	if(IsValid(shelter)) then
		hp = shelter:Health()
		maxhp = shelter:GetMaxHealth()
		if(!shelter.hLength) then
			shelter.hLength = 0
		end
	end

	local spacing = ScreenScaleH(20)
	local _wide = ScreenScaleH(140)
	local _tall = ScreenScaleH(18)
	local isx = ScreenScaleH(16)

	draw_RoundedBox(padding3x, centX - _wide / 2, tall + padding2x + spacing, _wide, _tall, Color(30, 30, 30, 200))
	surface_SetDrawColor(255, 255, 255, 255)
	surface_SetMaterial(woodmat)
	local dx = centX - _wide / 2
	local dy = tall + padding3x + spacing
	local dty = dy + padding3x
	surface_SetDrawColor(102, 73, 35, 255)
	surface_DrawTexturedRect(dx + padding, dy, isx, isx)
	draw_DrawText(GetGlobalInt("Woods", 0).." / "..GetGlobalInt("Capacity"), "ZShelter-HUDFontMedium", dx + _wide * 0.25, dty, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	surface_SetMaterial(ironmat)
	surface_SetDrawColor(100, 100, 100, 255)
	surface_DrawTexturedRect(dx + padding + _wide * 0.34, dy, isx, isx)
	draw_DrawText(GetGlobalInt("Irons", 0).." / "..GetGlobalInt("Capacity"), "ZShelter-HUDFontMedium", dx + _wide * 0.6, dty, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	surface_SetMaterial(powermat)
	surface_SetDrawColor(231, 193, 25, 255)
	surface_DrawTexturedRect(dx + padding + _wide * 0.67, dy, isx, isx)
	draw_DrawText(GetGlobalInt("Powers", 0), "ZShelter-HUDFontMedium", dx + _wide * 0.89, dty, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

	local scale = math_Clamp(hp / maxhp, 0, 1)
	local color = 255 * scale
	if(IsValid(shelter)) then
		if(nextupdate < SysTime()) then
			shelterstring = ZShelter_GetTranslate_Var("#ShelterNick", GetGlobalInt("ShelterLevel", 0) + 1)
			nextupdate = SysTime() + 1
		end

		shelter.hLength = math_Clamp(shelter.hLength + ZShelter.GetFixedValue(((wide2 * scale) - shelter.hLength) * 0.1), 0, wide2)
		draw_RoundedBox(padding2x, centX - wide / 2, tall + padding2x, wide, tall4, Color(30, 30, 30, 200))
		draw_RoundedBox(padding2x, centX - wide / 2 + padding2x, tall + padding2x * 2, shelter.hLength, tall3, Color(255, color, color, 200))
		draw_DrawText(shelterstring, "ZShelter-HUDFontSmall", centX - wide / 2 + padding2x, tall + ScreenScaleH(9) + padding2x, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
		draw_DrawText(hp.." / "..maxhp, "ZShelter-HUDFontSmall", centX + wide / 2 - padding2x, tall + ScreenScaleH(9) + padding2x, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
	end


	if(nextcheckpos < CurTime() && IsValid(GetGlobalEntity("ShelterEntity"))) then
		local e = GetGlobalEntity("ShelterEntity")
		homepos = e:GetPos() + (e:GetAngles():Right() * -20 - e:GetAngles():Forward() * 175 + e:GetAngles():Up() * 50)
		nextcheckpos = SysTime() + 0.2
	end

	if(homepos != Vector(0, 0, 0)) then
		local dst = LocalPlayer():GetPos():Distance(homepos)
		if(dst < 1024) then
			homealpha = math.Clamp(1 - (1024 - dst) / 256, 0, 1) * 255
		else
			homealpha = 255
		end
		local sx = ScreenScaleH(16)
		local offs = sx * 0.5
		local pos = homepos:ToScreen()
		surface_SetDrawColor(255, 255, 255, homealpha)
		surface_SetMaterial(home_mat)
		surface_DrawTexturedRect(pos.x - offs, pos.y - offs, sx, sx)
	end

	if(nextcheckhud < SysTime()) then
		shouldenablehud = GetConVar("zshelter_enable_hud"):GetInt() == 1
		nextcheckhud = SysTime() + 0.1
	end

	ZShelter.DebugDrawing()
	ZShelter.PaintHUD()
	ZShelter.PaintNotify()
	ZShelter.PaintDamageNumber()
	ZShelter.DrawPowerOutage()
end)