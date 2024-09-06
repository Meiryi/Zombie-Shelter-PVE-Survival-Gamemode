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

surface.CreateFont("ZShelter-BlueprintHint", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(18),
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

ZShelter.BlueprintNotify = nil

net.Receive("ZShelter-BroadcastBlueprintHint", function()
	ZShelter.BlueprintHint(net.ReadString())
end)

local blueprint = Material("zsh/icon/blueprint.png")
function ZShelter.BlueprintHint(text)
	if(IsValid(ZShelter.BlueprintNotify)) then
		ZShelter.BlueprintNotify:Remove()
	end
	local ui = ZShelter.CreatePanel(nil, 0, ScrH() * 0.6, 1, ScrH() * 0.1, Color(0, 0, 0, 255))
	ui.Wide = 1
	ui.AlphaMul = 0
	ui.KillTime = SysTime() + 2.5
	ui.Think = function()
		if(ui.KillTime < SysTime() && ui.Wide <= 1) then
			ui:Remove()
		end
	end
	local padding = ScreenScaleH(4)
	local translated = ZShelter_GetTranslate("#"..text)
	local tw, th = ZShelter.GetTextSize("ZShelter-BlueprintHint", translated)
	local targetWide = ui:GetTall() + tw + padding * 2
	ui.Paint = function()
		draw.RoundedBox(0, 0, 0, ui:GetWide(), ui:GetTall(), Color(0, 0, 0, 125))

		surface.SetMaterial(blueprint)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(0, 0, ui:GetTall(), ui:GetTall())
		if(ui.KillTime > SysTime()) then
			ui.Wide = math.Clamp(ui.Wide + ZShelter.GetFixedValue((targetWide - ui.Wide) * 0.15), 1, targetWide)
		else
			ui.Wide = math.Clamp(ui.Wide - ZShelter.GetFixedValue(ui.Wide * 0.15), 1, targetWide)
		end
		ui:SetWide(ui.Wide)
	end

	local _, _, label = ZShelter.CreateLabel(ui, ui:GetTall() + (targetWide - ui:GetTall()) / 2, ui:GetTall() / 2, translated, "ZShelter-BlueprintHint", Color(255, 255, 255, 255))
		label:CentPos()
	ZShelter.BlueprintNotify = ui
end