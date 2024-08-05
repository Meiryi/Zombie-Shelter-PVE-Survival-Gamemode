SWEP.Base = "arccw_base"
SWEP.Spawnable = false -- this obviously has to be set to true
SWEP.Category = "ArcCW - Zombie Shelter" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Mounted Machine Gun"
SWEP.Trivia_Class = "Machine Gun"
SWEP.Trivia_Desc = ""
SWEP.Trivia_Manufacturer = "Mounted Machine Gun"
SWEP.Trivia_Calibre = ".50 Cal"
SWEP.Trivia_Mechanism = ""
SWEP.Trivia_Country = ""
SWEP.Trivia_Year = -1
SWEP.Slot = 1

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/v_csomountgun.mdl"
SWEP.WorldModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos        =    Vector(-9.25, 4, -4.75),
    ang        =    Angle(-6, -2.5, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
}
SWEP.ViewModelFOV = 80

SWEP.Damage = 75
SWEP.DamageMin = 15
SWEP.RangeMin = 8
SWEP.Range = 90

SWEP.Penetration = 10
SWEP.DamageType = DMG_BULLET

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 8

SWEP.Primary.Automatic = true
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 250 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 15

SWEP.Recoil = 0.0
SWEP.RecoilSide = 0.2
SWEP.RecoilRise = 0.2

SWEP.Delay = 0.1125 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 3,
        CustomBars = "_",
        PrintName = "AUTOMATIC"
    }
}

SWEP.AlwaysFreeAim = tr
SWEP.DrawCrosshair = false
SWEP.HullSize = 6

SWEP.MirrorVMWM = false

SWEP.NPCWeaponType = {"weapon_pistol"}
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 0.10 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 1 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 130

SWEP.ShootWhileSprint = false

SWEP.Primary.Ammo = "pistol" -- what ammo type the gun uses

SWEP.ShootVol = 115 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "weapons/cso_mountgun/fire.wav"
SWEP.ShootSoundSilenced = "weapons/cso_mountgun/fire.wav"

SWEP.ViewModelFlip = true

SWEP.MuzzleEffect = "muzzleflash_mp5"
SWEP.ShellModel = "models/shells/shell_57.mdl"
SWEP.ShellScale = 1.5
SWEP.ShellPitch = 90

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on
SWEP.ProceduralViewBobAttachment = 1
SWEP.CamAttachment = 3

SWEP.SightTime = 0.5
SWEP.SpeedMult = 0.01
SWEP.SightedSpeedMult = 0.01
SWEP.BarrelLength = 0

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(0, 0, 0),
    Ang = Angle(0, 0, 0),
    Magnification = 2,
    CrosshairInSights = true,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "duel"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.ActivePos = Vector(0, 0, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(0, 0, 0)
SWEP.SprintAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(0, 0, 0)
SWEP.CustomizeAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(0, 0, 0)
SWEP.HolsterAng = Angle(0, 0, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(0, 0, 0)

SWEP.ExtraSightDist = 2

SWEP.RejectAttachments = {
}

SWEP.Attachments = {
}

SWEP.Animations = {
    ["draw"] = {
        Source = "idle",
        Time = 0.1,
    },
    ["holster"] = {
        Source = "idle",
        Time = 0.1,
    },
    ["ready"] = {
        Source = "idle",
        Time = 0.1,
    },
    ["idle"] = {
        Source = "idle",
    },
    ["reload"] = {
        Source = "idle",
    },
    ["reload_empty"] = {
        Source = "idle",
    },
    ["enter_sprint"] = {
        Source = "idle",
    },
    ["idle_sprint"] = {
        Source = "idle",
    },
    ["exit_sprint"] = {
        Source = "idle",
    },
    ["fire"] = {
        Source = {"shoot1", "shoot2"},
        ShellEjectAt = 1,
    },
    ["fire_empty"] = {
        Source = "shoot_empty",
        ShellEjectAt = 1,
    },
    ["fire_iron"] = {
        Source = {"shoot1", "shoot2"},
    },
    ["fire_iron_empty"] = {
        Source = "shoot_empty",
    },
}

function SWEP:Reload()
    return true
end

function SWEP:Holster()
    return false
end