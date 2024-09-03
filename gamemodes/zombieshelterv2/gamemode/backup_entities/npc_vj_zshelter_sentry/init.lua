AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2023 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_hlr/hl1/sentry.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 1600 -- How far it can see
ENT.SightAngle = 180 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
ENT.VJC_Data = {
    ThirdP_Offset = Vector(0, 0, -15), -- The offset for the controller when the camera is in third person
    FirstP_Bone = "Dummy03", -- If left empty, the base will attempt to calculate a position for first person
    FirstP_Offset = Vector(0, 0, 4), -- The offset for the controller when the camera is in first person
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_AUTOMATIC_TURRET"} -- NPCs with the same class with be allied to each other
ENT.AlertedToIdleTime = VJ_Set(16, 16) -- How much time until it calms down after the enemy has been killed/disappeared | Sets self.Alerted to false after the timer expires
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.PlayerFriendly = true
ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code
ENT.RangeDistance = 1600 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 0 -- How close does it have to be until it uses melee?
ENT.RangeAttackAngleRadius = 180 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.TimeUntilRangeAttackProjectileRelease = 0.0425 -- How much time until the projectile code is ran?
ENT.RangeAttackReps = 1 -- How many times does it run the projectile code?
ENT.NextRangeAttackTime = 0 -- How much time until it can use a range attack?
ENT.NextAnyAttackTime_Range = 0.01 -- How much time until it can use any attack again? | Counted in Seconds
ENT.PoseParameterLooking_TurningSpeed = 20

ENT.Medic_CanBeHealed = false -- If set to false, this SNPC can't be healed!
ENT.PoseParameterLooking_InvertPitch = true -- Inverts the pitch poseparameters (X)
ENT.PoseParameterLooking_InvertYaw = true -- Inverts the yaw poseparameters (Y)
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Alert = {}
ENT.SoundTbl_Impact = {"ambient/energy/spark1.wav","ambient/energy/spark2.wav","ambient/energy/spark3.wav","ambient/energy/spark4.wav"}

ENT.GeneralSoundPitch1 = 100

-- Custom
ENT.Sentry_MuzzleAttach = "0" -- The bullet attachment
ENT.Sentry_AlarmAttach = "1" -- Attachment that the alarm sprite spawns
ENT.Sentry_Type = 0 -- 0 = Regular Ground Sentry | 1 = Big Ceiling/Ground Turret | 2 = Mini Ceiling/Ground Turret
ENT.Sentry_OrientationType = 0 -- 0 = Ground | 1 = Ceiling
ENT.Sentry_GroundType = 0 -- 0 = Regular Ground Sentry | 1 = Decay Ground Sentry

ENT.Sentry_HasLOS = false -- Has line of sight
ENT.Sentry_StandDown = true
ENT.Sentry_SpunUp = false
ENT.Sentry_CurrentParameter = 0
ENT.Sentry_NextAlarmT = 0
ENT.Sentry_ControllerStatus = 0 -- Current status of the controller, 0 = Idle | 1 = Alerted

ENT.StopFlameTime = 0
ENT.FlameStarted = false

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))
	self:VJTags_Add(VJ_TAG_TURRET)
	if(self.FlameTurret) then
		self.HasPoseParameterLooking = false
		self.HasMeleeAttack = true
		self.HasRangeAttack = false
		self.RangeToMeleeDistance = 340
		self.SightDistance = 340
	end
end

function ENT:MultipleMeleeAttacks()
	self.Garg_FlameSd = VJ_CreateSound(self, "vj_hlr/hl1_npc/garg/gar_flamerun1.wav")
	self:StopParticles()
	ParticleEffectAttach("vj_hlr_garg_flame_small", PATTACH_POINT_FOLLOW,self, 1)
	self.StopFlameTime = CurTime() + 0.17
	self.FlameStarted = true
	local enemy = self:GetEnemy()
	if(IsValid(enemy)) then
		self:SetAngles(Angle(self:GetAngles().x, (enemy:GetPos() - self:EyePos()):Angle().y, 0))
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	self.Sentry_ControllerStatus = 0
	self.HasPoseParameterLooking = false -- Initially, we are going to start as idle, we do NOT want the sentry turning!
	self.NextAlertSoundT = CurTime() + 1 -- So it doesn't play the alert sound as soon as it enters the NPC!
	
	function controlEnt:CustomOnKeyPressed(key)
		if key == KEY_SPACE then
			if self.VJCE_NPC.Sentry_ControllerStatus == 0 then
				self.VJCE_NPC.Sentry_ControllerStatus = 1
				self.VJCE_NPC.HasPoseParameterLooking = true
				self.VJCE_NPC:Sentry_Activate()
			elseif self.VJCE_NPC.Sentry_SpunUp then -- Do NOT become idle if we are playing an activate routine!
				self.VJCE_NPC.Sentry_ControllerStatus = 0
				self.VJCE_NPC.HasPoseParameterLooking = false
			end
		end
	end
	
	function controlEnt:CustomOnStopControlling()
		if IsValid(self.VJCE_NPC) then
			self.VJCE_NPC.HasPoseParameterLooking = true
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply, controlEnt)
	ply:ChatPrint("SPACE: Activate / Deactivate")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	local parameter = self:GetPoseParameter("aim_yaw")
	self.Sentry_CurrentParameter = parameter
	if(!IsValid(self:GetEnemy())) then
		self.Alerted = false
	end
	if(self.FlameStarted) then
		if(self.StopFlameTime < CurTime()) then
			self:StopParticles()
			self.FlameStarted = false
			VJ_STOPSOUND(self.Garg_FlameSd)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead then return end
	local eneValid = IsValid(self:GetEnemy())
	-- Make it not reset its pose parameters while its transitioning from Alert to Idle
	if (self.Sentry_ControllerStatus == 1) or (!self.VJ_IsBeingControlled && (eneValid or self.Alerted == true)) then
		self.Sentry_StandDown = false
		self.AnimTbl_IdleStand = {"spin"}
	else
		if ((self.Sentry_ControllerStatus == 0) or (!self.VJ_IsBeingControlled && self.Alerted == false)) && self.Sentry_StandDown == false then
			if self.Sentry_Type == 1 or self.Sentry_Type == 2 then
				self:AddFlags(FL_NOTARGET) -- Make it not targetable
			end
			self.Sentry_StandDown = true
			if self.Sentry_Type == 1 then
				self.Sentry_SpunUp = false
			end
		end
		if self.Sentry_StandDown == true then
			self.AnimTbl_IdleStand = {"idle_off"}
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOn_PoseParameterLookingCode(pitch, yaw, roll)
	-- Compare the difference between the current position of the pose parameter and the position it's suppose to go to
	if (math.abs(math.AngleDifference(self:GetPoseParameter("aim_yaw"), math.ApproachAngle(self:GetPoseParameter("aim_yaw"), yaw, self.PoseParameterLooking_TurningSpeed))) >= 10) or (math.abs(math.AngleDifference(self:GetPoseParameter("aim_pitch"), math.ApproachAngle(self:GetPoseParameter("aim_pitch"), pitch, self.PoseParameterLooking_TurningSpeed))) >= 10) then
		self.Sentry_HasLOS = false
	else
		self.Sentry_HasLOS = true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack()
	return self.Sentry_HasLOS == true && self.Sentry_SpunUp == true && !self.Sentry_StandDown
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAlert(ent)
	if self.VJ_IsBeingControlled then return end
	self:Sentry_Activate()
	if self.Sentry_Type == 1 or self.Sentry_Type == 2 then
		self:RemoveFlags(FL_NOTARGET) -- Other NPCs should now target it!
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Sentry_Activate()
	self.Sentry_SpunUp = true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()

	local damage = 12

	if(self.TurretDamage) then
		damage = self.TurretDamage
	end

	local gunPos = self:GetAttachment(self:LookupAttachment(self.Sentry_MuzzleAttach)).Pos
	local bullet = {}
	bullet.Num = 1
	bullet.Src = gunPos
	bullet.Dir = (self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter()) - gunPos
	bullet.Spread = Vector(math.random(-10,10), math.random(-10,10), 0)
	bullet.Tracer = 1
	bullet.TracerName = "VJ_HLR_Tracer"
	bullet.Force = 5
	bullet.Damage = damage
	bullet.AmmoType = "SMG1"
	self:FireBullets(bullet)

	sound.Play("shigure/turretfire.wav", self:GetPos(), 100, 100, 0.75)
	
	if(!self.FlameTurret && self.Sentry_Type == 0) then
		self.NextAnyAttackTime_Range = 2
		local pos = (self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter())
		if(!IsValid(att)) then att = self end

		local ef = EffectData()
		ef:SetOrigin(pos)
		util.Effect("HelicopterMegaBomb", ef)
		sound.Play( "ambient/explosions/explode_3.wav", pos, 100, 100, 1)

		util.BlastDamage(self, att, pos, 256, damage * 4)
	end

	local muz = ents.Create("env_sprite_oriented")
	muz:SetKeyValue("model","vj_hl/sprites/muzzleflash3.vmt")
	muz:SetKeyValue("scale", "0.5")
	muz:SetKeyValue("GlowProxySize","1.0") -- Size of the glow to be rendered for visibility testing.
	muz:SetKeyValue("HDRColorScale","1.0")
	muz:SetKeyValue("renderfx","14")
	muz:SetKeyValue("rendermode","3") -- Set the render mode to "3" (Glow)
	muz:SetKeyValue("renderamt","255") -- Transparency
	muz:SetKeyValue("disablereceiveshadows","0") -- Disable receiving shadows
	muz:SetKeyValue("framerate","10.0") -- Rate at which the sprite should animate, if at all.
	muz:SetKeyValue("spawnflags","0")
	muz:SetParent(self)
	muz:Fire("SetParentAttachment", self.Sentry_MuzzleAttach)
	muz:SetAngles(Angle(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)))
	muz:Spawn()
	muz:Activate()
	muz:Fire("Kill","",0.08)
	
	local muzzleLight = ents.Create("light_dynamic")
	muzzleLight:SetKeyValue("brightness", "4")
	muzzleLight:SetKeyValue("distance", "60")
	muzzleLight:SetPos(gunPos)
	muzzleLight:SetLocalAngles(self:GetAngles())
	muzzleLight:Fire("Color", "255 150 60")
	muzzleLight:SetParent(self)
	muzzleLight:Spawn()
	muzzleLight:Activate()
	muzzleLight:Fire("TurnOn","",0)
	muzzleLight:Fire("Kill","",0.07)
	self:DeleteOnRemove(muzzleLight)
end