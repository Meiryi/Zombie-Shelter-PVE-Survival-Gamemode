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
//ENT.SoundTbl_FootStep = {"zombi/fallentitan/footstep1.wav", "zombi/fallentitan/footstep2.wav"}
ENT.SoundTbl_Attack = {"zshelter/bosses/boss_swing.wav"}
ENT.SoundTbl_Death = {"zshelter/bosses/boss_death.wav"}

ENT.FootStepSoundLevel = 100
ENT.DeathSoundPitch1 = 100

--[[
	0	dummy
	1	scene_appear1
	2	scene_appear2
	3	scene_appear3
	4	scene_howling
	5	zbs_idle1
	6	zbs_walk
	7	zbs_run
	8	zbs_dash_ready
	9	zbs_dash
	10	zbs_dash_end
	11	zbs_attack1
	12	zbs_attack2
	13	zbs_cannon_ready
	14	zbs_cannon1
	15	zbs_cannon_end
	16	zbs_cannon2
	17	zbs_landmine1
	18	zbs_landmine2
	19	death
]]

ENT.PrintSequence = true
function ENT:CustomOnThink()
	if(self.PrintSequence) then
		for i = 0, self:GetSequenceCount() - 1 do
			print(i, self:GetSequenceName(i), self:GetSequenceActivityName(i))
		end
		self.PrintSequence = false
	end
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
	--self:SetLocalVelocity(dir * self.MoveSpeed)
end

--[[
self:CustomOnMeleeAttack_BeforeChecks()
self:CustomOnMeleeAttack_BeforeStartTimer(seed)
self:CustomOnMeleeAttack_AfterStartTimer(seed)
]]