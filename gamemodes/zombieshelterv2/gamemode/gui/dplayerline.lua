
local P_meta = FindMetaTable("Panel")
local P_Player = FindMetaTable("Player")
local P_IsValid = P_meta.IsValid

local PANEL = {}

PANEL.m_Player = NULL
PANEL.NextRefresh = 0
PANEL.RefreshTime = 1

local draw_RoundedBox = draw.RoundedBox

function P_Player:LongName()
	if(!IsValid(self)) then return "Unconnected" end
	local name = self:Name()
	if #name > 25 then
		name = string.sub(name, 1, 25)..".."
	end

	return name
end

function PANEL:Init()

    self.m_AvatarPanel = vgui.Create("DPanel", self)
    self.m_AvatarPanel:SetText(" ")
	self.m_AvatarPanel:SetSize(ScreenScale(16), ScreenScale(16))
	self.m_AvatarPanel:Center()
	self.m_AvatarPanel:SetPaintBackground(false)

    self.m_Avatar = vgui.Create("AvatarImage", self.m_AvatarPanel)
	self.m_Avatar:SetSize(ScreenScale(16), ScreenScale(16))
	self.m_Avatar:SetVisible(false)
	self.m_Avatar:SetMouseInputEnabled(false)

	self.m_PlayerLabel = EasyLabel(self, " ", "Content", COLOR_WHITE)
	self.m_KillsLabel = EasyLabel(self, " ", "Content", COLOR_WHITE)
	self.m_TKLabel = EasyLabel(self, " ", "Content", COLOR_WHITE)
	self.m_WoodLabel = EasyLabel(self, " ", "Content", COLOR_WHITE)
	self.m_IronLabel = EasyLabel(self, " ", "Content", COLOR_WHITE)
	self.m_DeathsLabel = EasyLabel(self, " ", "Content", COLOR_WHITE)
	self.m_PingLabel = EasyLabel(self, " ", "Content", COLOR_WHITE)

    self:InvalidateLayout()
end

function PANEL:Think()
	if RealTime() >= self.NextRefresh then
		self.NextRefresh = RealTime() + self.RefreshTime
		self:RefreshPlayer()
	end
end

function PANEL:PerformLayout()

	self:SetSize(self:GetWide(), ScreenScale(16))

    local w = self:GetWide()
	local h = self:GetTall()

	self.m_AvatarPanel:CenterVertical()

	self.m_PlayerLabel:SizeToContents()
	self.m_PlayerLabel:AlignLeft(w * 0.065)
	self.m_PlayerLabel:CenterVertical()

	self.m_KillsLabel:SizeToContents()
	self.m_KillsLabel:AlignRight((w * 0.215), 0)
	self.m_KillsLabel:CenterVertical()

	self.m_WoodLabel:SizeToContents()
	self.m_WoodLabel:AlignRight((w * 0.4155), 0)
	self.m_WoodLabel:CenterVertical()

	self.m_IronLabel:SizeToContents()
	self.m_IronLabel:AlignRight((w * 0.36), 0)
	self.m_IronLabel:CenterVertical()

	self.m_TKLabel:SizeToContents()
	self.m_TKLabel:AlignRight((w * 0.305), 0)
	self.m_TKLabel:CenterVertical()

	self.m_DeathsLabel:SizeToContents()
	self.m_DeathsLabel:AlignRight(w * 0.111, 0)
	self.m_DeathsLabel:CenterVertical()

	self.m_PingLabel:SizeToContents()
	self.m_PingLabel:AlignRight(w * 0.04, 0)
	self.m_PingLabel:CenterVertical()

end

function PANEL:RefreshPlayer()

	local pl = self:GetPlayer()

	local name = pl:LongName()
	local color = color_white

	self.m_AvatarPanel:CenterVertical()

	self.m_PlayerLabel:SetText( name )
	self.m_PlayerLabel:SetColor( color )
	self.m_PlayerLabel:SizeToContents()
	
	self.m_KillsLabel:SizeToContents()

	local p_death = -1
	local p_frags = -1
	local p_tk = -1
	local p_ping = -1
	local p_wood = -1
	local p_iron = -1
	if(IsValid(pl)) then
		p_frags = pl:Frags()
		p_death = pl:Deaths()
		p_tk = pl:GetNWInt("TKAmount")
		p_ping = pl:Ping()
		p_wood = pl:GetNWInt("Woods")
		p_iron = pl:GetNWInt("Irons")
	end

	self.m_WoodLabel:SetText(p_wood)
	self.m_WoodLabel:SetColor( color )

	self.m_IronLabel:SetText(p_iron)
	self.m_IronLabel:SetColor( color )

	self.m_KillsLabel:SetText(p_frags)
	self.m_KillsLabel:SetColor( color )

	self.m_TKLabel:SizeToContents()
	self.m_TKLabel:SetText(p_tk)
	self.m_TKLabel:SetColor( color )

	self.m_DeathsLabel:SizeToContents()
	self.m_DeathsLabel:SetText(p_death)
	self.m_DeathsLabel:SetColor( color )

	self.m_PingLabel:SizeToContents()
	self.m_PingLabel:SetText(p_ping)
	self.m_PingLabel:SetColor( color )

	self:InvalidateLayout()
end

function PANEL:Paint()
	local pl = self:GetPlayer()
	local clr = Color( 20, 20, 20, 190 )
	if(!IsValid(pl)) then
		clr = Color( 0, 0, 0, 230 )
	else
		if(!pl:Alive()) then
			clr = Color( 65, 20, 20, 230 )
		end
	end

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), clr )
end

function PANEL:SetPlayer(pl)
	self.m_Player = pl or NULL

	self.m_Avatar:SetPlayer(pl)
	self.m_Avatar:SetVisible(true)

	self:RefreshPlayer()
end

function PANEL:GetPlayer()
	return self.m_Player
end

vgui.Register("DPlayerLine", PANEL, "Panel")