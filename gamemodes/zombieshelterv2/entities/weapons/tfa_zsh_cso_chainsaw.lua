SWEP.Base = "tfa_bash_base"
SWEP.Category = "TFA CS:O Equipment"
SWEP.Author = "Kamikaze, ★Bullet★"
SWEP.PrintName = "Ripper"
SWEP.Type	= "Transcendent Grade Equipment"
SWEP.ViewModel = "models/weapons/tfa_cso/c_chainsaw.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = true
SWEP.VMPos = Vector(0, 0, 0)
SWEP.UseHands = true
SWEP.ProceduralHolsterTime = 0

--SWEP.InspectPos = Vector(17.184, -4.891, -11.902) - SWEP.VMPos
--SWEP.InspectAng = Vector(70, 46.431, 70)
SWEP.WorldModel = "models/weapons/tfa_cso/w_chainsaw.mdl"
SWEP.Offset = {
	Pos = {
		Up = 2,
		Right = 1.5,
		Forward = 15
	},
	Ang = {
		Up = -90,
		Right = -0,
		Forward = 170
	},
	Scale = 1
}
SWEP.HoldType = "shotgun"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.AllowSprintAttack = true
SWEP.IsMelee = true
SWEP.DisableChambering = true
SWEP.MuzzleFlashEnabled = false
SWEP.MoveSpeed = 1.05

SWEP.Primary.Automatic = true
SWEP.Primary.RPM = 1000
SWEP.Primary.Damage = 60
SWEP.Primary.NumShots = 1
SWEP.Primary.Ammo = "gasoline"
SWEP.SelectiveFire = false
SWEP.Primary.Reach = 100
SWEP.Primary.ClipSize = 200
SWEP.Primary.DefaultClip = 600

SWEP.data = {}
SWEP.data.ironsights = 0

SWEP.SawAnimation = {
	["in"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "attack1_start", --Number for act, String/Number for sequence
		["transition"] = true
	}, --Inward transition
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "attack1_loop", --Number for act, String/Number for sequence
		["is_idle"] = true
	},--looping animation
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "attack1_end", --Number for act, String/Number for sequence
		["transition"] = true
	} --Outward transition
}

SWEP.Saw_Sound_Idle = ""
SWEP.Saw_Sound_Saw = "Chainsaw.Attack_Loop"
SWEP.Saw_Sound_In = "Chainsaw.Attack_Start"
SWEP.Saw_Sound_Out = "Chainsaw.Attack_End"

SWEP.Saw_Sound_Idle_Next = -1
SWEP.Saw_Sound_Saw_Next = -1

SWEP.Saw_Sound_BlendTime = 0.05

SWEP.Saw_Drain_Idle = 0
SWEP.Saw_Drain_Sawing = 120 / 10--Ammo per second

SWEP.Secondary.Automatic = true
SWEP.Secondary.CanBash = true
SWEP.Secondary.BashDamage = 450
SWEP.Secondary.BashDelay = 0.1
SWEP.Secondary.BashLength = 128
SWEP.Secondary.BashDamageType = bit.bor(DMG_SLASH,DMG_ALWAYSGIB)

SWEP.Secondary.BashSound = Sound("")
SWEP.Secondary.BashHitSound = Sound("Chainsaw.Slash"..math.random(1,2))
SWEP.Secondary.BashHitSound_Flesh = Sound("Chainsaw.HitFleshSlash2")
SWEP.StatusLengthOverride = {
	[ACT_VM_RELOAD] = 37 / 30
}

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Jack the Ripper"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualinfinityfinal"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= true	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= true	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.

SWEP.BashKnockback = 2300

DEFINE_BASECLASS( SWEP.Base )

local stat,_,tanim

function SWEP:Initialize( ... )
	self.StatCache_Blacklist[ "Secondary.BashHitSound"] = true
	self.StatCache_Blacklist[ "Secondary.BashHitSound_Flesh"] = true
	self.StatCache_Blacklist[ "Secondary.BashDamage"] = true
	return BaseClass.Initialize( self, ... )
end

function SWEP:Deploy( ... )
	self.FSaw_Velocity = 0
	if IsFirstTimePredicted() then
		self.Saw_Sound_Idle_Next = -1
		self.Saw_Sound_Saw_Next = -1
	end
	return BaseClass.Deploy( self, ... )
end

function SWEP:Holster( ... )
	return BaseClass.Holster(self, ... )
end
function SWEP:PrimaryAttack( ... )
	self:SawThink()

	BaseClass.PrimaryAttack( self, ... )
end
function SWEP:Think2( ... )
	self:SawThink()

	BaseClass.Think2( self, ... )
end



function SWEP:ChooseIdleAnim( ... )
	if self:GetStatus() == TFA.GetStatus("sawing") and self.SawAnimation["loop"] then
		return self:PlayAnimation( self.SawAnimation["loop"] )
	else
		return BaseClass.ChooseIdleAnim(self, ...)
	end
end

SWEP.NextSawTime = 0

function SWEP:SecondaryAttack()
	if(self:GetStatus() == TFA.GetStatus('sawing') || self:GetNextPrimaryFire() > CurTime()) then return end
	timer.Simple(0.1, function()
		if(!IsValid(self.Owner)) then return end
		local rad = 86
		local forward = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * rad
		local hit = false
		for _, ent in ipairs(ents.FindInSphere(forward, rad)) do
			if(!ZShelter.HurtableTarget(ent) || ent == self.Owner) then continue end
			if(SERVER) then
				if(IsValid(self.Owner)) then
					local dmginfo = DamageInfo()
						dmginfo:SetDamage(380)
						dmginfo:SetAttacker(self.Owner)
						dmginfo:SetInflictor(self.Owner)
						if(self.Owner.Callbacks && self.Owner.Callbacks.OnMeleeDamage) then
							for k,v in pairs(self.Owner.Callbacks.OnMeleeDamage) do
								v(self.Owner, ent, dmginfo, false)
							end
						end
				end
				ent:TakeDamage(380, self.Owner, self)
			end
			hit = true
		end
		if(hit) then
			self.Owner:EmitSound("Chainsaw.HitFleshSlash2")
		end
	end)
	self:SendViewModelAnim(ACT_VM_HITCENTER)
	self:SetNextPrimaryFire(CurTime() + 1.15)
end

function SWEP:SawThink()
	stat = self:GetStatus()
	if(!self.Owner:KeyDown(IN_ATTACK) || self:GetSprinting() || self:GetStatus() == TFA.GetStatus("sawing_end") || self:GetStatus() == TFA.GetStatus("draw")) then
		self.NextSawTime = CurTime() + 0.35
	end
	if self:Clip1() > 0 and self.Owner:KeyDown(IN_ATTACK) and TFA.Enum.ReadyStatus[stat] and not self:GetSprinting() then
		if self.SawAnimation["in"] then
			_,tanim = self:PlayAnimation( self.SawAnimation["in"] )
		end
		self:SetStatus( TFA.GetStatus("sawing") )
		self:SetStatusEnd( math.huge )
		self:GetOwner():SetAnimation(PLAYER_ATTACK1)
		if self:CanSoundPredict() then
			self:EmitSound(self.Saw_Sound_In)
			self.Saw_Sound_Saw_Next = SysTime() + 0.1
		end
	elseif stat == TFA.GetStatus("sawing") and ( ( not self.Owner:KeyDown(IN_ATTACK) ) or self:Clip1() <= 0 or self:GetSprinting() ) then
		self:SetStatus( TFA.GetStatus("sawing_end") )
		if self.SawAnimation["out"] then
			_,tanim = self:PlayAnimation( self.SawAnimation["out"] )
		else
			_,tanim = self:ChooseIdleAnim()
		end
		self:SetStatusEnd( CurTime() + 1 )
		if self:CanSoundPredict() then
			self:EmitSound(self.Saw_Sound_Out)
			self.Saw_Sound_Idle_Next = SysTime() + 0.1
		end
	elseif stat == TFA.GetStatus("sawing") and CurTime() > self:GetNextIdleAnim() then
		self:ChooseIdleAnim()
	end
	if self:Clip1() == 0 then
		self.Secondary.BashHitSound = Sound("Chainsaw.Slash"..math.random(3,4))
		self.Secondary.BashHitSound_Flesh = Sound("Chainsaw.HitFleshSlash2"..math.random(3,4))
		self.Secondary.BashDamage = 450
	end
	self:AnimateSaw()
	if(self.NextSawTime > CurTime()) then return end
	self:SawMechanics()
	self:SawSounds()
end

SWEP.AmmoDrainDelta = 0

function SWEP:SawMechanics()
	stat = self:GetStatus()
	if SERVER then
		self.AmmoDrainDelta = self.AmmoDrainDelta + ( ( stat == TFA.GetStatus("sawing") ) and self.Saw_Drain_Sawing or self.Saw_Drain_Idle ) * TFA.FrameTime()
		while self.AmmoDrainDelta >= 1 do
			self.AmmoDrainDelta = self.AmmoDrainDelta - 1
			self:TakePrimaryAmmo(1)
		end
	end
	if self:GetStatus() == TFA.GetStatus("sawing") and CurTime() > self:GetNextPrimaryFire() and ( IsFirstTimePredicted() and not ( game.SinglePlayer() and CLIENT ) ) then
		local ft = 60 / self.Primary.RPM
		if IsFirstTimePredicted() then
			self:Saw( self.Primary.Damage * ft, self.Primary.Damage * ft, self.Primary.Reach )
		end
		self:SetNextPrimaryFire( CurTime() + ft )
	end
end

SWEP.FSaw_Velocity = 0
SWEP.FSaw_Accel = 720
SWEP.FSaw_Decel = 360
SWEP.FSaw_IdleSpeed = 180
SWEP.FSaw_SawingSpeed = 720
SWEP.FSaw_Friction = 90

function SWEP:AnimateSaw()
	if self:Clip1() > 0 then
		if self:GetStatus() == TFA.GetStatus("sawing") or self:GetStatus() == TFA.GetStatus("bashing") then
			self.FSaw_Velocity = math.min( self.FSaw_Velocity + self.FSaw_Accel * TFA.FrameTime(), self.FSaw_SawingSpeed )
		else
			if self.FSaw_Velocity > self.FSaw_IdleSpeed then
				self.FSaw_Velocity = math.max( self.FSaw_Velocity - self.FSaw_Decel * TFA.FrameTime() , self.FSaw_IdleSpeed )
			else
				self.FSaw_Velocity = math.min( self.FSaw_Velocity + self.FSaw_Accel * TFA.FrameTime(), self.FSaw_IdleSpeed )
			end
		end
	else
		self.FSaw_Velocity = math.max( self.FSaw_Velocity - self.FSaw_Friction * TFA.FrameTime() , 0 )
	end
end

function SWEP:SawSounds()
	stat = self:GetStatus()
	if stat == TFA.GetStatus("holster") or stat == TFA.GetStatus("holster_final") or stat == TFA.GetStatus("holster_ready") then
		self:MuteSounds( true )
		return
	end
	if self:Clip1() == 0 then
		self:MuteSounds( true )
		self:StopSound("Chainsaw.Idle")
		return
	end
	if not self:CanSoundPredict() then return end
	if self:GetStatus() == TFA.GetStatus("sawing") then
		if SysTime() > self.Saw_Sound_Saw_Next then
			self.Saw_Sound_Saw_Next = SysTime() + SoundDuration( self.Saw_Sound_Saw ) / self:GetTimeScale() - self.Saw_Sound_BlendTime
			self:EmitSound( self.Saw_Sound_Saw )
		end
		if self.Saw_Sound_Idle_Next ~= -1 then
			self:StopSound( self.Saw_Sound_Idle )
			self.Saw_Sound_Idle_Next = -1
		end
	elseif self:Clip1() >= 0 and stat ~= TFA.GetStatus("reloading") then
		if SysTime() > self.Saw_Sound_Idle_Next then
			self.Saw_Sound_Idle_Next = SysTime() + SoundDuration( self.Saw_Sound_Idle ) / self:GetTimeScale() - self.Saw_Sound_BlendTime
			self:EmitSound( self.Saw_Sound_Idle )
		end
		if self.Saw_Sound_Saw_Next ~= -1 then
			self:StopSound( self.Saw_Sound_Saw )
			self.Saw_Sound_Saw_Next = -1
		end
	end
end

function SWEP:MuteSounds( offsnd )
	if self.Saw_Sound_Saw_Next ~= -1 then
		self:StopSound( self.Saw_Sound_Saw )
		self.Saw_Sound_Saw_Next = -1
		if offsnd then
			self:EmitSound("Chainsaw.Attack_End")
		end
	end
	if self.Saw_Sound_Idle_Next ~= -1 then
		self:StopSound( self.Saw_Sound_Idle )
		self.Saw_Sound_Idle_Next = -1
		if offsnd then
			self:EmitSound("Chainsaw.Idle")
		end
	end
end

function SWEP:CanSoundPredict()
	if game.SinglePlayer() then
		if CLIENT then return false end
	else
		if not IsFirstTimePredicted() then return false end
	end
	return true
end

local dryfire_cvar = GetConVar("sv_tfa_allow_dryfire")
local ct

function SWEP:Reload(released)
	if not self:VMIV() then return end

	if self.Primary.ClipSize < 0 then return end
	if ( not released ) and ( not self:GetLegacyReloads() ) then return end
	if self:GetLegacyReloads() and not  dryfire_cvar:GetBool() and not self.Owner:KeyDown(IN_RELOAD) then return end

	ct = CurTime()
	stat = self:GetStatus()

	if TFA.Enum.ReadyStatus[stat] or ( stat == TFA.Enum.STATUS_SHOOTING and self:CanInterruptShooting() ) then
		if self:Clip1() < self.Primary.ClipSize then
			if nzombies and self.Owner.HasPerk and self.Owner:HasPerk("speed") then
				self.SequenceRateOverrideScaled[ACT_VM_RELOAD] = 1
				self.SequenceRateOverrideScaled[ACT_VM_RELOAD_EMPTY] = 1
				self.SequenceRateOverrideScaled[ACT_VM_RELOAD_SILENCED] = 1
			end
			success, tanim = self:ChooseReloadAnim()
			self:SetStatus(TFA.Enum.STATUS_RELOADING)
			if self:GetStat("ProceduralReloadEnabled") then
				self:SetStatusEnd(ct + self:GetStat("ProceduralReloadTime"))
			else
				self:SetStatusEnd(ct + self:GetActivityLength( tanim ))
			end
			if ( not game.SinglePlayer() ) or ( not self:IsFirstPerson() ) then
				self.Owner:SetAnimation(PLAYER_RELOAD)
			end
			self:MuteSounds()
		elseif released or self.Owner:KeyPressed(IN_RELOAD) then--if self.Owner:KeyPressed(IN_RELOAD) or not self:GetLegacyReloads() then
			self:CheckAmmo()
		end
	end
end

function SWEP:CompleteReload()
	local maxclip = self.Primary.ClipSize
	local curclip = self:Clip1()
	local amounttoreplace = math.min(maxclip - curclip, self:Ammo1())
	self.Owner:SetAmmo( self:Ammo1() - amounttoreplace, self:GetPrimaryAmmoType() )
	self:SetClip1( curclip + amounttoreplace )
end

function SWEP:ChooseReloadAnim()
	if not self:VMIV() then return false, 0 end
	if self.ProceduralReloadEnabled then return false, 0 end

	if self:GetActivityEnabled( ACT_VM_RELOAD_EMPTY ) and (self:Clip1() == 0) then
		typev, tanim = self:ChooseAnimation( "reload_empty" )
	else
		typev, tanim = self:ChooseAnimation( "reload" )
	end

	local fac = 1
	if self.Shotgun and self.ShellTime then
		fac = self.ShellTime
	end

	self.AnimCycle = 0

	if typev ~= TFA.Enum.ANIMATION_SEQ then
		return self:SendViewModelAnim(tanim, fac, fac ~= 1)
	else
		return self:SendViewModelSeq(tanim, fac, fac ~= 1)
	end
end

local hull = {}

function SWEP:Saw( damage, force, reach )
	if not self:OwnerIsValid() then return end
	pos = self.Owner:GetShootPos()
	ang = self.Owner:GetAimVector()

	self.Owner:LagCompensation(true)

	hull.start = pos
	hull.endpos = pos + (ang * 150)
	hull.filter = self.Owner
	hull.mins = Vector(-16, -16, -16)
	hull.maxs = Vector(16, 16, 16)
	local slashtrace = util.TraceHull(hull)

	self.Owner:LagCompensation(false)

	if(IsValid(slashtrace.Entity))then
		if not IsValid( slashtrace.Entity ) then return end
		local dmg = DamageInfo()
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamagePosition(slashtrace.HitPos)
		dmg:SetDamage(30)
		dmg:SetDamageType( bit.bor( DMG_SLASH,DMG_ALWAYSGIB) )
		if(IsValid(self.Owner)) then
			if(self.Owner.Callbacks && self.Owner.Callbacks.OnMeleeDamage) then
				for k,v in pairs(self.Owner.Callbacks.OnMeleeDamage) do
					v(self.Owner, slashtrace.Entity, dmg, false)
				end
			end
		end
		if slashtrace.Entity.TakeDamageInfo then
			slashtrace.Entity:TakeDamageInfo(dmg)
		end
	end
end

local sv_cheats_cv = GetConVar("sv_cheats")
local host_timescale_cv = GetConVar("host_timescale")
local ts
function SWEP:GetTimeScale()
	ts = game.GetTimeScale()
	if sv_cheats_cv:GetBool() then
		ts = ts * host_timescale_cv:GetFloat()
	end
	return ts
end

function SWEP:Holster( ... )
	self:StopSound("Chainsaw.Idle")
	self:StopSound("Chainsaw.Attack_Loop")
	return BaseClass.Holster(self,...)
end
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_chainsaw")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end