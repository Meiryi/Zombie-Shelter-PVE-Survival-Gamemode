AddCSLuaFile("shared.lua")
include('shared.lua')

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Model = {"models/zshelter/bosses/zbs_bossl_big07.mdl"}
ENT.StartHealth = 5000
ENT.HullType = HULL_HUMAN

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.VJ_IsHugeMonster = true
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDamage = 90
ENT.MeleeAttackDistance = 100
ENT.MeleeAttackDamageDistance = 256
ENT.MeleeAttackDamageAngleRadius = 130
ENT.FootStepTimeWalk = 0.35
ENT.HasDeathRagdoll = false
ENT.HasDeathAnimation = true
ENT.HasExtraMeleeAttackSounds = false
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
ENT.DeathAnimationTime = 4
ENT.HasWorldShakeOnMove = true
ENT.NextWorldShakeOnRun = 0.35
ENT.NextWorldShakeOnWalk = 1
ENT.WorldShakeOnMoveAmplitude = 10
ENT.WorldShakeOnMoveRadius = 1000
ENT.WorldShakeOnMoveDuration = 0.25
ENT.WorldShakeOnMoveFrequency = 100
ENT.SightAngle = 180

	-- ====== Control Variables ====== --
ENT.FindEnemy_UseSphere = false
ENT.FindEnemy_CanSeeThroughWalls = false

	-- ====== Bleed & Blood Variables ====== --
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.HasBloodParticle = true
ENT.HasBloodDecal = false
ENT.HasBloodPool = true
ENT.BloodPoolSize = "Normal"

	-- ====== Movement & Idle Variables ====== --
ENT.AnimTbl_IdleStand = {ACT_IDLE}
ENT.AnimTbl_Walk = {ACT_RUN}
ENT.AnimTbl_Run = {ACT_RUN}

	-- ====== Run Away On Unknown Damage Variables ====== --
ENT.RunAwayOnUnknownDamage = false
ENT.NextRunAwayOnDamageTime = 0

	-- ====== Flinching Code ====== --
ENT.CanFlinch = 0

	-- ====== Leap Code ====== --
ENT.HasLeapAttack = false -- Should the SNPC have a leap attack?
ENT.AnimTbl_LeapAttack = {"zbs_attack_mahadash"} -- Melee Attack Animations
ENT.LeapDistance = 1024 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 64 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = 1.2 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 10 -- How much time until it can use a leap attack?
ENT.StopLeapAttackAfterFirstHit = false
ENT.NextAnyAttackTime_Leap = 1-- How much time until it can use any attack again? | Counted in Seconds
ENT.LeapAttackExtraTimers = {0.4,0.6,0.8,1} -- Extra leap attack timers | it will run the damage code after the given amount of seconds
ENT.TimeUntilLeapAttackVelocity = 1 -- How much time until it runs the velocity code?
ENT.LeapAttackVelocityForward = 2048 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 30 -- How much upward force should it apply?
ENT.LeapAttackDamage = 35
ENT.LeapAttackDamageDistance = 200 -- How far does the damage go?

	-- ====== Knock Back Variables ====== --
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackKnockBack_Forward1 = 300
ENT.MeleeAttackKnockBack_Forward2 = 300
ENT.MeleeAttackKnockBack_Up1 = 50
ENT.MeleeAttackKnockBack_Up2 = 50

	-- ====== Sound File Paths ====== --
ENT.SoundTbl_FootStep = {"zombi/fallentitan/footstep_1.wav", "zombi/fallentitan/footstep_2.wav"}
ENT.SoundTbl_Attack = {"zshelter/bosses/boss_swing.wav"}
ENT.SoundTbl_Death = {"zshelter/bosses/boss_death.wav"}

ENT.FootStepSoundLevel = 100
ENT.DeathSoundPitch1 = 100

ENT.Rushing = false
ENT.RushTimer = 0
ENT.ShockWaveTimer = 0
ENT.RushAngle = Angle(0, 0, 0)

ENT.Zsh_LastLeapAttackingTime = 0
ENT.LeapAngle = Angle(0, 0, 0)
ENT.GetLeapAngle = true
ENT.NextLeapAttackCodeTime = 0
ENT.LeapEndTime = 0

ENT.NoUnstuckChecks = true
ENT.NoPush = true

function ENT:CustomOnThink()
	self:SetMovementSequence(10)
end

ENT.MoveSpeed = 450
ENT.NextMoveTime = 0
function ENT:OverrideMove(interval)
	if(!self:IsMoving() || self.NextMoveTime > CurTime()) then return true end
	local pos, tpos = self:GetPos(), self:GetCurWaypointPos()
	if(tpos == Vector(0, 0, 0)) then return end
	local dir = tpos - pos
	dir:Normalize()
	dir.z = 0
	self:SetLocalVelocity(dir * self.MoveSpeed)
end

--[[
self:CustomOnMeleeAttack_BeforeChecks()
self:CustomOnMeleeAttack_BeforeStartTimer(seed)
self:CustomOnMeleeAttack_AfterStartTimer(seed)
]]