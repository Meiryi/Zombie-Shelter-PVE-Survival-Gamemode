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
local nextcheck = 0
local enablefog = true
ZShelter.FogColor = Color(160, 160, 160, 255)

hook.Add("SetupSkyboxFog", "fpsfog_skyfog", function(scale)
	if(!enablefog) then return end
	render.FogMode(1)
	render.FogColor(ZShelter.FogColor.r, ZShelter.FogColor.g, ZShelter.FogColor.b)
	render.FogMaxDensity(1)
	render.FogStart(512)
	render.FogEnd(2048)
	return true
end)


local skip = {
	npc_vj_zshelter_mounted_mg = true,
}
local ch = {
	prop_physics = true,
	prop_physics_override = true,
	prop_physics_multiplayer = true,
	obj_resource_wood = true,
	obj_resource_iron = true,
	CLuaEffect = true,
}

local fogmat = Material("gm_construct/color_room")
local nodrawProcess = 0
hook.Add("PreDrawOpaqueRenderables", "ZShelter-Fogs", function(isDrawingDepth, isDrawSkybox, isDraw3DSkybox)
	if(nextcheck < SysTime()) then
		enablefog = GetConVar("zshelter_enable_fog"):GetInt() == 1
		nextcheck = SysTime() + 0.33
	end
	if(nodrawProcess < SysTime()) then
		local ply = LocalPlayer()
		local pos = ply:GetPos()
		for k,v in pairs(ents.GetAll()) do
			if(skip[v:GetClass()]) then continue end
			if(v:IsNPC() || v:IsPlayer() || ch[v:GetClass()]) then
				if(!enablefog) then
					v:SetNoDraw(false)
					continue
				end
				if(v:GetPos():Distance(pos) > 2100) then
					v:SetNoDraw(true)
				else
					v:SetNoDraw(false)
				end
			end
			v:DrawShadow(false)
		end
		nodrawProcess = SysTime() + 0.1
	end
	if(enablefog && !ZShelter_StopFog) then
		local view = render.GetViewSetup()
		local lookdir = view.angles
		local lookpos = view.origin
		local looknorm = Vector(1,0,0)
		looknorm:Rotate(lookdir)
		render.SetMaterial(fogmat)
		render.DrawQuadEasy((lookpos + looknorm * 2050), looknorm * -1, 10240, 10240, ZShelter.FogColor)
	end
end)

hook.Add("SetupWorldFog", "fpsfog_fog", function()
	if(!enablefog || ZShelter_StopFog) then return end
	render.FogMode(1)
	render.FogColor(ZShelter.FogColor.r, ZShelter.FogColor.g, ZShelter.FogColor.b)
	render.FogMaxDensity(1)
	render.FogStart(512)
	render.FogEnd(2048)
	return true
end)
