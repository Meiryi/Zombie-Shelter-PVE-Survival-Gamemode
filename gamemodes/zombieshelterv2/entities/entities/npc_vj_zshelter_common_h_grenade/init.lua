AddCSLuaFile("shared.lua")
include('shared.lua')

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Model = {"models/cso_zbs/monsters/zombi_host.mdl"}
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_GROUND

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDistance = 32
ENT.MeleeAttackDamageDistance = 64
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
ENT.SoundTbl_Death = {"zshelter/zombies/zbs_death_1.wav"}
ENT.DeathSoundPitch1 = 100

ENT.IsRun = false
ENT.IsWalk = false

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(12, 12, 65), Vector(-12, -12, 0))
end

--[[
	gut_flinch
	death1
	zbs_idle1
	zbs_walk
	zbs_run
	zbs_jump
	zbs_aim_grenade_idle1
	zbs_aim_grenade_walk
	zbs_shoot_grenade_idle1
	zbs_attack_walk
	zbs_attack1_run
	zbs_attack2_run
]]

function ENT:GrenadeSkill(target)
	local nade = ents.Create("obj_zombie_grenade")
		nade:SetPos(self:GetPos() + Vector(0, 0, 80))
		nade:Spawn()
		nade.Target = target

		timer.Simple(0, function()
			local phys = nade:GetPhysicsObject()
			local dst = self:GetPos():Distance(target:GetPos())
			local vel = (target:GetPos() - self:GetPos())
			vel:Normalize()
			vel = vel * (dst * 2)
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			if(phys) then
				phys:SetVelocity(vel)
			end
		end)
end

ENT.NextGrenadeTime = 0
function ENT:CustomOnThink()
	local enemy = self:GetTarget() 
	if(IsValid(enemy) && ZShelterVisibleNPC(self, enemy) && self:GetPos():Distance(enemy:GetPos()) < 1300) then
		if(self.NextGrenadeTime < CurTime()) then
			self:GrenadeSkill(enemy)
			self:VJ_ACT_PLAYACTIVITY("zbs_shoot_grenade_idle1", false, false)
			self.AnimTbl_Run = {ACT_WALK}
			self.NextGrenadeTime = CurTime() + 10
		end
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