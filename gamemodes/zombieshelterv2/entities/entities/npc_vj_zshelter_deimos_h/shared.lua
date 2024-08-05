ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Deimos"
ENT.Author 			= ""
ENT.Contact 		= ""
ENT.Purpose 		= "Create and kill it"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= ""

if (CLIENT) then
local Name = "Deimos"
local LangName = ""
language.Add(LangName, Name)
killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
language.Add("#"..LangName, Name)
killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end