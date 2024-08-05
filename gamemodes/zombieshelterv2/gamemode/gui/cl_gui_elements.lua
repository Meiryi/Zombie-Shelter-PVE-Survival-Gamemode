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

function ZShelter.CreatePanelContainer(parent, x, y, w, h, color)
	local pa = ZShelter.CreatePanel(parent, x, y, w, h, color)
	pa.CurrentPanel = nil
	pa.Panels = {}

	pa.AddPanel = function(_pa)
		_pa.Alpha = 0
		table.insert(pa.Panels, _pa)
	end

	pa.Think = function()
		for k,v in pairs(pa.Panels) do
			if(v == pa.CurrentPanel) then
				if(!v:IsVisible()) then
					v:SetVisible(true)
				end
				v.Alpha = math.Clamp(v.Alpha + ZShelter.GetFixedValue(18), 0, 255)
				v:SetAlpha(v.Alpha)
			else
				if(v:IsVisible()) then
					v.Alpha = math.Clamp(v.Alpha - ZShelter.GetFixedValue(18), 0, 255)
					v:SetAlpha(v.Alpha)
					if(v.Alpha <= 0) then
						v:SetVisible(false)
					end
				end
			end
		end
	end

	return pa
end

function ZShelter.CreateTextEntry(parent, x, y, w, h, font, color, tcolor, hint, format)
	local base = ZShelter.CreateFrame(parent, x, y, w, h, Color(10, 10, 10, 200))
	local tw, th, text = ZShelter.CreateLabel(base, 0, 0, hint, font, tcolor)
	local dtextentry = base:Add("DTextEntry")
		dtextentry:SetSize(w, h - th)
		dtextentry:SetY(th)
		dtextentry:SetFont(font)
		dtextentry:SetTextColor(tcolor)
		dtextentry.oPaint = dtextentry.Paint
		dtextentry:SetPaintBackground(false)
		dtextentry.Paint = function(...)
			draw.RoundedBox(0, 0, 0, w, h, color)
			if(format == "color") then
				local var = dtextentry:GetVal()
				draw.RoundedBox(0, w - th, 0, th, th, Color(var.r, var.g, var.b, 255))
			end
			dtextentry.oPaint(...)
		end

	function dtextentry:ResetVal()
		dtextentry:SetValue("")
	end

	function dtextentry:GetVal()
		if(format == "int") then
			return tonumber(dtextentry:GetValue())
		elseif(format == "table") then
			local list = string.Explode(",", dtextentry:GetValue())
			local ret = {}
			for k,v in pairs(list) do
				if(v == "" || v == ",") then continue end
				table.insert(ret, v)
			end
			return ret
		elseif(format == "color") then
			local exp = string.Explode(",", dtextentry:GetValue())
			local r, g, b = exp[1], exp[2], exp[3]
			if(!r || r == "") then r = 255 end
			if(!g) then g = 255 end
			if(!b) then b = 255 end
			return Color(r, g, b, 255)
		else
			return dtextentry:GetValue()
		end
	end

	return dtextentry
end

function ZShelter.CreateCFGButton(parent, x, y, w, h, font, tcolor, hint)
	local outline = ScreenScaleH(1)
	local padding = ScreenScaleH(2)
	local size = h - padding * 2
	local base = ZShelter.CreateFrame(parent, x, y, w, h, Color(10, 10, 10, 200))
	base.Enabled = false
	base.Paint = function()
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawOutlinedRect(padding, padding, size, size, outline)
		if(base.Enabled) then
			draw.RoundedBox(0, padding, padding, size, size, Color(255, 255, 255, 255))
		end
	end

	local _, _, text = ZShelter.CreateLabel(base, padding * 2 + size, h / 2, hint, font, tcolor)
		text.CentVer()

	function base:ResetVal()
		base.Enabled = false
	end

	function base:SetValue(val)
		base.Enabled = val
	end

	function base:GetVal()
		return base.Enabled
	end

	ZShelter.InvisButton(base, 0, 0, w, h, function()
		base.Enabled = !base.Enabled
	end)

	return base
end