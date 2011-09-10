class BO_PlayerController extends UTPlayerController;

exec function Reload()
{
	local BO_Weapon_Base wp;
	wp = BO_Weapon_Base(Pawn.Weapon);

	if(wp != none)
	{
		if(wp.AmmoCount != wp.MaxAmmoCount && wp.ClipCount != 0 && !wp.bIsJammed)
		{
			wp.bIsReloading = true;
			wp.PlayWeaponAnimation('WeaponReload',wp.ReloadTime,false);
			wp.SetTimer(wp.ReloadTime,false,'EndReload');
		}
		else if(wp.bIsJammed)
		{
			if(!wp.bIsUnJamming && !wp.bIsReloading && !BO_PlayerPawn(Pawn).bIsSprinting)
			{
				wp.bIsUnJamming = true;
				wp.UnJam();
				wp.SetTimer(wp.UnJamTime,false,'UnJammed');
			}
		}
	}
}

DefaultProperties
{
}
