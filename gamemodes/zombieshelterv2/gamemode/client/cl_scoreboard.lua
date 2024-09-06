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

ZShelter.LogoIcon = Material("zsh/logo.png")
ZShelter.Scoreboard = nil
surface.CreateFont("ZShelter-ScoreboardTitleFont", {
    size = ScreenScaleH(18),
    weight = 32,
    antialias = true,
    font = "Arial",
})
surface.CreateFont("ZShelter-ScoreboardPopupFont", {
	font = "Arial",
    size = ScreenScaleH(10),
    weight = 100,
    antialias = true,
})
surface.CreateFont("ZShelter-ScoreboardDetailsFont", {
	font = "Arial",
    size = ScreenScaleH(14),
    weight = 100,
    antialias = true,
})
surface.CreateFont("ZShelter-ScoreboardDetailsFont2x", {
	font = "Arial",
    size = ScreenScaleH(16),
    weight = 10,
    antialias = true,
})

local fade_mat = Material("zsh/icon/fade_rev.png")
function ZShelter.ToggleScoreboard(display)
	if(display) then
		if(IsValid(ZShelter.Scoreboard)) then
			ZShelter.Scoreboard:Remove()
		end
		local padding = ScreenScaleH(2)
		local padding2x = padding * 2
		local padding3x = padding * 3
		local ui = ZShelter.CreatePanel(nil, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 0))
		ui.Think = function()
			if(!ui:HasFocus() && input.IsMouseDown(108)) then
				ui:MakePopup()
			end
		end
		local scl = 0.175
		ui.InnerPanel = ZShelter.CreatePanel(ui, ScrW() * scl, ScrH() * scl, ScrW() * (1 - scl * 2), ScrH() * (1 - scl * 2), Color(0, 0, 0, 0))
		local tw, th, tx = ZShelter.CreateLabel(ui.InnerPanel, padding, padding, game.GetMap().." ["..ZShelter_GetTranslate("#Dif"..GetConVar("zshelter_difficulty"):GetInt()).."]", "ZShelter-ScoreboardTitleFont", Color(255, 255, 255, 255))
		ui.Details = ZShelter.CreatePanel(ui.InnerPanel, 0, th + padding2x, ui.InnerPanel:GetWide(), ScreenScaleH(16), Color(40, 40, 40, 255), ScreenScaleH(6))
		local tw, th, tx = ZShelter.CreateLabel(ui.InnerPanel, padding, padding, GetHostName(), "ZShelter-ScoreboardTitleFont", Color(255, 255, 255, 255))
		tx:SetX(ui.InnerPanel:GetWide() - (tw + padding))

		ZShelter.CreateLabel(ui.Details, padding3x * 2, padding, ZShelter_GetTranslate("#Name"), "ZShelter-ScoreboardDetailsFont", Color(255, 255, 255, 255))

		local details = {
			{
				title = "#Contribute",
				func = function(ply)
					local var = ply:Frags()
					return var
				end,
			},
			{
				title = "#Woods",
				func = function(ply)
					local var = ply:GetNWInt("Woods", 0)
					return var
				end,
			},
			{
				title = "#Irons",
				func = function(ply)
					local var = ply:GetNWInt("Irons", 0)
					return var
				end,
			},
			{
				title = "#TK",
				func = function(ply)
					local var = ply:GetNWInt("TKAmount", 0)
					return var
				end,
			},
			{
				title = "#Deaths",
				func = function(ply)
					local var = ply:Deaths()
					return var
				end,
			},
			{
				title = "Ping",
				func = function(ply)
					local var = ply:Ping()
					return var
				end,
			},
		}
		local rev = table.Reverse(details)

		local XPos = {}
		local nextX = ui.Details:GetWide() - padding3x
		for k,v in pairs(rev) do
			local tw, th, tx = ZShelter.CreateLabel(ui.Details, nextX, padding, ZShelter_GetTranslate(v.title), "ZShelter-ScoreboardDetailsFont", Color(255, 255, 255, 255))
			XPos[v.title] = tx:GetX() - tw * 0.5
			tx:SetX(tx:GetX() - tw)
			nextX = nextX - (tw + padding3x)
		end

		local skillList = {}
		for _,category in pairs(ZShelter.SkillList) do
			for tier,skdata in pairs(category) do
				for index,skill in pairs(skdata) do
					local material = Material("zsh/icon/warning.png")
					if(ZShelter.SkillDatas[skill.title] && ZShelter.SkillDatas[skill.title].icon) then
						material = ZShelter.SkillDatas[skill.title].icon
					end
					table.insert(skillList, {
						title = "SK_"..skill.title,
						material = material,
					})
				end 
			end
		end

		local listing = ZShelter.CreateScroll(ui.InnerPanel, 0, th + padding3x + ui.Details:GetTall(), ui.InnerPanel:GetWide(),ui.InnerPanel:GetTall() - (th + padding3x + ui.Details:GetTall()), Color(0, 0, 0, 0))
		local round = ScreenScaleH(4)
		local baseheight = listing:GetTall() * 0.1
		local out = ScreenScaleH(1)
		local gap = ScreenScaleH(2)
		local out2x = out * 2
		local tall = (listing:GetTall() * 0.05) + out * 2
		local sksx = tall - out2x
		local starmat = Material("zsh/icon/star.png", "smooth")
		local starSize = ScreenScaleH(12)
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
		listing.CreatePlayers = function()
			listing:Clear()
			local player = player.GetAll()
			table.sort(player, function(a, b) return a:Frags() > b:Frags() end)
			for k,v in pairs(player) do
				local _base = ZShelter.CreatePanel(listing, 0 ,0, listing:GetWide(), baseheight + tall, Color(20, 20, 20 ,255), round)
				local hasskill = false
				local nextX = padding3x
				for index,skill in ipairs(skillList) do
					if(v:GetNWInt(skill.title, 0) <= 0 || !skill.material) then continue end
					local img = ZShelter.CreatePanel(_base, nextX + out, baseheight + out, sksx, sksx, Color(255, 255, 255 ,255)) -- Don't use Material() with DImage since it's costy
					img.Paint = function()
						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(skill.material)
						surface.DrawTexturedRect(0, 0, sksx, sksx)
					end
					nextX = nextX + sksx + padding2x
					hasskill = true
				end
				if(!hasskill) then
					_base:SetTall(baseheight)
				end
				_base:Dock(TOP)
				_base:DockMargin(0, 0, 0, ScreenScaleH(4))
				local currentRank, currentLevel, currentEXP, nextRequirement = ZShelter.CalculateRank(v:GetNWInt("ZShelterEXP", 0))
				local LevelTitle = ZShelter.GetLevelTitle(currentLevel)
				local LevelColor = ZShelter.GetLevelColor(currentLevel)
				local base = ZShelter.CreatePanel(_base, 0 ,0, listing:GetWide(), baseheight, Color(30, 30, 30, 255), round)
				base.__Color = Color(30, 30, 30, 255)
				base.Paint = function()
					if(!IsValid(v)) then
						draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(30, 30, 30, 255))
						return
					end
					if(v:Alive()) then
						draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(30, 30, 30, 255))
						base.__Color = Color(30, 30, 30, 255)
					else
						draw.RoundedBox(0, 0, 0, base:GetWide(), base:GetTall(), Color(100, 30, 30, 255))
						base.__Color = Color(100, 30, 30, 255)
					end
					draw.RoundedBox(0, 0, 0, padding, base:GetTall(), LevelColor)
				end
				local avatar = base:Add("AvatarImage")
					avatar:SetPos(padding3x, 0)
					avatar:SetSize(base:GetTall(), base:GetTall())
					avatar:SetPlayer(v, 186)
				local sx = base:GetTall() * 6
				local avatarbg = base:Add("AvatarImage")
					avatarbg:SetPos(0, (-sx * 0.5) - base:GetTall() * 0.5)
					avatarbg:SetSize(sx, sx)
					avatarbg:SetPlayer(v, 186)
					avatarbg:SetAlpha(20)
				local sx = base:GetTall() * 2
				local fade = ZShelter.CreatePanel(base, (avatarbg:GetWide()) - sx, 0, sx, base:GetWide(), Color(255, 255, 255, 255))
				fade.Paint = function()
					surface.SetDrawColor(base.__Color.r, base.__Color.g, base.__Color.b, base.__Color.a)
					surface.SetMaterial(fade_mat)
					surface.DrawTexturedRect(0, 0, fade:GetWide(), fade:GetTall())
				end
					local _, _, tx = ZShelter.CreateLabel(base, avatar:GetX() + avatar:GetTall() + padding2x, base:GetTall() * 0.5,  v:Nick(), "ZShelter-ScoreboardDetailsFont2x", Color(255, 255, 255, 255))
					tx:CentVer()
					if(currentRank > 0) then
						tx:Remove()
						_, tx_tall, tx = ZShelter.CreateLabel(base, avatar:GetX() + avatar:GetTall() + padding2x, out, v:Nick(), "ZShelter-ScoreboardDetailsFont2x", Color(255, 255, 255, 255))
						stars(base, avatar:GetX() + avatar:GetTall() + gap, base:GetTall() - starSize + out, starSize, 0, currentRank)
					end
					tx.NextUpdate = 0
					tx.Think = function()
						if(tx.NextUpdate > SysTime() || !IsValid(v)) then return end
						local str = ""
						if(!v:Alive()) then
							str = v:Nick().."  [Dead]"
						else
							str = v:Nick().."  ["..(math.Round(v:Health() / v:GetMaxHealth(), 2) * 100).."%]"
						end
						tx.UpdateText(str)
						tx.NextUpdate = SysTime() + 0.1
					end
					-- so it works even player is disconnected
					local steamid64 = v:SteamID64()
					local steamid = v:SteamID()
					local name = v:Nick()
					local profile = "https://steamcommunity.com/profiles/"..steamid64
					local upperLayer = ZShelter.InvisButton(base, 0, 0, base:GetWide(), base:GetTall(), function()
						gui.OpenURL(profile)
					end)
					upperLayer.oPaint = upperLayer.Paint
					upperLayer.Alpha = 0
					upperLayer.Paint = function()
						if(upperLayer:IsHovered()) then
							upperLayer.Alpha = math.Clamp(upperLayer.Alpha + ZShelter.GetFixedValue(10), 0, 60)
						else
							upperLayer.Alpha = math.Clamp(upperLayer.Alpha - ZShelter.GetFixedValue(10), 0, 60)
						end
						draw.RoundedBox(0, 0, 0, upperLayer:GetWide(), upperLayer:GetTall(), Color(255, 255, 255, upperLayer.Alpha))
					end
					upperLayer.DoRightClick = function()
						local x, y = input.GetCursorPos()
						local menu = ZShelter.CustomPopupMenu(base, x, y, ScrW() * 0.1, ScrH() * 0.1, Color(200, 200, 200, 255))
						menu.AddOptions("Copy SteamID", function() SetClipboardText(steamid) end)
						menu.AddOptions("Copy SteamID64", function() SetClipboardText(steamid64) end)
						menu.AddOptions("Copy Profile Link", function() SetClipboardText(profile) end)	
						menu.AddOptions("Copy Name", function() SetClipboardText(name) end)
						if(IsValid(v)) then
							if(v:IsMuted()) then
								menu.AddOptions("Unmute", function()
									v:SetMuted(false)
								end)
							else
								menu.AddOptions("Mute", function()
									v:SetMuted(true)
								end)
							end
						end
					end
				for x,y in pairs(details) do
					local var = y.func(v)
					local baseX, baseY = XPos[y.title], base:GetTall() * 0.5
					local _, _, text = ZShelter.CreateLabel(base, baseX, baseY, var, "ZShelter-ScoreboardDetailsFont", Color(255, 255, 255, 255))
					text:CentPos()

					text.NextUpdate = SysTime()
					text.Think = function()
						if(text.NextUpdate > SysTime() || !IsValid(v)) then return end
						local var = y.func(v)
						text.UpdateText(var)
						text:SetPos(baseX, baseY)
						text.CentPos()
						text.NextUpdate = SysTime() + 0.5
					end
				end
			end
		end

		listing.CreatePlayers()

		ZShelter.Scoreboard = ui
	else
		if(IsValid(ZShelter.Scoreboard)) then
			ZShelter.Scoreboard:Remove()
		end
	end
end

hook.Add("ScoreboardShow", "ZShelter_ScoreboardShow", function()
	ZShelter.ToggleScoreboard(true)
	return false
end)

hook.Add("ScoreboardHide", "ZShelter_ScoreboardHide", function()
	ZShelter.ToggleScoreboard(false)
end)
