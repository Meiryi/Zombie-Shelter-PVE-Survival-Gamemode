SWEP.Base = "zsh_shelter_melee_base"
SWEP.Spawnable = false
SWEP.Category = "ArcCW - Zombie Shelter"
SWEP.AdminOnly = false

SWEP.PrintName = "Shelter Axe"
SWEP.Trivia_Desc = [[
    
]]
SWEP.Trivia_Class = "Melee Weapon"
SWEP.Trivia_Manufacturer = "N/A"
SWEP.Trivia_Calibre = "N/A"
SWEP.Trivia_Mechanism = "Slashing"
SWEP.Trivia_Country = "NULL"
SWEP.Trivia_Year = 0
SWEP.BuildSpeed = 45

SWEP.Slot = 0

SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/tfa_cso/c_shelteraxe.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_shelteraxe.mdl"
SWEP.MirrorVMWM = false
SWEP.WorldModelOffset = {
    pos        =    Vector(-6.75, 4.25, 9),
    ang        =    Angle(-30, 0, 90),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale = 1.1,
}
SWEP.ViewModelFOV = 77

SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 1

SWEP.PrimaryBash = true
SWEP.CanBash = true
SWEP.ShootWhileSprint = TRUE

SWEP.MeleeSwingSound = ""
SWEP.MeleeMissSound = ""
SWEP.MeleeHitSound = "weapons/zsh/melees/wall.wav"
SWEP.MeleeHitNPCSound = "weapons/zsh/melees/hit1.wav"
SWEP.Melee2HitNPCSound = "weapons/zsh/melees/hit2.wav"

SWEP.MeleeDamage = 55
SWEP.MeleeRange = 60
SWEP.MeleeTime = 0.67
SWEP.MeleeAttackTime = 0.13
SWEP.DamageType = DMG_SLASH

SWEP.Melee2 = true
SWEP.Melee2Damage = 150
SWEP.Melee2Range = 50
SWEP.Melee2Time = 1.15
SWEP.Melee2AttackTime = 0.17

SWEP.NotForNPCs = false

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "Shelter Axe"
    },
}

SWEP.MeleeGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Melee2Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE

SWEP.HoldtypeActive = "knife"
SWEP.HoldtypeHolstered = "normal"

SWEP.Primary.ClipSize = -1

-- 0	=	reference
-- 1	=	seq_admire
-- 2	=	fists_draw
-- 3	=	fists_right
-- 4	=	fists_left
-- 5	=	fists_uppercut
-- 6	=	fists_holster
-- 7	=	fists_idle_01
-- 8	=	fists_idle_02


SWEP.Animations = {
    ["idle"] = {
        Source = {"idle"},
        Time = 1.5,
    },
    ["draw"] = {
        Source = "draw",
        Time = 0.94,
        SoundTable = {{s = "weapons/zsh/melees/draw.wav", t = 0}},
    },
    ["bash"] = {
        Source = {"slash1", "slash2"},
        Time = 1.20,
        SoundTable = {{s = "weapons/zsh/melees/slash.wav", t = 0}},
    },
    ["bash2"] = {
        Source = {"stab"},
        Time = 1.33,
        SoundTable = { {s = "weapons/zsh/melees/slash.wav", t = 0}},
    },
}


sound.Add({
    name = "Tomahawk.Draw",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/draw.wav"
})
sound.Add({
    name = "Tomahawk.Slash1",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/slash.wav"
})
sound.Add({
    name = "Tomahawk.Slash2",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/slash.wav"
})
sound.Add({
    name = "Tomahawk.Stab",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/slash.wav"
})
sound.Add({
    name = "Tomahawk.HitFleshSlash1",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/hit1.wav"
})
sound.Add({
    name = "Tomahawk.HitFleshSlash2",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/hit1.wav"
})
sound.Add({
    name = "Tomahawk.HitFleshSlash3",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/hit1.wav"
})
sound.Add({
    name = "Tomahawk.HitWall",
    channel = 16,
    volume = 1.0,
    sound = "weapons/zsh/melees/wall.wav"
})

SWEP.IronSightStruct = false

SWEP.ActivePos = Vector(0, 2, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(0, 2, 0)
SWEP.CustomizeAng = Angle(0, 0, 0)

SWEP.BashPreparePos = Vector(0, 0, 0)
SWEP.BashPrepareAng = Angle(0, 0, 0)

SWEP.BashPos = Vector(0, 0, 0)
SWEP.BashAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(0, 0, 0)
SWEP.HolsterAng = Angle(0, 0, 0)