AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = {"models/cso_zbs/monsters/zombi_origin.mdl"}
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
ENT.MeleeAttackDamage = 13
ENT.FootStepTimeWalk = 0.5
ENT.HasDeathRagdoll = false
ENT.HasDeathAnimation = true
ENT.HasExtraMeleeAttackSounds = true
ENT.AnimTbl_Death = {ACT_DIESIMPLE}
ENT.DeathAnimationTime = 2.5
ENT.NextMeleeAttackTime = 1
ENT.TimeUntilMeleeAttackDamage = 0.1

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
ENT.FlinchChance = 0.2
ENT.NextMoveAfterFlinchTime = 0
ENT.CanFlinch = 0
ENT.AnimTbl_Flinch = {ACT_SMALL_FLINCH}
ENT.NextFlinchTime = 1

	-- ====== Sound File Paths ====== --
ENT.SoundTbl_MeleeAttackExtra = {"zshelter/zombies/hit1.wav","zshelter/zombies/hit2.wav","zshelter/zombies/hit3.wav"}
ENT.SoundTbl_Death = {"zshelter/zombies/zbs_death_1.wav"}
ENT.DeathSoundPitch1 = 100

ENT.IsRun = false
ENT.IsWalk = false
ENT.CurrentEnemy = nil

ENT.NextAnyMeleeAttack = 0
ENT.PropCheckTraceLineLength = 0

local sch = ai_schedule.New("Chase")
	sch:EngTask("TASK_GET_PATH_TO_TARGET", 0)
	sch:EngTask("TASK_RUN_PATH", 0)

local defIdleTbl = {ACT_IDLE}
local defScaredStandTbl = {ACT_COWER}
local defShootVec = Vector(0, 0, 55)

function VJ_PICK(values)
	if istable(values) then
		return values[math.random(1, #values)] || false
	end
	return values || false
end

function ENT:IsScheduleFinished(schedule)
	return self.CurrentTaskComplete && (!self.CurrentTaskID or self.CurrentTaskID >= schedule:NumTasks())
end

function ENT:RunAI(strExp) -- Called from the engine every 0.1 seconds
	self:Think(true)
	if(self:IsRunningBehavior() || self:DoingEngineSchedule()) then return true end
	if(!self:IsSequenceFinished() && !self:IsMoving() && ((self:GetSequence() == self:GetIdealSequence()) || (self:GetActivity() == ACT_DO_NOT_DISTURB)) && self:GetSequenceMoveDist(self:GetSequence()) > 0 && self.MovementType != VJ_MOVETYPE_AERIAL && self.MovementType != VJ_MOVETYPE_AQUATIC) then
		self:AutoMovement(self:GetAnimTimeInterval())
	end
	local curSched = self.CurrentSchedule

	if(curSched) then
		if(self:IsMoving()) then
			local moveAct = self:GetMovementActivity()
			if(self:GetActivity() == moveAct) then
				self:SetMovementActivity(moveAct)
				local moveSeq = self:GetMovementSequence()
				local idealSeq = self:GetIdealSequence()
				if(moveSeq != idealSeq && self:GetSequenceActivity(moveSeq) != self:GetSequenceActivity(idealSeq)) then
					self:SetSaveValue("m_nIdealSequence", moveSeq)
				end
			end
		end
		
		self:DoSchedule(curSched)
		if(curSched.CanBeInterrupted || (self:IsScheduleFinished(curSched)) || (curSched.HasMovement && !self:IsMoving())) then
			self:SelectSchedule()
		end
	else
		self:SelectSchedule()
	end
	self:MaintainActivity()
end

local vec000 = Vector(0, 0, 0)
local function isenemy(ent)
	return !ent:IsPlayer() && !ent.IsTurret && !ent.IsShelter
end

function ENT:SelectSchedule()
	return
end

function ENT:FindEnemy()
	local dst = -1
	local pos = self:GetPos()
	local enemy = nil
	for _, ent in ipairs(ents.GetAll()) do
		if(isenemy(ent)) then continue end
		local _dst = ent:GetPos():Distance(pos)
		if(dst == -1) then
			dst = _dst
			enemy = ent
		else
			if(_dst < dst) then
				dst = _dst
				enemy = ent
			end
		end
	end
	if(IsValid(enemy)) then
		self.CurrentEnemy = enemy
		self:SetEnemy(enemy)
		self:SetTarget(enemy)
		self:SetLastPosition(enemy:GetPos())
	end
end

local props = {
	prop_physics = true,
	prop_physics_multiplayer = true,
	prop_physics_respawnable = true,
}

function ENT:DoPropCheck()
	if(self.NextPropCheck && self.NextPropCheck > CurTime()) then return end
	self.NextPropCheck = CurTime() + 0.25
	local pos = self:GetPos() + Vector(0, 0, self:OBBMaxs().z * 0.5)
	local tr = {
		start = pos,
		endpos = pos + self:GetForward() * self.PropCheckTraceLineLength,
		filter = self,
		ignoreworld = true,
	}
	local ent = util.TraceLine(tr).Entity
	if(IsValid(ent)) then
		return props[ent:GetClass()] || ent.IsPlayerBarricade, ent
	else
		return false
	end
end

local math_cos = math.cos
local math_rad = math.rad
function ENT:MeleeAttackCode(prop)
	local origin = self:GetMeleeAttackDamageOrigin()
	local hit = false
	local pos = self:GetPos()
	local dmg = self.MeleeAttackDamage
	local propdamaged = false
	for _, v in ipairs(ents.FindInSphere(self:GetMeleeAttackDamageOrigin(), self.MeleeAttackDamageDistance)) do
		if(!v:IsPlayer() && !v.IsBuilding) then continue end
		local vpos = v:GetPos()
		if(self:GetSightDirection():Dot((Vector(vpos.x, vpos.y, 0) - Vector(pos.x, pos.y, 0)):GetNormalized()) < math_cos(math_rad(self.MeleeAttackDamageAngleRadius))) then continue end
		v:TakeDamage(dmg, self, self)
		if(v == prop) then
			propdamaged = true
		end
		hit = true
	end
	if(!propdamaged && IsValid(prop)) then
		prop:TakeDamage(dmg, self, self)
	end
	if(hit) then
		self:PlaySoundSystem("MeleeAttack")
	end
end

ENT.FindEnemyTime = 0
ENT.NextChaseTime = 0
ENT.LastTarget = nil
ENT.LastTargetPosition = Vector(0, 0, 0)
ENT.PostInit = false
ENT.StuckTimer = 0

function ENT:Think(fromengine)
	if(!fromengine || self.Dead) then return end
	self:CustomOnThink()
	local curTime = CurTime()
	if(self.FindEnemyTime < curTime) then
		self:FindEnemy()
		self.FindEnemyTime = curTime + 2
	end
	if(self.StuckTimer < curTime) then
		if(!self:IsMoving()) then
			local tr = {
				start = self:GetPos(),
				endpos = self:GetPos(),
				mins = self:OBBMins(),
				maxs = self:OBBMaxs(),
				filter = self,
			}
			local ret = util.TraceHull(tr).Entity
			if(IsValid(ret.Entity) && !ret.Entity.IsBuilding) then
				self:SetAngles(Angle(0, math.random(-180, 180), 0))
				self:VJ_ACT_PLAYACTIVITY(self.AnimTbl_Run, true, 0.33, true, self.MeleeAttackAnimationDelay)
			end
		end
		self.StuckTimer = curTime + 1
	end
	self:SetEnemy(self.CurrentEnemy)
	local enemy = self:GetEnemy()
	if(IsValid(enemy)) then
		if(self.NextChaseTime < curTime) then -- Only re-chase if enemy or enemy position changed
			self.PropCheckTraceLineLength = self:OBBMins():Distance(self:OBBMaxs())
			if(self.LastTarget != enemy || self.LastTargetPosition != enemy:GetPos()) then
				--self:VJ_TASK_GOTO_TARGET()
				self:StartSchedule(sch)
				self.LastTargetPosition = enemy:GetPos()
				self.LastTarget = enemy
			else
				if(self:GetCurWaypointPos() == vec000) then
					--self:VJ_TASK_GOTO_TARGET()
					self:StartSchedule(sch)
					self.LastTargetPosition = enemy:GetPos()
					self.LastTarget = enemy
				end
			end
			self.NextChaseTime = curTime + 0.75
		end
		local spos, epos = self:GetPos(), enemy:GetPos()
		local blockedByProp, PropEnt = self:DoPropCheck()
		if(!blockedByProp) then PropEnt = nil end
		if((self.NextAnyMeleeAttack < curTime && (spos:Distance(epos) <= self.MeleeAttackDamageDistance || blockedByProp))) then
			if(!self.DisableMeleeAttackAnimation) then
				self:VJ_ACT_PLAYACTIVITY(self.AnimTbl_MeleeAttack, false, 0, true, self.MeleeAttackAnimationDelay)
			end
			self:MultipleMeleeAttacks()
			timer.Simple(self.TimeUntilMeleeAttackDamage / self:GetPlaybackRate(), function()
				if(!IsValid(self)) then return end
				self:MeleeAttackCode(PropEnt)
			end)
			self.NextAnyMeleeAttack = curTime + self.NextMeleeAttackTime
			self.StuckTimer = curTime + self.NextMeleeAttackTime
		end
	end
end

function ENT:OverrideMove() end
function ENT:OverrideMoveFacing() end

function ENT:DoKilled(dmginfo)
	hook.Run("OnNPCKilled", self, dmginfo:GetAttacker(), dmginfo:GetInflictor())
	self:SetCollisionGroup(10)
	self.RunAI = function() end -- Remove the functions so VJ Base won't do weird shit (e.g fuck with prop's collision)
	self.Think = function() end
	self.SelectSchedule = function() end
	self:PlaySoundSystem("Death")
	self:ClearSchedule()
	self:StopMoving()
	self.Dead = true
	if(self.HasDeathAnimation) then
		local time = self.DeathAnimationTime || 1
		local act = VJ_PICK(self.AnimTbl_Death)
		self:ResetIdealActivity(act)
		self:SetActivity(act)
		timer.Simple(time, function()
			if(!IsValid(self)) then return end
			self:Remove()
		end)
	else
		self:Remove()
	end
end

function ENT:OnTakeDamage(dmginfo)
	local damage = dmginfo:GetDamage()
	if(self:Health() <= damage) then
		self:DoKilled(dmginfo)
	end
	self:SetHealth(self:Health() - damage)
	return damage
end