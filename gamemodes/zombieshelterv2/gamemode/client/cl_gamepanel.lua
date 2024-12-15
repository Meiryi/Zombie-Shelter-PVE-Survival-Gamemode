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
surface.CreateFont("ZShelter-GameUIButton", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(14),
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

surface.CreateFont("ZShelter-GameUITitle", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(24),
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

surface.CreateFont("ZShelter-GameUIGameUITitle2x", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(18),
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

surface.CreateFont("ZShelter-GameUIDescription", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(14),
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

surface.CreateFont("ZShelter-GameUIStatisticText", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(10),
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

surface.CreateFont("ZShelter-GameUIStatisticTextSmall", {
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

surface.CreateFont("ZShelter-GameUIModifierTitle", {
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

surface.CreateFont("ZShelter-GameUIModifierDesc", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(12),
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

surface.CreateFont("ZShelter-GameUIKeybindTitle", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(18),
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

surface.CreateFont("ZShelter-GameUIKeybindDesc", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(14),
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

local devs_steamid = {
	["76561199185181296"] = true,
	["76561198987271516"] = true,
	["76561198158864042"] = true,
	["76561198329144374"] = true,
}

ZShelter.EnableRanks = false
ZShelter.ConnectAddress = ZShelter.ConnectAddress || "NULL"
ZShelter.GameStatistics = {}
ZShelter.Names = {}
ZShelter.QueuedAvatarID = {}
ZShelter.QueuedAvatarDownload = {}
ZShelter.PlayerLists = {}
ZShelter.Leaderboard = ZShelter.Leaderboard || {}
ZShelter.SelectedMeleeWeapon = 0

net.Receive("ZShelter-SyncMeleeWeapon", function()
	ZShelter.SelectedMeleeWeapon = net.ReadInt(32)
end)

function ZShelter.HTTPFetchStatistics()
	HTTP({
		failed = function(reason)
		end,
		success = function(code, body, headers)
			local ret = util.JSONToTable(body)
			if(!ret) then
				timer.Simple(15, function()
					ZShelter.HTTPFetchStatistics()
				end)
				return
			end
			ZShelter.GameStatistics = ret
		end,
		method = "GET",
		url = "https://meiryiservice.xyz/zshelter/records.txt"
	})
end

function ZShelter.HTTPUpdateStatus()
	http.Post("https://meiryiservice.xyz/zshelter/api/zshelter_status.php", {
			steamid = LocalPlayer():SteamID64(),
			host = GetHostName(),
			map = game.GetMap(),
			addr = ZShelter.ConnectAddress,
			day = tostring(GetGlobalInt("Day", 1)),
			difficulty = tostring(GetConVar("zshelter_difficulty"):GetInt()),
			playercount = tostring(player.GetCount()),
			maxplayer = tostring(game.MaxPlayers()),
		},
		function(body, length, headers, code)
		end,
		function(message)
		end
	)
end

local serverlist = {
--[[ -- Both are dead
	{
		host = "Hamgungus Zombie Shelter",
		address = "45.45.238.187:27015",
	},
]]
	{
		host = "NPCZ | Shelter - discord.gg/npc",
		address = "193.243.190.18:27025",
		maxplayers = 10,
	},
	{
		host = "STUDIO 缔造者 Q群:682625923",
		address = "47.113.148.193:27017",
		maxplayers = 8,
	},
}

local _pnl = nil
function ZShelter.RefreshModifierVote()
	if(IsValid(_pnl) && _pnl.ReloadVotes) then
		_pnl.ReloadVotes()
	end
end

function ZShelter.ReadName()
	local ctx = file.Read("zombie shelter v2/multiplayer/names.txt", "DATA")
	if(ctx) then
		local tab = util.JSONToTable(ctx, false, true)
		if(tab && table.Count(tab) > 0) then
			ZShelter.Names = tab
		end
	end
end

function ZShelter.WriteName(steamid64, name)
	local json = util.TableToJSON(ZShelter.Names)
	file.Write("zombie shelter v2/multiplayer/names.txt", json)
end

function ZShelter.GetName(steamid64)
	if(ZShelter.Names[steamid64]) then
		return ZShelter.Names[steamid64], false
	else
		steamworks.RequestPlayerInfo(steamid64, function(nick)
			local ret = nick
			if(!ret || ret == "" || ret == "anonymous") then
				ret = ZShelter_GetTranslate("#Player_NotFound")
			end
			ZShelter.Names[steamid64] = ret
			ZShelter.WriteName(steamid64, nick)
		end)
		return ZShelter_GetTranslate("#Fetching"), true
	end
end

function ZShelter.AddDockLabel(parent, text, font, sidepadding, toppadding, color)
	local _, _, label = ZShelter.CreateLabel(parent, 0, 0, text, font, color)
		label:Dock(TOP)
		label:DockMargin(sidepadding, toppadding, 0, 0)
end

local nextfetchtime = 0
local fade = Material("zsh/icon/fade.png")
local steammat = Material("zsh/icon/steam.png", "smooth")
local starmat = Material("zsh/icon/star.png", "smooth")
local func = {
	{
		title = "Ranks",
		func = function(ui)
			local function stars(parent, x, y, size, margin, rank)
				if(rank <= 0) then return end
				local currentXPosition = x
				for i = 1, rank do
					local star = ZShelter.CreatePanel(parent, currentXPosition, y, size, size, Color(0, 0, 0, 0))
					star.Paint = function()
						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(starmat)
						surface.DrawTexturedRect(0, 0, size, size)
					end
					currentXPosition = currentXPosition + (size + margin)
				end
			end
			local size = ScreenScaleH(70)
			local sidepadding = ScreenScaleH(4)
			local colorwide = ScreenScaleH(2)
			local gap = ScreenScaleH(2)
			local gap1x = ScreenScaleH(1)
			local textpadding = ScreenScaleH(12)
			local playerRank = 1
			local playerAvatar = ZShelter.CircleAvatar(ui, textpadding, textpadding, size, size, LocalPlayer(), 186)
			local currentRank, currentLevel, currentEXP, nextRequirement = ZShelter.CalculateRank(LocalPlayer():GetNWInt("ZShelterEXP", 0))
			local title = "["..ZShelter.GetLevelTitle(currentLevel).."] "
			local text_w, text_h, text_1 = ZShelter.CreateLabel(ui, playerAvatar:GetX() + playerAvatar:GetWide() + sidepadding * 2, playerAvatar:GetY() + sidepadding * 2, title, "ZShelter-GameUITitle", ZShelter.GetLevelColor(currentLevel))
			local text_w, text_h, text = ZShelter.CreateLabel(ui, playerAvatar:GetX() + playerAvatar:GetWide() + sidepadding * 2 + text_w, playerAvatar:GetY() + sidepadding * 2, LocalPlayer():Nick(), "ZShelter-GameUITitle", Color(255, 255, 255, 255))
			local size = ScreenScaleH(16)
			local _star = ZShelter.CreatePanel(ui, text:GetX() + text:GetWide() + sidepadding, text:GetY() + text:GetTall(), size, size, Color(0, 0, 0, 0))
			_star.Paint = function()
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(starmat)
				surface.DrawTexturedRect(0, 0, size, size)
			end
			_star:SetY(_star:GetY() - _star:GetTall())
			local _, _, ranktext = ZShelter.CreateLabel(ui, _star:GetX() + _star:GetWide(), text:GetY() + (text:GetTall()), "x"..currentRank + (currentLevel * 5), "ZShelter-GameUIDescription", Color(255, 255, 255, 255))
			ranktext:SetY(ranktext:GetY() - ranktext:GetTall())
			local starSize = ScreenScaleH(16)
			stars(ui, text_1:GetX() + gap, text:GetY() + text_h, starSize, 0, currentRank)
			local levelFraction = 0
			if(currentEXP != 0) then
				levelFraction = currentEXP / nextRequirement
			end
			local barwide = ui:GetWide() - ((textpadding * 2) + playerAvatar:GetX() + playerAvatar:GetWide())
			local barX = playerAvatar:GetX() + playerAvatar:GetWide() + textpadding
			local barY = text:GetY() + text_h + textpadding * 1.5
			local bar_background = ZShelter.CreatePanel(ui, barX, barY, barwide, sidepadding, Color(10, 10, 10, 255))
			local bar_exp = ZShelter.CreatePanel(ui, barX, barY, barwide * levelFraction, sidepadding, Color(70, 255, 70, 255))
			local y = bar_exp:GetY() + bar_exp:GetTall() + gap
			local textwide, texttall, text = ZShelter.CreateLabel(ui, barX, y, 0, "ZShelter-GameUIDescription", Color(255, 255, 255, 255))
			local textwide, texttall, text = ZShelter.CreateLabel(ui, barX + bar_background:GetWide(), y, nextRequirement, "ZShelter-GameUIDescription", Color(255, 255, 255, 255)) 
			text:SetX(text:GetX() - textwide)
			local multiplier = math.Round(ZShelter.CalculateEXPMultiplier(GetGlobalInt("Day", 1), GetConVar("zshelter_difficulty"):GetInt()), 2)
			local multiplierColor = Color(255, 255, 255, 255)
			if(multiplier > 1) then
				multiplierColor = Color(100, 255, 100, 255)
			else
				multiplierColor = Color(255, 100, 100, 255)
			end
			local textwide, texttall, text = ZShelter.CreateLabel(ui, barX, y + texttall, "x "..multiplier, "ZShelter-GameUIDescription", multiplierColor) 
			local textwide, texttall, text = ZShelter.CreateLabel(ui, barX + bar_exp:GetWide(), y - (bar_exp:GetTall() + textpadding + gap), currentEXP, "ZShelter-GameUIStatisticTextSmall", Color(255, 255, 255, 255))
			text.CentHor()
			local scl = 0.3
			local scroll = ZShelter.CreateScroll(ui, sidepadding, ui:GetTall() * scl + sidepadding, ui:GetWide() - (sidepadding * 2), ui:GetTall() * (1 - scl) - (sidepadding * 2), Color(25, 25, 25, 255))
			scroll.RefreshLeaderboard = function()
				scroll:Clear()
				local starSize = ScreenScaleH(12)
				for k,v in ipairs(ZShelter.Leaderboard) do
					local panel = ZShelter.CreatePanel(scroll, 0, 0, scroll:GetWide(), scroll:GetTall() * 0.15, Color(20, 20, 20, 255))
						panel:Dock(TOP)
						panel:DockMargin(0, 0, 0, gap)
						local avatar = ZShelter.CreateImage(panel, 0, 0, panel:GetTall(), panel:GetTall(), "zsh/icon/emptyframe.png", Color(255, 255, 255, 255))
						avatar.NextCheck = 0
						avatar.Path = "data/zombie shelter v2/avatars/"..v.steamid..".png"
						avatar.Think = function()
							if(avatar.NextCheck > SysTime()) then return end
							if(file.Exists(avatar.Path, "GAME")) then
								avatar:SetImage(avatar.Path)
								avatar.Think = nil
							else
								if(!ZShelter.QueuedAvatarID[v.steamid]) then
									ZShelter.QueuedAvatarID[v.steamid] = true
									ZShelter.QueuedAvatarDownload[v.steamid] = true
								end
							end
							avatar.NextCheck = SysTime() + 0.33
						end
						local currentRank, currentLevel, currentEXP, nextRequirement = ZShelter.CalculateRank(v.exp)
						local nick, check = ZShelter.GetName(v.steamid)
						local text_wide, text_tall, title = ZShelter.CreateLabel(panel, gap + avatar:GetWide(), gap, "["..ZShelter.GetLevelTitle(currentLevel).."] ", "ZShelter-GameUIGameUITitle2x", ZShelter.GetLevelColor(currentLevel))
						local text_wide, text_tall, nick = ZShelter.CreateLabel(panel, gap + avatar:GetWide() + text_wide, gap, nick, "ZShelter-GameUIGameUITitle2x", Color(255, 255, 255, 255))
						stars(panel, gap + avatar:GetWide()	, nick:GetY() + text_tall + gap, starSize, 0, currentRank)
						if(check) then
							nick.NextCheck = 0
							nick.Think = function()
								if(nick.NextCheck > SysTime()) then return end
								if(ZShelter.Names[v.steamid]) then
									nick.UpdateText(ZShelter.Names[v.steamid])
									nick.Think = nil
								end
								nick.NextCheck = SysTime() + 0.25
							end
						end
						local text_wide, text_tall, exp = ZShelter.CreateLabel(panel, panel:GetWide(), panel:GetTall() * 0.5, v.exp.." EXP", "ZShelter-GameUIGameUITitle2x", Color(255, 255, 255, 255))
						exp.CentVer()
						exp:SetX(exp:GetX() - (text_wide + sidepadding))
						local button = ZShelter.InvisButton(panel, 0, 0, panel:GetWide(), panel:GetTall(), function()
							gui.OpenURL("https://steamcommunity.com/profiles/"..v.steamid)
						end)
						button.Alpha = 0
						button.Paint = function()
							if(button:IsHovered()) then
								button.Alpha = math.Clamp(button.Alpha + ZShelter.GetFixedValue(2), 0, 20)
							else
								button.Alpha = math.Clamp(button.Alpha - ZShelter.GetFixedValue(2), 0, 20)
							end
							draw.RoundedBox(0, 0, 0, button:GetWide(), button:GetTall(), Color(255, 255, 255, button.Alpha))
						end
				end
			end
			ui.NextReloadTime = 0
			ui.Think = function()
				if(#ZShelter.Leaderboard > 0 || ui.NextReloadTime > SysTime()) then return end
				scroll.RefreshLeaderboard()
				ui.NextReloadTime = SysTime() + 1
			end
			scroll.RefreshLeaderboard()

			local bw, bh = ui:GetWide() * 0.15, ScreenScaleH(24)
			local meleeButton = ZShelter.CreateButton(ui, ui:GetWide() - (bw + sidepadding), sidepadding, bw, bh, "Bonus Weapons", "ZShelter-GameUIButton", Color(255, 255, 255, 255), Color(30, 30, 30, 255), function()
				local panel = ZShelter.CreatePanel(ui, 0, 0, ui:GetWide(), ui:GetTall(), Color(30, 30, 30, 255))
				local backButton = ZShelter.CreateButton(panel, panel:GetWide() - (bw + sidepadding), sidepadding, bw, bh, "Back", "ZShelter-GameUIButton", Color(255, 255, 255, 255), Color(30, 30, 30, 255), function()
					panel:Remove()
				end)
				backButton.Paint = function()
					draw.RoundedBox(0, 0, 0, backButton:GetWide(), backButton:GetTall(), Color(30, 30, 30, 255))
					surface.SetDrawColor(255, 255, 255, 255)
					surface.DrawOutlinedRect(0, 0, backButton:GetWide(), backButton:GetTall(), ScreenScaleH(1))
				end

				local top = ScreenScaleH(32)
				local starsize = ScreenScaleH(24)
				local scroll = ZShelter.CreateScroll(panel, sidepadding, top + sidepadding, panel:GetWide() - (sidepadding * 2), panel:GetTall() - (top + sidepadding * 2), Color(20, 20, 20, 255))
				local _, myLevel = ZShelter.CalculateRank(LocalPlayer():GetNWInt("ZShelterEXP", 0))
				for level, melee in ipairs(ZShelter.RankMelees) do
					local pnl = ZShelter.CreatePanel(scroll, 0, 0, scroll:GetWide(), scroll:GetTall() * 0.15, Color(25, 25, 25, 255))
						pnl:Dock(TOP)
						pnl:DockMargin(0, 0, 0, gap)

						local clr = ZShelter.GetLevelColor(level)
						local size = pnl:GetTall() * 2.25
						local icon = ZShelter.CreateImage(pnl, 0, (size - pnl:GetTall()) * -0.5, size, size, "entities/"..melee.icon..".png", Color(255, 255, 255, 255))
						local _, _, title = ZShelter.CreateLabel(pnl, icon:GetX() + icon:GetWide() + sidepadding, sidepadding, melee.name, "ZShelter-GameUIDescription", Color(255, 255, 255, 255))
						local _, _, desc = ZShelter.CreateLabel(pnl, title:GetX(), title:GetY() + title:GetTall() + sidepadding, melee.desc, "ZShelter-GameUIStatisticTextSmall", Color(255, 255, 255, 255))

						local btn = ZShelter.InvisButton(pnl, 0, 0, pnl:GetWide(), pnl:GetTall(), function()
							if(myLevel >= level) then
								net.Start("ZShelter-SelectMeleeWeapon")
									net.WriteInt(level, 32)
								net.SendToServer()
							end
						end)
						btn.Paint = function()
							if(myLevel < level) then
								draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(120, 50, 50, 150))
							end
							if(level == ZShelter.SelectedMeleeWeapon) then
								surface.SetDrawColor(255, 255, 255, 255)
								surface.DrawOutlinedRect(0, 0, btn:GetWide(), btn:GetTall(), ScreenScaleH(1))
							end
						end
						local _, _, require = ZShelter.CreateLabel(btn, pnl:GetWide(), pnl:GetTall() * 0.5, "x"..level * 5, "ZShelter-GameUIStatisticText", clr)
						require:SetPos(require:GetX() - (require:GetWide() + sidepadding * 2), require:GetY() - require:GetTall() * 0.5)
						local _star = ZShelter.CreatePanel(btn, require:GetX() - starsize, pnl:GetTall() * 0.5 - starsize * 0.5, starsize, starsize, Color(0, 0, 0, 0))
						_star.Paint = function()
							surface.SetDrawColor(clr.r, clr.g, clr.b, 255)
							surface.SetMaterial(starmat)
							surface.DrawTexturedRect(0, 0, starsize, starsize)
						end
				end
			end)
			meleeButton.Paint = function()
				draw.RoundedBox(0, 0, 0, meleeButton:GetWide(), meleeButton:GetTall(), Color(30, 30, 30, 255))
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawOutlinedRect(0, 0, meleeButton:GetWide(), meleeButton:GetTall(), ScreenScaleH(1))
			end
		end,
	},
	{
		title = "ModifiersList",

		func = function(ui)
			local categories = {}
			local categoryColor = {}
			for k,v in pairs(ZShelter.Modifiers.List) do
				if(!categories[v.category]) then
					categories[v.category] = {}
				end
				categoryColor[v.category] = v.categoryColor
				table.insert(categories[v.category], v)
			end

			local sidePanel = ZShelter.CreateScroll(ui, 0, 0, ui:GetWide() * 0.2, ui:GetTall(), Color(0, 0, 0, 0))
			local sidepadding = ScreenScaleH(4)
			local sidepadding2x = sidepadding * 2
			local selectedDiff = 1
			local colorwide = ScreenScaleH(2)
			local gap = ScreenScaleH(2)
			local gap1x = ScreenScaleH(1)
			local textpadding = ScreenScaleH(12)
			local textpadding_2 = ScreenScaleH(8)
			local height = ScreenScaleH(32)
			local elemTall = ScreenScaleH(52)
			local container = ZShelter.CreatePanelContainer(ui, sidePanel:GetWide(), 0, ui:GetWide() - sidePanel:GetWide(), ui:GetTall(), Color(20, 20, 20, 255))
			local first = true
			local displayEXPInformation = GetConVar("zshelter_enable_ranks"):GetInt() == 1
			local pnls = {}
			_pnl = ui

			_pnl.ReloadVotes = function()
				for _, pnl in ipairs(pnls) do
					pnl.AvatarLayer.Reload()
				end
			end
			for category, modifiers in pairs(categories) do
				local diffpanel = ZShelter.CreateScroll(container, 0, 0, container:GetWide(), container:GetTall(), Color(0, 0, 0, 0))
				for _, modifier in pairs(modifiers) do
					local pnl = ZShelter.CreatePanel(diffpanel, 0, 0, diffpanel:GetWide(), elemTall, Color(25, 25, 25, 255))
						pnl:Dock(TOP)
						pnl:DockMargin(0, 0, 0, sidepadding)
						local append = ""
						if(displayEXPInformation) then
							if(modifier.scoreMul > 1) then
								append = ZShelter_GetTranslate("#XP_Mod_Plus1")..((modifier.scoreMul - 1) * 100)..ZShelter_GetTranslate("#XP_Mod_Plus2")
							else
								append = ZShelter_GetTranslate("#XP_Mod_Minus1")..((1 - modifier.scoreMul) * 100)..ZShelter_GetTranslate("#XP_Mod_Minus2")
							end
						end
						local _, _, title = ZShelter.CreateLabel(pnl, sidepadding, sidepadding, ZShelter_GetTranslate("#"..modifier.title || "NULL")..append, "ZShelter-GameUIModifierTitle", Color(255, 255, 255, 255))
						local _, _, desc = ZShelter.CreateLabel(pnl, sidepadding, 0, ZShelter_GetTranslate("#"..modifier.desc) || "NULL", "ZShelter-GameUIModifierDesc", Color(255, 255, 255, 255))
						desc:SetY(pnl:GetTall() - desc:GetTall() - textpadding_2)

						local stringIndex = modifier.title.."Voted"
						pnl.AvatarLayer = ZShelter.CreatePanel(pnl, 0, 0, pnl:GetWide(), pnl:GetTall(), Color(0, 0, 0, 0))
						pnl.AvatarLayer.Votes = 0
						pnl.AvatarLayer.Reload = function(first)
							pnl.AvatarLayer:Clear()
							pnl.AvatarLayer.Votes = 0

							local size = ScreenScaleH(18)
							local nextX = pnl:GetWide() - textpadding - size
							local Y = pnl:GetTall() - size - sidepadding
							if(first) then
								for _, ply in ipairs(player.GetAll()) do
									if(!ply:GetNWBool(stringIndex)) then continue end
									local avatar = ZShelter.CircleAvatar(pnl.AvatarLayer, nextX, Y, size, size, ply, 64)
									nextX = nextX - size - sidepadding
									pnl.AvatarLayer.Votes = pnl.AvatarLayer.Votes + 1
								end
							else
								if(!ZShelter.Modifiers.VoteList[modifier.title]) then return end
								for index, voted in pairs(ZShelter.Modifiers.VoteList[modifier.title]) do
									local ply = Entity(index)
									if((!IsValid(ply) && !ply:IsPlayer()) || !voted) then continue end
									local avatar = ZShelter.CircleAvatar(pnl.AvatarLayer, nextX, Y, size, size, ply, 64)
									nextX = nextX - size - sidepadding
									pnl.AvatarLayer.Votes = pnl.AvatarLayer.Votes + 1
								end
							end
						end

						pnl.AvatarLayer.Reload(true)

						local btn = ZShelter.InvisButton(pnl, 0, 0, pnl:GetWide(), pnl:GetTall(), function()
							net.Start("ZShelter_SendVoteModifiers")
							net.WriteString(modifier.title)
							net.SendToServer()
						end)
						btn.Alpha = 0
						btn.Paint = function()
							if(btn:IsHovered()) then
								btn.Alpha = math.Clamp(btn.Alpha + ZShelter.GetFixedValue(2), 0, 20)
							else
								btn.Alpha = math.Clamp(btn.Alpha - ZShelter.GetFixedValue(2), 0, 20)
							end
							draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(255, 255, 255, btn.Alpha))
							if(pnl.AvatarLayer.Votes > 0 && pnl.AvatarLayer.Votes >= math.Round(player.GetCount() * 0.5)) then
								surface.SetDrawColor(255, 255, 255, 255)
								surface.DrawOutlinedRect(0, 0, btn:GetWide(), btn:GetTall(), gap1x)
							else
								local required = math.Round(player.GetCount() * 0.5) - pnl.AvatarLayer.Votes
								draw.DrawText("[-"..required.."]", "ZShelter-GameUIDescription", btn:GetWide() - textpadding, sidepadding, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
							end
						end

					table.insert(pnls, pnl)
				end

				container.AddPanel(diffpanel)
				if(first) then
					selectedDiff = category
					container.CurrentPanel = diffpanel
					first = false
				end

				local panel = ZShelter.CreatePanel(sidePanel, 0, 0, sidePanel:GetWide(), height, Color(25, 25, 25, 255))
					panel:Dock(TOP)
					panel:DockMargin(0, 0, 0, gap)
					panel.AvatarLayer = ZShelter.CreatePanel(panel, 0, 0, panel:GetWide(), panel:GetTall(), Color(0, 0, 0, 0))
					local _, _, dif = ZShelter.CreateLabel(panel, sidepadding, panel:GetTall() / 2, ZShelter_GetTranslate("#"..category), "ZShelter-SummeryButton", Color(255, 255, 255, 255))
					dif:CentVer()
					local color = categoryColor[category] || Color(255, 255, 255, 255)
					local wide = 0
					local btn = ZShelter.InvisButton(panel, 0, 0, panel:GetWide(), panel:GetTall(), function()
						container.CurrentPanel = diffpanel
						selectedDiff = category
					end)
					panel.Paint = function()
						draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), Color(30, 30, 30, 255))
						draw.RoundedBox(0, 0, 0, colorwide, panel:GetTall(), color)
						if(btn:IsHovered() || selectedDiff == category) then
							wide = math.Clamp(wide + ZShelter.GetFixedValue((panel:GetWide() - wide) * 0.15), 0, panel:GetWide())
						else
							wide = math.Clamp(wide - ZShelter.GetFixedValue(wide * 0.15), 0, panel:GetWide())
						end
						surface.SetDrawColor(color.r, color.g, color.b, 80)
						surface.SetMaterial(fade)
						surface.DrawTexturedRect(0, 0, wide, panel:GetTall())
					end
				end
		end,
	},
	--[[ I'm too lazy to write this
	{
		title = "Updates",
		func = function(ui)
			local scroll = ZShelter.CreateScroll(ui, 0, 0, ui:GetWide(), ui:GetTall(), Color(0, 0, 0, 0))
			local pad1x = ScreenScaleH(4)
			local pad2x = ScreenScaleH(8)
			local pad3x = ScreenScaleH(12)
			local pad4x = ScreenScaleH(30)
			ZShelter.AddDockLabel(scroll, "Zombie Shelter v"..ZShelter.GameVersion, "ZShelter-GameUITitle", pad2x, pad2x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "- Changes", "ZShelter-GameUIGameUITitle2x", pad3x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "Config will be exported to 'garrysmod/data/zombie shelter v2/config/' now", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "Musics can be changed via these convars", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "    > zshelter_music_night", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "    > zshelter_music_countdown", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "    > zshelter_music_horde", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "Increased Advanced Gathering's resource bonus chance from 7% to 10%", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "Advanced Gathering guarantee one bonus resource every 6 hit", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "Healing Station is now upgradable, +3 HP recovery every upgrade", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "Armor Box is now upgradable, +2 Armor recovery every upgrade", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255)) 
			ZShelter.AddDockLabel(scroll, "- Bug Fixes", "ZShelter-GameUIGameUITitle2x", pad3x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "Export config now exports correct enemy config instead of building config", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "Corrected crowbar upgrade's description", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "Scoreboard no longer creating errors when someone leaved", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "Advanced Gathering now works with Resource Transporting", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255))
			ZShelter.AddDockLabel(scroll, "Railgun Cannon now face to correct angle when placing it", "ZShelter-GameUIDescription", pad4x, pad1x, Color(255, 255, 255, 255))
		end,
	},
	]]
	{
		title = "EnemyList",
		func = function(ui)
			local sidePanel = ZShelter.CreateScroll(ui, 0, 0, ui:GetWide() * 0.2, ui:GetTall(), Color(0, 0, 0, 0))
			local sidepadding = ScreenScaleH(4)
			local sidepadding2x = sidepadding * 2
			local selectedDiff = 1
			local colorwide = ScreenScaleH(2)
			local gap = ScreenScaleH(2)
			local gap1x = ScreenScaleH(1)
			local textpadding = ScreenScaleH(12)
			local height = (ui:GetTall() / ZShelter.MaximumDifficulty) - gap
			local container = ZShelter.CreatePanelContainer(ui, sidePanel:GetWide(), 0, ui:GetWide() - sidePanel:GetWide(), ui:GetTall(), Color(20, 20, 20, 255))
			local hpmat = Material("zsh/icon/health.png", "smooth")
			local atkmat = Material("zsh/icon/attack.png", "smooth")
			local skmat = Material("zsh/icon/skull_full.png", "smooth")
			local daycountmat = Material("zsh/icon/day_count.png", "smooth")
			local daymat = Material("zsh/icon/day.png", "smooth")
			local nightmat = Material("zsh/icon/night.png", "smooth")
			for i = 1, ZShelter.MaximumDifficulty do
				local diffpanel = ZShelter.CreateScroll(container, 0, 0, container:GetWide(), container:GetTall(), Color(0, 0, 0, 0))
				local list = {}
				local bosses = {}
				for k,v in ipairs(ZShelter.EnemyList) do
					if((v.min_diff > i || v.max_diff < i)) then continue end
					if(v.treasureboss) then
						table.insert(bosses, v)
					else
						table.insert(list, v)
					end
				end
				table.sort(list, function(a, b) return a.day < b.day end)
				table.sort(bosses, function(a, b) return a.day < b.day end)
				local final = table.Add(bosses, list)
				for k,v in ipairs(final) do
					--if((v.min_diff > i || v.max_diff < i)) then continue end
					local base = ZShelter.CreatePanel(diffpanel, 0, 0, container:GetWide(), container:GetTall() * 0.2, Color(35, 35, 35, 255))
						base:DockMargin(0, gap, 0, 0)
						base:Dock(TOP)
						local tw, th, title = ZShelter.CreateLabel(base, sidepadding + base:GetTall(), sidepadding, v.class, "ZShelter-SummeryButton", Color(255, 255, 255, 255))
						local icon = vgui.Create("SpawnIcon", base)
							icon:SetSize(base:GetTall(), base:GetTall())
							icon:SetModel(v.model)
							icon.Think = function() end
							local sx = ScreenScaleH(14)
							local basex = base:GetTall() + sidepadding
							local basey = base:GetTall() - (sx + sidepadding)
							local dx = base:GetWide() - (base:GetTall() + sidepadding)
							if(v.end_day != -1) then
								local day = ZShelter.CreatePanelMat(base, dx, sidepadding, base:GetTall() - sidepadding2x, base:GetTall() - sidepadding2x, daycountmat, Color(255, 255, 255, 255))
								local x, y = day:GetWide() * 0.5, day:GetTall() * 0.35
								day.Paint2x = function()
									draw.DrawText(v.end_day, "ZShelter-GameUITitle", x, y, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
								end
								dx = dx - base:GetTall() + gap
							end
							local day = ZShelter.CreatePanelMat(base, dx, sidepadding, base:GetTall() - sidepadding2x, base:GetTall() - sidepadding2x, daycountmat, Color(255, 255, 255, 255))
							local x, y = day:GetWide() * 0.5, day:GetTall() * 0.35
							day.Paint2x = function()
								draw.DrawText(v.day, "ZShelter-GameUITitle", x, y, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
							end
							local icony = basey - sx - gap * 2
							if(v.treasureboss) then
								ZShelter.CreatePanelMat(base, basex, icony, sx, sx, skmat, Color(255, 255, 255, 255))
							else
								if(v.night) then
									ZShelter.CreatePanelMat(base, basex, icony, sx, sx, nightmat, Color(255, 255, 255, 255))
								else
									ZShelter.CreatePanelMat(base, basex, icony, sx, sx, daymat, Color(255, 255, 255, 255))
								end
							end
							ZShelter.CreatePanelMat(base, basex, basey, sx, sx, hpmat, Color(255, 255, 255, 255))
							local _x = basex + sx + gap
							local _y = basey + sx * 0.5
							local tw, th, text = ZShelter.CreateLabel(base, _x, _y, v.hp, "ZShelter-GameUIDescription", Color(255, 255, 255, 255))
							if(v.hp_boost_day > 0) then
								text:Remove()
								tw, th, text = ZShelter.CreateLabel(base, _x, _y, v.hp.." + "..ZShelter_GetTranslate_Var("#EnemyListHPBoost", v.hp_boost_day), "ZShelter-GameUIDescription", Color(255, 255, 255, 255))
							end
							text.CentVer()
							_x = _x + tw + sidepadding
							ZShelter.CreatePanelMat(base, _x, basey, sx, sx, atkmat, Color(255, 255, 255, 255))
							_x = _x + sx + gap
							local tw, th, text = ZShelter.CreateLabel(base, _x, _y, v.damage, "ZShelter-GameUIDescription", Color(255, 255, 255, 255))
							text.CentVer()
				end

				container.AddPanel(diffpanel)
				if(i == 1) then
					container.CurrentPanel = diffpanel
				end

				local panel = ZShelter.CreatePanel(sidePanel, 0, 0, sidePanel:GetWide(), height, Color(25, 25, 25, 255))
					panel:Dock(TOP)
					panel:DockMargin(0, 0, 0, gap)
					panel.AvatarLayer = ZShelter.CreatePanel(panel, 0, 0, panel:GetWide(), panel:GetTall(), Color(0, 0, 0, 0))
					local _, _, dif = ZShelter.CreateLabel(panel, sidepadding, panel:GetTall() / 2, ZShelter_GetTranslate("#Dif"..i), "ZShelter-SummeryButton", Color(255, 255, 255, 255))
					dif:CentVer()
					local color = ZShelter.GetDiffColor(i)
					local wide = 0
					local btn = ZShelter.InvisButton(panel, 0, 0, panel:GetWide(), panel:GetTall(), function()
						container.CurrentPanel = diffpanel
						selectedDiff = i
					end)
					panel.Paint = function()
						draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), Color(30, 30, 30, 255))
						draw.RoundedBox(0, 0, 0, colorwide, panel:GetTall(), color)
						if(btn:IsHovered() || selectedDiff == i) then
							wide = math.Clamp(wide + ZShelter.GetFixedValue((panel:GetWide() - wide) * 0.15), 0, panel:GetWide())
						else
							wide = math.Clamp(wide - ZShelter.GetFixedValue(wide * 0.15), 0, panel:GetWide())
						end
						surface.SetDrawColor(color.r, color.g, color.b, 80)
						surface.SetMaterial(fade)
						surface.DrawTexturedRect(0, 0, wide, panel:GetTall())
					end
				end

		end,
	},
	{
		title = "Statistics",
		func = function(ui)
			local sidePanel = ZShelter.CreateScroll(ui, 0, 0, ui:GetWide() * 0.2, ui:GetTall(), Color(0, 0, 0, 0))
			local sidepadding = ScreenScaleH(4)
			local colorwide = ScreenScaleH(2)
			local gap = ScreenScaleH(2)
			local gap1x = ScreenScaleH(1)
			local textpadding = ScreenScaleH(12)
			local height = (ui:GetTall() / ZShelter.MaximumDifficulty) - gap
			local selectedDiff = 1
			local currentdataTable = ZShelter.GameStatistics[selectedDiff] || {}
			local statisticPanel = ZShelter.CreateScroll(ui, sidePanel:GetWide(), 0, ui:GetWide() - sidePanel:GetWide(), ui:GetTall(), Color(20, 20, 20, 255))
			local scl = 0.15
			local DiffString = "#Dif1"
			local _, _h, title = ZShelter.CreateLabel(statisticPanel, sidepadding, sidepadding * 1.5, ZShelter_GetTranslate_Var("#AvgFail", ZShelter_GetTranslate(DiffString)), "ZShelter-GameUITitle", Color(255, 255, 255, 255))
			local _, _h, records = ZShelter.CreateLabel(statisticPanel, sidepadding * 2, sidepadding * 1.5 + _h, ZShelter_GetTranslate_Var("#TotalPlayed", 0)..", "..ZShelter_GetTranslate_Var("#TotalFailed", 0), "ZShelter-GameUIDescription", Color(255, 255, 255, 255))
			local _, _, failratio = ZShelter.CreateLabel(statisticPanel, sidepadding * 2, records:GetY() + _h, ZShelter_GetTranslate_Var("#WinFailRatio", "0%/0%"), "ZShelter-GameUIDescription", Color(255, 255, 255, 255))
			statisticPanel.Statistic = ZShelter.CreateScroll(statisticPanel, 0, statisticPanel:GetTall() * scl, statisticPanel:GetWide(), statisticPanel:GetTall() * (1 - scl), Color(20, 20, 20, 50))
			local lineHeight = {}
			local wide, tall = statisticPanel.Statistic:GetWide(), statisticPanel.Statistic:GetTall()
			local lineGap = wide / 32
			local startY = statisticPanel.Statistic:GetTall() * 0.85
			local maxH = statisticPanel.Statistic:GetTall() * 0.7
			local lineY = startY - gap1x
			local textY = startY + ScreenScaleH(8)
			local dayY = startY + ScreenScaleH(20)
			local linewide, halfw = ScreenScaleH(6), ScreenScaleH(3)
			statisticPanel.Statistic.Paint = function()
				surface.SetDrawColor(255, 255, 255, 255)
				draw.DrawText(ZShelter_GetTranslate("#DayStatpanel"), "ZShelter-GameUIDescription", lineGap, dayY, color_white, TEXT_ALIGN_CENTER)
				draw.RoundedBox(0, 0, startY, wide, gap1x, color_white)
				local totalPlays = 0
				local totalFails = 0
				local stats = ZShelter.GameStatistics[selectedDiff]
				if(stats) then
					totalPlays = (stats.wins || 0) + (stats.fails || 0)
					totalFails = (stats.fails || 0)
				end
				local str = ZShelter_GetTranslate_Var("#TotalPlayed", totalPlays)..", "..ZShelter_GetTranslate_Var("#TotalFailed", totalFails)
				local failRatio = math.Round(math.Clamp(totalFails / totalPlays, 0, 1), 2) * 100
				local winRatio = 100 - failRatio
				if(totalPlays <= 0) then winRatio = 0 end
				failratio.UpdateText(ZShelter_GetTranslate_Var("#WinFailRatio", winRatio.."%/"..failRatio.."%"))
				records.UpdateText(str)
				for i = 1, 31 do
					if(!lineHeight[i]) then
						lineHeight[i] = 0
					end
					if(totalFails > 0) then
						if(stats.fail_sheet && stats.fail_sheet[i]) then
							local targetH = maxH * (stats.fail_sheet[i] / totalFails)
							if(targetH > lineHeight[i]) then
								lineHeight[i] = math.Clamp(lineHeight[i] + ZShelter.GetFixedValue((targetH - lineHeight[i]) * 0.15), lineHeight[i], targetH)
							else
								lineHeight[i] = math.Clamp(lineHeight[i] - ZShelter.GetFixedValue((lineHeight[i] - targetH) * 0.15), targetH, lineHeight[i])
							end
						else
							lineHeight[i] = math.Clamp(lineHeight[i] - ZShelter.GetFixedValue(lineHeight[i] * 0.15), 0, lineHeight[i])
						end
					else
						lineHeight[i] = math.Clamp(lineHeight[i] - ZShelter.GetFixedValue(lineHeight[i] * 0.15), 0, lineHeight[i])
					end

					local x = i * lineGap
					draw.RoundedBox(0, x - halfw, lineY - lineHeight[i], linewide, lineHeight[i], color_white)
					draw.RoundedBox(0, x, lineY, gap1x, gap, color_white)
					draw.DrawText(i, "ZShelter-GameUIStatisticText", x, textY, color_white, TEXT_ALIGN_CENTER)
					local perc = math.Clamp(math.Round(lineHeight[i] / maxH, 2), 0, 1) * 100
					draw.DrawText(perc.."%", "ZShelter-GameUIStatisticTextSmall", x, lineY - (lineHeight[i] + textpadding), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
				end
			end

		for i = 1, ZShelter.MaximumDifficulty do
			local panel = ZShelter.CreatePanel(sidePanel, 0, 0, sidePanel:GetWide(), height, Color(25, 25, 25, 255))
				panel:Dock(TOP)
				panel:DockMargin(0, 0, 0, gap)
				panel.AvatarLayer = ZShelter.CreatePanel(panel, 0, 0, panel:GetWide(), panel:GetTall(), Color(0, 0, 0, 0))
				local _, _, dif = ZShelter.CreateLabel(panel, sidepadding, panel:GetTall() / 2, ZShelter_GetTranslate("#Dif"..i), "ZShelter-SummeryButton", Color(255, 255, 255, 255))
				dif:CentVer()
				local color = ZShelter.GetDiffColor(i)
				local wide = 0
				local btn = ZShelter.InvisButton(panel, 0, 0, panel:GetWide(), panel:GetTall(), function()
					selectedDiff = i
					currentdataTable = ZShelter.GameStatistics[selectedDiff]
					DiffString = "#Dif"..selectedDiff
					title.UpdateText(ZShelter_GetTranslate_Var("#AvgFail", ZShelter_GetTranslate(DiffString)))
				end)
				panel.Paint = function()
					draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), Color(30, 30, 30, 255))
					draw.RoundedBox(0, 0, 0, colorwide, panel:GetTall(), color)

					if(btn:IsHovered() || selectedDiff == i) then
						wide = math.Clamp(wide + ZShelter.GetFixedValue((panel:GetWide() - wide) * 0.15), 0, panel:GetWide())
					else
						wide = math.Clamp(wide - ZShelter.GetFixedValue(wide * 0.15), 0, panel:GetWide())
					end

					surface.SetDrawColor(color.r, color.g, color.b, 80)
					surface.SetMaterial(fade)
					surface.DrawTexturedRect(0, 0, wide, panel:GetTall())
				end
			end
		end,
	},
	{
		title = "Looking2play",
		allowfunc = true,
		clickfunc = function(ui)
			ui.GetPlayerList()
		end,
		func = function(ui)
			local sidepadding = ScreenScaleH(4)
			local colorwide = ScreenScaleH(2)
			local gap = ScreenScaleH(2)
			local gap1x = ScreenScaleH(1)
			local textpadding = ScreenScaleH(12)
			local tw, th, counttext = ZShelter.CreateLabel(ui, textpadding, 0, ZShelter_GetTranslate_Var("#OnlinePlayers", "..."), "ZShelter-GameUITitle", Color(255, 255, 255, 255))
			local tw, th, hinttext1 = ZShelter.CreateLabel(ui, textpadding + gap, th, ZShelter_GetTranslate("#FindOtherPlayer"), "ZShelter-GameUIDescription", Color(255, 255, 255, 255))
			local tw, th, hinttext2 = ZShelter.CreateLabel(ui, textpadding + gap + tw, hinttext1:GetY() + th, ZShelter_GetTranslate("#ConnectionHint"), "ZShelter-GameUIStatisticText", Color(255, 255, 255, 255))
			hinttext2:SetPos(ui:GetWide() - (tw + textpadding), hinttext2:GetY() - (th + gap))
			local top_padding = th + textpadding * 2
			local scroll = ZShelter.CreateScroll(ui, sidepadding, top_padding + sidepadding, ui:GetWide() - sidepadding * 2, (ui:GetTall() - top_padding) - sidepadding * 2, Color(30, 30, 30, 255))

			local fetching = false
			local onplayers = false
			local nextfetch = 0
			ui.ReloadList = function(data)
				local count = table.Count(data)
				counttext.UpdateText(ZShelter_GetTranslate_Var("#OnlinePlayers", count))
				local plyCounts = {}
				for k,v in pairs(serverlist) do
					local base = ZShelter.CreatePanel(scroll, 0, 0, scroll:GetWide(), scroll:GetTall() * 0.125, Color(25, 25, 25, 255))
						base:Dock(TOP)
						base:DockMargin(0, 0, 0, gap)
						local avatar = ZShelter.CreateImage(base, 0, 0, base:GetTall(), base:GetTall(), "zsh/icon/server.png", Color(255, 255, 255, 255))
						local _, _, nick = ZShelter.CreateLabel(base, gap + avatar:GetWide(), base:GetTall() * 0.5, v.host, "ZShelter-GameUIGameUITitle2x", Color(255, 255, 255, 255))
						nick:CentVer()
						local wide, _, cnt = ZShelter.CreateLabel(base, 0, base:GetTall() * 0.5, "[0/"..v.maxplayers.."]", "ZShelter-GameUIGameUITitle2x", Color(255, 255, 255, 255))
						cnt:CentVer()
						cnt:SetX(base:GetWide() - (wide + gap))
						cnt.Think = function()
							cnt.UpdateText("["..(plyCounts[v.host] || 0).."/"..v.maxplayers.."]")
						end
						local btn = ZShelter.InvisButton(base, 0, 0, base:GetWide(), base:GetTall(), function()
							LocalPlayer():ConCommand("connect "..v.address)
						end)
						btn.Alpha = 0
						btn.Paint = function()
							if(btn:IsHovered()) then
								btn.Alpha = math.Clamp(btn.Alpha + ZShelter.GetFixedValue(1.5), 0, 15)
							else
								btn.Alpha = math.Clamp(btn.Alpha - ZShelter.GetFixedValue(1.5), 0, 15)
							end
							draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(255, 255, 255, btn.Alpha))
						end
				end
				if(count <= 0) then return end
				for k,v in pairs(data) do
					if(!v.lastonline || !v.host || !v.map || !v.address || !v.day) then continue end
					plyCounts[v.host] = (plyCounts[v.host] || 0) + 1
					local base = ZShelter.CreatePanel(scroll, 0, 0, scroll:GetWide(), scroll:GetTall() * 0.125, Color(25, 25, 25, 255))
						base:Dock(TOP)
						base:DockMargin(0, 0, 0, gap)
						local nick, check = ZShelter.GetName(k)
						local avatar = ZShelter.CreateImage(base, 0, 0, base:GetTall(), base:GetTall(), "zsh/icon/emptyframe.png", Color(255, 255, 255, 255))
						avatar.NextCheck = 0
						avatar.Path = "data/zombie shelter v2/avatars/"..k..".png"
						avatar.Think = function()
							if(avatar.NextCheck > SysTime()) then return end
							if(file.Exists(avatar.Path, "GAME")) then
								avatar:SetImage(avatar.Path)
								avatar.Think = nil
							else
								if(!ZShelter.QueuedAvatarID[k]) then
									ZShelter.QueuedAvatarID[k] = true
									ZShelter.QueuedAvatarDownload[k] = true
								end
							end
							avatar.NextCheck = SysTime() + 0.33
						end
						local tw, th, nick = ZShelter.CreateLabel(base, gap + avatar:GetWide(), gap, nick, "ZShelter-GameUIGameUITitle2x", Color(255, 255, 255, 255))
						if(check) then
							nick.NextCheck = 0
							nick.Think = function()
								if(nick.NextCheck > SysTime()) then return end
								if(ZShelter.Names[k]) then
									nick.UpdateText(ZShelter.Names[k])
									nick.Think = nil
								end
								nick.NextCheck = SysTime() + 0.25
							end
						end

						base.CheckDev = true
						base.NextCheck = 0
						base.Think = function()
							if(base.NextCheck > SysTime()) then return end
							if(base.CheckDev) then
								if(!devs_steamid[k]) then
									base.CheckDev = false
								else
									if(ZShelter.Names[k]) then
										nick.UpdateText(ZShelter.Names[k]..ZShelter_GetTranslate("#DeveloperTag"))
										nick:SetTextColor(Color(255, 185, 20, 255))
									end
								end
							end
							if(nick:GetText() == ZShelter_GetTranslate("#Player_NotFound")) then
								base:Remove()
								scroll:InvalidateLayout()
								count = math.max(count - 1, 0)
								counttext.UpdateText(ZShelter_GetTranslate_Var("#OnlinePlayers", count))
							end
							base.NextCheck = SysTime() + 0.2
						end
						local localserver = v.host == "Garry's Mod"
						local hostname = v.host
						if(localserver) then hostname = ZShelter_GetTranslate_Var("#LocalSv") end
						hostname = hostname.." ["..(v.playercount || 0).." / "..(v.maxplayer || 0).."]"
						local tw, th, nick = ZShelter.CreateLabel(base, sidepadding + avatar:GetWide(), gap + gap1x + th, hostname, "ZShelter-GameUIDescription", Color(255, 255, 255, 255))
						local _, _, addr = ZShelter.CreateLabel(base, nick:GetX() + tw + sidepadding, nick:GetY() + th * 0.5, "["..v.address.."]".." ["..(v.region || "?").."]", "ZShelter-GameUIStatisticText", Color(255, 255, 255, 100))
						addr:CentVer()
						local tw, th, map = ZShelter.CreateLabel(base, base:GetWide(), base:GetTall(), v.map.." ["..ZShelter_GetTranslate("#Dif"..(v.difficulty || 0)).."]".." ["..ZShelter_GetTranslate_Var("#NDay", v.day).."]", "ZShelter-GameUIDescription", Color(255, 255, 255, 255))
						map:SetPos(map:GetX() - (tw + sidepadding + gap), map:GetY() - (th + gap))
						local steambtn = ZShelter.InvisButton(base, 0, 0, base:GetTall(), base:GetTall(), function()
							gui.OpenURL("https://steamcommunity.com/profiles/"..k)
						end)
						steambtn.Alpha = 0
						steambtn.Paint = function()
							if(steambtn:IsHovered()) then
								steambtn.Alpha = math.Clamp(steambtn.Alpha + ZShelter.GetFixedValue(25), 0, 200)
							else
								steambtn.Alpha = math.Clamp(steambtn.Alpha - ZShelter.GetFixedValue(25), 0, 200)
							end
							draw.RoundedBox(0, 0, 0, steambtn:GetWide(), steambtn:GetTall(), Color(0, 0, 0, steambtn.Alpha))
							surface.SetDrawColor(255, 255, 255, steambtn.Alpha)
							surface.SetMaterial(steammat)
							surface.DrawTexturedRect(0, 0, steambtn:GetWide(), steambtn:GetWide())
						end

						local btn = ZShelter.InvisButton(base, base:GetTall(), 0, base:GetWide() - base:GetTall(), base:GetTall(), function()
							if(k == LocalPlayer():SteamID64() || (tonumber(v.playercount) || 0) >= (tonumber(v.maxplayer) || 0)) then return end
							LocalPlayer():ConCommand("connect "..v.address)
						end)
						btn.Alpha = 0
						btn.Paint = function()
							if(btn:IsHovered()) then
								btn.Alpha = math.Clamp(btn.Alpha + ZShelter.GetFixedValue(1.5), 0, 15)
							else
								btn.Alpha = math.Clamp(btn.Alpha - ZShelter.GetFixedValue(1.5), 0, 15)
							end
							draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(255, 255, 255, btn.Alpha))
						end
				end
			end
			ui.GetPlayerList = function()
				counttext.UpdateText(ZShelter_GetTranslate_Var("#OnlinePlayers", "..."))
				scroll:Clear()
				if(nextfetch > SysTime() || nextfetchtime > SysTime()) then if(table.Count(ZShelter.PlayerLists) > 0) then ui.ReloadList(ZShelter.PlayerLists) end return end
				http.Fetch("https://meiryiservice.xyz/zshelter/players.txt",
					function(body, size, header, code)
						local data = util.JSONToTable(body, false, true)
						if(!data) then return end
						ZShelter.PlayerLists = data
						if(!IsValid(ui)) then return end
						ui.ReloadList(data)
					end,
					function()
					end
				)
				nextfetch = SysTime() + 5
				nextfetchtime = SysTime() + 5
			end
		end,
	},
	--[[
	{
		title = "ServerList",
		func = function(ui)
			local sidepadding = ScreenScaleH(4)
			local colorwide = ScreenScaleH(2)
			local gap = ScreenScaleH(2)
			local gap1x = ScreenScaleH(1)
			local textpadding = ScreenScaleH(12)
			local tw, th, counttext = ZShelter.CreateLabel(ui, textpadding, 0, ZShelter_GetTranslate("#ServerListHint"), "ZShelter-GameUITitle", Color(255, 255, 255, 255))
			local top_padding = th + textpadding * 2
			local scroll = ZShelter.CreateScroll(ui, sidepadding, top_padding + sidepadding, ui:GetWide() - sidepadding * 2, (ui:GetTall() - top_padding) - sidepadding * 2, Color(30, 30, 30, 255))
				for k,v in pairs(serverlist) do
					local base = ZShelter.CreatePanel(scroll, 0, 0, scroll:GetWide(), scroll:GetTall() * 0.15, Color(25, 25, 25, 255))
						base:Dock(TOP)
						base:DockMargin(0, 0, 0, gap)
						local tw, th, hostname = ZShelter.CreateLabel(base, sidepadding, gap, v.host, "ZShelter-GameUITitle", Color(255, 255, 255, 255))
						local tw, th, addr = ZShelter.CreateLabel(base, sidepadding, sidepadding + th, ZShelter_GetTranslate_Var("#ServerListAddr", v.address), "ZShelter-GameUIDescription", Color(255, 255, 255, 120))
						local tw, th, c2j = ZShelter.CreateLabel(base, 0, 0, ZShelter_GetTranslate("#ServerListClick"), "ZShelter-GameUIDescription", Color(255, 255, 255, 255))
						c2j:SetPos(base:GetWide() - (tw + sidepadding), base:GetTall() - (th + sidepadding))

						local btn = ZShelter.InvisButton(base, 0, 0, base:GetWide(), base:GetTall(), function()
							LocalPlayer():ConCommand("connect "..v.address)
						end)
						btn.Alpha = 0
						btn.Paint = function()
							if(btn:IsHovered()) then
								btn.Alpha = math.Clamp(btn.Alpha + ZShelter.GetFixedValue(1.5), 0, 15)
							else
								btn.Alpha = math.Clamp(btn.Alpha - ZShelter.GetFixedValue(1.5), 0, 15)
							end
							draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(255, 255, 255, btn.Alpha))
						end
				end
		end,
	},
	]]
	{
		title = "Settings",
		func = function(ui)
			local gap = ScreenScaleH(4)
			local dockmargin = ScreenScaleH(2)
			local scroll = ZShelter.CreateScroll(ui, gap, gap, ui:GetWide() - gap * 2, ui:GetTall() - gap * 2, Color(25, 25, 25, 255))

			local currentSelectedKeybind = nil
			local keybinds = {}

			function addkeybind(title, index)
				local key = ZShelter.Keybinds[index]
				if(!key) then return end
				local base = ZShelter.CreatePanel(scroll, 0, 0, scroll:GetWide(), scroll:GetTall() * 0.1, Color(15, 15, 15, 255))
					base:Dock(TOP)
					base:DockMargin(0, 0, 0, dockmargin)

					local _, _, title = ZShelter.CreateLabel(base, gap, base:GetTall() * 0.5, title, "ZShelter-GameUIKeybindTitle", Color(255, 255, 255, 255))
					title.CentVer()
					local _, _, key_t = ZShelter.CreateLabel(base, base:GetWide(), base:GetTall() * 0.5, input.GetKeyName(tonumber(key)), "ZShelter-GameUIKeybindTitle", Color(255, 255, 255, 255))
					key_t.CentVer()
					key_t:SetX(key_t:GetX() - (key_t:GetWide() + gap))

					base.WarningTime = 0
					base.WarningAlpha = 0
					base.Paint = function()
						draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(15, 15, 15, 255))
						if(currentSelectedKeybind == base) then
							draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(255, 255, 255, 50))
						end
						if(base.WarningTime > SysTime()) then
							base.WarningAlpha = math.Clamp(base.WarningAlpha + ZShelter.GetFixedValue(25), 0, 80)
						else
							base.WarningAlpha = math.Clamp(base.WarningAlpha - ZShelter.GetFixedValue(10), 0, 80)
						end

						if(base.WarningAlpha > 0) then
							draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(255, 0, 0, base.WarningAlpha))
						end
					end

					function base:OnMousePressed()
						if(currentSelectedKeybind == base) then
							currentSelectedKeybind = nil
						else
							currentSelectedKeybind = base
						end
					end

					base.BindKey = function(key)
						ZShelter.WriteKeybind(index, key)
						key_t.UpdateText(input.GetKeyName(ZShelter.Keybinds[index]))
						key_t:SetX(base:GetWide() - (key_t:GetWide() + gap))
					end

					base.GetKey = function()
						return ZShelter.Keybinds[index]
					end

				keybinds[index] = base
			end

			scroll.Think = function()
				if(!IsValid(currentSelectedKeybind)) then return end
				for i = 0, 160 do
					if(input.IsKeyDown(i)) then
						for _, keybind in pairs(keybinds) do
							if(keybind.GetKey() != i) then continue end
							keybind.WarningTime = SysTime() + 0.1
							return
						end
						currentSelectedKeybind.BindKey(i)
						currentSelectedKeybind = nil
						return
					end
				end
			end

			--[[
				["BuildMenu"] = 12,
				["SkillMenu"] = 24,
				["ConfigMenu"] = 97,
				["Ready"] = 95,
				["GameUI"] = 93,
				["Skill"] = 101,
			]]
			addkeybind("Game UI", "GameUI")
			addkeybind("Build Menu", "BuildMenu")
			addkeybind("Skill Menu", "SkillMenu")
			addkeybind("Config Menu", "ConfigMenu")
			addkeybind("Ready", "Ready")
			addkeybind("Active Skill", "Skill")
			addkeybind("Drop Weaoon", "DropGun")
		end,
	},
	{
		title = "Discord",
		clickfunc = function()
			gui.OpenURL("https://discord.gg/XMZQpDavbU")
		end,
	},
}

local closemat = Material("zsh/worktable/twitter.png")
function ZShelter.GameUI()
	if(IsValid(ZShelter.GamePanel)) then
		ZShelter.GamePanel:Remove()
		return
	end
	local currentTab = nil
	local scl = 0.1
	local ui = ZShelter.CreatePanel(nil, ScrW() * scl, ScrH() * scl, ScrW() * (1 - scl * 2), ScrH() * (1 - scl * 2), Color(35, 35, 35, 255))
		ui:MakePopup()
		local headerHeight = ui:GetTall() * 0.08
		ui.Container = ZShelter.CreatePanelContainer(ui, 0, headerHeight, ui:GetWide(), ui:GetTall() - headerHeight, Color(0, 0, 0, 0))
		ui.Header = ZShelter.CreatePanel(ui, 0, 0, ui:GetWide(), headerHeight, Color(35, 35, 35, 255))
		local close = ZShelter.InvisButton(ui.Header, ui.Header:GetWide() - ui.Header:GetTall(), 0, ui.Header:GetTall(), ui.Header:GetTall(), function()
			ui:Remove()
		end)
		local half = ui.Header:GetTall() * 0.5
		close.Paint = function()
		local _half = half * 0.5
		surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(closemat)
			surface.DrawTexturedRect(_half, _half, half, half)
		end
		local gap = ScreenScaleH(1)
		local wide = ui:GetWide() * 0.125
		local nextX = 0
		for k,v in ipairs(func) do
			if(GetConVar("zshelter_enable_ranks"):GetInt() == 0 && k == 1) then continue end
			local panel = ZShelter.CreatePanel(ui.Container, 0, 0, ui.Container:GetWide(), ui.Container:GetTall(), Color(0, 0, 0, 0))
			if(v.func) then
				local success, err = pcall(function() v.func(panel) end)
				if(!success) then
					Error(err)
				end
			end
			ui.Container.AddPanel(panel)
			local alpha = 0
			local base = ZShelter.CreatePanel(ui.Header, nextX, 0, wide, headerHeight, Color(30, 30, 30, 255))
			nextX = nextX + (wide + gap)
			local _, _, label = ZShelter.CreateLabel(base, base:GetWide() * 0.5, base:GetTall() * 0.5, ZShelter_GetTranslate("#"..(v.title)), "ZShelter-GameUIButton", Color(255, 255, 255, 255))
				label:CentPos()

			local btn = ZShelter.InvisButton(base, 0, 0, base:GetWide(), base:GetTall(), function()
				if(!v.clickfunc) then
					ui.Container.CurrentPanel = panel
				else
					v.clickfunc(panel)
					if(v.allowfunc) then
						ui.Container.CurrentPanel = panel
					end
				end
			end)
			if(GetConVar("zshelter_enable_ranks"):GetInt() == 0) then
				if(k == 3) then
					ui.Container.CurrentPanel = panel
					btn.DoClick()
				end
			else
				if(k == 1) then
					ui.Container.CurrentPanel = panel
					btn.DoClick()
				end
			end
			btn.Think = function()
				if(ui.Container.CurrentPanel == panel) then
					alpha = math.Clamp(alpha + ZShelter.GetFixedValue(25), 0, 255)
				else
					alpha = math.Clamp(alpha - ZShelter.GetFixedValue(25), 0, 255)
				end
			end
			base.Paint = function()
				draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(30, 30, 30, alpha))
			end
		end

	ZShelter.GamePanel = ui
end

function ZShelter.ShouldOpenPanel()
	ZShelter.GameUI()
end

local nextexec = 0
local nextqueue = 0
hook.Add("Think", "ZShelter-UpdateStatus", function()
	if(nextqueue < SysTime()) then
		for k,v in pairs(ZShelter.QueuedAvatarDownload) do
			ZShelter.DownloadAvatar(k)
			ZShelter.QueuedAvatarDownload[k] = nil
			break
		end
		nextqueue = SysTime() + 0.25
	end
	if(nextexec > SysTime() || ZShelter.ConnectAddress == "NULL") then return end
	ZShelter.HTTPUpdateStatus()
	nextexec = SysTime() + 15
end)

ZShelter.ReadName()
ZShelter.HTTPFetchStatistics()
