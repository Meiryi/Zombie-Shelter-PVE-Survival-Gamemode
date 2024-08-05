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
ZShelter.GUI_Scoreboard_Title = nil
surface.CreateFont("TitleFont", {
    size = 30,
    weight = 32,
    antialias = true,
    font = "Arial",
})

function DrawScoreboard(boolen)
	if(boolen) then
		local width = ScrW() * 0.6
		local height = ScrH() * 0.65
   		ZShelter.GUI_Scoreboard_Title = vgui.Create("DPanel")
    	ZShelter.GUI_Scoreboard_Title:SetSize(width, height)
		ZShelter.GUI_Scoreboard_Title:AlignTop( ScrH() * 0.12 )
		ZShelter.GUI_Scoreboard_Title:CenterHorizontal()

		local diff = GetConVar("zshelter_difficulty"):GetInt()
		local str = ZShelter_GetTranslate("#Map").." : "..game.GetMap().."   ["..ZShelter.GetDiffName(diff).."]"
    	function ZShelter.GUI_Scoreboard_Title:Paint(w, h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( ZShelter.LogoIcon )
			surface.DrawTexturedRect( (w / 2) - 110 ,0, 250, 100 )
        	draw.SimpleText(str, "TitleFont", ScreenScale(10), ZShelter.GUI_Scoreboard_Title:GetTall() * 0.165, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    	end

		local header = ZShelter.GUI_Scoreboard_Title:Add("DHeaderPanel")
		header:Dock(TOP)
    	header:SetSize(ZShelter.GUI_Scoreboard_Title:GetWide(), 35)
    	header:DockMargin(0,150,0,0)

    	local board = ZShelter.GUI_Scoreboard_Title:Add("DPanel")
		board:Dock(FILL)
    	board:SetSize(width, 40)
		board:CenterHorizontal()
		board.Paint = function()
			draw.RoundedBox( 10, 0, 0, board:GetWide(), board:GetTall(), Color( 0, 0, 0, 150 ) )
		end
    	local ScrollPanel = ZShelter.CreateScroll(board, 0, 0, 0, 0, Color(0, 0, 0, 0))
    	ScrollPanel:Dock(FILL)
    	local Bar = ScrollPanel:GetVBar()
    	local butC = 0
    	local PlayerPanels
    	if PlayerPanels == nil then
        	PlayerPanels = {}
    	end
   		local function RemovePlayerPanel(panel)
	    	if panel:IsValid() then
	    		PlayerPanels[panel:GetPlayer()] = nil
	    		panel:Remove()
	    	end
    	end
		for pl, panel in pairs(PlayerPanels) do
			if not panel:IsValid() or pl:IsValid() and pl:IsSpectator() then
				RemovePlayerPanel(panel)
			end
		end
    	local function GetPlayerPanel(pl)
        	for _, panel in pairs(PlayerPanels) do
            	if panel:IsValid() and panel:GetPlayer() == pl then
                	return panel
            	end
        	end
    	end
	    local function CreatePlayerPanel(pl)
   		    local curpan = GetPlayerPanel(pl)
    	    if curpan and curpan:IsValid() then return curpan end

    	    local panel = ScrollPanel:Add("DPlayerLine")
    	    panel:SetPlayer(pl)
    	    panel:Dock(TOP)
    	    panel:DockMargin(ScrollPanel:GetWide() * 0.01, 2, ScrollPanel:GetWide() * 0.01, 2)
    
    	    PlayerPanels[pl] = panel
    
        	return panel
    	end

     board:SizeToChildren(true, false)

    local player_score = {}
    for _, ply in pairs(player.GetAll()) do
        player_score[ply] = ply:Frags()
    end

    for ply, _ in SortedPairsByValue(player_score, true) do
        CreatePlayerPanel(ply)
    end

    local function GetPlayerPanel(pl)
        for _, panel in pairs(PlayerPanels) do
            if panel:IsValid() and panel:GetPlayer() == pl then
                return panel
            end
        end
    end
	else
		if(IsValid(ZShelter.GUI_Scoreboard_Title)) then
			ZShelter.GUI_Scoreboard_Title:Remove()
		end
	end
end

hook.Add( "ScoreboardShow", "ZShelter_ScoreboardShow", function()
	DrawScoreboard(true)
	return false
end )

hook.Add( "ScoreboardHide", "ZShelter_ScoreboardHide", function()
	DrawScoreboard(false)
end )
