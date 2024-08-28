AddCSLuaFile("shared.lua")
include('shared.lua')

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Model = {"models/monsters/zbs_oberon.mdl"}
ENT.StartHealth = 500
ENT.HullType = HULL_HUMAN

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.VJ_IsHugeMonster = true
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.HasMeleeAttack = true
ENT.MeleeAttackDamage = 80
ENT.MeleeAttackDistance = 128
ENT.MeleeAttackDamageDistance = 256
ENT.MeleeAttackDamageAngleRadius = 130
ENT.FootStepTimeRun = 0.8
ENT.FootStepTimeWalk = 1
ENT.HasDeathRagdoll = false
ENT.HasDeathAnimation = true
ENT.HasExtraMeleeAttackSounds = false
ENT.DeathAnimationTime = 10
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

ENT.AnimTbl_Death = {"ACT_DIESIMPLE"}
ENT.AnimTbl_IdleStand = {"zbs_idle1"}
ENT.AnimTbl_Walk = {6}
ENT.AnimTbl_Run = {6}
ENT.AnimTbl_MeleeAttack = {"zbs_attack1", "zbs_attack2"}

	-- ====== Sound File Paths ====== --
ENT.SoundTbl_FootStep = {"zshelter/bosses/oberon/footstep.wav"}
ENT.SoundTbl_Rush = {"zshelter/bosses/boss_dash.wav"}
ENT.SoundTbl_Death = {"zshelter/bosses/oberon/death.wav"}

ENT.FootStepSoundLevel = 100
ENT.DeathSoundPitch1 = 100

ENT.KnifeMode = false

--[[
	0	scene_appear
	1	zbs_idle1
	2	zbs_walk (6)
	3	zbs_run
	4	zbs_jump
	5	zbs_attack1
	6	zbs_attack2
	7	zbs_attack3
	8	zbs_attack_bomb
	9	zbs_attack_hole
	10	scene_knife
	11	knife_idle
	12	knife_walk (14)
	13	knife_attack1
	14	knife_attack2
	15	knife_attack3
	16	zbs_attack_bomb_2
	17	knife_attack_bomb
	18	knife_attack_hole
]]

ENT.TestSequence = false
ENT.BombTime = 0
ENT.HoleTime = 0
ENT.DamageImmunityTime = 0
ENT.ResetTime = true
ENT.HoleSkill = false
ENT.BombSkill = false
ENT.KnifeSwitching = false

function ENT:CustomOnInitialize()
	timer.Simple(0.0, function() self:EmitSound("zshelter/bosses/oberon/appear.wav", 1556, 100, 1, CHAN_STATIC) end)
end

function ENT:SwitchToKnifeMode()
	VJ_EmitSound(self, "zshelter/bosses/oberon/knife.wav", 100, 100)
	self.AnimTbl_IdleStand = {"knife_idle"}
	self.AnimTbl_Walk = {14}
	self.AnimTbl_Run = {14}
	self.AnimTbl_MeleeAttack = {"knife_attack1", "knife_attack2"}
	self:VJ_ACT_PLAYACTIVITY("scene_knife", true, 8.25, false)
	self.KnifeMode = true
	self.BombTime = CurTime() + 25
	self.HoleTime = CurTime() + 10
	self.damage = (self.damage || 60) * 1.5
	self.DamageImmunityTime = CurTime() + 8.5
end

function ENT:SpawnBombs()
	local pos = self:GetPos() + Vector(0, 0, 10)
	local rand = 512
	local dmg = 40 * (GetConVar("zshelter_difficulty"):GetInt() * 0.033)
	for i = 1, 20 do
		local bomb = ents.Create("obj_oberon_bomb")
			bomb:SetPos(pos)
			bomb:Spawn()
			bomb:SetOwner(self)
			bomb:SetAngles(AngleRand())
			local phys = bomb:GetPhysicsObject()
			if(IsValid(phys)) then
				phys:SetVelocity(Vector(math.random(-rand, rand), math.random(-rand, rand), math.random(850, 1100)))
			end
			bomb.damage = dmg
	end
end

function ENT:CustomOnThink()
	self:SetCollisionBounds(Vector(30, 30, 100), Vector(-30, -30, 0))
	if(self.Dead) then return end
	local vel = self:GetMoveVelocity():Length2D()
	if(vel >= 280) then
		self:SetMoveVelocity(self:GetMoveVelocity() * 0.8)
	end

	if(self.ResetTime) then
		self.BombTime = CurTime() + 20
		self.HoleTime = CurTime() + 5
		self.ResetTime = false
	end

	if(self.HoleTime < CurTime()) then
		if(!self.BombSkill) then
			if(self.KnifeMode) then
				self:VJ_ACT_PLAYACTIVITY("knife_attack_hole", true, 6.5, false)
				VJ_EmitSound(self, "zshelter/bosses/oberon/knife_hole.wav", 100, 100)
			else
				self:VJ_ACT_PLAYACTIVITY("zbs_attack_hole", true, 6.5, false)
				VJ_EmitSound(self, "zshelter/bosses/oberon/hole.wav", 100, 100)
			end
			local anim = self:LookupSequence("idle1")
				self.holeent = ents.Create("prop_dynamic")
				self.holeent:SetModel("models/misc/ef_hole.mdl")
				self.holeent:SetPos(self:GetPos())
				self.holeent:SetOwner(self)
				self.holeent:SetParent(self)
				self.holeent:DrawShadow(false)
				self.holeent:Spawn()
				self.holeent:ResetSequence(anim)
				local ref = self.holeent
			timer.Simple(5, function()
				if(IsValid(ref)) then
					ref:Remove()
				end
				if(!IsValid(self)) then return end
				local diff = GetConVar("zshelter_difficulty"):GetInt()
				local dmg = 70 * (1 + (diff - 1) * 0.05)
				for k,v in pairs(ents.FindInSphere(self:GetPos(), 400)) do
					if(v == self) then continue end
					if(!v.IsBuilding && !v:IsPlayer()) then continue end
					if(v.IsBuilding) then
						ZShelter.ApplyDamageFast(v, dmg, true, true)
					else
						v:TakeDamage(35, self, self)
					end
				end
				self.HoleSkill = false
			end)
		end
		self.HoleSkill = true
		self.BombTime = CurTime() + 25
		self.HoleTime = CurTime() + 45
	end

	if(self.HoleSkill) then
		local maxdst = 3072
		for k,v in ipairs(player.GetAll()) do
			local dst = v:GetPos():Distance(self:GetPos())
			if(dst > maxdst) then continue end
			local f = 1 - math.Clamp(dst / maxdst, 0, 1)
			local vel = (self:GetPos() - v:GetPos())
			vel:Normalize()
			v:SetVelocity((vel * 310) * f)
		end
	end

	if(self.BombTime < CurTime() && !self.HoleSkill) then
		if(self.KnifeMode) then
			self:VJ_ACT_PLAYACTIVITY("zbs_attack_bomb_2", true, 14, false)
		else
			self:VJ_ACT_PLAYACTIVITY("zbs_attack_bomb", true, 14, false)
		end
		for i = 1, 3 do
			timer.Simple(3 + ((i - 1) * 2.75), function()
				if(!IsValid(self)) then return end
				VJ_EmitSound(self, "zshelter/bosses/oberon/knife_attack_bomb.wav", 100, 100)
				self:SpawnBombs()
				if(i == 3) then
					self.BombSkill = false
				end
			end)
		end
		self.BombSkill = true
		self.BombTime = CurTime() + 50
	end
end

function ENT:CustomOnMeleeAttack_AfterStartTimer(seed)
	local sequence = self:GetSequence()
	if(sequence == 5) then
		VJ_EmitSound(self, "zshelter/bosses/oberon/attack1.wav", 100, 100)
	elseif(sequence == 6) then
		VJ_EmitSound(self, "zshelter/bosses/oberon/attack2.wav", 100, 100)
	elseif(sequence == 13) then
		VJ_EmitSound(self, "zshelter/bosses/oberon/knife_attack1.wav", 100, 100)
	elseif(sequence == 14) then
		VJ_EmitSound(self, "zshelter/bosses/oberon/knife_attack2.wav", 100, 100)
	end
end

function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo)
	if(self:Health() <= self:GetMaxHealth() * 0.5 && !self.KnifeMode) then
		self:SetHealth(self:GetMaxHealth())
		self:SwitchToKnifeMode()
	end
	if(self.DamageImmunityTime > CurTime()) then
		dmginfo:SetDamage(1)
	end
end

game.AddParticles("particles/zbs_fx.pcf")

PrecacheParticleSystem("oberon_hole")
PrecacheParticleSystem("oberon_hole2")