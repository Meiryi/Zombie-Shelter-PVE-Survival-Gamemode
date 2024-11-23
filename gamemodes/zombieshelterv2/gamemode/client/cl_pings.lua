ZShelter.Pings = {}

net.Receive("ZShelter_SendPings", function()
	local vec = net.ReadVector()
	local ent = net.ReadEntity()
	local name = net.ReadString()

	local color = Color(255, 255, 255, 255)
	local showHP = false

	if(IsValid(ent)) then
		if(ent:GetNWBool("IsBuilding") && !ent:GetNWBool("IsResource")) then
			showHP = true
			color = Color(55, 255, 55, 255)
			ZShelter.PlaySound("sound/shigure/ping_vector.mp3")
		else
			if(ent:IsNPC()) then
				color = Color(255, 55, 55, 255)
				ZShelter.PlaySound("sound/shigure/ping_enemy.mp3")
			else
				if(ent:IsPlayer()) then
					showHP = true
					color = Color(55, 255, 55, 255)
					ZShelter.PlaySound("sound/shigure/ping_vector.mp3")
				end
			end
		end
	else
		ZShelter.PlaySound("sound/shigure/ping_vector.mp3")
	end

	table.insert(ZShelter.Pings, {
		vec = vec,
		entity = ent,
		color = color,
		hp = showHP,
		alpha = 0,

		alpha_start = 255,
		size_start_mul = 0,

		time = SysTime() + 5,
	})
end)

hook.Add("PreDrawHalos", "ZShelter-Pings", function()
	local ents = {}
	for _, data in ipairs(ZShelter.Pings) do
		if(IsValid(data.entity)) then
			halo.Add({data.entity}, data.color, 3, 3, 1, true, true)
		end
	end
end)

surface.CreateFont("ZShelter-PingHPFont", {
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

local mdown = false
local nextping = 0
local mat = Material("zsh/icon/ping.png", "smooth")
hook.Add("HUDPaint", "ZShelter-Pings", function()
	local down = input.IsMouseDown(109)
	if(nextping < SysTime() && !mdown && down) then
		local tr = LocalPlayer():GetEyeTrace()
		local ent = tr.Entity
		if(!IsValid(ent)) then
			ent = game.GetWorld()
		end
		net.Start("ZShelter_SendPings")
		net.WriteVector(tr.HitPos)
		net.WriteEntity(ent)
		net.SendToServer()
		nextping = SysTime() + 0.5
	end

	surface.SetMaterial(mat)

	local size = ScreenScaleH(10)
	local size_half = size * 0.5
	local time = SysTime()
	local hpbarSize = ScreenScaleH(10)
	local hpbarT = ScreenScaleH(2)
	for _, data in ipairs(ZShelter.Pings) do
		if(data.time > time) then
			data.alpha = math.Clamp(data.alpha + ZShelter.GetFixedValue(15), 0, 255)
		else
			data.alpha = math.Clamp(data.alpha - ZShelter.GetFixedValue(15), 0, 255)
			if(data.alpha <= 0) then
				table.remove(ZShelter.Pings, _)
			end
		end

		local clr = data.color
		local pos = data.vec:ToScreen()
		if(IsValid(data.entity)) then
			local ent = data.entity
			data.vec = ent:GetPos() + ent:OBBCenter()
			if(data.hp) then
				if(!ent.LerpedHP) then
					ent.LerpedHP = ent:Health()
				else
					ent.LerpedHP = math.Clamp(ent.LerpedHP + ZShelter.GetFixedValue((ent:Health() - ent.LerpedHP) * 0.2), 0, ent:GetMaxHealth())
				end
				local fraction = math.Clamp(ent.LerpedHP / ent:GetMaxHealth(), 0, 1)
				local fraction_rev = 1 - fraction
				ZShelter:CircleTimerAnimation(pos.x, pos.y, hpbarSize, hpbarT, fraction, Color(255 * fraction_rev, 255 * fraction, 0, data.alpha))
				draw.DrawText(ent:Health().."/"..ent:GetMaxHealth(), "ZShelter-PingHPFont", pos.x, pos.y + hpbarSize, Color(255, 255, 255, data.alpha), TEXT_ALIGN_CENTER)
				surface.SetMaterial(mat)
			else
				surface.SetDrawColor(clr.r, clr.g, clr.b, data.alpha)
				surface.DrawTexturedRect(pos.x - size_half, pos.y - size_half, size, size)
			end
		else
			surface.SetDrawColor(clr.r, clr.g, clr.b, data.alpha)
			surface.DrawTexturedRect(pos.x - size_half, pos.y - size_half, size, size)
		end

		if(data.alpha_start > 0) then
			local size = size * data.size_start_mul
			local size_half = size * 0.5
			surface.SetDrawColor(clr.r, clr.g, clr.b, data.alpha_start)
			surface.DrawTexturedRect(pos.x - size_half, pos.y - size_half, size, size)

			data.size_start_mul = data.size_start_mul + ZShelter.GetFixedValue(0.65)
			data.alpha_start = math.Clamp(data.alpha_start - ZShelter.GetFixedValue(20), 0, 255)
		end
	end

	mdown = down
end)