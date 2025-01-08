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

util.AddNetworkString("ZShelter-UpgradeSkill")
util.AddNetworkString("ZShelter-AddSkillCallback")
util.AddNetworkString("ZShelter-ResetSkills")

function ZShelter.ApplySkill(ply, tier, skill)
	ply:SetNWInt("SK_"..skill.title, ply:GetNWInt("SK_"..skill.title, 0) + 1)
	ply:SetNWInt("Tier"..tier.."Spent", ply:GetNWInt("Tier"..tier.."Spent", 0) + 1)

	if(tier >= 4) then
		ply:SetNWString("Tier4Skill", skill.title)
	end

	if(skill.callback_onselect) then
		skill.callback_onselect(ply, ply:GetNWInt("SK_"..skill.title, 0))
	end

	if(skill.callbackhook && skill.callback) then
		net.Start("ZShelter-AddSkillCallback")
		net.WriteString(skill.title)
		net.Send(ply)
		if(skill.callbackhook != "MultipleHook") then
			if(!ply.Callbacks[skill.callbackhook]) then
				ply.Callbacks[skill.callbackhook] = {}
			end
			ply.Callbacks[skill.callbackhook]["SK_"..skill.title] = skill.callback
		else
			for callbackhook, callback in pairs(skill.callback) do
				if(!ply.Callbacks[callbackhook]) then
					ply.Callbacks[callbackhook] = {}
				end
				ply.Callbacks[callbackhook]["SK_"..skill.title] = callback
			end
		end
	end
end

net.Receive("ZShelter-UpgradeSkill", function(len, ply)
	local class = net.ReadString()
	local tier = net.ReadInt(32)
	local index = net.ReadInt(32)
	if(!ZShelter.AllowedToUpgrade(ply, class, tier, index)) then return end
	local skill = ZShelter.SkillList[class][tier][index]

	-- Skill successfully upgraded

	ply:SetNWInt("SkillPoints", math.max(ply:GetNWInt("SkillPoints", 0) - 1, 0))
	ply:SetNWInt("SkillPoints_TotalSpent", ply:GetNWInt("SkillPoints_TotalSpent", 0) + 1)
	ply:SetNWInt(class.."SkillSpent", ply:GetNWInt(class.."SkillSpent", 0) + 1)

	ZShelter.ApplySkill(ply, tier, skill)
end)