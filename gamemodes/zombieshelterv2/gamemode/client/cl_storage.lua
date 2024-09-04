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

net.Receive("ZShelter-OpenStorage", function()
	ZShelter.OpenStorageUI()
end)

function ZShelter.OpenStorageUI()
	if(IsValid(ZShelter.StorageUI)) then
		ZShelter.StorageUI:Remove()
	end
	local ui = ZShelter.CreatePanel(nil, 0, 0, ScrH() * 0.625, ScrH() * 0.15, Color(0, 0, 0, 120))
	ui:MakePopup()
	ui:Center()
	ui:SetY(ScrH() * 0.37)
	local margin = ScreenScaleH(4)
	local dockmargin = ScreenScaleH(2)
	local size = ScreenScaleH(32)

	ui.oPaint = ui.Paint
	ui.Paint = function()
		ZShelter.DrawBlur(ui, 2)
		 ui.oPaint(ui)
	end

	local res = {
		[1] = "Woods",
		[2] = "Irons",
	}

	local c = LocalPlayer():GetNWInt("ResourceCapacity", 24)
	local bw, bh, dock = ScreenScaleH(32), ScreenScaleH(20), ScreenScaleH(6)
	for k,v in ipairs(res) do
		local currentAmount = 1
		local y = dockmargin + (k - 1) * (size + dockmargin)
		ZShelter.CreateImage(ui, margin, y, size, size, "zsh/icon/"..string.lower(v)..".png")
		local x = margin * 2 + size
		local counter = ZShelter.CreatePanel(ui, x, y + ScreenScaleH(6), ScreenScaleH(36), ScreenScaleH(20), Color(0, 0, 0, 0))
		counter.Paint = function()
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawOutlinedRect(0, 0, counter:GetWide(), counter:GetTall(), 1)
			draw.RoundedBox(0, 0, 0, counter:GetWide(), counter:GetTall(), Color(0, 0, 0, 120))
			draw.DrawText(GetGlobalInt(v, 0), "ZShelter-MenuLarge", counter:GetWide() / 2, counter:GetTall() / 2 - ScreenScaleH(6), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
		x = x + counter:GetWide() + dock

		ZShelter.CreateButton(ui, x, y + dock, bw, bh, "+1", "ZShelter-HUDFontSmall", Color(255, 255, 255, 255), Color(0, 0, 0, 160), function()
			net.Start("ZShelter-Storage")
			net.WriteString(v)
			net.WriteBool(false)
			net.WriteInt(1, 8)
			net.SendToServer()
		end, dock)
		x = x + bw + dockmargin
		ZShelter.CreateButton(ui, x, y + dock, bw, bh, "+"..math.floor(c / 2), "ZShelter-HUDFontSmall", Color(255, 255, 255, 255), Color(0, 0, 0, 160), function()
			net.Start("ZShelter-Storage")
			net.WriteString(v)
			net.WriteBool(false)
			net.WriteInt(math.floor(c / 2), 8)
			net.SendToServer()
		end, dock)
		x = x + bw + dockmargin
		ZShelter.CreateButton(ui, x, y + dock, bw, bh, "+"..c, "ZShelter-HUDFontSmall", Color(255, 255, 255, 255), Color(0, 0, 0, 160), function()
			net.Start("ZShelter-Storage")
			net.WriteString(v)
			net.WriteBool(false)
			net.WriteInt(c, 8)
			net.SendToServer()
		end, dock)
		x = x + bw + dock * 2
		ZShelter.CreateButton(ui, x, y + dock, bw, bh, "-1", "ZShelter-HUDFontSmall", Color(255, 255, 255, 255), Color(0, 0, 0, 160), function()
			net.Start("ZShelter-Storage")
			net.WriteString(v)
			net.WriteBool(true)
			net.WriteInt(1, 8)
			net.SendToServer()
		end, dock)
		x = x + bw + dockmargin
		ZShelter.CreateButton(ui, x, y + dock, bw, bh, "-"..math.floor(c / 2), "ZShelter-HUDFontSmall", Color(255, 255, 255, 255), Color(0, 0, 0, 160), function()
			net.Start("ZShelter-Storage")
			net.WriteString(v)
			net.WriteBool(true)
			net.WriteInt(math.floor(c / 2), 8)
			net.SendToServer()
		end, dock)
		x = x + bw + dockmargin
		ZShelter.CreateButton(ui, x, y + dock, bw, bh, "-"..c, "ZShelter-HUDFontSmall", Color(255, 255, 255, 255), Color(0, 0, 0, 160), function()
			net.Start("ZShelter-Storage")
			net.WriteString(v)
			net.WriteBool(true)
			net.WriteInt(c, 8)
			net.SendToServer()
		end, dock)
	end

	local closemat = Material("zsh/worktable/twitter.png", "smooth")

	local w, h = ScreenScaleH(36), ScreenScaleH(16)
	local btn = ZShelter.CreateButton(nil, ScrW() / 2 - w / 2, ui:GetTall() + ui:GetY() + dock, w, h, ZShelter_GetTranslate("#Close"), "ZShelter-HUDFontSmall", Color(255, 255, 255, 255), Color(0, 0, 0, 160), function()
		ui:Remove()
	end, dock)
	btn.Think = function()
		if(!IsValid(ui)) then
			btn:Remove()
		end
	end

	local size = ScreenScaleH(12)
	ZShelter.StorageUI = ui
end