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

util.AddNetworkString("ZShelter-Messages")

ZShelter.DayMessages = {}

function ZShelter.SetDayMessage(day, message, color, style)
	ZShelter.DayMessages[day] = {
		msg = message,
		clr = color,
		style = style,
	}
end

function ZShelter.BroadcastMessage(msg, color, style)
	if(!msg) then msg = "Undefined Message" end
	if(!color) then color = color_white end
	if(!style) then style = false end
	net.Start("ZShelter-Messages")
	net.WriteBool(style)
	net.WriteString(msg)
	net.WriteColor(color, false)
	net.Broadcast()
end

ZShelter.SetDayMessage(15, "#CommHint", Color(255, 255, 255, 255), true)