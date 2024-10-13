AddCSLuaFile("shared.lua")
include('shared.lua')

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Model = {"models/cso_zbs/monsters/resident_zombi_host.mdl"}
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_GROUND

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDistance = 32
ENT.MeleeAttackDamageDistance = 120
ENT.MeleeAttackDamageAngleRadius = 100
ENT.MeleeAttackDamage = 10
ENT.FootStepTimeWalk = 0.5
ENT.HasDeathRagdoll = false
ENT.HasDeathAnimation = true
ENT.HasExtraMeleeAttackSounds = true
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
ENT.DeathAnimationTime = 2.5
ENT.NextMeleeAttackTime = 1

	-- ====== Control Variables ====== --
ENT.FindEnemy_UseSphere = false
ENT.FindEnemy_CanSeeThroughWalls = false

	-- ====== Bleed & Blood Variables ====== --
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "Red"
ENT.HasBloodParticle = true
ENT.HasBloodDecal = false
ENT.HasBloodPool = true
ENT.BloodPoolSize = "Normal"

	-- ====== Movement & Idle Variables ====== --
ENT.AnimTbl_IdleStand = {ACT_IDLE}
ENT.AnimTbl_Walk = {ACT_WALK}
ENT.AnimTbl_Run = {ACT_RUN}

	-- ====== Run Away On Unknown Damage Variables ====== --
ENT.RunAwayOnUnknownDamage = true
ENT.NextRunAwayOnDamageTime = 0

	-- ====== Flinching Code ====== --
ENT.FlinchChance = 0.3
ENT.NextMoveAfterFlinchTime = 0
ENT.CanFlinch = 0
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH}
ENT.NextFlinchTime = 0.8

	-- ====== Sound File Paths ====== --
ENT.SoundTbl_MeleeAttackExtra = {"zshelter/zombies/hit1.wav","zshelter/zombies/hit2.wav","zshelter/zombies/hit3.wav"}
ENT.SoundTbl_Death = {"zshelter/zombies/zbs_death_female_1.wav"}
ENT.DeathSoundPitch1 = 100
ENT.IsRun = false
ENT.IsWalk = false

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()

	self:SetCollisionBounds(Vector(12, 12, 70), Vector(-12, -12, 0))
end

function ENT:CustomOnThink()
	if self.AnimTbl_Run then
		self.IsRun = true
	elseif self.AnimTbl_Walk then
		self.IsWalk = true
	end
end

function ENT:MultipleMeleeAttacks()
	if self.AnimTbl_Run[1] == ACT_RUN then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
	else
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2}
	end
	self.TimeUntilMeleeAttackDamage = 0.1
end