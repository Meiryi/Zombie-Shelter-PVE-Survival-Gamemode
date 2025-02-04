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

util.AddNetworkString("ZShelter-UltimateSkill")

net.Receive("ZShelter-UltimateSkill", function(len, ply)
	local skill = ply:GetNWString("Tier4Skill", "")
	local skTable = ZShelter.SkillDatas[skill]
	local cd = ply:GetNWFloat("UltimateCooldown", 0)
	local bypass = false

	if(skill == "" || !skTable) then return end

	if(skTable.callbackhook == "MultipleHook" && istable(skTable.callback) && skTable.callback.OnSkillRequestReceived) then
		bypass = skTable.callback.OnSkillRequestReceived(ply)
	end
	if(cd > CurTime() && !bypass) then return end
	if(bypass == -1) then return end

	if(bypass != -2) then
		ply:SetNWFloat("UltimateCooldown", CurTime() + skTable.cooldown)
	end

	if(skTable.callbackhook == "OnSkillCalled" && skTable.callback) then
		skTable.callback(ply)
	else
		if(skTable.callbackhook == "MultipleHook" && istable(skTable.callback) && skTable.callback.OnSkillCalled) then
			skTable.callback.OnSkillCalled(ply)
		end
	end
end)