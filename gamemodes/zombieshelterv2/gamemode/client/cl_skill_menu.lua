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

surface.CreateFont("ZShelter-SkillTitle", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(48),
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

surface.CreateFont("ZShelter-SkillDesc", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(16),
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

surface.CreateFont("ZShelter-ClassFont", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(16),
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

local LoadOrder = {
	["Combat"] = 1,
	["Survival"] = 2,
	["Engineer"] = 3,
}
function ZShelter.SkillMenu()
	if(IsValid(ZShelter.CFGMenu)) then return end
	if(IsValid(ZShelter.SkillUI)) then
		ZShelter.SkillUI:Remove()
		return
	end
	ZShelter.ClearMenus()
	local ui = ZShelter.CreatePanel(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 120))
	ui:MakePopup()
	ui:Center()
	ui.oPaint = ui.Paint
	ui.Paint = function()
		ZShelter.DrawBlur(ui, 2)
		ui.oPaint(ui)
	end

	local topPadding = ScreenScaleH(48)
	local dockMargin = ScreenScaleH(4)
	ui.Classes = ZShelter.CreatePanel(ui, topPadding, topPadding, ScrW() - topPadding, ScrH() * 0.05, Color(0, 0, 0, 0))

	ui.SkillDesc = ZShelter.CreatePanel(ui, topPadding, ScrH() * 0.25, ScrW(), ScrH() * 0.25, Color(0, 0, 0, 0))
	local _, tw, title = ZShelter.CreateLabel(ui.SkillDesc, 0, 0, ZShelter_GetTranslate("#Skillpanel_Title"), "ZShelter-SkillTitle", Color(255, 255, 255, 255))
		title:SetWide(ScrW())

	local _, _, descr = ZShelter.CreateLabel(ui.SkillDesc, dockMargin, tw, ZShelter_GetTranslate("#Skillpanel_Desc"), "ZShelter-SkillDesc", Color(255, 255, 255, 255))

	ui.SkillDesc.UpdateInfo = function(title_, desc)
		if(!title_) then
			title_ = "Undefined Skill Title"
		end
		if(!desc) then
			desc = "Undefined Skill Desc"
		end

		title.UpdateText(title_)
		descr.UpdateText(desc)
	end

	local size = ScrH() * 0.4
	ui.ClassIcon = ZShelter.CreateImage(ui, (ScrW() - topPadding) - size, topPadding, size, size, "zsh/class/none.png", Color(255, 255, 255, 10))
	ui.ClassIcon.UpdateClass = function(class)
		local found = file.Exists("materials/zsh/class/"..string.lower(class)..".png", "GAME")
		local path = "zsh/class/"..string.lower(class)..".png"
		if(!found) then
			path = "zsh/class/none.png"
		end
		local fade = ZShelter.CreateImage(ui.ClassIcon, 0, 0, size, size, ui.ClassIcon:GetImage(), Color(255, 255, 255, 10))
			fade.Alpha = 255
			fade.Think = function()
				fade.Alpha = math.Clamp(fade.Alpha - ZShelter.GetFixedValue(15), 0, 255)
				fade:SetAlpha(fade.Alpha)
				if(fade.Alpha <= 0) then
					fade:Remove()
				end
			end
		ui.ClassIcon:SetImage(path)
	end

	local scale = 0.45
	ui.Container = ZShelter.CreatePanelContainer(ui, 0, ScrH() * (1 - scale), ScrW(), ScrH() * scale, Color(40, 40, 40, 200))

	local new = table.Copy(ZShelter.SkillList)
	local load = {}
	local names = {}
	local currentIndex = 1
	for k,v in pairs(new) do
		if(LoadOrder[k]) then
			load[LoadOrder[k]] = v
			names[LoadOrder[k]] = k
			new[k] = nil
			currentIndex = currentIndex + 1
		end
	end

	for k,v in pairs(new) do
		table.insert(load, v)
		names[currentIndex] = k
		currentIndex = currentIndex + 1
	end

	local UltimateWidth = ScreenScaleH(32)
	local TierWidth = (ScrW() * 0.33) - UltimateWidth
	local SkillGap = ScreenScaleH(8)
	local MaxTier = 4
	local rowCount = 3

	local skWide, skTall = ScreenScaleH(40), ScreenScaleH(50)

	for k,v in next, load do
		local name = names[k] || "Undefined"
		local w, h = ZShelter.GetTextSize("ZShelter-ClassFont", ZShelter_GetTranslate("#"..name))

		local pa = ZShelter.CreatePanel(ui.Container, 0, 0, ui.Container:GetWide(), ui.Container:GetTall(), Color(0, 0, 0, 0))
			pa.TierGroup = {}

			for i = 1, MaxTier do
				local wide = TierWidth
				if(i == MaxTier) then
					wide = UltimateWidth * 3
				end
				local group = ZShelter.CreatePanel(pa, TierWidth * (i - 1), 0, wide, ui.Container:GetTall(), Color(0, 0, 0, 0))
				local gap, tall = pa:GetTall() * 0.2, pa:GetTall() * 0.6
				local _w = ScreenScaleH(1)
				group.Paint = function()
					draw.DrawText(ZShelter_GetTranslate_Var("#SkillsTier_X", i), "ZShelter-SkillDesc", 0, 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
					if(i != MaxTier) then
						draw.RoundedBox(0, group:GetWide() - _w, gap, _w, tall, Color(20, 20, 20, 200))
					end
				end

				pa.TierGroup[i] = group
			end

		for x,y in pairs(v) do
			local cont = pa.TierGroup[x]
			local skillAmount = table.Count(y)
			local cols, rows = math.floor((skillAmount - 1) / 3) + 1, math.min(skillAmount, 3)
			local _w, _h = ((cols * skWide) + (math.max(cols - 1, 0) * SkillGap)), ((rows * skTall) + (math.max(rows - 1, 0) * SkillGap))
			local StartX, StartY = (cont:GetWide() / 2) - _w / 2, (cont:GetTall() / 2) - _h / 2
			local cY = 0
			local cX = 0
			local totalWide, totalTall = 0, 0
			for index, skill in pairs(y) do
				cX = math.floor((index - 1) / 3)
				local _x, _y = StartX + (cX * (skWide + SkillGap)), StartY + (cY * (skTall + SkillGap))

				local skillContainer = ZShelter.CreatePanel(pa.TierGroup[x], _x, _y, skWide, skTall, Color(0, 0, 0, 0))
				local path = "zsh/skills/"..skill.icon..".png"
				if(!file.Exists("materials/zsh/skills/"..skill.icon..".png", "GAME")) then
					path = "zsh/icon/questionmark.png"
				end
				local img = ZShelter.CreateImage(skillContainer, 0, 0, skWide, skWide, path, Color(255, 255, 255, 255))

				local maxUpgrade = math.max(skill.maximum, 1)
				local sx = ScreenScaleH(6)
				local outline = ScreenScaleH(1)
				local sqrGap = ScreenScaleH(2)
				local wide = (sx * maxUpgrade) + (sqrGap * (maxUpgrade - 1))
				local __y = (skWide + ((skTall - skWide) / 2)) - (sx / 2)
				skillContainer.Paint = function()
					draw.RoundedBox(0, 0, 0, skWide, skWide, Color(50, 50, 50, 200))
					draw.RoundedBox(0, 0, 0, skWide, skTall, Color(0, 0, 0, 150))
					surface.SetDrawColor(255, 255, 255, 255)
					local STX = (skillContainer:GetWide() / 2) - (wide / 2)
					for i = 1, maxUpgrade do
						if(LocalPlayer():GetNWFloat("SK_"..skill.title, 0) >= i) then
							draw.RoundedBox(0, STX, __y, sx, sx, Color(255, 255, 255, 255))
						else
							surface.DrawOutlinedRect(STX, __y, sx, sx, outline)
						end
						STX = STX + sx + sqrGap
					end
				end
				skillContainer.CanUpgrade = false
				skillContainer.NextCheck = 0
				skillContainer.Think = function()
					if(skillContainer.NextCheck > CurTime()) then return end
					skillContainer.CanUpgrade = ZShelter.AllowedToUpgrade(LocalPlayer(), name, x, index)
					skillContainer.NextCheck = CurTime() + 0.15
				end
				local btn = ZShelter.InvisButton(skillContainer, 0, 0, skillContainer:GetWide(), skillContainer:GetTall(), function()
					if(!skillContainer.CanUpgrade) then return end
					net.Start("ZShelter-UpgradeSkill")
					net.WriteString(name)
					net.WriteInt(x, 32)
					net.WriteInt(index, 32)
					net.SendToServer()
				end)
				btn.Paint = function()
					if(!skillContainer.CanUpgrade && LocalPlayer():GetNWInt("SK_"..skill.title, 0) < maxUpgrade) then
						draw.RoundedBox(0, 0, 0, skillContainer:GetWide(), skillContainer:GetTall(), Color(80, 30, 30, 100))
					end
				end
				btn.OnCursorEntered = function()
					local t, i = ZShelter.PickInfo(skill.title)
					ui.SkillDesc.UpdateInfo(t, i)
				end

				cY = cY + 1
				if(cY >= 3) then
					cY = 0
				end
			end
		end

		ui.Container.AddPanel(pa)

		local classButton = ZShelter.CreatePanel(ui.Classes, 0, 0, h + w + dockMargin * 2, h, Color(0, 0, 0, 0))
			classButton:Dock(LEFT)
			classButton:DockMargin(dockMargin, 0, 0, 0)
			local imgname = string.lower(string.Replace(name, " ", "_"))
			local img = ZShelter.CreateImage(classButton, 0, 0, h, h, "zsh/class/"..imgname..".png", Color(255, 255, 255, 255))
			local _, _, title = ZShelter.CreateLabel(classButton, dockMargin + h, 0, ZShelter_GetTranslate("#"..name), "ZShelter-ClassFont", Color(255, 255, 255, 255))
			local btn = ZShelter.InvisButton(classButton, 0, 0, classButton:GetWide(), classButton:GetTall(), function()
				ui.Container.CurrentPanel = pa
				ui.ClassIcon.UpdateClass(name)
			end)

			btn.Think = function()
				if(ui.Container.CurrentPanel == pa) then
					title:SetColor(Color(255, 255, 255, 255))
					img:SetImageColor(Color(255, 255, 255, 255))
				else
					title:SetColor(Color(100, 100, 100, 255))
					img:SetImageColor(Color(100, 100, 100, 255))
				end
			end

			if(load[k + 1]) then
				local line = ZShelter.CreatePanel(ui.Classes, 0, 0, ScreenScaleH(1), h, Color(255, 255, 255, 255))
					line:Dock(LEFT)
					line:DockMargin(dockMargin, 0, 0, 0)
			end
	end

	ZShelter.SkillUI = ui
	ZShelter.AddMenu(ui)
end
