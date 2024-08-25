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

ZShelter.UnsupportedMap = ZShelter.UnsupportedMap || false
ZShelter.EditMode = ZShelter.EditMode || false
ZShelter.MapEnts = ZShelter.MapEnts || {}
ZShelter.EntList = ZShelter.EntList || {}
ZShelter.MapEdit_PreviewEntity = ZShelter.MapEdit_PreviewEntity || nil
ZShelter.MapEdit_Yaw = 0

local keystates = {}
local keys = {
	KEY_F3,
	KEY_R,
	KEY_G,
}
local mouse = {
	MOUSE_LEFT,
	MOUSE_RIGHT,
}

local datas = {
	[1] = {
		type = "shelter",
		class = "info_zshelter_shelter_position",
		model = "models/shigure/shelter_b_shelter03.mdl",
		required = 1,
		offset = Vector(0, 0, 0),
		title = "#ShelterPos",
		desc = "#ShelterDesc",
	},
	[2] = {
		type = "barricade",
		class = "prop_zshelter_obstacle",
		model = "models/props_wasteland/cargo_container01.mdl",
		required = -1,
		offset = Vector(0, 0, 60),
		title = "#BarricadePos",
		desc = "#BarricadeDesc",
	},
	[3] = {
		type = "treasure",
		class = "info_zshelter_treasure_area",
		model = "models/props_docks/channelmarker_gib03.mdl",
		required = -1,
		offset = Vector(0, 0, 45),
		title = "#TreasurePos",
		desc = "#TreasureDesc",
	},
	[4] = {
		type = "bonus",
		class = "info_zshelter_resource_bonus_area",
		model = "models/props_docks/channelmarker_gib04.mdl",
		required = -1,
		offset = Vector(0, 0, 45),
		title = "#BonusPos",
		desc = "#BonusDesc",
	},
	[5] = {
		type = "spawnpoint_extra",
		class = "info_zshelter_extra_enemy_spawn",
		model = "models/Zombie/Classic.mdl",
		required = -1,
		offset = Vector(0, 0, 1),
		title = "#SpawnPointExtra",
		desc = "#SpawnPointExtraDesc",
	},
	[6] = {
		type = "spawnpoint_extra",
		class = "info_zshelter_dedicated_enemy_spawn",
		model = "models/Zombie/Poison.mdl",
		required = -1,
		offset = Vector(0, 0, 1),
		title = "#SpawnPointDedicated",
		desc = "#SpawnPointDedicatedDesc",
	}
}

function ZShelter.RemoveAllMapEnt()
	for k,v in pairs(ZShelter.EntList) do
		if(IsValid(v)) then
			v:Remove()
		end
		ZShelter.EntList[k] = nil
	end
end

function ZShelter.RemoveMapEnt(type, index)
	if(!ZShelter.MapEnts[type] || !ZShelter.MapEnts[type][index]) then return end

	ZShelter.MapEnts[type][index] = nil
	if(ZShelter.EntList[index] && IsValid(ZShelter.EntList[index])) then
		ZShelter.EntList[index]:Remove()
	end
end

function ZShelter.AddMapEntity(type, pos, yaw, offset, index, model, class)
	if(!ZShelter.MapEnts[type]) then
		ZShelter.MapEnts[type] = {}
	end
	local ent = ClientsideModel(model)
	ent:SetPos(pos + offset)
	ent:SetAngles(Angle(0, yaw, 0))
	ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
	ent:SetColor(Color(120, 255, 120, 200))
	ent:SetSolid(SOLID_VPHYSICS)
	ent:SetSolidFlags(1)
	ent.type = type
	ent.index = index
	ZShelter.MapEnts[type][index] = {
		vec = pos + offset,
		offs = offset,
		yaw = yaw,
		class = class,
		temp = ent,
	}
	ZShelter.EntList[index] = ent -- Keep track of them just in case
end

function ZShelter.IsInSight(ent)
	local cx, cy = ScrW() * 0.5, ScrH() * 0.5
	local pos = ent:GetPos():ToScreen()
	local insight = math.Distance(cx, cy, pos.x, pos.y) < 100
	if(insight) then
		local str = ZShelter_GetTranslate("#EditModeHintAim")
		draw.DrawText(str, "TargetID", pos.x, pos.y, Color(255, 100, 100, 255), TEXT_ALIGN_CENTER)
	else
		draw.DrawText("X", "TargetID", pos.x, pos.y, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end
	return insight
end

local waitForRelease = false
function ZShelter.CreatePreviewEntity(type, model, offset, class)
	local eIndex = bit.tohex(math.random(1, 65535), 4)
	ZShelter.MapEdit_PreviewEntity = ClientsideModel(model)
	ZShelter.MapEdit_PreviewEntity:SetRenderMode(RENDERMODE_TRANSCOLOR)
	ZShelter.MapEdit_PreviewEntity:SetColor(Color(255, 255, 255, 200))
	ZShelter.MapEdit_PreviewEntity.Offset = offset
	ZShelter.MapEdit_PreviewEntity.eIndex = eIndex
	ZShelter.MapEdit_PreviewEntity.type = type
	ZShelter.MapEdit_PreviewEntity.__class = class
	ZShelter.MapEdit_Yaw = 0
end

ZShelter.SettingsUI = ZShelter.SettingsUI || nil
function ZShelter.OpenSettingsMenu()
	if(IsValid(ZShelter.SettingsUI)) then
		ZShelter.SettingsUI:Remove()
		return
	end
	local dockmargin = ScreenScaleH(4)
	local innermargin = ScreenScaleH(2)
	local textmargin = ScreenScaleH(1)
	local margin = ScreenScaleH(16)

	local ui = ZShelter.CreateFrame(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 120))
	ui:MakePopup()
	ui:Center()
	ui.oPaint = ui.Paint
	ui.Paint = function()
		if(!ZShelter.EditMode || !ZShelter.UnsupportedMap) then
			ui:Remove()
			return
		end
		ZShelter.DrawBlur(ui, 2)
		ui.oPaint(ui)
	end
	local side, top = ScrW() * 0.2, ScrH() * 0.2
	local list = ZShelter.CreateScroll(ui, side, top, ui:GetWide() - side * 2, ui:GetTall() - top * 2, Color(30, 30, 30, 200))
	local tall = (list:GetTall() / #datas) - 3
	local cancomplete = true
	for k,v in ipairs(datas) do
		local base = ZShelter.CreateFrame(list, 0, 0, ui:GetWide(), tall, Color(30, 30, 30, 255))
			base:Dock(TOP)
			base:DockMargin(0, 2, 0, 0)
			local tw, th = ZShelter.CreateLabel(base, dockmargin, dockmargin, ZShelter_GetTranslate(v.title), "ZShelter-MenuTitle", Color(255, 255, 255, 255))
			ZShelter.CreateLabel(base, dockmargin, dockmargin + th + innermargin, ZShelter_GetTranslate(v.desc), "ZShelter-MenuLarge", Color(255, 255, 255, 255))

		local count = 0
		if(ZShelter.MapEnts[v.type]) then
			count = table.Count(ZShelter.MapEnts[v.type])
		end
		if(v.required != -1) then
			local tw, th, text = ZShelter.CreateLabel(base, dockmargin, base:GetTall(), v.required.."/"..count, "ZShelter-HUDFont", Color(255, 255, 255, 255))
			text:SetY(text:GetY() - (th + dockmargin))

			if(v.required > count) then
				cancomplete = false
			end
		end
		local btn = ZShelter.InvisButton(base, 0, 0, base:GetWide(), base:GetTall(), function()
			ui:Remove()
			ZShelter.CreatePreviewEntity(v.type, v.model, v.offset, v.class)
			ZShelter.IsChoosingPlacePos = true
		end)
	end
	local wide = list:GetWide() * 0.8
	local button = ZShelter.CreateButton(ui, (ScrW() * 0.5) - wide * 0.5, list:GetY() + list:GetTall() + dockmargin, wide, ScreenScaleH(32), ZShelter_GetTranslate("#FinishSettings"), "ZShelter-HUDFont", Color(255, 255, 255, 255), Color(35, 35, 35, 255), function()
		if(!cancomplete) then return end
		local data, len = ZShelter.CompressTable(ZShelter.MapEnts)
		net.Start("ZShelter-SendMapConfig")
		net.WriteUInt(len, 32)
		net.WriteData(data, len)
		net.SendToServer()
		ZShelter.UnsupportedMap = false
		ZShelter.EditMode = false
	end, ScreenScaleH(4))
	button.Paint = function()
		if(cancomplete) then
			draw.RoundedBox(0, 0, 0, button:GetWide(), button:GetTall(), Color(35, 35, 35, 255))
			button:SetTextColor(Color(255, 255, 255, 255))
		else
			draw.RoundedBox(0, 0, 0, button:GetWide(), button:GetTall(), Color(35, 35, 35, 155))
			button:SetTextColor(Color(255, 255, 255, 155))
		end
	end

	ZShelter.SettingsUI = ui
end

net.Receive("ZShelter-SendMapStats", function()
	ZShelter.UnsupportedMap = net.ReadBool()
	if(!ZShelter.UnsupportedMap) then
		ZShelter.EditMode = false
		hook.Remove("HUDPaint", "ZShelter-SupportHUDPaint")
		if(IsValid(ZShelter.MapEdit_PreviewEntity)) then
			ZShelter.MapEdit_PreviewEntity:Remove()
		end
		ZShelter.MapEnts = {}
		ZShelter.RemoveAllMapEnt()
	end
end)

hook.Add("ZShelter-MapEditKeyPressed", "ZShelter-MapeditKeyHandler", function(key)
	if(!ZShelter.UnsupportedMap || !IsValid(LocalPlayer())) then return end
	if(key == KEY_F3 && LocalPlayer():IsAdmin()) then
		ZShelter.EditMode = !ZShelter.EditMode
	end
	if(key == KEY_R && IsValid(ZShelter.MapEdit_PreviewEntity)) then
		ZShelter.MapEdit_Yaw = ZShelter.MapEdit_Yaw + 45
		if(ZShelter.MapEdit_Yaw >= 360) then
			ZShelter.MapEdit_Yaw = 0
		end
	end
	if(key == KEY_G && ZShelter.EditMode && !ZShelter.IsChoosingPlacePos) then
		ZShelter.OpenSettingsMenu()
	end
end)

ZShelter.IsChoosingPlacePos = false
hook.Add("HUDPaint", "ZShelter-SupportHUDPaint", function()
	if(!ZShelter.UnsupportedMap || !IsValid(LocalPlayer())) then return end
	for k,v in pairs(keys) do
		if(input.IsKeyDown(v)) then
			if(!keystates[v]) then
				hook.Run("ZShelter-MapEditKeyPressed", v)
			end
			keystates[v] = true
		else
			keystates[v] = false
		end
	end
	for k,v in pairs(mouse) do
		if(input.IsMouseDown(v)) then
			if(!keystates[v]) then
				hook.Run("ZShelter-MapEditKeyPressed", v)
			end
			keystates[v] = true
		else
			keystates[v] = false
		end
	end

	if(!ZShelter.EditMode) then
		if(LocalPlayer():IsAdmin()) then
			draw.RoundedBox(0, 0, ScrH() * 0.64, ScrW(), ScrH() * 0.1, Color(0, 0, 0, 150))
			draw.DrawText(ZShelter_GetTranslate("#UnsupportedMap1"), "ZShelter-HUDFont", ScrW() * 0.5, ScrH() * 0.65,  Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			draw.DrawText(ZShelter_GetTranslate("#UnsupportedMapEditMode"), "ZShelter-HUDFont", ScrW() * 0.5, ScrH() * 0.69,  Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		else
			draw.RoundedBox(0, 0, ScrH() * 0.64, ScrW(), ScrH() * 0.06, Color(0, 0, 0, 150))
			draw.DrawText(ZShelter_GetTranslate("#UnsupportedMap1"), "ZShelter-HUDFont", ScrW() * 0.5, ScrH() * 0.65,  Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			ZShelter.EditMode = false
		end
		if(IsValid(ZShelter.MapEdit_PreviewEntity)) then
			ZShelter.MapEdit_PreviewEntity:Remove()
		end
	else
		if(!ZShelter.IsChoosingPlacePos) then
			if(!IsValid(ZShelter.SettingsUI)) then
				draw.RoundedBox(0, 0, ScrH() * 0.64, ScrW(), ScrH() * 0.06, Color(0, 0, 0, 150))
				draw.DrawText(ZShelter_GetTranslate("#EditModeHint"), "ZShelter-HUDFont", ScrW() * 0.5, ScrH() * 0.65,  Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			end
			local keydown = LocalPlayer():KeyDown(2048)
			for k,v in pairs(ZShelter.EntList) do
				if(!IsValid(v)) then
					ZShelter.EntList[k] = nil
					continue
				end
				if(ZShelter.IsInSight(v)) then
					v:SetColor(Color(255, 150, 150, 200))
					if(keydown && !waitforrelease) then
						ZShelter.RemoveMapEnt(v.type, v.index)
						continue
					end
				else
					v:SetColor(Color(120, 255, 120, 200))
				end
			end
			waitforrelease = keydown
			if(IsValid(ZShelter.MapEdit_PreviewEntity)) then
				ZShelter.MapEdit_PreviewEntity:Remove()
			end
		else
			if(IsValid(ZShelter.MapEdit_PreviewEntity)) then
				draw.DrawText(ZShelter_GetTranslate("#EditModeHintPlace"), "ZShelter-HUDFont", ScrW() * 0.5, ScrH() * 0.65,  Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
				local pos = util.QuickTrace(LocalPlayer():GetEyeTrace().HitPos, Vector(0, 0, -65536)).HitPos
				ZShelter.MapEdit_PreviewEntity:SetPos(pos + (ZShelter.MapEdit_PreviewEntity.Offset || Vector(0, 0, 0)))
				ZShelter.MapEdit_PreviewEntity:SetAngles(Angle(0, ZShelter.MapEdit_Yaw, 0))
				if(LocalPlayer():KeyDown(1)) then
					ZShelter.AddMapEntity(ZShelter.MapEdit_PreviewEntity.type, pos, ZShelter.MapEdit_Yaw, ZShelter.MapEdit_PreviewEntity.Offset, ZShelter.MapEdit_PreviewEntity.eIndex, ZShelter.MapEdit_PreviewEntity:GetModel(), ZShelter.MapEdit_PreviewEntity.__class)
					ZShelter.MapEdit_PreviewEntity:Remove()
					ZShelter.IsChoosingPlacePos = false
				end
				if(LocalPlayer():KeyDown(2048)) then
					ZShelter.MapEdit_PreviewEntity:Remove()
					ZShelter.IsChoosingPlacePos = false
				end
			end
		end
	end
end)