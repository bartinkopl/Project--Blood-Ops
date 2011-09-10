class BO_Weap_Knife extends BO_Weapon_Base;

var float AttackCooldown, LastAttackTime, HitDamage, HitRange;

var Vector MuzzleSocLoc;

simulated function bool ShouldRefire()
{
	return False;
}

simulated function Reload()
{
}

simulated function StartFire(byte FireModeNum)
{
	if(FireModeNum != 0 || WorldInfo.TimeSeconds - LastAttackTime < AttackCooldown)
	{
		return;
	}
	DoAttack();
	super.StartFire(FireModeNum);
	ClearPendingFire(CurrentFireMode);
}

function DoAttack()
{
	local Vector Direction, StartTrace, EndTrace, HitLocation, HitNormal;
	local Actor HitActor;

	// Direction is the direction the pawn is looking in
	Direction = Vector(Instigator.Rotation);

	// Start a little behind the view location
	StartTrace = Instigator.GetPawnViewLocation() + -Direction * 10;

	// Trace forward by attack range
	EndTrace = Instigator.GetPawnViewLocation() + Direction * HitRange;

	// Hit all things that can be hurt in sword range
	ForEach TraceActors(class'Actor', HitActor, HitLocation, HitNormal, EndTrace, StartTrace, vect(96, 96, 0))
	{
		// Skip the pawn using the sword
		if(HitActor == Instigator || !HitActor.bCanBeDamaged)
			continue;

		// Apply damage with a momentum direction from Instigator location to HitActor location
		HitActor.TakeDamage( HitDamage, Instigator.Controller,
						HitActor.Location, Normal(HitActor.Location - Instigator.Location) * 50,
						class'UTDmgType_Pancake',, self);
	}
}

DefaultProperties
{
	begin object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'MG_WP_Knife.Mesh.WP_Knife_1P'
	end object
	
	begin object class=AnimNodeSequence Name=MeshSequenceA
	end object

	begin object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'MG_WP_Knife.Mesh.WP_Knife_1P'
		AnimSets(0)=AnimSet'MG_WP_Knife.Anim_Knife'
		Animations=MeshSequenceA
		Translation=(X=0,Y=0,Z=0)
		FOV=60.0
		Scale=1f
	end object

	AttachmentClass=class'BO_Attachment_Knife'

    LastAttackTime=0
	AttackCooldown=0.1f
	HitDamage=20

	FireInterval(0)=0.5f
	
	InstantHitMomentum(0)=+60000.0

	WeaponFireTypes(0)=EWFT_InstantHit

	InstantHitDamage(0)=20

	InstantHitDamageTypes(0)=class'UTDmgType_ShockPrimary'

	bInstantHit=true
	ShouldFireOnRelease(0)=0
	
	DefaultAnimSpeed=1.f
	HitRange = 30;
	PlayerViewOffset=(X=23.0,Y=10.0,Z=-8.0)

	ShotCost(0)=0
	ShotCost(1)=0
	
	EquipTime=0.000005

	MaxAmmoCount = 100
	AmmoCount = 1
}
