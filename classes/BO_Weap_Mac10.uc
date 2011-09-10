class BO_Weap_Mac10 extends BO_Weapon_Base;

var float AttackDuration, HitDamage;

var Vector MuzzleSocLoc;

simulated function bool ShouldRefire()
{
	return false;
}

simulated function StartFire(byte FireModeNum)
{
	CurrentFireMode = (FireModeNum == 0) ? 0 : 1;
	super.StartFire(FireModeNum);
	//ClearPendingFire(CurrentFireMode);
}

simulated function FireAmmunition()
{
	super.FireAmmunition();
	if(CurrentFireMode == 0)
	{
		DoFire();
	}
}

function DoFire()
{
	local Vector TraceStart, TraceEnd, HitLoc, HitNormals, Extent;
	local Actor HitActor;

	Extent.X = 1;
	Extent.Y = 1;
	Extent.Z = 1;

	UTPawn(Instigator).CurrentWeaponAttachment.Mesh.GetSocketWorldLocationAndRotation('Muzzle',TraceStart,);
	TraceEnd = Location + normal(vector(Rotation))*63366;
	foreach TraceActors(class'Actor',HitActor,HitLoc,HitNormals,TraceEnd,TraceStart,Extent)
	{
		if(HitActor == Instigator|| !HitActor.bCanBeDamaged)
		{
			continue;
		}
		HitActor.TakeDamage(HitDamage,Instigator.Controller,HitActor.Location,
					normal(HitActor.Location - Instigator.Location)*50,
					class'UTDmgType_ShockPrimary',,self);
	}
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
	local MaterialInterface DecalChoice;
	DecalChoice = DecalMaterial'BO_WP_Mac10.DecalMaterial.BulletHoleDecal';
	WorldInfo.MyDecalManager.SpawnDecal
	(
		DecalChoice,	                                // UMaterialInstance used for this decal.
		Impact.HitLocation,	                            // Decal spawned at the hit location.
		Rotator(-Impact.HitNormal),	                    // Orient decal into the surface.
		24, 24,	                                    // Decal size in tangent/binormal directions.
		64,	                                        // Decal size in normal direction.
		false,	                                        // If TRUE, use "NoClip" codepath.
		rand(360)	                                    // random rotatio
	);
}

defaultproperties
{
	begin object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'BO_WP_Mac10.Mesh.SK_WP_Mac10'
	end object
	
	begin object class=AnimNodeSequence Name=MeshSequenceA
	end object

	begin object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'BO_WP_Mac10.Mesh.SK_WP_Mac10'
		AnimSets(0)=AnimSet'BO_WP_Mac10.Anim.Anim_Mac10'
		Animations=MeshSequenceA
		Translation=(X=25,Y=5,Z=-16)
		FOV=60.0
		Scale=1.f
	end object

	AttachmentClass=class'BO_Attachment_Mac10'

	AttackDuration=0.1f
	HitDamage=10
	ClipCount = 3;
	bCanAim = true;

	FireInterval(0)=0.0715f

	InstantHitMomentum(0)=+60000.0

	WeaponFireTypes(0)=EWFT_InstantHit

	InstantHitDamage(0)=20

	InstantHitDamageTypes(0)=class'UTDmgType_ShockPrimary'

	bInstantHit=true
	ShouldFireOnRelease(0)=0

	PlayerViewOffset=(X=23.0,Y=10.0,Z=-8.0)

	WeaponFireSnd[0]=SoundCue'BO_WP_Mac10.SoundCue.Mac10_Fire'

	EquipTime = 1.0;
	PutDownTime = 0.8

	ShotCost(0)=1
	ShotCost(1)=0

	MaxAmmoCount = 32
	AmmoCount = 32
}
