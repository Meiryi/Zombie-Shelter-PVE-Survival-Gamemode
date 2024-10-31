local toggle = false
concommand.Add("zshelter_toggle_thirdperson", function()
	toggle = !toggle
end)

local cvar = GetConVar("zshelter_thirdperson_distance")
local cvar2 = GetConVar("zshelter_thirdperson_offset")
local cvar3 = GetConVar("zshelter_thirdperson_fade_distance")
hook.Add("CalcView", "ZShelter_Thirdperson", function(ply, pos, angles, fov)
	if(!toggle) then return end
	local tr = {
		start = pos,
		endpos = pos - (angles:Forward() * cvar:GetInt()) + (angles:Right() * cvar2:GetInt()),
		filter = ply,
		mask = MASK_SHOT,
	}
	local ret = util.TraceLine(tr)
	local view = {
		origin = ret.HitPos,
		angles = angles,
		fov = fov,
		drawviewer = true
	}

	if(cvar3:GetInt() > 0) then
		local fraction = math.Clamp(ret.HitPos:Distance(pos) / cvar3:GetInt(), 0, 1)
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetColor(Color(255, 255, 255, 255 * fraction))
	else
		ply:SetColor(Color(255, 255, 255, 255))
	end

	return view
end)