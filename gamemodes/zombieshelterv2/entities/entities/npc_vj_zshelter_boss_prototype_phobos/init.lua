AddCSLuaFile("shared.lua")
include('shared.lua')

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Model = {"models/cso_zbs/monsters/zbs_alienboss.mdl"}
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
ENT.HasLeapAttack = true -- Should the SNPC have a leap attack?
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
ENT.SoundTbl_FootStep = {"zshelter/bosses/boss_footstep_1.wav", "zshelter/bosses/boss_footstep_2.wav"}
ENT.SoundTbl_Shockwave_Ready = {"zshelter/bosses/boss_voice_1.wav"}
ENT.SoundTbl_Shockwave = {"zshelter/bosses/boss_shokwave.wav"}
ENT.SoundTbl_Attack = {"zshelter/bosses/boss_swing.wav"}
ENT.SoundTbl_Rush = {"zshelter/bosses/boss_dash.wav"}
ENT.SoundTbl_Death = {"zshelter/bosses/boss_death.wav"}
ENT.SoundTbl_LeapAttackDamage = {"zshelter/bosses/boss_dash.wav"}

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

function ENT:CustomOnLeapAttackVelocityCode()
	self.LeapEndTime = CurTime() + 0.5
end

function ENT:CustomOnThink()
	self:SetCollisionBounds(Vector(30, 30, 100), Vector(-30, -30, 0))
	if(IsValid(self:GetEnemy())) then
		if(self.ShockWaveTimer < CurTime() && !self.Rushing) then
			self:ShockWave()
			self.ShockWaveTimer = CurTime() + math.random(18, 25)
		end
	end
	if((self.LeapAttacking && !self.DoingShockwave) || self.LeapEndTime > CurTime()) then
		if(CurTime() - self.Zsh_LastLeapAttackingTime > 0.5) then
			local enemy = self:GetEnemy()
			if(IsValid(enemy) && ZShelterVisible_NPC(self, enemy)) then
				if(self.GetLeapAngle) then
					self.LeapAngle = (enemy:GetPos() - self:GetPos()):Angle()
					self.GetLeapAngle = false
				end
				local ang = self.LeapAngle
				self:SetAngles(Angle(0, ang.y, 0))
				local vel = self:GetAngles():Forward() * 2048
				vel.z = 0
				self:SetVelocity(vel)
			else
				local vel = self:GetAngles():Forward() * 2048
				vel.z = 0
				self:SetVelocity(vel)
			end
			if(self.NextLeapAttackCodeTime < CurTime()) then
				self:LeapDamageCode()
				self.NextLeapAttackTime = CurTime() + 0.08
			end
		end
	else
		self.GetLeapAngle = true
		self.Zsh_LastLeapAttackingTime = CurTime()
	end
end

function ENT:CustomOnMeleeAttack_BeforeStartTimer()
	self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
	self.TimeUntilMeleeAttackDamage = 0.3
	self.NextAnyAttackTime_Melee = 1.5
	self.MeleeAttackDamage = 50
	VJ_EmitSound(self,self.SoundTbl_Attack,100,100) 
end

function ENT:ShockWave()
	self.HasMeleeAttack = false
	self.HasLeapAttack = false
	self.DisableChasingEnemy = true
	self.DisableFindEnemy = true
	self.DoingShockwave = true
	self:VJ_ACT_PLAYACTIVITY("zbs_attack_shockwave", true, 3.5, false)
	VJ_EmitSound(self,self.SoundTbl_Shockwave_Ready,100,100)
	VJ_EmitSound(self,self.SoundTbl_Shockwave_Ready,100,100) 
	timer.Simple(2, function()
		if(!IsValid(self)) then return end
		VJ_EmitSound(self,self.SoundTbl_Shockwave,100,100)
		VJ_EmitSound(self,self.SoundTbl_Shockwave,100,100) 
		local diff = GetConVar("zshelter_difficulty"):GetInt()
		local radius = 512 * (1 + (diff - 1) * 0.05)
		local dmg = 70 * (1 + (diff - 1) * 0.05)
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 512)) do
			if(v == self) then continue end
			if(v.IsBuilding) then
				ZShelter.ApplyDamageFast(v, dmg, true, true)
				if(v.IsTurret && diff >= 8) then
					ZShelter.StunBuilding(v, 2, false)
				end
			else
				v:TakeDamage(35, self, self)
			end
		end
		util.ScreenShake(self:GetPos(), 50, 50, 2, 1024)
		self.HasMeleeAttack = true
		self.HasLeapAttack = true
		self.DisableChasingEnemy = false
		self.DisableFindEnemy = false
		self.DoingShockwave = false
	end)
end