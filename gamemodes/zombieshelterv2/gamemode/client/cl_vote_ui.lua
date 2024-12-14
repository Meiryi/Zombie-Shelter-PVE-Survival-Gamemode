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

ZShelter.MapList = {}
ZShelter.Votes = {}
ZShelter.PlayTime = 0
ZShelter.BlockMenu = false
ZShelter.CountDown = SysTime() + 30

surface.CreateFont("ZShelter-SummeryTitle", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(64),
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

surface.CreateFont("ZShelter-SummeryDesc", {
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

surface.CreateFont("ZShelter-SummeryButton", {
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

surface.CreateFont("ZShelter-SummeryTime", {
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

surface.CreateFont("ZShelter-SummeryStats", {
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

surface.CreateFont("ZShelter-SummeryDetails", {
	font = "Arial",
	extended = false,
	size = ScreenScaleH(10),
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

local list = {
	[1] = {
		title = "#Name",
		func = function(panel, player)
			local padding = ScreenScaleH(4)
			local size = panel:GetTall() - padding
			local av = ZShelter.CircleAvatar(panel, padding, padding, size, size, player, 186)
			local _, _, name = ZShelter.CreateLabel(panel, panel:GetWide() / 2, panel:GetTall() / 2, player:Nick(), "ZShelter-SummeryDetails", Color(255, 255, 255, 255))
			name:CentVer()
		end,
	},
	[2] = {
		title = "#Contribute",
		func = function(panel, player)
			local _, _, name = ZShelter.CreateLabel(panel, panel:GetWide() / 2, panel:GetTall() / 2, player:Frags(), "ZShelter-SummeryDetails", Color(255, 255, 255, 255))
			name:CentPos()
		end,
	},
	[3] = {
		title = "#TotalKills",
		func = function(panel, player)
			local _, _, name = ZShelter.CreateLabel(panel, panel:GetWide() / 2, panel:GetTall() / 2, player:GetNWInt("TKills", 0), "ZShelter-SummeryDetails", Color(255, 255, 255, 255))
			name:CentPos()
		end,
	},
	[4] = {
		title = "#TotalWoods",
		func = function(panel, player)
			local _, _, name = ZShelter.CreateLabel(panel, panel:GetWide() / 2, panel:GetTall() / 2, player:GetNWInt("TWoods", 0), "ZShelter-SummeryDetails", Color(255, 255, 255, 255))
			name:CentPos()
		end,
	},
	[5] = {
		title = "#TotalIrons",
		func = function(panel, player)
			local _, _, name = ZShelter.CreateLabel(panel, panel:GetWide() / 2, panel:GetTall() / 2, player:GetNWInt("TIrons", 0), "ZShelter-SummeryDetails", Color(255, 255, 255, 255))
			name:CentPos()
		end,
	},
	[6] = {
		title = "#TotalBuilds",
		func = function(panel, player)
			local _, _, name = ZShelter.CreateLabel(panel, panel:GetWide() / 2, panel:GetTall() / 2, player:GetNWInt("TBuilds", 0), "ZShelter-SummeryDetails", Color(255, 255, 255, 255))
			name:CentPos()
		end,
	},
	[7] = {
		title = "#TK",
		func = function(panel, player)
			local _, _, name = ZShelter.CreateLabel(panel, panel:GetWide() / 2, panel:GetTall() / 2, player:GetNWInt("TKAmount", 0), "ZShelter-SummeryDetails", Color(255, 255, 255, 255))
			name:CentPos()
		end,
	},
}

local fade = Material("zsh/icon/fade.png")
local func = {
	["Summery"] = function(ui, pa)
		local padding = ScreenScaleH(4)
		local margin = ScreenScaleH(8)
		local __margin = ScreenScaleH(2)
		local players = player.GetAll()
		table.sort(players, function(a, b) return a:Frags() > b:Frags() end)
		local player = players[1]
		local w, h = ui:GetWide() - margin * 2, ui:GetTall() * 0.33
		local tw, th, text = ZShelter.CreateLabel(pa, pa:GetWide() / 2, padding, game.GetMap().."  ["..ZShelter.GetDiffName(GetConVar("zshelter_difficulty"):GetInt()).."]", "ZShelter-SummeryDesc", Color(255, 255, 255, 255))
			text:CentHor()
		local avatarSize = pa:GetTall() * 0.2
		local totalWide = 0
		local startX = pa:GetWide() / 2
		local startY = padding + th + padding
		local av = ZShelter.CircleAvatar(pa, startX, startY, avatarSize, avatarSize, player, 186)
		startX = startX + avatarSize + margin
		totalWide = totalWide + avatarSize + margin
		local tw, th, nick = ZShelter.CreateLabel(pa, startX, startY + margin, ZShelter_GetTranslate_Var("#MVP", player:Nick()), "ZShelter-SummeryDesc", Color(255, 255, 255, 255))
		totalWide = totalWide + tw
		nick:SetX(nick:GetX() - totalWide / 2)
		av:SetX(av:GetX() - totalWide / 2)
		startY = startY + th
		local tw, th, pts = ZShelter.CreateLabel(pa, nick:GetX() + padding, startY + margin, ZShelter_GetTranslate_Var("#PTS", player:Frags()), "ZShelter-SummeryButton", Color(255, 255, 255, 255))
		startY = startY + avatarSize
		local statsPanel = ZShelter.CreatePanel(pa, 0, startY, pa:GetWide(), pa:GetTall() - startY, Color(25, 25, 25, 255))
		local size = pa:GetWide() / #list
		local currentX = size / 2
		local playtime = string.FormattedTime(ZShelter.PlayTime, "%02i:%02i")
		local _, _, timestr = ZShelter.CreateLabel(pa, pa:GetWide() * 0.5, pa:GetTall() * 0.32, ZShelter_GetTranslate_Var("#TotalPlayTime", playtime), "ZShelter-SummeryTime", Color(255, 255, 255, 255))
		timestr:CentHor()
		local listing = ZShelter.CreateScroll(pa, 0, startY + ScreenScaleH(8) + padding * 2, pa:GetWide(), pa:GetTall() - (startY + ScreenScaleH(8) + padding * 2), Color(0, 0, 0, 0))
		local avatarbg = pa:Add("AvatarImage")
			avatarbg:SetPlayer(player, 186)
			avatarbg:SetSize(pa:GetWide(), pa:GetWide())
			avatarbg:SetAlpha(5)
			avatarbg:SetY((pa:GetTall() - listing:GetTall()) * 0.5 - avatarbg:GetTall() * 0.5)
			avatarbg:SetZPos(-3000)
			local height = ScreenScaleH(128)
			local img = ZShelter.CreateImage(pa, 0, listing:GetY() - height, pa:GetWide(), height, "zsh/icon/fade_up.png", Color(40, 40, 40, 255))
				img:SetZPos(-2999)
		for k,v in ipairs(list) do
			local _, _, text = ZShelter.CreateLabel(pa, currentX, startY + padding, ZShelter_GetTranslate(v.title), "ZShelter-SummeryStats", Color(255, 255, 255, 255))
			text:CentHor()
			currentX = currentX + size
		end
		for k,v in pairs(players) do
			local p = ZShelter.CreatePanel(listing, 0, 0, pa:GetWide(), pa:GetTall() * 0.08, Color(20, 20, 20, 255))
				p:Dock(TOP)
				p:DockMargin(0, 0, 0, __margin)
				p.NextX = 0
			for x,y in ipairs(list) do
				local subPanel = ZShelter.CreatePanel(p, p.NextX, 0, size, p:GetTall(), Color(0, 0, 0, 0))
				y.func(subPanel, v)
				p.NextX = p.NextX + size
			end
		end
	end,
	["MapVote"] = function(ui, pa)
		local padding = ScreenScaleH(4)
		local diffvote = ui.Container:GetWide() * 0.25
		pa.DiffList = ZShelter.CreateScroll(pa, padding, padding, diffvote - padding * 2, ui.Container:GetTall() - padding * 2, Color(0, 0, 0, 0))
		pa.DiffList.DiffButtons = {}
		local gap = ScreenScaleH(2)
		local height = (ui.Container:GetTall() / ZShelter.MaximumDifficulty) - gap * 1.25
		local margin = ScreenScaleH(2)
		local margin2 = ScreenScaleH(1)

		local sidepadding = ScreenScaleH(8)
		local colorwide = ScreenScaleH(2)
		for i = 1, ZShelter.MaximumDifficulty do
			local panel = ZShelter.CreatePanel(pa.DiffList, 0, 0, pa.DiffList:GetWide(), height, Color(25, 25, 25, 255))
				panel:Dock(TOP)
				panel:DockMargin(0, 0, 0, gap)
				panel.AvatarLayer = ZShelter.CreatePanel(panel, 0, 0, panel:GetWide(), panel:GetTall(), Color(0, 0, 0, 0))
				local _, _, dif = ZShelter.CreateLabel(panel, sidepadding, panel:GetTall() / 2, ZShelter_GetTranslate("#Dif"..i), "ZShelter-SummeryButton", Color(255, 255, 255, 255))
				dif:CentVer()
				local color = ZShelter.GetDiffColor(i)
				local wide = 0
				local btn = ZShelter.InvisButton(panel, 0, 0, panel:GetWide(), panel:GetTall(), function()
					net.Start("ZShelter-SendDiffVote")
					net.WriteInt(i, 32)
					net.SendToServer()
				end)
				panel.Paint = function()
					draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), Color(25, 25, 25, 255))
					draw.RoundedBox(0, 0, 0, colorwide, panel:GetTall(), color)

					if(btn:IsHovered()) then
						wide = math.Clamp(wide + ZShelter.GetFixedValue((panel:GetWide() - wide) * 0.15), 0, panel:GetWide())
					else
						wide = math.Clamp(wide - ZShelter.GetFixedValue(wide * 0.15), 0, panel:GetWide())
					end

					surface.SetDrawColor(color.r, color.g, color.b, 80)
					surface.SetMaterial(fade)
					surface.DrawTexturedRect(0, 0, wide, panel:GetTall())
				end

			pa.DiffList.DiffButtons[i] = panel.AvatarLayer
		end
		pa.List = ZShelter.CreateScroll(pa, padding + diffvote, padding, (ui.Container:GetWide() - diffvote) - padding * 3, ui.Container:GetTall() - padding * 2, Color(0, 0, 0, 0))
		pa.List.Panels = {}
		for k,v in pairs(ZShelter.MapList) do
			local map = string.Replace(k, ".bsp", "")
			local panel = ZShelter.CreatePanel(pa.List, 0, 0, pa.List:GetWide(), pa.List:GetTall() * 0.1, Color(25, 25, 25, 255))
				panel:Dock(TOP)
				panel:DockMargin(0, 0, 0, margin)
				panel.AvatarLayer = ZShelter.CreatePanel(panel, 0, 0, panel:GetWide(), panel:GetTall(), Color(0, 0, 0, 0))
				panel.AvatarLayer.MapName = map

				table.insert(pa.List.Panels, panel.AvatarLayer)

				local _, _, mapname = ZShelter.CreateLabel(panel, margin * 3, panel:GetTall() / 2, map, "ZShelter-SummeryButton", Color(255, 255, 255, 255))
					mapname.CentVer()

				local btn = ZShelter.InvisButton(panel, 0, 0, panel:GetWide(), panel:GetTall(), function()
					net.Start("ZShelter-SendVote")
					net.WriteString(map)
					net.SendToServer()
				end)

				panel.Alpha = 0
				panel.Paint = function()
					draw.RoundedBox(0, 0, 0, panel:GetWide(), panel:GetTall(), Color(25, 25, 25, 255))

					if(btn:IsHovered()) then
						panel.Alpha = math.Clamp(panel.Alpha + ZShelter.GetFixedValue(20), 0, 255)
					else
						panel.Alpha = math.Clamp(panel.Alpha - ZShelter.GetFixedValue(20), 0, 255)
					end
					surface.SetDrawColor(255, 255, 255, panel.Alpha)
					surface.DrawOutlinedRect(0, 0, panel:GetWide(), panel:GetTall(), margin2)
				end
		end

		ui.MapsPanel = pa.List
		ui.DiffPanel = pa.DiffList
	end,
}

net.Receive("ZShelter-SyncDiffVote", function()
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	local votes = util.JSONToTable(util.Decompress(data))
	if(!IsValid(ZShelter.EndUI.MapsPanel)) then return end
	local sx = ScreenScaleH(10)
	local margin = ScreenScaleH(2)
	for k,v in pairs(ZShelter.EndUI.DiffPanel.DiffButtons) do
		v:Clear()
		local _x, _y = v:GetWide() - (sx + margin), v:GetTall() - (sx + margin)
		for x,y in pairs(votes) do
			local ply = Entity(x)
			if(!IsValid(ply) || !ply:IsPlayer() || y != k) then continue end
			ZShelter.CircleAvatar(v, _x, _y, sx, sx, ply, 186)
			_x = _x - (sx + margin)
		end
	end
end)

net.Receive("ZShelter-SyncVote", function()
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	local changemap = net.ReadBool()
	local votes = util.JSONToTable(util.Decompress(data))
	local margin = ScreenScaleH(4)
	local avatarsize = ScreenScaleH(24)
	ZShelter.Votes = {}
	for k,v in pairs(votes) do
		if(!ZShelter.Votes[v]) then
			ZShelter.Votes[v] = {k}
		else
			table.insert(ZShelter.Votes[v], k)
		end
	end

	if(IsValid(ZShelter.EndUI.MapsPanel)) then
		for k,v in pairs(ZShelter.EndUI.MapsPanel.Panels) do
			v:Clear()
			if(!ZShelter.Votes[v.MapName]) then continue end
			local startX = v:GetWide() - (avatarsize + margin)
			for x,y in pairs(ZShelter.Votes[v.MapName]) do
				local ply = Entity(y)
				if(!IsValid(ply) || !ply:IsPlayer()) then continue end
				ZShelter.CircleAvatar(v, startX, (v:GetTall() / 2) - avatarsize / 2, avatarsize, avatarsize, ply, 186)
				startX = startX - (avatarsize + margin)
			end
		end
	end

	if(ZShelter.CountDown - SysTime() > 5 && changemap) then
		ZShelter.CountDown = SysTime() + 5
	end
end)

net.Receive("ZShelter-Endgame", function()
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	ZShelter.MapList = util.JSONToTable(util.Decompress(data))
	local victory = net.ReadBool()
	local title = ZShelter_GetTranslate(net.ReadString())
	local desc = ZShelter_GetTranslate(net.ReadString())
	local time = net.ReadInt(32)
	ZShelter.PlayTime = time
	ZShelter.VoteUI(victory, title, desc)
end)

local category = {"Summery", "MapVote"}
function ZShelter.VoteUI(victory, text, reason)
	if(IsValid(ZShelter.EndUI)) then
		ZShelter.EndUI:Remove()
	end
	ZShelter.ClearMenus()
	ZShelter.CountDown = SysTime() + 34
	local color = Color(30, 30, 30, 0)
	if(!victory) then
		color = Color(80, 30, 30, 0)
	end
	if(!text) then
		if(victory) then
			text = "Victory!"
		else
			text = "Defeat!"
		end
	end
	ZShelter.BlockMenu = true
	local ui = ZShelter.CreateFrame(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 120))
	local center = ScrW() / 2
	local padding = ScreenScaleH(4)

	local uithinker = ZShelter.CreateFrame(nil, 0, 0, 1, 1, Color(0, 0, 0, 0))
	uithinker.CheckTarget = ui
	uithinker.Alpha = 255
	uithinker.Think = function()
		if(!IsValid(uithinker.CheckTarget)) then uithinker:Remove() return end
		if(gui.IsGameUIVisible()) then
			uithinker.Alpha = math.Clamp(uithinker.Alpha - ZShelter.GetFixedValue(20), 0, 255)
		else
			uithinker.Alpha = math.Clamp(uithinker.Alpha + ZShelter.GetFixedValue(10), 0, 255)
		end
		uithinker.CheckTarget:SetAlpha(uithinker.Alpha)
		if(uithinker.Alpha <= 0) then
			uithinker.CheckTarget:SetVisible(false)
		else
			uithinker.CheckTarget:SetVisible(true)
		end
	end

	local scl = 0.175
	ui.VoteMenu = ZShelter.CreatePanel(ui, ScrW() * scl, ScrH() * scl, ScrW() * (1 - scl * 2), ScrH() * (1 - scl * 2), Color(0, 0, 0, 0))
	ui.VoteMenu.oX = (ScrW() * 0.5 - ui.VoteMenu:GetWide() / 2) + ScrW()
	ui.VoteMenu:SetX(ui.VoteMenu.oX + ScrW())
	ui.VoteMenu.Head = ZShelter.CreatePanel(ui.VoteMenu, 0, 0, ui.VoteMenu:GetWide(), ScreenScaleH(24), Color(40, 40, 40, 255))
	ui.VoteMenu.Body = ZShelter.CreatePanel(ui.VoteMenu, 0, ui.VoteMenu.Head:GetTall(), ui.VoteMenu:GetWide(), ui.VoteMenu:GetTall() - ui.VoteMenu.Head:GetTall(), Color(30, 30, 30, 255))

	local gap = ScreenScaleH(8)
	ui.ChatMenu = ZShelter.CreatePanel(ui, ui.VoteMenu:GetX() - (ScrW() * scl), ui.VoteMenu:GetY(), (ScrW() * scl) - gap, ui.VoteMenu:GetTall(), Color(30, 30, 30, 255))
	local margin = ScreenScaleH(4)
	local headersize = ScreenScaleH(24)
	local entrysize = ScreenScaleH(24)
	local _, _, chat = ZShelter.CreateLabel(ui.ChatMenu, margin, margin, "Chat", "ZShelter-SummeryButton", Color(255, 255, 255, 255))
	chat:SetY((headersize - chat:GetTall()) * 0.5)
	ui.ChatMenu.Chat = ZShelter.CreateScroll(ui.ChatMenu, margin, headersize + margin, ui.ChatMenu:GetWide() - (margin * 2), ui.ChatMenu:GetTall() - ((margin * 2) + headersize + entrysize), Color(20, 20, 20, 255))
	local entry = ZShelter.CreateTextEntry(ui.ChatMenu, margin, ui.ChatMenu.Chat:GetY() + ui.ChatMenu.Chat:GetTall(), ui.ChatMenu.Chat:GetWide(), entrysize - margin, "ZShelter-SummeryStats", Color(25, 25, 25, 255), Color(255, 255, 255, 255), "Type something", "string")
	function entry:OnEnter(val)
		if(#val <= 0) then
			return
		end
		local hasstr = false
		for i = 1, #val do
			if(val[i] != " ") then
				hasstr = true
				break
			end
		end
		if(!hasstr) then
			return
		end

		net.Start("ZShelter-VoteChat")
		net.WriteString(val)
		net.SendToServer()

		entry:SetText("")
	end

	local chat = ui.ChatMenu.Chat
	local msgSize = ScreenScaleH(16)
	local padding = ScreenScaleH(2)
	chat.AddNewMsg = function(ply, msg)
		local base = ZShelter.CreatePanel(chat, 0, 0, chat:GetWide(), msgSize, Color(25, 25, 25, 255))
		local av = vgui.Create("AvatarImage", base)
			av:SetPlayer(ply, 64)
			av:SetSize(msgSize, msgSize)
			base:Dock(TOP)
			base:DockMargin(0, 0, 0, padding)
			local stringarea = ZShelter.CreatePanel(base, msgSize, 0, base:GetWide(), base:GetTall(), Color(0, 0, 0, 0))
			local message = ply:Nick()..": "..msg
			local tmp = ""
			local newmsg = ""
			for i = 1, #message do
				tmp = tmp..message[i]
				local w, h = ZShelter.GetTextSize("ZShelter-SummeryStats", tmp)
				if(w > stringarea:GetWide() - msgSize * 2) then
					newmsg = newmsg.."\n"..tmp
					tmp = ""
				end
			end
			if(#newmsg <= 0) then
				newmsg = message
			end
			local _, tall = ZShelter.GetTextSize("ZShelter-SummeryStats", newmsg)
			tall = math.max(tall, msgSize)
			local _, _, text = ZShelter.CreateLabel(stringarea, padding, padding, newmsg, "ZShelter-SummeryStats", Color(255, 255, 255, 255))
			base:SetTall(tall + padding * 2)
			stringarea:SetTall(tall)
			text:SetY((base:GetTall() * 0.5) - (text:GetTall() * 0.5))
			base.Paint = function()
				draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(25, 25, 25, 255))
			end
			av:SetY((base:GetTall() * 0.5) - (av:GetTall() * 0.5))
			if((math.abs(chat.MaximumScroll - chat:GetVBar():GetScroll())) < ScreenScaleH(2)) then
				chat.CurrrentScroll = chat:GetVBar().CanvasSize + base:GetTall()
			end
	end
	net.Receive("ZShelter-VoteChat", function()
		if(!IsValid(chat)) then return end
		local ply = net.ReadEntity()
		local str = net.ReadString()
		if(!IsValid(ply)) then return end
		chat.AddNewMsg(ply, str)
	end)

	ui.Container = ZShelter.CreatePanelContainer(ui.VoteMenu.Body, 0, 0, ui.VoteMenu.Body:GetWide(), ui.VoteMenu.Body:GetTall(), Color(0, 0, 0, 0))

	local _, _, countdown = ZShelter.CreateLabel(ui.VoteMenu.Head, ui.VoteMenu.Head:GetWide(), ui.VoteMenu.Head:GetTall() / 2, math.max(ZShelter.CountDown, 0), "ZShelter-SummeryDesc", Color(255, 255, 255, 255))
	countdown:CentVer()
	countdown.Think = function()
		local str = math.floor(math.max(ZShelter.CountDown - SysTime(), 0), 1)
		local w, h = ZShelter.GetTextSize("ZShelter-SummeryDesc", str)
		countdown:SetX((ui.VoteMenu.Head:GetWide() - padding * 2) - w)
		countdown:SetText(str)
		countdown:SetSize(w, h)
		if(str <= 5) then
			countdown:SetTextColor(Color(255, 200, 200, 255))
		end
	end
	local startX = 0
	for k,v in pairs(category) do
		local title = ZShelter_GetTranslate("#"..v)
		local w, h = ZShelter.GetTextSize("ZShelter-SummeryButton", title)
		local pa = ZShelter.CreatePanel(ui.Container, 0, 0, ui.Container:GetWide(), ui.Container:GetTall(), Color(0, 0, 0, 0))
		if(func[v]) then
			func[v](ui, pa)
		end

		ui.Container.AddPanel(pa)

		local btn = ZShelter.CreateButton(ui.VoteMenu.Head, startX, 0, w + padding * 2, ui.VoteMenu.Head:GetTall(), title, "ZShelter-SummeryButton", Color(200, 200, 200, 255), Color(0, 0, 0, 0), function()
			ui.Container.CurrentPanel = pa
		end)
		btn.Alpha = 0
		btn.Paint = function()
			if(ui.Container.CurrentPanel == pa) then
				btn.Alpha = math.Clamp(btn.Alpha + ZShelter.GetFixedValue(20), 100, 255)
			else
				btn.Alpha = math.Clamp(btn.Alpha - ZShelter.GetFixedValue(20), 100, 255)
			end
			btn:SetTextColor(Color(255, 255, 255, btn.Alpha))
			draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(30, 30, 30, btn.Alpha))
		end
		if(k == 1) then
			btn.DoClick()
		end

		startX = startX + btn:GetWide()
	end

	ui:MakePopup()
	ui:Center()
	ui.oPaint = ui.Paint
	ui.TargetBlur = 5
	ui.TargetAlpha = 100
	ui.TargetAnimTime = 0.35
	ui.TargetTime = SysTime() + ui.TargetAnimTime
	ui.TextX = ScrW() / 2
	ui.TextStayTime = 1
	ui.TextMoveTime = SysTime() + ui.TextStayTime * 3
	ui.CurrentBlur = 0
	ui.Paint = function()
		local scale = math.Clamp(1 - ((ui.TargetTime - SysTime()) / ui.TargetAnimTime), 0, 1)
		color.a = ui.TargetAlpha * scale

		ZShelter.DrawBlur(ui, scale * ui.TargetBlur)
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), color)

		draw.DrawText(text, "ZShelter-SummeryTitle", ui.TextX, ScrH() * 0.325, Color(255, 255, 255, color.a), TEXT_ALIGN_CENTER)
		if(reason) then
			draw.DrawText(reason, "ZShelter-SummeryDesc", ui.TextX, ScrH() * 0.475, Color(255, 255, 255, color.a), TEXT_ALIGN_CENTER)
		end

		local scale2 = math.Clamp(1 - ((ui.TextMoveTime - SysTime()) / ui.TextStayTime), 0, 1)
		local lerpX = math.ease.InOutQuad(scale2) * ScrW()
		ui.VoteMenu:SetX(ui.VoteMenu.oX - lerpX)
		ui.ChatMenu:SetX(ui.VoteMenu:GetX() - (ui.ChatMenu:GetWide() + gap))
		ui.TextX = center - lerpX
	end

	ZShelter.EndUI = ui
end
