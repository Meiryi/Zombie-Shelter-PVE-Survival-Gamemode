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

function ZShelter.CostSanity(player, amount)
	if(GetConVar("zshelter_debug_disable_sanity"):GetInt() == 1) then
		player:SetNWFloat("Sanity", 100)
		return
	end
	if(player:GetNWFloat("SanityCostImmunityTime", 0) > CurTime() || ZShelter.UnsupportedMap || !GetGlobalBool("GameStarted")) then return end
	if(GetGlobalBool("Night")) then amount = amount * 2 end
	player:SetNWFloat("Sanity", math.max(player:GetNWFloat("Sanity", 100) - amount, 0))
end

function ZShelter.AddSanity(player, amount)
	player:SetNWFloat("Sanity", math.min(player:GetNWFloat("Sanity", 100) + amount, 100))
end

hook.Add("Move", "ZShelter-PlayerThink", function(ply, mv)
	if(!ply:Alive()) then return end
	if(ply.Callbacks && ply.Callbacks.Think) then
		for k,v in pairs(ply.Callbacks.Think) do
			v(ply)
		end
	end
	if(!ply.NextTick) then
		ply.NextTick = CurTime() + 1
	else
		if(ply.NextTick < CurTime()) then
			if(ply.AFKing) then
				if(GetGlobalBool("Night")) then
					ply:RemoveFlags(FL_NOTARGET)
				else
					ply:AddFlags(FL_NOTARGET)
				end
			end

			if(ply.Callbacks.OnSecondPassed) then
				for k,v in pairs(ply.Callbacks.OnSecondPassed) do
					v(ply)
				end
			end

			if(ply:GetNWFloat("Sanity", 100) <= 0) then
				ply:SetHealth(ply:Health() - 3)
				if(ply:Health() <= 0) then
					ply:Kill()
				end
			end
			ZShelter.CostSanity(ply, ply:GetNWFloat("SanityCost", 1))

			ply.NextTick = CurTime() + 1
		end
	end

	local speed = ply:GetNWFloat("MovementSpeed", 250)
	ply:SetRunSpeed(speed)
	ply:SetWalkSpeed(speed)
end)