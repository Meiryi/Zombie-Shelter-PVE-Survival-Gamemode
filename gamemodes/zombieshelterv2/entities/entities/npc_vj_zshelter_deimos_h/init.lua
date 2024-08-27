AddCSLuaFile("shared.lua")
include('shared.lua')

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Model = {"models/cso_zbs/monsters/deimos_zombi_host.mdl"}
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_GROUND

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDistance = 32
ENT.MeleeAttackDamageDistance = 85
ENT.MeleeAttackDamageAngleRadius = 100
ENT.MeleeAttackDamage = 30
ENT.FootStepTimeWalk = 0.5
ENT.HasDeathRagdoll = false
ENT.HasDeathAnimation = true
ENT.HasExtraMeleeAttackSounds = true
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
ENT.DeathAnimationTime = 4
ENT.NextMeleeAttackTime = 1

	-- ====== Grenade Variables ====== --
ENT.NeedleEntity = "obj_zbs_zneedle"

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
ENT.FlinchChance = 0
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

ENT.Skill_Time = 8.0

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	timer.Simple(0.0, function() self:EmitSound("shigure/zombie_attack1.wav", 1556, 100, 1, CHAN_STATIC) end)
	self:SetCollisionBounds(Vector(15, 15, 80), Vector(-15, -15, 0))
end

function ENT:CustomOnThink()
	if self.AnimTbl_Run then
		self.IsRun = true
	elseif self.AnimTbl_Walk then
		self.IsWalk = true
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------

function ENT:Needle_GetShootPos(TheProjectile)
	//return (self:GetEnemy():GetPos() - self:LocalToWorld(Vector(math.random(0,0),math.random(0,0),math.random(0,0))))*2 + self:GetUp()*200
	return (self:GetEnemy():GetPos() - self:LocalToWorld(Vector(0,0,0):GetNormalized()))*3 +self:GetRight()+self:GetUp()*25 + self:GetEnemy():GetVelocity()*1
end

function ENT:DropNeedle()
	if self.Dead == false then
	if self.RangeAttackAnimationStopMovement == true then self:StopMoving() end
	if IsValid(self:GetEnemy()) then
		if self.RangeAttackAnimationStopMovement == true then self:StopMoving() end
		self.RangeAttacking = true
		if /*self.VJ_IsBeingControlled == false &&*/ self.RangeAttackAnimationFaceEnemy == true then self:FaceCertainEntity(self:GetEnemy(),true) end
		local rangeprojectile = ents.Create(self.NeedleEntity)
		local getposoverride = self:RangeAttackCode_OverrideProjectilePos(rangeprojectile)
		if getposoverride == 0 then
			if self.RangeUseAttachmentForPos == false then
				rangeprojectile:SetPos(self:GetPos() + self:GetUp()*self.RangeAttackPos_Up + self:GetForward()*self.RangeAttackPos_Forward + self:GetRight()*self.RangeAttackPos_Right)
			else
				rangeprojectile:SetPos(self:GetAttachment(self:LookupAttachment(self.RangeUseAttachmentForPosID)).Pos)
			end
		else
			rangeprojectile:SetPos(getposoverride)
		end
		rangeprojectile:SetAngles((self:GetEnemy():GetPos()-rangeprojectile:GetPos()):Angle())
		rangeprojectile:Spawn()
		rangeprojectile:Activate()
		rangeprojectile:SetOwner(self)
		rangeprojectile:SetPhysicsAttacker(self)
		local phys = rangeprojectile:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake() //:GetNormal() *self.RangeDistance
			phys:SetVelocity(self:Needle_GetShootPos(rangeprojectile)) //ApplyForceCenter
		end
	end
	end
end

function ENT:MultipleMeleeAttacks()
	if self.IsRun == true then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
	elseif self.IsWalk == true then
		self.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK2}
	end
	self.TimeUntilMeleeAttackDamage = 0.1
end