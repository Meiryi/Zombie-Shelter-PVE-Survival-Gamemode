AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/zshelter/shelter_b_thron01.mdl"
ENT.StartHealth = 50
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"}
ENT.PlayerFriendly = true
ENT.IsBuilding = true
ENT.IsVJBaseSNPC_Animal = true
ENT.MaximumDistance = 64
ENT.AimTarget = nil