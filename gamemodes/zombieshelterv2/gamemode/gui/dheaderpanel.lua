surface.CreateFont("DefaultFont", {
    size = ScreenScale( 8 ),
    weight = 32,
    antialias = true,
    font = "Arial",
})

function EasyLabel(parent, text, font, textcolor)
    local ELpanel = vgui.Create("DLabel", parent)
    if font then
        ELpanel:SetFont("DefaultFont")
    end
    ELpanel:SetText(text)
    ELpanel:SizeToContents()
    if textcolor then
        ELpanel:SetTextColor(textcolor)
    end
    ELpanel:SetKeyboardInputEnabled(false)
    ELpanel:SetMouseInputEnabled(false)

    return ELpanel
end

local PANEL = {}
PANEL.m_Team = 0
PANEL.NextRefresh = 0
PANEL.RefreshTime = 2

function PANEL:Init()

    self.m_HeaderPanel = vgui.Create("DPanel", self)
    self.m_HeaderPanel:SetPaintBackground(false)

    self.m_TKLabel = EasyLabel(self.m_HeaderPanel, " ", "Content", color_white)
	self.m_NameLabel = EasyLabel(self.m_HeaderPanel, " ", "Content", color_white)
    self.m_WoodLabel = EasyLabel(self.m_HeaderPanel, " ", "Content", color_white)
    self.m_IronLabel = EasyLabel(self.m_HeaderPanel, " ", "Content", color_white)
    self.m_KillsLabel = EasyLabel(self.m_HeaderPanel, " ", "Content", color_white)
    self.m_DeathsLabel = EasyLabel(self.m_HeaderPanel, " ", "Content", color_white)
    self.m_PingLabel = EasyLabel(self.m_HeaderPanel, " ", "Content", color_white)

	self:InvalidateLayout()
end

function PANEL:Think()
	if RealTime() >= self.NextRefresh then
		self.NextRefresh = RealTime() + self.RefreshTime
		self:RefreshContents()
	end
end

function PANEL:PerformLayout()
    local w = self:GetWide()
	local h = self:GetTall()

    self.m_HeaderPanel:SetSize(w, h)

    self.m_TKLabel:AlignRight(w * 0.3)
    self.m_TKLabel:CenterVertical()
    self.m_TKLabel:SizeToContents()

	self.m_NameLabel:AlignLeft(w * 0.07)
    self.m_NameLabel:CenterVertical()
    self.m_NameLabel:SizeToContents()

    self.m_WoodLabel:AlignRight(w * 0.4)
    self.m_WoodLabel:CenterVertical()
    self.m_WoodLabel:SizeToContents()

    self.m_IronLabel:AlignRight(w * 0.35, 0)
    self.m_IronLabel:CenterVertical()
    self.m_IronLabel:SizeToContents()

    self.m_KillsLabel:AlignRight(w * 0.18, 0)
	self.m_KillsLabel:CenterVertical()
    self.m_KillsLabel:SizeToContents()

    self.m_DeathsLabel:AlignRight(w * 0.087, 0)
	self.m_DeathsLabel:CenterVertical()
    self.m_DeathsLabel:SizeToContents()

    self.m_PingLabel:AlignRight(w * 0.0275)
	self.m_PingLabel:CenterVertical()
    self.m_PingLabel:SizeToContents()

end

function PANEL:RefreshContents()

    local w = self:GetWide()

	self.m_NameLabel:SetText(ZShelter_GetTranslate("#Name"))
    self.m_NameLabel:SizeToContents()

    self.m_WoodLabel:SetText(ZShelter_GetTranslate("#Woods"))
    self.m_WoodLabel:SizeToContents()

    self.m_IronLabel:SetText(ZShelter_GetTranslate("#Irons"))
    self.m_IronLabel:SizeToContents()

    self.m_TKLabel:SetText(ZShelter_GetTranslate("#TK"))
    self.m_TKLabel:SizeToContents()

    self.m_KillsLabel:SetText(ZShelter_GetTranslate("#Contribute"))
    self.m_KillsLabel:SizeToContents()

    self.m_DeathsLabel:SetText(ZShelter_GetTranslate("#Deaths"))
    self.m_DeathsLabel:SizeToContents()

    self.m_PingLabel:SetText("Ping")
    self.m_PingLabel:SizeToContents()

	self:InvalidateLayout()
end

function PANEL:Paint()
	local wid, hei = self:GetWide(), self:GetTall()

    draw.RoundedBoxEx(8, 0, 0, wid, hei, Color(25, 25, 25, 210), true, true, false, false)

	--surface.SetDrawColor(40,40,40,200)
	--surface.DrawRect(0, 0, wid, hei)

    surface.SetDrawColor(Color(255,255,255))
	surface.DrawRect(0, hei - 2, wid, 2)

	return true
end

vgui.Register("DHeaderPanel", PANEL, "Panel")