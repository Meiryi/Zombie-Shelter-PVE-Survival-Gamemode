SWEP.Base = "tfa_zsh_melee_base"
SWEP.Category = "#zshelter.category.melee"
SWEP.PrintName = "#zshelter.weapon.soul_bane_dagger"
SWEP.Author		= "Kamikaze" --Author Tooltip
SWEP.ViewModel = "models/weapons/tfa_cso/c_combatknife.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_combatknife.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "knife"
SWEP.DrawCrosshair = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = false
SWEP.ProceduralHolsterTime = 0
SWEP.Secondary.CanBash = false
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.VMPos = Vector(0,0,0) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Lady's Kiss"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualinfinityfinal"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.BuildSpeed = 45
SWEP.OldStyleHit = true

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
		Pos = {
		Up = -5,
		Right = 1.5,
		Forward = 5,
		},
		Ang = {
		Up = 80,
		Right = -100,
		Forward = 30
		},
		Scale = 1
}


sound.Add({
	['name'] = "Combatknife.Draw",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/combatknife/draw.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Combatknife.Hit1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/combatknife/hit1.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Combatknife.Hit2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/combatknife/hit2.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Combatknife.Slash",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/combatknife/slash.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Combatknife.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/combatknife/stab.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Combatknife.Wall",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/combatknife/wall.wav" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 65, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(50,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 60, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Weapon_Knife.Miss", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 50, --Hullsize
		['direction'] = "W", --Swing dir,
		['hitflesh'] = "Combatknife.Hit1",
		['hitworld'] = "Combatknife.Wall"
	},
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 70, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-40,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 165, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Weapon_Knife.Miss", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.25, --time before next attack
		['hull'] = 50, --Hullsize
		['direction'] = "S", --Swing dir,
		['hitflesh'] = "Combatknife.Stab",
		['hitworld'] = "Combatknife.Wall"
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_combatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
