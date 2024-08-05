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

function ZShelter.WriteAvatar(steamid, ctx)
	file.Write("zombie shelter v2/avatars/"..steamid..".png", ctx)
end

local emptyAvatar = file.Read("materials/zsh/icon/emptyframe.png", "GAME")

function ZShelter.DownloadAvatar(steamid64)
	HTTP({
		failed = function(reason)
		end,
		success = function(code, body, headers)
			local st, ed = string.find(body, "<avatarFull>"), string.find(body, "</avatarFull>")
			if(st && ed) then
				st = st + 12
				ed = ed - 1
				local ctx = string.sub(body, st, ed)
				local avatar_link = string.Replace(ctx, "<![CDATA[", "")
				avatar_link = string.Replace(avatar_link, "]]>", "")
				HTTP({
					failed = function(reason)
					end,
					success = function(code, body, headers)
						ZShelter.WriteAvatar(steamid64, body)
					end,
					method = "GET",
					url = avatar_link
				})
			else
				ZShelter.WriteAvatar(steamid64, emptyAvatar)
			end
		end,
		method = "GET",
		url = "https://steamcommunity.com/profiles/"..steamid64.."?xml=1"
	})
end