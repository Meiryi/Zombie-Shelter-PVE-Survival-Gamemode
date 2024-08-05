ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "Zombie Needle"
ENT.Author 			= "[BC™][HLO]Dr.Hunter[TR]"
ENT.Contact 		= "https://steamcommunity.com/id/6601216/"
ENT.Information		= "An Project of projectiles"
ENT.Category		= "Counter-Strike Online: ZBS"

ENT.Spawnable = false
ENT.AdminOnly = false

if (CLIENT) then
	local Name = "Needle"
	local LangName = "obj_zbs_zneedle"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end