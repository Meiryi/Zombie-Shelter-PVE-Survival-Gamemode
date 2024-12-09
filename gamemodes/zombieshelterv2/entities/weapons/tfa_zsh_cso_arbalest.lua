SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O Equipment" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep.
SWEP.Author				= "★Bullet★, Kamikaze" --Author Tooltip
SWEP.Contact				= "" --Contact Info Tooltip
SWEP.Purpose				= "" --Purpose Tooltip
SWEP.Instructions				= "" --Instructions Tooltip
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair			= true		-- Draw the crosshair?
SWEP.PrintName				= "Arbalest"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 73			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter if enabled in the GUI.
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.Weight				= 30			-- This controls how "good" the weapon is for autopickup.
SWEP.Type	= "Epic Grade Equipment"
SWEP.Primary.Knockback = 0 
SWEP.ProceduralHolsterTime = 0

--[[WEAPON HANDLING]]--
SWEP.AttachmentDependencies = {}
SWEP.AttachmentExclusions = {}
--Firing related
SWEP.Primary.Sound 			= Sound("Halogun.Fire")				-- This is the sound of the weapon, when you shoot.
SWEP.Primary.Damage		= 80					-- Damage, in standard damage points.
SWEP.Primary.BlastRadius	= 32               -- Radius for DMG_BLAST
SWEP.DamageType = DMG_BLAST --See DMG enum.  This might be DMG_SHOCK, DMG_BURN, DMG_BULLET, etc.
SWEP.Primary.NumShots	= 1 --The number of shots the weapon fires.  SWEP.Shotgun is NOT required for this to be >1.
SWEP.Primary.Automatic			= true					-- Automatic/Semi Auto
SWEP.Primary.RPM				= 500					-- This is in Rounds Per Minute / RPM
SWEP.Primary.RPM_Semi				= 500					-- RPM for semi-automatic or burst fire.  This is in Rounds Per Minute / RPM
SWEP.FiresUnderwater = true

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Buffed Ethereal"
--SWEP.NZPaPReplacement 	= "tfa_cso_g_ak47"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.

SWEP.CantBoostFirerate = true
SWEP.CantSaveAmmo = true

-- Selective Fire Stuff

SWEP.SelectiveFire		= true --Allow selecting your firemode?
SWEP.DisableBurstFire	= false --Only auto/single?
SWEP.OnlyBurstFire		= false --No auto, only burst/single?
SWEP.DefaultFireMode 	= "Auto" --Default to auto or whatev
SWEP.FireModes = {"Auto"}

--Ammo Related

SWEP.Primary.ClipSize			= 100					-- This is the size of a clip
SWEP.Primary.DefaultClip			= 500				-- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo			= "ar2"					-- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.  
--Pistol, buckshot, and slam like to ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.DisableChambering = true --Disable round-in-the-chamber

--Recoil Related
SWEP.Primary.KickUp			= 0.025				-- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown			= 0.025					-- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal			= 0.08					-- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor = 0 	--Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

--Firing Cone Related

SWEP.Primary.Spread		= .0025					--This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.IronAccuracy = .0005	-- Ironsight accuracy, should be the same for shotguns

--Unless you can do this manually, autodetect it.  If you decide to manually do these, uncomment this block and remove this line.
SWEP.Primary.SpreadMultiplierMax = 4.5 --How far the spread can expand when you shoot.
SWEP.Primary.SpreadIncrement = 0.75 --What percentage of the modifier is added on, per shot.
SWEP.Primary.SpreadRecovery = 4.5 --How much the spread recovers, per second.

--Range Related
SWEP.Primary.Range = -1 -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff = 1 -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.


--Penetration Related

SWEP.MaxPenetrationCounter=2 --The maximum number of ricochets.  To prevent stack overflows.

--Misc
SWEP.IronRecoilMultiplier=0.75 --Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchRecoilMultiplier=0.65  --Multiply recoil by this factor when we're crouching.  This is proportional, not inversely.
SWEP.JumpRecoilMultiplier=1.3  --Multiply recoil by this factor when we're crouching.  This is proportional, not inversely.
SWEP.WallRecoilMultiplier=1.1  --Multiply recoil by this factor when we're changing state e.g. not completely ironsighted.  This is proportional, not inversely.
SWEP.ChangeStateRecoilMultiplier=1.3  --Multiply recoil by this factor when we're crouching.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier=0.65--Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate
SWEP.ChangeStateAccuracyMultiplier=1.5 --Less is more.  A change of state is when we're in the progress of doing something, like crouching or ironsighting.  Accuracy * 2 = Half as accurate.  Accuracy * 5 = 1/5 as accurate
SWEP.JumpAccuracyMultiplier=2.5--Less is more.  Accuracy * 2 = Half as accurate.  Accuracy * 5 = 1/5 as accurate
SWEP.WalkAccuracyMultiplier=2--Less is more.  Accuracy * 2 = Half as accurate.  Accuracy * 5 = 1/5 as accurate
SWEP.IronSightTime = 0.3 --The time to enter ironsights/exit it.
SWEP.NearWallTime = 0.25 --The time to pull up  your weapon or put it back down
SWEP.ToCrouchTime = 0.05 --The time it takes to enter crouching state
SWEP.WeaponLength = 50 --Almost 3 feet Feet.  This should be how far the weapon sticks out from the player.  This is used for calculating the nearwall trace.
SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.8 --Multiply the player's movespeed by this when sighting.
SWEP.SprintFOVOffset = 3.75 --Add this onto the FOV when we're sprinting.

--[[PROJECTILES]]--

SWEP.ProjectileEntity = nil --Entity to shoot
SWEP.ProjectileVelocity = 0 --Entity to shoot's velocity
SWEP.ProjectileModel = nil --Entity to shoot's model

--[[VIEWMODEL]]--

SWEP.ViewModel			= "models/weapons/tfa_cso/c_halogun.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 80		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= true		-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands = true --Use gmod c_arms system.
SWEP.VMPos = Vector(0,0,0) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position. 
SWEP.VMAng = Vector(0,0,0) --The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle. 

--[[WORLDMODEL]]--

SWEP.WorldModel			= "models/weapons/tfa_cso/w_halogun.mdl" -- Worldmodel path

SWEP.HoldType 				= "ar2"		-- This is how others view you carrying the weapon. Options include:
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
		Pos = {
		Up = -4.75,
		Right = 0.7,
		Forward = 17,
		},
		Ang = {
		Up = -90,
		Right = 0,
		Forward = 172
		},
		Scale = 1.2
}

SWEP.ThirdPersonReloadDisable=false --Disable third person reload?  True disables.

SWEP.ShowWorldModel = true

--[[SCOPES]]--

SWEP.BoltAction			= false  --Unscope/sight after you shoot?
SWEP.Scoped				= false  --Draw a scope overlay?

SWEP.ScopeOverlayThreshold = 0.875 --Percentage you have to be sighted in to see the scope.
SWEP.BoltTimerOffset = 0.25 --How long you stay sighted in after shooting, with a bolt action.

SWEP.ScopeScale = 0.5 --Scale of the scope overlay
SWEP.ReticleScale = 0.7 --Scale of the reticle overlay

--GDCW Overlay Options.  Only choose one.

SWEP.Secondary.UseACOG			= false	 --Overlay option
SWEP.Secondary.UseMilDot			= false			 --Overlay option
SWEP.Secondary.UseSVD			= false		 --Overlay option
SWEP.Secondary.UseParabolic		= false		 --Overlay option
SWEP.Secondary.UseElcan			= false	 --Overlay option
SWEP.Secondary.UseGreenDuplex		= true		 --Overlay option

--[[SHOTGUN CODE]]--

SWEP.Shotgun = false --Enable shotgun style reloading.

SWEP.ShellTime			= .4 -- For shotguns, how long it takes to insert a shell.

--[[SPRINTING]]--

SWEP.RunSightsPos = Vector(-5.788, -1.009, 0)
SWEP.RunSightsAng = Vector(-16.223, -35.562, 0)

--[[IRONSIGHTS]]--

SWEP.data 				= {}
SWEP.data.ironsights			= 0 --Enable Ironsights
SWEP.Secondary.IronFOV			= 75					-- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.

SWEP.IronSightsPos = Vector(8.52, -4.114, 2.4)
SWEP.IronSightsAng = Vector(2.08, -0.03, 0)

--[[INSPECTION]]--

SWEP.InspectPos = nil --Replace with a vector, in style of ironsights position, to be used for inspection
SWEP.InspectAng = nil --Replace with a vector, in style of ironsights angle, to be used for inspection
SWEP.InspectionLoop = true --Setting false will cancel inspection once the animation is done.  CS:GO style.

--[[VIEWMODEL ANIMATION HANDLING]]--

SWEP.ShootWhileDraw=false --Can you shoot while draw anim plays?
SWEP.AllowReloadWhileDraw=false --Can you reload while draw anim plays?
SWEP.SightWhileDraw=false --Can we sight in while the weapon is drawing / the draw anim plays?
SWEP.AllowReloadWhileHolster=true --Can we interrupt holstering for reloading?
SWEP.ShootWhileHolster=true --Cam we interrupt holstering for shooting?
SWEP.SightWhileHolster=false --Cancel out "iron"sights when we holster?
SWEP.UnSightOnReload=true --Cancel out ironsights for reloading.
SWEP.AllowReloadWhileSprinting=false --Can you reload when close to a wall and facing it?
SWEP.AllowReloadWhileNearWall=false --Can you reload when close to a wall and facing it?
SWEP.SprintBobMult=1.5 -- More is more bobbing, proportionally.  This is multiplication, not addition.  You want to make this > 1 probably for sprinting.
SWEP.IronBobMult=0  -- More is more bobbing, proportionally.  This is multiplication, not addition.  You want to make this < 1 for sighting, 0 to outright disable.
SWEP.AllowViewAttachment = true --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS!!!!11111oneONEELEVEN

--[[HOLDTYPES]]--

SWEP.IronSightHoldTypeOverride=""  --This variable overrides the ironsights holdtype, choosing it instead of something from the above tables.  Change it to "" to disable.
SWEP.SprintHoldTypeOverride=""  --This variable overrides the sprint holdtype, choosing it instead of something from the above tables.  Change it to "" to disable.

--[[VIEWMODEL BLOWBACK]]--

SWEP.BlowbackEnabled = true --Enable Blowback?
SWEP.BlowbackVector = Vector(0,-2,0) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackCurrentRoot = 0 --Amount of blowback currently, for root
SWEP.BlowbackCurrent = 0 --Amount of blowback currently, for bones
SWEP.Blowback_Only_Iron = true --Only do blowback on ironsights
SWEP.Blowback_PistolMode = false --Do we recover from blowback when empty?
SWEP.Blowback_Shell_Enabled = true
SWEP.Blowback_Shell_Effect = "9mmShellEject"

--[[ANIMATION]]--

SWEP.ForceDryFireOff = true --Disables dryfire.  Set to false to enable them.
SWEP.DisableIdleAnimations = false --Disables idle animations.  Set to false to enable them.
SWEP.ForceEmptyFireOff = true --Disables empty fire animations.  Set to false to enable them.

--If you really want, you can remove things from SWEP.actlist and manually enable animations and set their lengths.

SWEP.SequenceEnabled = {} --Self explanitory.  This can forcefully enable or disable a certain ACT_VM
SWEP.SequenceLength = {}  --This controls the length of a certain ACT_VM
//SWEP.SequenceLengthOverride={
//	[ACT_VM_PRIMARYATTACK] = 1,
//}
--[[EFFECTS]]--



--Muzzle Flash

SWEP.MuzzleAttachment			= "0" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
--SWEP.MuzzleAttachmentRaw = 1 --This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.ShellAttachment			= "2" 		-- Should be "2" for CSS models or "shell" for hl2 models

SWEP.DoMuzzleFlash = true --Do a muzzle flash?
SWEP.CustomMuzzleFlash = true --Disable muzzle anim events and use our custom flashes?
SWEP.AutoDetectMuzzleAttachment = false --For multi-barrel weapons, detect the proper attachment?
SWEP.MuzzleFlashEffect = "cso_muz_halogun" --Change to a string of your muzzle flash effect.  Copy/paste one of the existing from the base.

--Tracer Stuff

SWEP.Tracer				= 0		--Bullet tracer.  TracerName overrides this.
SWEP.TracerName 		= "cso_tra_haloguna" 	--Change to a string of your tracer name.  Can be custom.
								--There is a nice example at https://github.com/garrynewman/garrysmod/blob/master/garrysmod/gamemodes/base/entities/effects/tooltracer.lua
SWEP.TracerCount 		= 1 	--0 disables, otherwise, 1 in X chance


SWEP.TracerLua 			= false --Use lua effect, TFA Muzzle syntax.  Currently obsolete.
SWEP.TracerDelay		= 0.01 --Delay for lua tracer effect

SWEP.Primary.ImpactEffect = "exp_haloguna_hit"

--[[EVENT TABLE]]--

SWEP.EventTable = {} --Event Table, used for custom events when an action is played.  This can even do stuff like playing a pump animation after shooting.

--example:
--SWEP.EventTable = {
--	[ACT_VM_RELOAD] = {
--		{ ['time'] = 0.1, ['type'] = "lua", ['value'] = examplefunction, ['client'] = true, ['server'] = false  },
--		{ ['time'] = 0.2, ['type'] = "sound", ['value'] = Sound("ExampleGun.Sound1", ['client'] = true, ['server'] = false ) }
--	}
--}


--[[RENDER TARGET]]--

SWEP.RTMaterialOverride = nil -- Take the material you want out of print(LocalPlayer():GetViewModel():GetMaterials()), subtract 1 from its index, and set it to this.

SWEP.RTOpaque = false -- Do you want your render target to be opaque?

SWEP.RTCode = nil

--[[AKIMBO]]--

SWEP.Akimbo = false --Akimbo gun?  Alternates between primary and secondary attacks.
SWEP.AnimCycle = 0 -- Start on the right
 
--[[TTT]]--

local gm = engine.ActiveGamemode()
if string.find(gm,"ttt") or string.find(gm,"terrorist") then
	SWEP.Kind = WEAPON_HEAVY
	SWEP.AutoSpawnable = false
	SWEP.AllowDrop = true
	SWEP.AmmoEnt = "item_ammo_smg1_ttt"
	SWEP.Base = "weapon_tttbase"
	DEFINE_BASECLASS("weapon_tttbase")
else
	SWEP.Base = "weapon_base"
	DEFINE_BASECLASS("weapon_base")
end



--[[MISC INFO FOR MODELERS]]--

--[[

Used Animations (for modelers):

ACT_VM_DRAW - Draw
ACT_VM_DRAW_EMPTY - Draw empty
ACT_VM_DRAW_SILENCED - Draw silenced, overrides empty

ACT_VM_IDLE - Idle
ACT_VM_IDLE_SILENCED - Idle empty, overwritten by silenced
ACT_VM_IDLE_SILENCED - Idle silenced

ACT_VM_PRIMARYATTACK - Shoot
ACT_VM_PRIMARYATTACK_EMPTY - Shoot last chambered bullet
ACT_VM_PRIMARYATTACK_SILENCED - Shoot silenced, overrides empty
ACT_VM_PRIMARYATTACK_1 - Shoot ironsights, overriden by everything besides normal shooting
ACT_VM_DRYFIRE - Dryfire

ACT_VM_RELOAD - Reload / Tactical Reload / Insert Shotgun Shell
ACT_SHOTGUN_RELOAD_START - Start shotgun reload, unless ACT_VM_RELOAD_EMPTY is there.
ACT_SHOTGUN_RELOAD_FINISH - End shotgun reload.
ACT_VM_RELOAD_EMPTY - Empty mag reload, chambers the new round.  Works for shotguns too, where applicable.
ACT_VM_RELOAD_SILENCED - Silenced reload, overwrites all


ACT_VM_HOLSTER - Holster
ACT_VM_HOLSTER_SILENCED - Holster empty, overwritten by silenced
ACT_VM_HOLSTER_SILENCED - Holster silenced

]]--

--[[Stuff you SHOULD NOT touch after this]]--

--Allowed VAnimations.  These are autodetected, so not really needed except as an extra precaution.  Do NOT change these, unless absolutely necessary.

SWEP.CanDrawAnimate=true
SWEP.CanDrawAnimateEmpty=true
SWEP.CanDrawAnimateSilenced=false
SWEP.CanHolsterAnimate=true
SWEP.CanHolsterAnimateEmpty=false
SWEP.CanIdleAnimate=true
SWEP.CanIdleAnimateEmpty=true
SWEP.CanIdleAnimateSilenced=false
SWEP.CanShootAnimate=true
SWEP.CanShootAnimateSilenced=false
SWEP.CanReloadAnimate=true
SWEP.CanReloadAnimateEmpty=false
SWEP.CanReloadAnimateSilenced=false
SWEP.CanDryFireAnimate=false
SWEP.CanDryFireAnimateSilenced=false
SWEP.CanSilencerAttachAnimate=false
SWEP.CanSilencerDetachAnimate=false

--Misc

SWEP.ShouldDrawAmmoHUD=false--THIS IS PROCEDURALLY CHANGED AND SHOULD NOT BE TWEAKED.  BASE DEPENDENT VALUE.  DO NOT CHANGE OR THINGS MAY BREAK.  NO USE TO YOU.
SWEP.DefaultFOV=90 --BASE DEPENDENT VALUE.  DO NOT CHANGE OR THINGS MAY BREAK.  NO USE TO YOU.

--Disable secondary crap

SWEP.Secondary.ClipSize			= 0					-- Size of a clip
SWEP.Secondary.DefaultClip			= 0					-- Default ammo to give...
SWEP.Secondary.Automatic			= false					-- Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none" -- Self explanitory, ammo type.

SWEP.Base				= "tfa_gun_base"

SWEP.LaserAnimation = {
	["start"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "shootb_start", --Number for act, String/Number for sequence
		["transition"] = true
	},
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "shootb_loop", --Number for act, String/Number for sequence
		["is_idle"] = true
	},
	["loop_2"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,
		["value"] = 7,
		["is_idle"] = true
	},
	["end"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "shootb_end", --Number for act, String/Number for sequence
		["transition"] = true
	},
	["end_2"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,
		["value"] = 8,
		["is_idle"] = true
	},
}

SWEP.LaserSound_Loop = "Halogun.ShootB_Loop"

SWEP.LaserSound_Loop_Next = -1

SWEP.LaserSound_BlendTime = 0.05

SWEP.LaserDrain_Idle = 0
SWEP.LaserDrain_Loop = 80 / 10--Ammo per second

SWEP.Secondary.Damage = 600
SWEP.Secondary.MaxAmmo = 60
SWEP.Secondary.Reach = 1200
SWEP.Secondary.RPM = 600
SWEP.Secondary.ClipSize			= -1					-- Size of a clip
SWEP.Secondary.DefaultClip			= 0					-- Default ammo to give...
SWEP.Secondary.NumShots = 1
SWEP.Secondary.Automatic			= true					-- Automatic/Semi Auto
SWEP.Secondary.Ammo			= "cosmic_stone" -- Self explanitory, ammo type.
SWEP.Secondary.Nextregen = 0

DEFINE_BASECLASS( SWEP.Base )

local stat,_,tanim

function SWEP:Initialize()
	BaseClass.Initialize(self)

	self.StatCache_Blacklist["Primary.Damage"] = true
	self.StatCache_Blacklist["Primary.BlastRadius"] = true
	self.StatCache_Blacklist["Primary.ImpactEffect"] = true

	self:ClearStatCache()
end

function SWEP:Deploy( ... )
	self.FLaser_Velocity = 0
	if IsFirstTimePredicted() then
		self.LaserSound_Loop_Next = -1
	end
	return BaseClass.Deploy( self, ... )
end

function SWEP:Holster( ... )
	return BaseClass.Holster(self, ... )
end

function SWEP:ShootProjectile()
	if((CLIENT && !IsFirstTimePredicted()) || self:GetNWInt("Arbalest_Charge") <= 0) then return end
	self:PlayAnimation({
		["type"] = TFA.Enum.ANIMATION_SEQ,
		["value"] = 9,
		["transition"] = true
	})

	self:EmitSound("weapons/tfa_cso/halogun/fire2.wav")

	self.NextProjectileTime = CurTime() + 1
	self:SetNWInt("Arbalest_Charge", self:GetNWInt("Arbalest_Charge") - 1)

	if(SERVER) then
		ZShelter.AddNoise(15, owner)
		local ent = ents.Create("zsh_arbalest_projectile")
			ent:SetOwner(self.Owner)
			ent.Inflictor = self
			ent:SetPos(self.Owner:EyePos())
			ent:SetAngles(self.Owner:EyeAngles())
			ent:Spawn()
	end
	self:SetNextPrimaryFire(CurTime() + 0.8)
	self:SetNextIdleAnim(CurTime() + 0.8)
	self:SetStatusEnd(CurTime() + 0.8)
end

SWEP.NextProjectileTime = 0
function SWEP:Think2( ... )
	if self.Weapon:Ammo2() > self.Secondary.MaxAmmo then
			self.Owner:SetAmmo( self.Secondary.MaxAmmo, self.Secondary.Ammo )
	end
	local keydown = (self.Owner:KeyDown(IN_ATTACK) && self.Owner:KeyDown(IN_ATTACK2))
	if(keydown) then
		if(self:GetStatus() != 1 && self.NextProjectileTime < CurTime()) then
			self:ShootProjectile()
		end
		self:SetNextPrimaryFire(CurTime() + 0.2)
	else
		self:LaserThink()
	end
	BaseClass.Think2( self, ... )
end

function SWEP:SecondaryAttack( ... )
self.Secondary.Nextregen =  CurTime()  + 1

end

SWEP.HoldTime = 0
function SWEP:LaserThink()
	stat = self:GetStatus()
	if(self:GetStatus() != TFA.GetStatus("laser_attack")) then
		self.HoldTime = CurTime()
	end
	if self:Ammo2() > 0 and self.Owner:KeyDown(IN_ATTACK2) and TFA.Enum.ReadyStatus[stat] and not self:GetSprinting() then
	   if self.LaserAnimation["start"] then
		  _,tanim = self:PlayAnimation( self.LaserAnimation["start"] )
	   else
		  _,tanim = self:PlayAnimation( self.LaserAnimation["loop"] )
	   end
	   self:SetStatus( TFA.GetStatus("laser_attack") )
	   self:SetStatusEnd( math.huge )
	   if self:CanSoundPredict() then
		  self.LaserSound_Loop_Next = SysTime() + 0.1
	   end
	elseif stat == TFA.GetStatus("laser_attack") and ( ( not self.Owner:KeyDown(IN_ATTACK2) ) or self:Ammo2() <= 0 or self:GetSprinting() ) then
	   self:SetStatus( TFA.GetStatus("laser_end") )
	   local t = CurTime() - self.HoldTime
	   if self.LaserAnimation["end"] then
		  if(t > 2) then
		  	_,tanim = self:PlayAnimation(self.LaserAnimation["end_2"])
		  	self:EmitSound("weapons/tfa_cso/halogun/exp.wav")
		  else
		  	_,tanim = self:PlayAnimation( self.LaserAnimation["end"] )
		  end
	   else
		  _,tanim = self:ChooseIdleAnim()
	   end
	   local ht = 2
	   local damage = 250
	   if(t > ht) then
	   		local pos = self.Owner:GetEyeTrace().HitPos
	   		if(SERVER || (CLIENT && IsFirstTimePredicted())) then
		   		local e = EffectData()
		   			e:SetOrigin(pos)

		   		util.Effect("tfa_cso_arbalest_explosion", e)
	   		end

	   		if(SERVER) then
	   			ZShelter.AddNoise(20, owner)
	   			for _, ent in ipairs(ents.FindInSphere(pos, 400)) do
	   				if(ent:Health() <= 0 || ent == self.Owner) then continue end
	   				local dmg = DamageInfo()
	   					dmg:SetAttacker(self.Owner)
	   					dmg:SetInflictor(self)
	   					if(ent.IsBoss) then
	   						dmg:SetDamage(damage * 8)
	   					else
	   						dmg:SetDamage(damage)
	   					end
	   					dmg:SetDamageType(DMG_BLAST)
	   					dmg:SetDamagePosition(ent:GetPos() + ent:OBBCenter())

	   				ent:TakeDamageInfo(dmg)
	   			end
	   		end
	   end

	   self:SetStatusEnd( CurTime() + 0.75 )
	   self:StopSound("Halogun.ShootB_Loop")
	elseif stat == TFA.GetStatus("laser_attack") and CurTime() > self:GetNextIdleAnim() then
	   self:ChooseIdleAnim()
	end
	self:LaserMechanics()
	self:LaserSounds()
	self:AnimateLaser()
 end

SWEP.AmmoDrainDelta = 0

function SWEP:LaserMechanics()
	stat = self:GetStatus()
	if SERVER then
		self.AmmoDrainDelta = self.AmmoDrainDelta + ( ( stat == TFA.GetStatus("laser_attack") ) and self.LaserDrain_Loop or self.LaserDrain_Idle ) * TFA.FrameTime()
		while self.AmmoDrainDelta >= 1 do
			self.AmmoDrainDelta = self.AmmoDrainDelta - 1
			self:TakeSecondaryAmmo(1)
			self.Secondary.Nextregen =  CurTime() + 0.5
		end
	end
	if self:GetStatus() == TFA.GetStatus("laser_attack") and CurTime() > self:GetNextSecondaryFire() and ( IsFirstTimePredicted() and not ( game.SinglePlayer() and CLIENT ) ) then
		local ft = 0.1
		if IsFirstTimePredicted() then
			self:Laser( self.Secondary.Damage * ft, self.Secondary.Damage * ft, self.Secondary.Reach )
		end
		self:SetNextSecondaryFire( CurTime() + ft )
	end
end

SWEP.FLaser_Velocity = 0
SWEP.FLaser_Accel = 720
SWEP.FLaser_Decel = 360
SWEP.FLaser_IdleSpeed = 180
SWEP.FLaser_LoopSpeed = 720
SWEP.FLaser_Friction = 90

function SWEP:AnimateLaser()
	if self:Ammo2() > 0 then
		if self:GetStatus() == TFA.GetStatus("laser_attack") then
			self.FLaser_Velocity = math.min( self.FLaser_Velocity + self.FLaser_Accel * TFA.FrameTime(), self.FLaser_LoopSpeed )
		else
			if self.FLaser_Velocity > self.FLaser_IdleSpeed then
				self.FLaser_Velocity = math.max( self.FLaser_Velocity - self.FLaser_Decel * TFA.FrameTime() , self.FLaser_IdleSpeed )
			else
				self.FLaser_Velocity = math.min( self.FLaser_Velocity + self.FLaser_Accel * TFA.FrameTime(), self.FLaser_IdleSpeed )
			end
		end
	else
		self.FLaser_Velocity = math.max( self.FLaser_Velocity - self.FLaser_Friction * TFA.FrameTime() , 0 )
	end
end

function SWEP:ChooseIdleAnim( ... )
	if self:GetStatus() == TFA.GetStatus("laser_attack") and self.LaserAnimation["loop"] then
		local t = CurTime() - self.HoldTime
		if(t < 1.5) then
			return self:PlayAnimation( self.LaserAnimation["loop"] )
		else
			return self:PlayAnimation( self.LaserAnimation["loop_2"] )
		end
	else
		return BaseClass.ChooseIdleAnim(self, ...)
	end
end

function SWEP:LaserSounds()
	stat = self:GetStatus()
	if stat == TFA.GetStatus("holster") or stat == TFA.GetStatus("holster_final") or stat == TFA.GetStatus("holster_ready") then
		self:MuteSounds( true )
		return
	end
	if self:Ammo2() <= 0 then
		self:MuteSounds( true )
		return
	end
	if not self:CanSoundPredict() then return end
	if self:GetStatus() == TFA.GetStatus("laser_attack") then
		if SysTime() > self.LaserSound_Loop_Next then
			self.LaserSound_Loop_Next = SysTime() + SoundDuration( self.LaserSound_Loop ) / self:GetTimeScale() - self.LaserSound_BlendTime
			self:EmitSound( self.LaserSound_Loop)
		end
	elseif self:Ammo2() >= 0 and stat ~= TFA.GetStatus("reloading") then
	end
end

function SWEP:MuteSounds( offsnd )

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
local hull = {}

function SWEP:Laser( damage, force, reach )
	if not self:OwnerIsValid() || CLIENT then return end
	local owner = self.Owner
	local start = owner:EyePos()
	local endpos = owner:EyePos() + owner:EyeAngles():Forward() * 512
	local maxdst = endpos:Distance(owner:EyePos())
	local step = 64
	local rad = step * 1.5

	local hits = {}
	local total = 1 + math.floor(maxdst / step)
	local diff = endpos - start

	ZShelter.AddNoise(1.5, owner)

	for i = 0, total, 1 do
		local vec = start + (diff * (i / total))
		for _, ent in ipairs(ents.FindInSphere(vec, rad)) do
			if(ent:Health() <= 0 || ent == owner || hits[ent:EntIndex()]) then continue end -- damage whatever have health
			hits[ent:EntIndex()] = true
		end
	end

	local dmg = 20
	local t = CurTime() - self.HoldTime
	if(t > 2) then
		dmg = 30
	end
	for entindex, _ in pairs(hits) do
		local ent = Entity(entindex)
		if(!IsValid(ent)) then continue end
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(owner)
			dmginfo:SetInflictor(self)
			if(ent.IsBoss) then
				dmginfo:SetDamage(dmg * 3)
			else
				dmginfo:SetDamage(dmg)
			end
			dmginfo:SetDamageType(self.DamageType)
			dmginfo:SetDamageForce(owner:GetAimVector() * force)
			dmginfo:SetDamagePosition(ent:GetPos() + ent:OBBCenter())
			ent:TakeDamageInfo(dmginfo)
	end

	dmg = 10
	for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 128)) do
		if(ent:Health() <= 0 || ent == owner) then continue end
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker(owner)
		dmginfo:SetInflictor(self)
		dmginfo:SetDamage(dmg)
		dmginfo:SetDamageType(self.DamageType)
		dmginfo:SetDamageForce(owner:GetAimVector() * force)
		dmginfo:SetDamagePosition(ent:GetPos() + ent:OBBCenter())
		ent:TakeDamageInfo(dmginfo)
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

SWEP.NextRechargeTime = 0
function SWEP:Think() 
	if SERVER then
		if self.Secondary.Nextregen <= CurTime()  and self:Ammo2() < 60 then 
			self.Owner:GiveAmmo( 1,"cosmic_stone", true )                     -------SECONDARY AMMO REGEN
			self.Secondary.Nextregen =  CurTime()  + 0.2
		end

		local charge = self:GetNWInt("Arbalest_Charge")
		local progress = self:GetNWInt("Arbalest_ChargeProgress")
		if(self.NextRechargeTime < CurTime() && charge < 3) then
			self:SetNWInt("Arbalest_ChargeProgress", progress + 1)
			if(progress >= 100) then
				self:SetNWInt("Arbalest_ChargeProgress", 0)
				self:SetNWInt("Arbalest_Charge", charge + 1)
			end
			self.NextRechargeTime = CurTime() + 0.1
		end
	end
	BaseClass.Think(self)
end

function SWEP:PostPrimaryAttack()
	if(self:Clip1() % 10 == 1) then
		self.Primary_TFA.Damage = 200
		self.Primary_TFA.BlastRadius = 180
		self.Primary_TFA.ImpactEffect = "exp_haloguna"
	else
		self.Primary_TFA.Damage = 80
		self.Primary_TFA.BlastRadius = 0
		self.Primary_TFA.ImpactEffect = "exp_haloguna_hit"
	end
	BaseClass.PostPrimaryAttack(self)
end

-- I hate math
function SWEP:DrawHUD(...)
	local centerX, centerY = ScrW() / 2, ScrH() / 2
	local wide = ScreenScaleH(40)
	local tall = ScreenScaleH(40)
	local thickness = ScreenScaleH(10)
	local offset = ScreenScaleH(2)
	local offset_h = offset * 0.5
	local offset_w = ScreenScaleH(9)
	local bg1 = {
		{x = centerX - wide - offset_w, y = centerY},
		{x = centerX - offset_w, y = centerY - tall},
		{x = centerX - offset_w, y = centerY - tall + thickness},
		{x = centerX - wide + thickness - offset_w, y = centerY},
	}
	local bg2 = {
		{x = centerX + offset_w, y = centerY - tall},
		{x = centerX + offset_w + wide, y = centerY},
		{x = centerX + offset_w + wide - thickness, y = centerY},
		{x = centerX + offset_w, y = centerY - tall + thickness},
	}

	local fraction1 = math.max(self:GetNWInt("Arbalest_ChargeProgress"), 1) / 100 -- Prevent math.huge aka infinite
	local charge = self:GetNWInt("Arbalest_Charge")

	draw.NoTexture()
	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawPoly(bg1)
	surface.DrawPoly(bg2)

	local progress = {
		{x = centerX - offset_w - wide + offset + offset_h, y = centerY - offset + offset_h},
		{x = centerX - offset_w - offset + offset_h, y = centerY - tall + offset + offset_h},
		{x = centerX - offset_w - offset + offset_h, y = centerY - tall + thickness - offset + offset_h},
		{x = centerX - offset_w - wide + thickness - offset + offset_h, y = centerY - offset + offset_h},
	}

	local tall_1 = tall * fraction1
	if(charge >= 3) then
		tall_1 = tall
	end
	local tall_2 = tall * fraction1
	local mask_poly1 = {
		{x = centerX - wide - offset_w, y = centerY - tall_1},
		{x = centerX - wide - offset_w, y = centerY - tall},
		{x = centerX -  offset_w, y = centerY - tall},
		{x = centerX -  offset_w, y = centerY - tall_1},
	}

    render.ClearStencil()

    render.SetStencilEnable(true)
    render.SetStencilTestMask(0xFF)
    render.SetStencilWriteMask(0xFF)
    render.SetStencilReferenceValue(0x01)

    render.SetStencilCompareFunction(STENCIL_NEVER)
    render.SetStencilFailOperation(STENCIL_REPLACE)
    render.SetStencilZFailOperation(STENCIL_REPLACE)

    surface.DrawPoly(mask_poly1)

    render.SetStencilCompareFunction(STENCIL_GREATER)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)

	surface.SetDrawColor(155, 55, 255, 100)
	surface.DrawPoly(progress)

    render.SetStencilEnable(false)

	if(charge > 0) then
		for i = 1, charge do
			local poly = {}
			local x = i - 1
			local f1, f2 = i / 3, x / 3
			local f1_r, f2_r = 1 - f1, 1 - f2
			if(i == 1) then
				poly = {
					{x = centerX + offset_w + offset - (thickness - offset * 2) - offset + (wide * f1_r), y = centerY - (tall * f1) + offset},
					{x = centerX + offset_w + offset - offset + (wide * f1_r), y = centerY - (tall * f1) + offset},
					{x = centerX + offset_w + wide - offset - offset_h, y = centerY - offset + offset_h},
					{x = centerX + offset_w + wide - thickness + offset - offset_h, y = centerY - offset + offset_h},
				}
			elseif(i == 2) then
				poly = {
					{x = centerX + offset_w + offset - (thickness - offset * 2) - offset_h + (wide * f1_r), y = centerY - (tall * f1) + offset + offset_h},
					{x = centerX + offset_w + offset - offset_h + (wide * f1_r), y = centerY - (tall * f1) + offset + offset_h},
					{x = centerX + offset_w + (wide * f2_r) - offset - offset_h, y = centerY - offset + offset_h - (tall * f2)},
					{x = centerX + offset_w + (wide * f2_r) - thickness + offset - offset_h, y = centerY - offset + offset_h - (tall * f2)},
				}
			else
				poly = {
					{x = centerX + offset_w + offset - offset_h + (wide * f1_r), y = centerY - (tall * f1) + offset + offset_h},
					{x = centerX + offset_w + (wide * f2_r) - offset + offset_h, y = centerY - offset + offset_h - (tall * f2 - offset)},
					{x = centerX + offset_w + (wide * f2_r) - thickness + offset + offset_h, y = centerY - offset + offset_h - (tall * f2 - offset)},
					{x = centerX + offset_w + offset - offset_h + (wide * f1_r), y = centerY - tall + thickness - offset_h},
				}
			end
			surface.DrawPoly(poly)
		end
	end

	BaseClass.DrawHUD(self, ...)
end

function SWEP:Holster( ... )
	self:StopSound("Halogun.Idle")
	self:StopSound("Halogun.ShootB_Loop")
	return BaseClass.Holster(self,...)
end

if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_halogun")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end