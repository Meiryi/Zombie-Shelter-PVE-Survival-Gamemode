ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Effect Boomer Origin"
ENT.Author 			= "[BC™][HLO]Dr.Hunter[TR]"
ENT.Contact 		= "https://steamcommunity.com/id/6601216/"
ENT.Purpose 		= "Create and kill it"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= ""

if (CLIENT) then
local Name = "Effect Boomer Origin"
local LangName = "ef_zbs_boomer_o"
language.Add(LangName, Name)
killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
language.Add("#"..LangName, Name)
killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end