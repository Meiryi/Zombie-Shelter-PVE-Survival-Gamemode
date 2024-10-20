SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O Melees"
SWEP.PrintName = "VULCANUS-9"

SWEP.ViewModel = "models/weapons/tfa_cso/c_vulcanus9.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_vulcanus9.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 100
SWEP.UseHands = true
SWEP.HoldType = "melee2"
SWEP.DrawCrosshair = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = false
SWEP.ProceduralHolsterTime = 0
SWEP.Secondary.CanBash = false
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.VMPos = Vector(0,-5,0) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= ""
--SWEP.NZPaPReplacement 	= "tfa_cso_dualinfinityfinal"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.


SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
		Pos = {
		Up = -8,
		Right = 3,
		Forward = 3,
		},
		Ang = {
		Up = 90,
		Right = -3,
		Forward = 180
		},
		Scale = 1.2
}

sound.Add({
	['name'] = "Vulcanus9.Idle",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/vulcanus9/idle.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Vulcanus9.Draw",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/vulcanus9/draw.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Vulcanus9.Draw_Off",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/vulcanus9/draw_off.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Vulcanus9.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/vulcanus9/slash1.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Vulcanus9.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/vulcanus9/slash2.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Vulcanus9.Hit",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/vulcanus9/hit.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Vulcanus9.Wall",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/vulcanus9/wall.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFABaseMelee.Null",
	['channel'] = CHAN_STATIC,
	['sound'] = { "common/null.wav" },
	['pitch'] = {95,105}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 130, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-120,0,-100), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 500, --This isn't overpowered enough, I swear!!
		['dmgtype'] = bit.bor(DMG_SLASH,DMG_ALWAYSGIB), --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.1, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.4,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.6, --time before next attack
		['hull'] = 24, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "Vulcanus9.Hit",
		['hitworld'] = "Vulcanus9.Wall"
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 130, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-120,0,90), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 500, --Nope!! Not overpowered!! B-baka!!
		['dmgtype'] = bit.bor(DMG_SLASH,DMG_ALWAYSGIB), --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.4, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.4,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.6, --time before next attack
		['hull'] = 24, --Hullsize
		['direction'] = "L", --Swing dir
		['hitflesh'] = "Vulcanus9.Hit",
		['hitworld'] = "Vulcanus9.Wall"
	}
}
DEFINE_BASECLASS(SWEP.Base)
function SWEP:Holster( ... )
	self:StopSound("Vulcanus9.Idle")
	return BaseClass.Holster(self,...)
end
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_vulcanus9")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end

function SWEP:ChooseIdleAnim()
	if(self:GetSilenced()) then
		return self:SendViewModelSeq(0)
	else
		return self:SendViewModelSeq(9)
	end
end

function SWEP:ChooseDrawAnim()
	if(self:GetSilenced()) then
		return self:SendViewModelSeq(3)
	else
		return self:SendViewModelSeq(8)
	end
end

function SWEP:PlaySwing(act)
	if(self:GetSilenced()) then
		self:EmitSoundNet("Vulcanus9.Slash1")
		self.Primary.Attacks[1]['delay'] = 0.4
		return self:SendViewModelSeq(math.random(5, 7))
	else
		self:EmitSoundNet("Vulcanus9.Slash1")
		self.Primary.Attacks[1]['delay'] = 0.1
		return self:SendViewModelSeq(math.random(10, 11))
	end
	self:ClearStatCache()
end

function SWEP:ChooseSilenceAnim()
	if(self:GetSilenced()) then
		return self:SendViewModelSeq(2)
	else
		return self:SendViewModelSeq(1)
	end
end

function SWEP:SecondaryAttack()
	if(self:GetNextPrimaryFire() > CurTime() || self:GetStatus() == TFA.Enum.STATUS_SILENCER_TOGGLE) then return end
	self:ChooseSilenceAnim()
	self:SetStatus(TFA.Enum.STATUS_SILENCER_TOGGLE)
	self:SetStatusEnd(CurTime() + 2.5)
	self:SetNextPrimaryFire(CurTime() + 2.5)
	if(self:GetSilenced()) then
		self:EmitSoundNet("weapons/tfa_cso/vulcanus9/vulcanus9_off.wav")
	else
		self:EmitSoundNet("weapons/tfa_cso/vulcanus9/vulcanus9_on.wav")
	end
end