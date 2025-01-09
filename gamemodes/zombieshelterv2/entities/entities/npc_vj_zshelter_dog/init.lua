AddCSLuaFile("shared.lua")
include('shared.lua')

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Model = {"models/cso_zbs/monsters/zombiedog.mdl"}
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_GROUND

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDistance = 32
ENT.MeleeAttackDamageDistance = 100
ENT.MeleeAttackDamageAngleRadius = 100
ENT.MeleeAttackDamage = 9
ENT.FootStepTimeWalk = 0.6
ENT.FootStepTimeRun = 0.1
ENT.HasDeathRagdoll = false
ENT.HasDeathAnimation = true
ENT.HasExtraMeleeAttackSounds = true
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
ENT.DeathAnimationTime = 3
ENT.NextMeleeAttackTime = 0.8

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

ENT.HasLeapAttack = true
ENT.LeapDistance = 400 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 150 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = 0.2 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 10 -- How much time until it can use a leap attack?
ENT.NextAnyAttackTime_Leap = 1 -- How much time until it can use any attack again? | Counted in Seconds
ENT.LeapAttackExtraTimers = {0.4,0.6,0.8,1} -- Extra leap attack timers | it will run the damage code after the given amount of seconds
ENT.TimeUntilLeapAttackVelocity = 0.2 -- How much time until it runs the velocity code?
ENT.LeapAttackVelocityForward = 300 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 250 -- How much upward force should it apply?
ENT.LeapAttackDamage = 20
ENT.LeapAttackDamageDistance = 100 -- How far does the damage go?

	-- ====== Flinching Code ====== --
ENT.FlinchChance = 0.3
ENT.NextMoveAfterFlinchTime = 0
ENT.CanFlinch = 0
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH}
ENT.NextFlinchTime = 0.8

	-- ====== Sound File Paths ====== --
ENT.SoundTbl_Idle = {"zshelter/zombies/zombiedog_idle.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"zshelter/zombies/zombiedog_attack1.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"npc/barnacle/barnacle_crunch3.wav"}
ENT.SoundTbl_Death = {"zshelter/zombies/zombiedog_death1.wav"}
ENT.SoundTbl_Bite = {"zshelter/zombies/zombiedog_skill1.wav"}
ENT.SoundTbl_AttackRun = {"zshelter/zombies/zombiedog_attack_run.wav"}

ENT.AlertSoundPitch1 = 100
ENT.DeathSoundPitch1 = 100
ENT.Skill_Time = 8.0

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	timer.Simple(0.0, function()
		if(!IsValid(self)) then return end
		if(math.random(1, 2) == 2) then
			self:EmitSound("zshelter/zombies/zombiedog_howls.wav", 100, 100, 1, CHAN_STATIC)
		end
	end)
	self:SetCollisionBounds(Vector(12, 12, 65), Vector(-12, -12, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.NextLeapATime = 0
function ENT:CustomOnThink()
	local enemy = self:GetTarget()
	if(IsValid(enemy) && enemy:Visible(enemy)) then
		if(self.NextLeapATime < CurTime()) then
			local angle = (enemy:GetPos() - self:GetPos()):Angle()
			self:EmitSound("zshelter/zombies/zombiedog_skill1.wav")
			timer.Simple(self.TimeUntilLeapAttackVelocity, function()
				local vel = (angle:Forward() * 3000)
				vel.z = 0
				self:SetVelocity(vel + Vector(0, 0, self.LeapAttackVelocityUp))
			end)
			for k,v in ipairs(self.LeapAttackExtraTimers) do
				timer.Simple(v, function()
					if(!IsValid(self) || !self.LeapDamageCode) then return end
					self:LeapDamageCode()
				end)
			end
			self.NextLeapATime = CurTime() + self.NextLeapAttackTime
		end
	end
end

function ENT:CustomOnMeleeAttack_BeforeStartTimer()
	self.AnimTbl_MeleeAttack = {ACT_RUN_HURT}
	self.TimeUntilMeleeAttackDamage = 1
	self.MeleeAttackDamage = 13
	self.MeleeAttackDamageDistance = 100
	self.MeleeAttackDamageAngleRadius = 100
	VJ_EmitSound(self,self.SoundTbl_AttackRun,100,100)
end

function ENT:MultipleMeleeAttacks()
	if self.AnimTbl_Run[1] == ACT_RUN then
		self.AnimTbl_MeleeAttack = {ACT_RUN_HURT}
	else
		self.AnimTbl_MeleeAttack = {ACT_WALK_HURT}
	end
	self.TimeUntilMeleeAttackDamage = 0.1
end