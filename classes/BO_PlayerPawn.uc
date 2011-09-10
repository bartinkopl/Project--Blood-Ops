class BO_PlayerPawn extends UTPawn;

var UTWeapon LastWeapon;

var BO_Weapon_Base CurrentWeapon;

var float RegenCooldown, RegenPerSecond, SprintSpeed, WalkSpeed, Stamina, MaxStamina, OldPutDownTime;

var bool bKnifeReady, bGrenadeReady, bIsSprinting;

function PlayTeleportEffect(bool bOut, bool bSound);

exec function StartSprint()
{
	CurrentWeapon = BO_Weapon_Base(Weapon);
	if(bIsSprinting == false && Stamina > 1 && !CurrentWeapon.bIsUnJamming && !CurrentWeapon.bIsJammed && !CurrentWeapon.bIsReloading)
	{
		Stamina -= 1;
		ClearTimer('ReplenishStamina');
		Weapon.PlayWeaponAnimation('WeaponSprintStart',0.5,false);
		SetTimer(0.2,false,'PlaySprintAnim');
		GroundSpeed = SprintSpeed;
		bIsSprinting = true;
		if(GroundSpeed == SprintSpeed)
		{
			StopFiring();
			SetTimer(1.0,true,'ConsumeStamina');
		}
	}
}

simulated function PlaySprintAnim()
{
	Weapon.PlayWeaponAnimation('WeaponSprintIdle',0.7,true);
}

exec function StopSprint()
{
	GroundSpeed = WalkSpeed;
	bIsSprinting = false;
	ClearTimer('ConsumeStamina');
	if(IsTimerActive('PlaySprintAnim'))
	{
		ClearTimer('PlaySprintAnim');
	}
	Weapon.PlayWeaponAnimation('WeaponSprintEnd',0.5,false);
	SetTimer(1.0,true,'ReplenishStamina');
}

simulated function ConsumeStamina()
{
	Stamina -= 1;
	if(Stamina == 0)
	{
		StopSprint();
	}
}
simulated function ReplenishStamina()
{
	Stamina += 2.0;
	if(Stamina >= MaxStamina)
	{
		Stamina = MaxStamina;
		ClearTimer('ReplenishStamina');
	}
}

exec function Hurt(int damage)
{
	Health -= damage;
}

exec function Knife()
{
	local array<UTWeapon> WeaponList;
	local int KnifeAmmo, LastAmmo;
	if(bKnifeReady)
	{
		bKnifeReady = false;
		OldPutDownTime = Weapon.PutDownTime;
		Weapon.PutDownTime = 0.1;
		UTInventoryManager(InvManager).GetWeaponList(WeaponList,true,);
		LastWeapon = UTWeapon(Weapon);
		SetActiveWeapon(WeaponList[0]);
		KnifeAmmo = WeaponList[0].GetAmmoCount();
		LastAmmo = LastWeapon.GetAmmoCount();
		WeaponList[0].AddAmmo(LastAmmo - KnifeAmmo);
		SetTimer(LastWeapon.PutDownTime + 0.05,false, nameOf(Fire));
		SetTimer(2,false, nameOf(ReadyKnife));
	}
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage,EventInstigator,HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	
	if(IsTimerActive('Regenerate'))
	{
		ClearTimer('Regenerate');
		ClearTimer();
	}

	if(PlayerController(Controller) != none)
	{
		SetTimer(RegenCooldown,false,nameOf(Regenerate));
		return;
	}
}

function Regenerate()
{
	 if( PlayerController(Controller) != None )
        ClearTimer();
		SetTimer(1.0,true);
}

function Timer()
{
	if (Controller.IsA('PlayerController') && Health < HealthMax )
	{
		`log(Health);
		Health = Min( Health + RegenPerSecond, HealthMax );
	}
	else { ClearTimer(); }
}

simulated function Fire()
{
	Weapon.StartFire(0);
	UTPawn(Instigator).SetActiveWeapon(LastWeapon);
	Weapon.PutDownTime = OldPutDownTime;
}

simulated function ReadyKnife()
{
	bKnifeReady = true;
	bGrenadeReady = true;
}

exec function ThrowGrenade()
{
	local array<UTWeapon> WeaponList;

	UTInventoryManager(InvManager).GetWeaponList(WeaponList,true,);

	if(bGrenadeReady && WeaponList[1].AmmoCount>0)
	{
		bGrenadeReady = false;
		OldPutDownTime = Weapon.PutDownTime;
		Weapon.PutDownTime = 0.2;
		LastWeapon = UTWeapon(Weapon);
		SetActiveWeapon(WeaponList[1]);
		SetTimer(LastWeapon.PutDownTime + 0.1,false, nameOf(Fire));
		SetTimer(2,false, nameOf(ReadyKnife));
	}
}

DefaultProperties
{
	GroundSpeed=200.0
	AirSpeed=200.0
	WalkSpeed=280.0
	SprintSpeed=500.0
	Stamina = 6;
	MaxStamina = 6;

	bKnifeReady=true
	bGrenadeReady=true
	RegenCooldown = 10.0;
	RegenPerSecond = 10.0;
}
