AddCSLuaFile("shared.lua")
include('shared.lua')

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Model = {"models/zshelter/bosses/zbs_bossl_big09.mdl"}
ENT.StartHealth = 5000
ENT.HullType = HULL_HUMAN

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.VJ_IsHugeMonster = true
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1, ACT_MELEE_ATTACK2}
ENT.MeleeAttackDamage = 90
ENT.MeleeAttackDistance = 100
ENT.MeleeAttackDamageDistance = 350
ENT.MeleeAttackDamageAngleRadius = 130
ENT.TimeUntilMeleeAttackDamage = 1.25
ENT.FootStepTimeWalk = 0.35
ENT.HasDeathRagdoll = false
ENT.HasDeathAnimation = true
ENT.HasExtraMeleeAttackSounds = false
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
ENT.DeathAnimationTime = 12
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
ENT.SoundTbl_FootStep = {"zombi/ampsuit/zbs_walk.wav"}
ENT.SoundTbl_Attack = {""}
ENT.SoundTbl_Rush = {""}
ENT.SoundTbl_Death = {"zombi/ampsuit/death.wav"}
ENT.SoundTbl_LeapAttackDamage = {""}

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

ENT.MovementAnimationType = 2

function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(30, 30, 100), Vector(-30, -30, 0))
end

function ENT:CustomOnLeapAttackVelocityCode()
	self.LeapEndTime = CurTime() + 1
end

ENT.OneTime = false
ENT.SetSkillTime = true

ENT.NextFlameSkillTime = 0
ENT.FlameSkillDelay = 0
ENT.FlameSkillDuration = 0

ENT.NextLaserSkillTime = 0
ENT.LaserSkillDelay = 0
ENT.LaserSkillDuration = 0
ENT.LaserAngleFix = 0

ENT.IsDoingFlameSkill = false
ENT.IsDoingLaserSkill = false

local trbounds = Vector(8, 8, 8)
function ENT:CustomOnThink()
	if(self.Dead) then return end
	if(self.SetSkillTime) then
		self.NextFlameSkillTime = CurTime() + 3
		self.NextLaserSkillTime = CurTime() + 15
		self.SetSkillTime = false
	end

	local enemy = self:GetEnemy()
	local visible = (IsValid(enemy) && self:Visible(enemy))

	if(self.NextFlameSkillTime < CurTime() && !self.IsDoingLaserSkill && visible) then
		self.FlameSkillDuration = CurTime() + 6
		self.FlameSkillDelay = CurTime() + 1.5

		self.NextMoveTime = self.FlameSkillDuration
		self.HasMeleeAttack = false

		self:VJ_ACT_PLAYACTIVITY("zbs_attack_flame", true, 6, false)

		timer.Simple(1.5, function()
			VJ_EmitSound(self, "zombi/ampsuit/zbs_attack_flame1.wav", 100, 100) 
		end)
		timer.Simple(6, function()
			self.HasMeleeAttack = true
		end)

		self.NextFlameSkillTime = CurTime() + 30
		self.NextLaserSkillTime = CurTime() + 25
	end

	if(self.FlameSkillDelay < CurTime() && self.FlameSkillDuration > CurTime()) then
		local att = self:GetAttachment(1)
		local pos = att.Pos
		local flame = ents.Create("obj_ampsuit_flame")
			flame:SetOwner(self)
			flame:SetPos(pos)
			flame:SetAngles(att.Ang)
			flame:Spawn()
			flame.KillTime = CurTime() + 1.25
	end

	if(self.NextLaserSkillTime < CurTime() && !self.IsDoingFlameSkill && visible) then
		self.LaserSkillDuration = CurTime() + 6
		self.LaserSkillDelay = CurTime() + 1.5

		self.NextMoveTime = self.LaserSkillDuration
		self.HasMeleeAttack = false

		self:VJ_ACT_PLAYACTIVITY("zbs_attack_lazer", true, 6, false)

		timer.Simple(1.5, function()
			VJ_EmitSound(self, "zombi/ampsuit/zbs_lazer.wav", 100, 100) 
		end)
		timer.Simple(6, function()
			self.HasMeleeAttack = true
		end)

		self.NextLaserSkillTime = CurTime() + 30
		self.NextFlameSkillTime = CurTime() + 25
	end

	if(self.LaserSkillDelay < CurTime() && self.LaserSkillDuration > CurTime()) then
		local att = self:GetAttachment(2)
		local pos = att.Pos
		local ang = att.Ang
		local tr = util.TraceHull({
			start = pos,
			endpos = pos + Angle(ang.p - (9 + (CurTime() - self.LaserAngleFix)), ang.y, ang.r):Forward() * 2048,
			filter = self,
			mins = -trbounds,
			maxs = trbounds,
			mask = MASK_SHOT_HULL,
			collisiongroup = COLLISION_GROUP_NPC_SCRIPTED,
		})

		local e = EffectData()
			e:SetOrigin(pos)
			e:SetStart(tr.HitPos)
		util.Effect("zshelter_boss_ampsuit", e)

		local ent = tr.Entity
		if(IsValid(ent) && (ent:IsPlayer() || ent.IsBuilding)) then
			local dmg = 60 * (1 + (GetConVar("zshelter_difficulty"):GetInt() * 0.1))
			if(ent.IsBuilding) then
				dmg = dmg * 0.33
			end
			ZShelter.DealNoScaleDamage(self, ent, dmg)
		end

		self:NextThink(CurTime())
		return true
	else
		self.LaserAngleFix = CurTime()
	end

	self.IsDoingFlameSkill = self.FlameSkillDuration > CurTime()
	self.IsDoingLaserSkill = self.LaserSkillDuration > CurTime()
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

function ENT:CustomOnMeleeAttack_BeforeChecks(seed)
	local act = self:GetSequenceActivity(self:GetSequence())
	if(act == ACT_MELEE_ATTACK1) then
		VJ_EmitSound(self, "zombi/ampsuit/zbs_attack1.wav", 100, 100) 
	else
		VJ_EmitSound(self, "zombi/ampsuit/zbs_attack2.wav", 100, 100) 
	end

	if(act == ACT_MELEE_ATTACK2) then
		for i = 1, 2 do
			timer.Simple(i * 0.3, function()
				for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 300)) do
					if(!ZShelter.IsAttackableEntity(ent)) then continue end
					ent:TakeDamage(self.MeleeAttackDamage, self, self)
				end
			end)
		end
	end
end


--[[
self:CustomOnMeleeAttack_BeforeChecks()
self:CustomOnMeleeAttack_BeforeStartTimer(seed)
self:CustomOnMeleeAttack_AfterStartTimer(seed)
]]