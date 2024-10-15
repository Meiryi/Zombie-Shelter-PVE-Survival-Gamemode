if CLIENT then
SWEP.BounceWeaponIcon = false
SWEP.DrawWeaponInfoBox = false
surface.CreateFont( "CSSelectIcons",
{
font = "csd",
size = 96,
weight = 0
} )
end

SWEP.PrintName = "C4"
SWEP.Category = "ArcCW - Zombie Shelter"
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 0
SWEP.Slot = 5
SWEP.SlotPos = 0

SWEP.UseHands = true
SWEP.HoldType = "slam"
SWEP.FiresUnderwater = true
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true
SWEP.CSMuzzleFlashes = 1
SWEP.Base = "weapon_base"

SWEP.Plant = 0
SWEP.PlantTimer = CurTime()
SWEP.Idle = 0
SWEP.IdleTimer = CurTime()
SWEP.WalkSpeed = 200
SWEP.RunSpeed = 400

SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Spread = 0.02
SWEP.Primary.SpreadMin = 0.02
SWEP.Primary.SpreadMove = 0.05
SWEP.Primary.SpreadAir = 0.1
SWEP.Primary.SpreadRecoveryTime = 0.3
SWEP.Primary.SpreadRecoveryTimer = CurTime()
SWEP.Primary.Delay = 2.5

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
self:SetWeaponHoldType( self.HoldType )
self.Idle = 0
self.IdleTimer = CurTime() + 1
end

function SWEP:DrawWeaponSelection( x, y, wide, tall )
draw.SimpleText( "I", "CSSelectIcons", x + wide / 2, y + tall / 4, Color( 255, 220, 0, 255 ), TEXT_ALIGN_CENTER )
end

function SWEP:Deploy()
self:SetWeaponHoldType( self.HoldType )
self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self:SetNextSecondaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self.Plant = 0
self.PlantTimer = CurTime()
self.Idle = 0
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Owner:SetWalkSpeed( self.WalkSpeed )
self.Owner:SetRunSpeed( self.RunSpeed )
self.Owner:SetJumpPower( 200 )
return true
end

function SWEP:Holster()
self.PlantTimer = CurTime()
self.Idle = 0
self.IdleTimer = CurTime()
self.Owner:SetWalkSpeed( 200 )
self.Owner:SetRunSpeed( 400 )
self.Owner:SetJumpPower( 200 )
if self.Plant == 3 then
if SERVER then
self.Owner:DropWeapon( self.Weapon )
self.Weapon:Remove()
end
end
return true
end

function SWEP:PrimaryAttack()
if !( self.Plant == 0 ) || !self.Owner:IsOnGround() then return end
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
self.Plant = 1
self.PlantTimer = CurTime() + self.Primary.Delay
self.Idle = 2
self.Owner:SetWalkSpeed( 1 )
self.Owner:SetRunSpeed( 1 )
self.Owner:SetJumpPower( 0 )
end

function SWEP:SecondaryAttack()
end

function SWEP:ShootEffects()
self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:Reload()
end

function SWEP:Think()
if !( self.Plant == 0 ) and !self.Owner:KeyDown( IN_ATTACK ) || !self.Owner:IsOnGround() then
self:SetNextPrimaryFire( CurTime() + 0.1 )
self:SetNextSecondaryFire( CurTime() + 0.1 )
self.Plant = 0
self.PlantTimer = CurTime()
self.Idle = 0
self.IdleTimer = CurTime()
self.Owner:SetWalkSpeed( self.WalkSpeed )
self.Owner:SetRunSpeed( self.RunSpeed )
self.Owner:SetJumpPower( 200 )
end
if self.Plant == 1 and self.PlantTimer <= CurTime() then
self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
self:ShootEffects()
self:SetNextPrimaryFire( CurTime() + 0.5 )
self:SetNextSecondaryFire( CurTime() + 0.5 )
self.Plant = 2
self.PlantTimer = CurTime() + 0.5
self.Idle = 2
end
if self.Plant == 2 and self.PlantTimer <= CurTime() then
if SERVER then
local entity = ents.Create( "planted_c4" )
entity:SetOwner( self.Owner )
if IsValid( entity ) then
entity:SetPos( self.Owner:GetPos() )
entity:SetAngles( Angle( 0, 0, 0 ) )
entity:Spawn()
end
end
self.Plant = 3
end
if self.Owner:IsOnGround() then
if self.Owner:GetVelocity():Length() <= 100 then
if self.Primary.SpreadRecoveryTimer <= CurTime() then
self.Primary.Spread = self.Primary.SpreadMin
end
if self.Primary.Spread > self.Primary.SpreadMin then
self.Primary.Spread = ( ( self.Primary.SpreadRecoveryTimer - CurTime() ) / self.Primary.SpreadRecoveryTime ) * self.Primary.Spread
end
end
if self.Owner:GetVelocity():Length() > 100 then
self.Primary.Spread = self.Primary.SpreadMove
self.Primary.SpreadRecoveryTimer = CurTime() + self.Primary.SpreadRecoveryTime
if self.Primary.Spread > self.Primary.SpreadMin then
self.Primary.Spread = ( ( self.Primary.SpreadRecoveryTimer - CurTime() ) / self.Primary.SpreadRecoveryTime ) * self.Primary.SpreadMove
end
end
end
if !self.Owner:IsOnGround() then
self.Primary.Spread = self.Primary.SpreadAir
self.Primary.SpreadRecoveryTimer = CurTime() + self.Primary.SpreadRecoveryTime
if self.Primary.Spread > self.Primary.SpreadMin then
self.Primary.Spread = ( ( self.Primary.SpreadRecoveryTimer - CurTime() ) / self.Primary.SpreadRecoveryTime ) * self.Primary.SpreadAir
end
end
if self.IdleTimer <= CurTime() then
if self.Idle == 0 then
self.Idle = 1
end
if SERVER and self.Idle == 1 then
self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
end
self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end
if self.Plant == 3 then
self.Owner:SetWalkSpeed( 200 )
self.Owner:SetRunSpeed( 400 )
self.Owner:SetJumpPower( 200 )
if SERVER then
self.Owner:DropWeapon( self.Weapon )
self.Weapon:Remove()
end
end
end