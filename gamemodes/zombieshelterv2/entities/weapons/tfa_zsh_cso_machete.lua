SWEP.Base = "tfa_zsh_melee_base"
SWEP.Category = "#zshelter.category.melee"
SWEP.PrintName = "#zshelter.weapon.machete"
SWEP.Author	= "★Bullet★"
SWEP.ViewModel = "models/weapons/tfa_cso/c_machete.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_machete.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "knife"
SWEP.Type	= "#zshelter.type.common_melee"
SWEP.DrawCrosshair = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = false
SWEP.StabMissTable = {"ACT_VM_PULLBACK"} --Table of possible hull sequences
SWEP.Secondary.Automatic = true
SWEP.Secondary.CanBash = false
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1
SWEP.ProceduralHolsterTime = 0

SWEP.Attachments = {
    [1] = { atts = { "cso_machetetransgear" } },
}


--[[INSPECTION]]--

SWEP.InspectPos = Vector (0,0,0) --Replace with a vector, in style of ironsights position, to be used for inspection
SWEP.InspectAng = Vector (0,0,0) --Replace with a vector, in style of ironsights angle, to be used for inspection
SWEP.InspectionLoop = true --Setting false will cancel inspection once the animation is done.  CS:GO style.

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Kukri"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualsword"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.PaPMats			= {}

SWEP.OldStyleHit = true

SWEP.Offset = {
		Pos = {
		Up = -3.5,
		Right = 2,
		Forward = 5,
		},
		Ang = {
		Up = 0,
		Right = -60,
		Forward = 120
		},
		Scale = 1.0
}

sound.Add({
	['name'] = "Tomahawk.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/tomahawk/draw.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/tomahawk/slash1.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/tomahawk/slash2.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/tomahawk/stab.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.HitFleshSlash1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/tomahawk/hit1.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.HitFleshSlash2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/tomahawk/hit2.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.HitFleshSlash3",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/tomahawk/hit3.wav"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/tomahawk/wall.wav" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 125, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(90,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 150, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.1, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.1,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "Tomahawk.HitFleshSlash1",
		['hitworld'] = "Tomahawk.HitWall",
		['maxhits'] = 3
	},
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 125, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-90,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 150, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.1, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "Tomahawk.HitFleshSlash2",
		['hitworld'] = "Tomahawk.HitWall",
		['maxhits'] = 3
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 125, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-35,0,-80), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 300, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.1, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.2, --time before next attack
		['hull'] = 64, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "weapons/tfa_cso/tomahawk/hit3.wav",
		['hitworld'] = "Tomahawk.HitWall",
		['maxhits'] = 3
	}
}

DEFINE_BASECLASS(SWEP.Base)
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_machete")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end