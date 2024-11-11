ZShelter.StartPlayingTime = ZShelter.StartPlayingTime || 0

local currentpnl = nil
local currentBans = {}

local QuickRespondWindow = function(text)
	if(!IsValid(currentpnl)) then return end
	local ui = ZShelter.CreatePanel(currentpnl, 0, 0, currentpnl:GetWide(), currentpnl:GetTall(), Color(0, 0, 0, 200))
	ui.Alpha = 0
	ui.Think = function()
		ui.Alpha = math.Clamp(ui.Alpha + ZShelter.GetFixedValue(15), 0, 255)
		ui:SetAlpha(ui.Alpha)
	end
	local _, _, t = ZShelter.CreateLabel(ui, ui:GetWide() * 0.5, ui:GetTall() * 0.5, text, "ZShelter-GameUIModifierTitle", Color(255, 255, 255, 255))
	t:CentPos()

	local w, h = ScreenScaleH(86), ScreenScaleH(24)
	local btn = ZShelter.CreateButton(ui, ui:GetWide() * 0.5 - w * 0.5, ui:GetTall() * 0.85 - h * 0.5, w, h, "Close", "ZShelter-GameUIButton", Color(255, 255, 255, 255), Color(0, 0, 0, 0), function()
		ui:Remove()
	end)
	btn.Paint = function()
		draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(25, 25, 25, 255))
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawOutlinedRect(0, 0, btn:GetWide(), btn:GetTall(), ScreenScaleH(1))
	end
end

local CloseVotePanel = function()
	if(!IsValid(currentpnl)) then return end
	currentpnl:Remove()
end

local headers = {
	{
		title = "Kick Player",
		func = function(ui)
			local scroll = ZShelter.CreateScroll(ui, 0, 0, ui:GetWide(), ui:GetTall(), Color(30, 30, 30, 255))
			local gap = ScreenScaleH(2)
			local elemTall = scroll:GetTall() * 0.1
			for _, ply in ipairs(player.GetAll()) do
				if(ply == LocalPlayer()) then continue end
				local pnl = ZShelter.CreatePanel(scroll, 0, 0, scroll:GetWide(), elemTall, Color(20, 20, 20, 255))
				pnl:Dock(TOP)
				pnl:DockMargin(0, 0, 0, gap)
				local avatar = ZShelter.CreateAvatar(pnl, 0, 0, elemTall, elemTall, ply, 64)
				local _, _, label = ZShelter.CreateLabel(pnl, elemTall + gap, gap, ply:Nick(), "ZShelter-GameUIButton", Color(255, 255, 255, 255))

				local btn = ZShelter.InvisButton(pnl, 0, 0, pnl:GetWide(), elemTall, function()
					if(ply:IsAdmin()) then 
						QuickRespondWindow("You can't kick an admin!")
						return
					end
					net.Start("ZShelter_VoteKick")
					net.WriteEntity(ply)
					net.SendToServer()
				end)
				btn.Alpha = 0
				btn.Paint = function()
					if(btn:IsHovered()) then
						btn.Alpha = math.Clamp(btn.Alpha + ZShelter.GetFixedValue(5), 0, 50)
					else
						btn.Alpha = math.Clamp(btn.Alpha - ZShelter.GetFixedValue(5), 0, 50)
					end
					draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(255, 255, 255, btn.Alpha))
				end
			end

			if(CurTime() - ZShelter.StartPlayingTime < 300) then
				local ui = ZShelter.CreatePanel(ui, 0, 0, ui:GetWide(), ui:GetTall(), Color(255, 50, 50, 10))
				local _, _, t = ZShelter.CreateLabel(ui, ui:GetWide() * 0.5, ui:GetTall() * 0.5, "You will be able to start votekick after "..(CurTime() - ZShelter.StartPlayingTime).."s", "ZShelter-GameUIButton", Color(255, 255, 255, 255))
				t.Think = function()
					local time = math.Round(300 - (CurTime() - ZShelter.StartPlayingTime))
					t.UpdateText("You will be able to start votekick after "..time.."s")
					t.CentPos()
					if(time <= 0) then
						ui:Remove()
					end
				end
			end
		end,
	},
	{
		title = "Unban Player",
		func = function(ui)
			local scroll = ZShelter.CreateScroll(ui, 0, 0, ui:GetWide(), ui:GetTall(), Color(30, 30, 30, 255))
			local gap = ScreenScaleH(2)
			local elemTall = scroll:GetTall() * 0.1
			for steamid, name in pairs(currentBans) do
				local pnl = ZShelter.CreatePanel(scroll, 0, 0, scroll:GetWide(), elemTall, Color(20, 20, 20, 255))
				pnl:Dock(TOP)
				pnl:DockMargin(0, 0, 0, gap)
				local _, _, label = ZShelter.CreateLabel(pnl, gap, elemTall * 0.5, name, "ZShelter-GameUITitle", Color(255, 255, 255, 255))
				label.CentVer()
				local btn = ZShelter.InvisButton(pnl, 0, 0, pnl:GetWide(), elemTall, function()
					net.Start("ZShelter_VoteUnban")
					net.WriteString(steamid)
					net.SendToServer()
				end)
				btn.Alpha = 0
				btn.Paint = function()
					if(btn:IsHovered()) then
						btn.Alpha = math.Clamp(btn.Alpha + ZShelter.GetFixedValue(5), 0, 50)
					else
						btn.Alpha = math.Clamp(btn.Alpha - ZShelter.GetFixedValue(5), 0, 50)
					end
					draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(255, 255, 255, btn.Alpha))
				end
			end

			if(CurTime() - ZShelter.StartPlayingTime < 300) then
				local ui = ZShelter.CreatePanel(ui, 0, 0, ui:GetWide(), ui:GetTall(), Color(255, 50, 50, 10))
				local _, _, t = ZShelter.CreateLabel(ui, ui:GetWide() * 0.5, ui:GetTall() * 0.5, "You will be able to start votekick after "..(CurTime() - ZShelter.StartPlayingTime).."s", "ZShelter-GameUIButton", Color(255, 255, 255, 255))
				t.Think = function()
					local time = math.Round(300 - (CurTime() - ZShelter.StartPlayingTime))
					t.UpdateText("You will be able to start unban vote after "..time.."s")
					t.CentPos()

					if(time <= 0) then
						ui:Remove()
					end
				end
			end
		end,
	},
	{
		title = "Change Difficulty",
		func = function(ui)
			local scroll = ZShelter.CreateScroll(ui, 0, 0, ui:GetWide(), ui:GetTall(), Color(30, 30, 30, 255))
			local maxDiff = ZShelter.MaximumDifficulty
			local gap = ScreenScaleH(2)
			local elemTall = scroll:GetTall() * 0.1
			for i = 1, maxDiff do
				local name = ZShelter_GetTranslate("#Dif"..i)
				local color = ZShelter.GetDiffColor(i)
				local pnl = ZShelter.CreatePanel(scroll, 0, 0, scroll:GetWide(), elemTall, Color(20, 20, 20, 255))
				pnl:Dock(TOP)
				pnl:DockMargin(0, 0, 0, gap)
				local _, _, label = ZShelter.CreateLabel(pnl, gap * 3, elemTall * 0.5, name, "ZShelter-GameUITitle", Color(255, 255, 255, 255))
				label.CentVer()
				local btn = ZShelter.InvisButton(pnl, 0, 0, pnl:GetWide(), elemTall, function()
					net.Start("ZShelter_VoteDifficulty")
					net.WriteInt(i, 32)
					net.SendToServer()
				end)
				btn.Alpha = 0
				btn.Paint = function()
					if(btn:IsHovered()) then
						btn.Alpha = math.Clamp(btn.Alpha + ZShelter.GetFixedValue(5), 0, 50)
					else
						btn.Alpha = math.Clamp(btn.Alpha - ZShelter.GetFixedValue(5), 0, 50)
					end
					draw.RoundedBox(0, 0, 0, btn:GetWide(), btn:GetTall(), Color(255, 255, 255, btn.Alpha))
					draw.RoundedBox(0, 0, 0, gap, btn:GetTall(), color)
				end
			end
			if(GetGlobalBool("GameStarted")) then
				local ui = ZShelter.CreatePanel(ui, 0, 0, ui:GetWide(), ui:GetTall(), Color(255, 50, 50, 10))
				local _, _, t = ZShelter.CreateLabel(ui, ui:GetWide() * 0.5, ui:GetTall() * 0.5, "You can't change difficulty after the game has started!", "ZShelter-GameUIButton", Color(255, 255, 255, 255))
				t.CentPos()
			end
		end,
	},
}
local closemat = Material("zsh/worktable/twitter.png")
function ZShelter.VoteKickMenu()
	local scl = 0.15
	local ui = ZShelter.CreatePanel(nil, ScrW() * scl, ScrH() * scl, ScrW() * (1 - (scl * 2)), ScrH() * (1 - (scl * 2)), Color(50, 50, 50, 255))
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
		local wide = ui:GetWide() * 0.175
		local nextX = 0
		for k,v in ipairs(headers) do
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
				ui.Container.CurrentPanel = panel
			end)
			if(k == 1) then
				btn.DoClick()
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

	currentpnl = ui
end

local currentVotePanel = nil
local currentVotes = {}

net.Receive("ZShelter_SyncBannedPlayers", function()
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	local bans = ZShelter.DecompressTable(data, true)
	currentBans = bans
end)

net.Receive("ZShelter_StartMultuiplayerVote", function()
	ZShelter.CreateSideVotePanel(net.ReadString())
end)

net.Receive("ZShelter_VoteResult", function()
	ZShelter.CreateSideVoteNotify(net.ReadString(), net.ReadBool())
end)

net.Receive("ZShelter_RejectVote", function()
	QuickRespondWindow(net.ReadString())
end)

net.Receive("ZShelter_SyncMulVote", function()
	local len = net.ReadUInt(32)
	local data = net.ReadData(len)
	local votes = ZShelter.DecompressTable(data, true)
	currentVotes = votes
	if(!IsValid(currentVotePanel)) then return end
	currentVotePanel.UpdateVotes()
end)

function ZShelter.CreateSideVoteNotify(result)
	local w, h = ScreenScaleH(128), ScreenScaleH(64)
	local sidepadding = ScreenScaleH(4)
	local tw, th = ZShelter.GetTextSize("ZShelter-VoteUIFont", result)
	local ui = ZShelter.CreatePanel(nil, 0, ScrH() * 0.5 - h * 0.5, math.max(sidepadding * 2 + tw, w), h, Color(50, 50, 50, 255))
	local _, _, t = ZShelter.CreateLabel(ui, sidepadding, sidepadding * 0.5, "", "ZShelter-VoteUIFont", Color(255, 255, 255, 255))
	if(result) then
		t.UpdateText("Vote passed!")
	else
		t.UpdateText("Vote failed!")
	end
	local _, _, t2 = ZShelter.CreateLabel(ui, sidepadding, t:GetY() + t:GetTall() + sidepadding * 2, result, "ZShelter-VoteUIFont", Color(255, 255, 255, 255))
	local timeout = CurTime() + 5
	ui.Paint = function()
		draw.RoundedBox(0, 0, 0, ui:GetWide(), ui:GetTall(), Color(30, 30, 30, 255))
		draw.RoundedBox(0, 0, 0, ui:GetWide(), th + sidepadding, Color(20, 20, 20, 255))
		if(CurTime() > timeout) then
			ui:Remove()
		end
	end
	if(IsValid(currentVotePanel)) then
		currentVotePanel:Remove()
	end
end

surface.CreateFont("ZShelter-VoteUIFont", {
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

function ZShelter.CreateSideVotePanel(title)
	local w, h = ScreenScaleH(128), ScreenScaleH(64)
	local sidepadding = ScreenScaleH(4)
	local time = 15
	local timeout = CurTime() + time
	local tw, th = ZShelter.GetTextSize("ZShelter-VoteUIFont", title.." ["..time.."]")
	local ui = ZShelter.CreatePanel(nil, 0, ScrH() * 0.5 - h * 0.5, math.max(sidepadding * 2 + tw, w), h, Color(50, 50, 50, 255))
	local _, _, t = ZShelter.CreateLabel(ui, sidepadding, sidepadding * 0.5, title, "ZShelter-VoteUIFont", Color(255, 255, 255, 255))
	local k1, k2
	ui.Think = function()
		if(CurTime() > timeout) then
			ui:Remove()
			return
		end
		t.UpdateText(title.." ["..math.Round(timeout - CurTime()).."]")

		if(!k1 && input.IsKeyDown(KEY_1)) then
			net.Start("ZShelter_SendMulVote")
			net.WriteBool(true)
			net.SendToServer()
		end
		if(!k2 && input.IsKeyDown(KEY_2)) then
			net.Start("ZShelter_SendMulVote")
			net.WriteBool(false)
			net.SendToServer()
		end

		k1 = input.IsKeyDown(KEY_1)
		k2 = input.IsKeyDown(KEY_2)
	end
	ui.Paint = function()
		draw.RoundedBox(0, 0, 0, ui:GetWide(), ui:GetTall(), Color(30, 30, 30, 255))
		draw.RoundedBox(0, 0, 0, ui:GetWide(), th + sidepadding, Color(20, 20, 20, 255))
	end
	local _, _, yes = ZShelter.CreateLabel(ui, sidepadding, t:GetY() + t:GetTall() + sidepadding, "1 - Yes", "ZShelter-VoteUIFont", Color(255, 255, 255, 255))
	local _, _, no = ZShelter.CreateLabel(ui, sidepadding, yes:GetY() + yes:GetTall() + sidepadding, "2 - No", "ZShelter-VoteUIFont", Color(255, 255, 255, 255))
	local localplayerVote = -1

	local panels = {}

	ui.BuildVoteBlocks = function(yesVotes, unVoted)
		for k,v in ipairs(panels) do
			v:Remove()
		end
		local margin = ScreenScaleH(8)
		local totalVoters = table.Count(currentVotes)
		local blockWide = (ui:GetWide() / totalVoters) - margin
		local blockTall = ScreenScaleH(3)
		local nextX = margin * 0.5
		local nextY = ui:GetTall() - (margin + blockTall)
		local yes = yesVotes
		local unvoted = unVoted

		for i = 1, totalVoters do
			local isYesVote = yes > 0
			local color = Color(255, 0, 0, 255)
			if(isYesVote) then
				color = Color(0, 255, 0, 255)
				yes = yes - 1
			else
				if(unvoted > 0) then
					color = Color(0, 0, 0, 255)
					unvoted = unvoted - 1
				end
			end
			local block = ZShelter.CreatePanel(ui, nextX, nextY, blockWide, blockTall, color)
			table.insert(panels, block)
			nextX = nextX + blockWide + margin
		end
	end

	ui.UpdateVotes = function()
		local yesVotes = 0
		local noVotes = 0
		local unVoted = 0
		for _, vote in pairs(currentVotes) do
			if(vote == true) then
				yesVotes = yesVotes + 1
			else
				if(vote == -1) then
					unVoted = unVoted + 1
				else
					noVotes = noVotes + 1
				end
			end
		end
		yes.UpdateText("1 - Yes ("..yesVotes..")")
		no.UpdateText("2 - No ("..noVotes..")")

		ui.BuildVoteBlocks(yesVotes, unVoted)
	end
	currentVotePanel = ui
end