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

local ClassName = "Survival"

function ZShelter.Decloak(player)
	player:SetRenderMode(RENDERMODE_TRANSCOLOR)
	player:SetColor(Color(255, 255, 255, 255))
	player:SetNWBool("IsCloaking", false)
	player:RemoveFlags(FL_NOTARGET)
end

ZShelter.AddSkills(ClassName, "OnSkillCalled",
	function(player)
		if(player:GetNWBool("IsCloaking", false)) then return end
		player:SetNWBool("IsCloaking", true)
		player:SetRenderMode(RENDERMODE_TRANSCOLOR)
		player:SetColor(Color(255, 255, 255, 150))
		player:AddFlags(FL_NOTARGET)
		player:EmitSound("shigure/cloak.mp3")
		timer.Simple(30, function()
			if(!player:GetNWBool("IsCloaking", false)) then return end
			ZShelter.Decloak(player)
		end)
	end, nil, 1, "cloaking", 4, "Cloaking", nil, 60)

if(CLIENT) then
	hook.Add("PreDrawPlayerHands", "ZShelter-HandsAlpha", function()
		if(!LocalPlayer():GetNWBool("IsCloaking", false)) then return end
	    render.SuppressEngineLighting(true)
	    render.SetColorModulation(1, 1, 1)
	    render.SetBlend(0.7)
	    render.SuppressEngineLighting(false)
	end)
end