AddCSLuaFile("shared.lua")
include('shared.lua')

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Model = {"models/cso_zbs/effect/ef_boomer.mdl"}
ENT.StartHealth = 1
ENT.HullType = HULL_TINY

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.HasMeleeAttack = false
ENT.HasDeathRagdoll = false
ENT.HasDeathAnimation = true
ENT.HasExtraMeleeAttackSounds = true
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
ENT.DeathAnimationTime = 0

	-- ====== Bleed & Blood Variables ====== --
ENT.Bleeds = false
ENT.HasBloodParticle = false
ENT.HasBloodDecal = false
ENT.HasBloodPool = false

	-- ====== Movement & Idle Variables ====== --
ENT.AnimTbl_IdleStand = {ACT_IDLE_HURT}

	-- ====== Turning Yaw Speed Variables ====== --
ENT.TurningSpeed = 0

	-- ====== Immune God Mode Variables ====== --
ENT.GodMode = true

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	timer.Simple(0.55, function() if IsValid(self) then self:Remove() end end)	

	self:SetCollisionBounds(Vector(0, 0, 1), Vector(0, 0, 0))
end