AddCSLuaFile("shared.lua")
include('shared.lua')

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Model = {"models/zshelter/bosses/zbs_bossl_big07.mdl"}
ENT.StartHealth = 1000
ENT.HullType = HULL_HUMAN

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.VJ_IsHugeMonster = true
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2}
ENT.MeleeAttackDamage = 90
ENT.MeleeAttackDistance = 200
ENT.MeleeAttackDamageDistance = 256
ENT.MeleeAttackDamageAngleRadius = 160
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
ENT.NoPush = true

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
ENT.NextMeleeAttackTime = 1.25

	-- ====== Knock Back Variables ====== --
ENT.HasMeleeAttackKnockBack = true
ENT.MeleeAttackKnockBack_Forward1 = 300
ENT.MeleeAttackKnockBack_Forward2 = 300
ENT.MeleeAttackKnockBack_Up1 = 50
ENT.MeleeAttackKnockBack_Up2 = 50

	-- ====== Sound File Paths ====== --
ENT.SoundTbl_FootStep = {"zombi/fallentitan/footstep1.wav", "zombi/fallentitan/footstep2.wav"}
ENT.SoundTbl_Attack = {"zombi/fallentitan/zbs_attack2.wav"}
ENT.SoundTbl_Death = {"zombi/fallentitan/death.wav"}

	-- ====== Sound Duration Variables ====== --
ENT.FootStepTimeRun = 0.6

ENT.FootStepSoundLevel = 100
ENT.DeathSoundPitch1 = 100

ENT.MoveSpeed = 300
ENT.NextMoveTime = 0
ENT.AnimCycle = 0
ENT.IsDoingSkill = false

local vector_zero = Vector(0, 0, 0)
function ENT:CustomOnInitialize()
	ZShelter.CreatePathHelper(self)
	self.IsHugeEnemy = true
	function self:OverrideMove(interval)
		if(self.Dead || !self:IsMoving() || self.IsDoingSkill) then return end
		local helper = self.PathHelper
		if(!IsValid(helper)) then return end
		local waypoint = helper:GetCurWaypointPos()
		if(waypoint == vector_zero) then return end
		local dst = self:GetPos():Distance(waypoint)
		if(dst < 8) then
			return
		end
		local dir = (waypoint - self:GetPos()):Angle()
		self:SetAngles(Angle(0, dir.y, 0))
		local vel = dir:Forward() * self.MoveSpeed
		self:SetLocalVelocity(Vector(vel.x, vel.y, 0))
		return true
	end

	if(!self.oThink) then
		self.oThink = self.Think
	end
	self.NextThinkTime = 0
	local scale = 0.25
	local lastexec = CurTime()
	function self:Think()
		local frametime = CurTime() - lastexec
		if(self:IsMoving() && !self.IsDoingSkill) then
			self:SetActivity(ACT_WALK)
			self:SetSequence(2)
			self.AnimCycle = self.AnimCycle + frametime * scale
			if(self.AnimCycle > 1) then
				self.AnimCycle = 0
			end
			self:SetCycle(self.AnimCycle)
		end

		if(self.NextThinkTime < CurTime()) then
			self.oThink(self)
			self.NextThinkTime = CurTime() + 0.1
		end

		lastexec = CurTime()

		self:NextThink(CurTime())
		return true
	end

	timer.Simple(0, function()
		sound.Play("zombi/fallentitan/scene_howling.wav", self:GetPos(), 160, 100, 1)
	end)
end

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

ENT.LastTarget = nil
ENT.LastTargetPos = Vector(0, 0, 0)
ENT.NextGetTargetTime = 0
ENT.NextSkillTime = 0
ENT.SkillTime = 0
ENT.SkillDelayTime = 0
ENT.IsDoingSkill = false
ENT.SkillPre = false
ENT.SkillPost = false
ENT.SkillEnd = false
ENT.SkillType = 0
ENT.SkillDuration = {
	3,
	5,
	5,
}
ENT.SkillDelay = {
	1,
	0.7,
	5,
}
ENT.HitPlayers = {}
ENT.NextFootStep = 0
ENT.NextCannonTime = 0

function ENT:CustomOnThink()
	if(self.Dead) then return end

	if(self.NextGetTargetTime < CurTime() && self.LastTargetPos) then
		local target = self:GetEnemy()
		if((IsValid(target) && IsValid(self.PathHelper) && (self.LastTargetPos != target:GetPos() || self.LastTarget != target)) || (IsValid(target) && IsValid(self.PathHelper) && self.PathHelper:GetCurWaypointPos() == vector_zero)) then
			self.PathHelper:GoTo(target:GetPos(), target)

			self.LastTarget = target
			self.LastTargetPos = target:GetPos()
		end
		self.NextGetTargetTime = CurTime() + 1.25
	end

	self.IsDoingSkill = self.SkillTime > CurTime()

	if(self.NextSkillTime < CurTime()) then
		local target = self:GetEnemy()
		local type = math.random(1, 2)
		if(!IsValid(target) || !self:Visible(target)) then
			goto recheck
		end
		local dur = self.SkillDuration[type]
		local delay = self.SkillDelay[type]
		self.SkillDelayTime = CurTime() + delay
		self.SkillType = type
		self.SkillTime = CurTime() + dur
		self.NextSkillTime = CurTime() + math.random(18, 25) + dur
		::recheck::
	end

	if(self.SkillTime > CurTime()) then
		self.HasMeleeAttack = false
		local target = self:GetEnemy()
		local valid = IsValid(target)
		self.SkillEnd = true
		if(!self.SkillPre) then
			if(self.SkillType == 1) then
				self:VJ_ACT_PLAYACTIVITY("zbs_dash_ready", true, 3, false)
			elseif(self.SkillType == 2) then
				self:VJ_ACT_PLAYACTIVITY("zbs_cannon_ready", true, 3, false)
				sound.Play("zombi/fallentitan/zbs_cannon_ready.wav", self:GetPos(), 140, 100, 1)
			end
		end

		if(self.SkillDelayTime < CurTime()) then
			if(!self.SkillPost) then
				if(self.SkillType == 1) then
					self:VJ_ACT_PLAYACTIVITY("zbs_dash", true, 1, false)
				end
			end

			if(self.SkillType == 1) then
				if(self:GetSequence() == 5 || self:GetCycle() >= 0.9) then
					self:VJ_ACT_PLAYACTIVITY("zbs_dash", true, 1, false)
				end
				local vel = self:GetAngles():Forward() * 2048
				local dmg = (1 + GetConVar("zshelter_difficulty"):GetInt() * 0.06) * 10
				self:SetLocalVelocity(vel)
				if(self.NextFootStep < CurTime()) then
					sound.Play("zombi/fallentitan/footstep"..math.random(1, 2)..".wav", self:GetPos(), 120, 100, 1)
					self.NextFootStep = CurTime() + 0.2
				end
				for k,v in ipairs(ents.FindInSphere(self:GetPos(), 120)) do
					if(!v.IsBuilding && !v:IsPlayer()) then continue end
					local index = v:EntIndex()
					if(v.IsBuilding) then
						if(v.IsPlayerBarricade) then
							ZShelter.ApplyDamageFast(v, 100, true)
						else
							ZShelter.ApplyDamageFast(v, 3, true)
						end
					else
						if(!self.HitPlayers[index]) then
							self.HitPlayers[index] = 0
						end
						if(v:IsPlayer()) then
							if(self.HitPlayers[index] < CurTime()) then
								v:TakeDamage(dmg, v, v)
								self.HitPlayers[index] = CurTime() + 0.1
							end
							v:SetVelocity(-v:GetVelocity() + vel + Vector(0, 0, -400))
						else
							v:SetVelocity(-v:GetVelocity() + vel)
						end
					end
				end
			elseif(self.SkillType == 2) then
				if(self.NextCannonTime < CurTime()) then
					self:VJ_ACT_PLAYACTIVITY("zbs_cannon1", true, 2, false)
					sound.Play("zombi/fallentitan/zbs_cannon1.wav", self:GetPos(), 140, 100, 1)

					for i = 1, math.random(1, 3) do
						local anglerand = 8
						local missile = ents.Create("obj_fallentitan_missile")
							missile:SetPos(self:GetAttachment(1).Pos)
							missile:SetAngles(self:GetAngles() + Angle(math.random(-anglerand, anglerand), math.random(-anglerand, anglerand), 0))
							missile:SetOwner(self)
							missile:Spawn()
							missile.damage = 15 + (GetConVar("zshelter_difficulty"):GetInt() * 1.5)

							local phys = missile:GetPhysicsObject()

							if(IsValid(phys)) then
								phys:SetVelocity(missile:GetAngles():Forward() * 2048)
							end
					end

					self.NextCannonTime = CurTime() + 0.2
				end
			end

			self.SkillPost = true
		else
			if(self.SkillType == 1) then
				if(valid) then
					local ang = Angle(0, (target:GetPos() - self:GetPos()):Angle().y, 0)
					self:SetAngles(ang)
				end
			elseif(self.SkillType == 2) then
				if(valid) then
					local ang = Angle(0, (target:GetPos() - self:GetPos()):Angle().y, 0)
					self:SetAngles(ang)
				end
			end
		end

		self.SkillPre = true
	else
		if(self.SkillEnd) then
			if(self.SkillType == 1) then
				self:VJ_ACT_PLAYACTIVITY("zbs_dash_end", true, 1, false)
			elseif(self.SkillType == 2) then
				self:VJ_ACT_PLAYACTIVITY("zbs_cannon_end", true, 1, false)
			end
		end
		self.HitPlayers = {}
		self.SkillEnd = false
		self.SkillPre = false
		self.SkillPost = false
		self.HasMeleeAttack = true
	end
	
end

function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo)
	if(self.IsDoingSkill) then
		dmginfo:ScaleDamage(0.33)
	end
end

--[[
self:CustomOnMeleeAttack_BeforeChecks()
self:CustomOnMeleeAttack_BeforeStartTimer(seed)
self:CustomOnMeleeAttack_AfterStartTimer(seed)
]]