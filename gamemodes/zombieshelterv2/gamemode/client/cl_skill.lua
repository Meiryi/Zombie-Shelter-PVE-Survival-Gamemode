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

net.Receive("ZShelter-ResetSkills", function()
	LocalPlayer().Callbacks = {}
end)

net.Receive("ZShelter-AddSkillCallback", function()
	local skill = net.ReadString()
	local skTable = ZShelter.SkillDatas[skill]
	if(!skTable) then return end
	if(!LocalPlayer().Callbacks) then
		LocalPlayer().Callbacks = {}
	end
	if(skTable.callbackhook != "MultipleHook") then
		if(!LocalPlayer().Callbacks[skTable.callbackhook]) then
			LocalPlayer().Callbacks[skTable.callbackhook] = {}
		end
		LocalPlayer().Callbacks[skTable.callbackhook][skTable.title] = skTable.callback
	else
		for callbackhook, callback in pairs(skTable.callback) do
			if(!LocalPlayer().Callbacks[callbackhook]) then
				LocalPlayer().Callbacks[callbackhook] = {}
			end
			LocalPlayer().Callbacks[callbackhook][skTable.title] = callback
		end
	end
end)

function ZShelter.UltimateSkill(skill)
	if(!LocalPlayer():Alive()) then return end
	net.Start("ZShelter-UltimateSkill")
	net.SendToServer()
	LocalPlayer():SetNWFloat("UltimateCooldown", CurTime() + skill.cooldown)

	if(skill.callbackhook == "MultipleHook" && istable(skill.callback) && skill.callback.OnSkillCalled_Client) then
		skill.callback.OnSkillCalled_Client(LocalPlayer())
	end
end