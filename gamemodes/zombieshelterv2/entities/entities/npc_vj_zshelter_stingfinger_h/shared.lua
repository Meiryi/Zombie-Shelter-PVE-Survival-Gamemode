ENT.Base 			= "npc_zshelter_zombie_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Light Zombie"
ENT.Author 			= ""
ENT.Contact 		= ""
ENT.Purpose 		= "Create and kill it"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= ""

if (CLIENT) then
local Name = "Light Zombie"
local LangName = ""
language.Add(LangName, Name)
killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
language.Add("#"..LangName, Name)
killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end