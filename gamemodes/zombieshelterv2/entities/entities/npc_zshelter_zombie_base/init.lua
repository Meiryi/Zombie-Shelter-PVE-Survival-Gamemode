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

ENT.IsDefaultBase = true
ENT.CurrentEnemy = nil

ENT.NextAnyMeleeAttack = 0
ENT.PropCheckTraceLineLength = 0

ENT.MoveWhileAttacking = true

local schrun = ai_schedule.New("Chase1")
	schrun:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
	schrun:EngTask("TASK_RUN_PATH", 0)

local schrand = ai_schedule.New("Rand1")
	schrand:EngTask("TASK_GET_PATH_TO_RANDOM_NODE", 2048)
	schrand:EngTask("TASK_RUN_PATH", 0)

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

function ENT:RunAI(strExp)
	self:Think(true)
	self:MaintainActivity()
	self:SetMovementActivity(VJ_PICK(self.AnimTbl_Run))
end

local vec000 = Vector(0, 0, 0)
local function isenemy(ent)
	return !ent:IsPlayer() && !ent.IsTurret && !ent.IsShelter
end

function ENT:MoveToEnemy()
	self:StartSchedule(schrun)
end

function ENT:SelectSchedule()
	return
end

function ENT:FindEnemy()
	local dst = -1
	local pos = self:GetPos()
	local enemy = nil
	for _, ent in ipairs(ents.GetAll()) do
		if(ZShelter.PathValidTime < CurTime() && self:IsUnreachable(ent)) then continue end
		if(isenemy(ent) || ent.NoTarget) then continue end
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
		collisiongroup = 2,
		ignoreworld = true,
	}
	local ent = util.TraceLine(tr).Entity
	if(IsValid(ent)) then
		return props[ent:GetClass()] || ent.IsPlayerBarricade, ent
	else
		return false
	end
end

function ENT:PostInitialize()
	self:CapabilitiesClear()
	self:CapabilitiesAdd(CAP_MOVE_GROUND)
end

local math_cos = math.cos
local math_rad = math.rad
function ENT:MeleeAttackCode(prop)
	local origin = self:GetMeleeAttackDamageOrigin()
	local hit = false
	local pos = self:GetPos()
	local dmg = self.MeleeAttackDamage
	local barricadeHit = false
	local propdamaged = false
	for _, v in ipairs(ents.FindInSphere(self:GetMeleeAttackDamageOrigin(), self.MeleeAttackDamageDistance)) do
		if(!v:IsPlayer() && !v.IsBuilding) then continue end
		if(v.IsPlayerBarricade && barricadeHit) then continue end
		local vpos = v:GetPos()
		if(self:GetSightDirection():Dot((Vector(vpos.x, vpos.y, 0) - Vector(pos.x, pos.y, 0)):GetNormalized()) < math_cos(math_rad(self.MeleeAttackDamageAngleRadius))) then continue end
		v:TakeDamage(dmg, self, self)
		if(v == prop) then
			propdamaged = true
		end
		if(v.IsPlayerBarricade) then
			barricadeHit = true
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
ENT.InvalidTime = 0
ENT.InvalidCount = 0
ENT.NextRedecidePathTime = 0

function ENT:Think(fromengine)
	if(!fromengine || self.Dead) then return end
	if(!self.PostInit) then
		self:PostInitialize()
		self.PostInit = true
	end
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
				self:SetLocalVelocity(self:GetMoveVelocity() + self:GetAngles():Forward() * 1500)
				self:VJ_ACT_PLAYACTIVITY(self.AnimTbl_Run, true, 0.5, false, 0)
				self.LastStuckTime = curTime + 3
				self.NextChaseTime = curTime + 0.55
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
				self:MoveToEnemy()
				self.LastTargetPosition = enemy:GetPos()
				self.LastTarget = enemy
			else
				if(self:GetCurWaypointPos() == vec000) then
					--self:VJ_TASK_GOTO_TARGET()
					self:MoveToEnemy()
					self.LastTargetPosition = enemy:GetPos()
					self.LastTarget = enemy
				end
			end
			self.NextChaseTime = curTime + 0.6
		end
		local spos, epos = self:GetPos(), enemy:GetPos()
		local blockedByProp, PropEnt = self:DoPropCheck()
		if(!blockedByProp) then
			PropEnt = nil
		end
		self:MultipleMeleeAttacks()
		if((self.NextAnyMeleeAttack < curTime && (spos:Distance(epos) <= self.MeleeAttackDamageDistance || blockedByProp))) then
			if(!self.DisableMeleeAttackAnimation) then
				local anim = VJ_PICK(self.AnimTbl_MeleeAttack)
				local v1 = self:VJ_ACT_PLAYACTIVITY(anim, false, 0, true, self.MeleeAttackAnimationDelay)
				self.CurrentAttackAnimation = anim
				self.CurrentAttackAnimationDuration = v1
				v1 = v1 * 0.5
				self.StuckTimer = curTime + v1
				self.NextChaseTime = curTime + v1
				if(!blockedByProp) then
					local angle = (epos - spos):Angle()
					self:SetAngles(Angle(0, angle.y, 0))
				end
			end
			self:CustomOnMeleeAttack_BeforeStartTimer()
			timer.Simple(self.TimeUntilMeleeAttackDamage / self:GetPlaybackRate(), function()
				if(!IsValid(self) || self.Dead) then return end
				self:MeleeAttackCode(PropEnt)
			end)
			self.NextAnyMeleeAttack = curTime + self.NextMeleeAttackTime
			self.StuckTimer = curTime + self.NextMeleeAttackTime
		end
	end
end

function ENT:OnTaskFailed(failCode, failString)
	if(failCode == 11) then -- Pathing is fucked
		local target = self.CurrentEnemy
		if(IsValid(target)) then
			self:RememberUnreachable(target, 5)
		end
	else
		if(failCode == 13) then
			if(self.NextRedecidePathTime < CurTime()) then
				local target = self.CurrentEnemy
				if(IsValid(target) && self:DoPropCheck()) then
					self:RememberUnreachable(target, 3)
					self:StartSchedule(schrand)
					self.NextChaseTime = CurTime() + 2
				end
				self.NextRedecidePathTime = CurTime() + 1
			end
		end
	end
end

function ENT:OverrideMove()
	if(self.Dead) then return end
	if(self:GetActivity() == self.CurrentAttackAnimation && self.MoveWhileAttacking) then
		self:SetLocalVelocity(self:GetMoveVelocity() + self:GetAngles():Forward() * 300)
	end
end
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
	self:SetHealth(0)
	self:SetUpGibesOnDeath(dmginfo, 0)
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
	if(self.Dead) then return end
	local damage = dmginfo:GetDamage()
	if(self:Health() <= damage) then
		self:DoKilled(dmginfo)
	end
	self:SetHealth(self:Health() - damage)
	return damage
end