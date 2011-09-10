class BO_Weap_Grenade extends BO_Weapon_Base;
var int GrenadeSpreadDist;
exec function AddGrenades()
{
	AmmoCount = MaxAmmoCount;
}
simulated function bool ShouldRefire()
{
	return False;
}

simulated function Reload()
{
}

simulated function StartFire(byte FireModeNum)
{
	if(FireModeNum == 0)
	{
		`log("start");
		super.StartFire(FireModeNum);

		DoAttack();
	}
	ClearPendingFire(FireModeNum);
}

simulated function DoAttack()
{
	local Projectile SpawnedGrenade;
	local float theta;
	local vector VSpread;
	local rotator AimRot;
	`log("HIAY");
	AimRot = GetAdjustedAim( Location );


	theta = GrenadeSpreadDist * Pi / 32768.0 * (0 - float(AmmoCount - 1) / 2.0);
	VSpread.X = Cos(theta);
	VSpread.Y = Sin(theta);
	VSpread.Z = 0.0;

	SpawnedGrenade = Spawn(Class 'UTProj_Grenade',,, UTPawn(Instigator).Location, Rotator(VSpread >> AimRot));
	UTProjectile(SpawnedGrenade).TossZ += (FRand() * 200 - 100);
	SpawnedGrenade.Init(VSpread >> AimRot);
}
DefaultProperties
{
	begin object Name=PickupMesh
		//SkeletalMesh=SkeletalMesh'MG_WP_Knife.Mesh.WP_Knife_1P'
	end object
	
	begin object class=AnimNodeSequence Name=MeshSequenceA
	end object

	begin object Name=FirstPersonMesh
		//SkeletalMesh=SkeletalMesh'MG_WP_Knife.Mesh.WP_Knife_1P'
		//AnimSets(0)=AnimSet'MG_WP_Knife.Anim_Knife'
		Animations=MeshSequenceA
		Translation=(X=0,Y=0,Z=0)
		FOV=60.0
		Scale=1f
	end object

	AttachmentClass=class'BO_Attachment_Knife'

	FireInterval(0)=0.5f
	
	InstantHitMomentum(0)=+60000.0

	WeaponFireTypes(0)=EWFT_InstantHit
	
	DefaultAnimSpeed=1.f
	PlayerViewOffset=(X=23.0,Y=10.0,Z=-8.0)

	ShotCost(0)=1
	ShotCost(1)=0
	
	EquipTime=0.000005

	MaxAmmoCount = 4
	AmmoCount = 4
}
