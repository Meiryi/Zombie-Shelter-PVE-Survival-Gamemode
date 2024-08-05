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

ZShelter.ReadyPanel = ZShelter.ReadyPanel || nil
surface.CreateFont("ZShelter-ReadyHintFont", {
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
surface.CreateFont("ZShelter-ReadyFont", {
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

function ZShelter.Ready()
	if(!GetGlobalBool("ReadyState")) then return end
	net.Start("ZShelter-Ready")
	net.SendToServer()
end

if(IsValid(ZShelter.ReadyPanel)) then
	ZShelter.ReadyPanel:Remove()
end

local hintText = ZShelter_GetTranslate("#ReadyHint")
ZShelter.ReadyPanel = vgui.Create("DPanel")
ZShelter.ReadyPanel:SetSize(ScrW(), ScrH() * 0.1)
ZShelter.ReadyPanel:SetPos(0, ScrH() * 0.165)
ZShelter.ReadyPanel.Paint = function()
	draw.DrawText(hintText, "ZShelter-ReadyHintFont", ScrW() * 0.5, ZShelter.ReadyPanel:GetTall() * 0.65, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
end

local w, h = ScreenScaleH(64), ScreenScaleH(20)
local margin = ScreenScaleH(4)
local innermargin = ScreenScaleH(2)
local outline = ScreenScaleH(1)
ZShelter.ReadyPanel.ReloadList = function()
	ZShelter.ReadyPanel:Clear()
	local totalWide = 0
	local nextX = 0
	local panels = {}
	local nReady = ZShelter_GetTranslate("#Not Ready")
	local Ready = ZShelter_GetTranslate("#Ready")
	for k,v in pairs(player.GetAll()) do
		local p = vgui.Create("DPanel", ZShelter.ReadyPanel)
			p:SetPos(ScrW() / 2 + nextX)
			p:SetSize(w, h)
			p.Paint = function()
				if(!IsValid(v)) then
					ZShelter.ReadyPanel.ReloadList()
					return
				end
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
				if(!v:GetNWBool("Ready", false)) then
					draw.RoundedBox(0, 0, 0, innermargin, h, Color(255, 50, 50, 255))
					draw.DrawText(nReady, "ZShelter-ReadyFont", p:GetTall() + ((p:GetWide() - p:GetTall()) / 2), p:GetTall() * 0.3, Color(255, 50, 50, 255), TEXT_ALIGN_CENTER)
				else
					draw.RoundedBox(0, 0, 0, innermargin, h, Color(110, 255, 110, 255))
					draw.DrawText(Ready, "ZShelter-ReadyFont", p:GetTall() + ((p:GetWide() - p:GetTall()) / 2), p:GetTall() * 0.3, Color(50, 255, 50, 255), TEXT_ALIGN_CENTER)
				end
			end

			local size = p:GetTall()
			local Avatar = vgui.Create("AvatarImage", p)
				Avatar:SetSize(size, size)
				Avatar:SetPos(innermargin, 0)
				Avatar:SetPlayer(v, 64)

			panels[k] = p
			nextX = nextX + p:GetWide() + margin
	end
	local offset = (nextX / 2)
	for k,v in pairs(panels) do
		v:SetX(v:GetX() - offset)
	end
end

ZShelter.ReadyPanel.PlayerCount = player.GetCount()
ZShelter.ReadyPanel.Think = function()
	if(ZShelter.ReadyPanel.PlayerCount != player.GetCount()) then
		ZShelter.ReadyPanel.ReloadList()
	end
	ZShelter.ReadyPanel.PlayerCount = player.GetCount()
end

ZShelter.ReadyPanel.ReloadList()