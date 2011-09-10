class BO_Weapon_Base extends UTWeapon
	abstract;

var float UnJamTime, ReloadTime, StartAimTime, EndAimTime, JammedLoopTime, Durability, DurabilityDamage;
var int ClipCount;
var bool bIsJammed, bIsUnJamming, bIsReloading, bCanAim, bIsAiming, bINSTMatSet;
var name DefaultIdleAnim;
var MaterialInstanceTimeVarying DirtyMaterial;

simulated function StartFire(byte FireModeNum)
{
	if(!BO_PlayerPawn(Instigator).bIsSprinting && !bIsJammed && !bIsUnJamming && !bIsReloading)
	{
		super.StartFire(FireModeNum);
	}
}

exec function RMBOn()
{
	if(bCanAim && !BO_PlayerPawn(Instigator).bIsSprinting && !bIsJammed && !bIsUnJamming && !bIsReloading)
	{
		DefaultIdleAnim = WeaponIdleAnims[0];
		`log(WeaponIdleAnims.Length);
		WeaponIdleAnims[0] = 'WeaponHoldAim';
		bIsAiming = true;
		StartAim();
	}
}

simulated function StartAim()
{
	PlayWeaponAnimation('WeaponStartAim',StartAimTime, false);
	SetTimer(StartAimTime,false,'HoldAim');
}

simulated function HoldAim()
{
	`log("HoldAim");
	PlayWeaponAnimation('WeaponHoldAim',100000,);
}

simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
	if(bIsAiming)
	{
		PlayWeaponAnimation( 'WeaponFireAim', GetFireInterval(FireModeNum) );
	}
	else
	{
		PlayWeaponAnimation( WeaponFireAnim[FireModeNum], GetFireInterval(FireModeNum) );
	}

	CauseMuzzleFlash();
	ShakeView();
}

exec function RMBOff()
{
	WeaponIdleAnims[0] = DefaultIdleAnim;
	if(IsTimerActive('HoldAim'))
	{
		ClearTimer('HoldAim');
	}   
	if(bIsAiming && !bIsJammed && !bIsUnJamming)
	{
		PlayWeaponAnimation('WeaponEndAim',EndAimTime,false);
	}
	bIsAiming = false;
}

simulated function WeaponJammed()
{
	bIsJammed = true;
	PlayWeaponAnimation('WeaponJammedLoop',JammedLoopTime,true);
}

simulated function UnJam()
{
	PlayWeaponAnimation('WeaponUnJam',UnJamTime,false);
}

simulated function UnJammed()
{
	bIsUnJamming = false;
	bIsJammed = false;
	AmmoCount--;
}

simulated function PlayWeaponEquip()
{
	
	`log(Mesh.Materials[0]);
	super.PlayWeaponEquip();
	if(!bINSTMatSet)
	{
		MaterialInstInit();
	}
	if(bIsJammed)
	{
		SetTimer(EquipTime + 0.05, false, 'WeaponJammed');
	}
}

simulated function MaterialInstInit()
{
	bINSTMatSet = true;
	DirtyMaterial = new(none) Class'MaterialInstanceTimeVarying';
	DirtyMaterial.SetParent(Mesh.GetMaterial(0));
	Mesh.SetMaterial(0,DirtyMaterial);
	DirtyMaterial.SetScalarParameterValue('Weathering',0);
}
exec function NubCannon()
{
	MaxAmmoCount = 100000;
	AmmoCount = MaxAmmoCount;
}

simulated function FireAmmunition()
{
	local int i;
	
	super.FireAmmunition();

	if(CurrentFireMode == 0)
	{
		Durability -= DurabilityDamage;
		`log(Durability);
		if(Round(Durability) % 10 == 0)
		{
			`log("Durability Set");
			DirtyMaterial.SetScalarParameterValue('Weathering',1 - (Durability / 100));
		}
	}
	i = Rand(5000);
	if(i < 10 + (100 - Durability) && AmmoCount > 1)
	{   
		ClearPendingFire(0);
		bIsJammed = true;
		SetTimer(0.4,false,'WeaponJammed');
	}
}

exec function AddClips(int Clips)
{
	ClipCount += Clips;
}

simulated function EndReload()
{
	ClipCount -= 1;
	AmmoCount = MaxAmmoCount;
	bIsReloading = false;
}

DefaultProperties
{
	JammedLoopTime = 2.0f
	UnJamTime = 2.0
	ReloadTime = 2.0
	StartAimTime = 0.5
	EndAimTime = 0.5
	Durability = 100
	DurabilityDamage=1

}