class BO_SFHudMovie extends GFxMoviePlayer;

var int LastAmmoCount, LastClipCount, LastHealth;

var GFxObject HealthMC;
var GFxObject ClipTF,ExtraClipTF;

function Init(optional LocalPlayer LocPlay)
{
	Start();
	Advance(0.f);

	ExtraClipTF = GetVariableObject("_root.playerStats.ammoN.ammoN_Clips");
	ClipTF = GetVariableObject("_root.playerStats.ammoN.ammoN");
	HealthMC = GetVariableObject("_root.healthDisplay.bloodScreen");
}

function TickHUD()
{
	local BO_PlayerPawn UTP;
	local UTWeapon Weapon;
	local BO_Weapon_Base BOWeap;
	local int i;
	UTP = BO_PlayerPawn(GetPC().Pawn);
	if(UTP == none)
	{
		return;
	}

	if(LastHealth != UTP.Health)
	{
		LastHealth = UTP.Health;
		if(LastHealth > 100)
		{
			LastHealth = 100;
		}
		HealthMC.GotoAndStopI(LastHealth / 2);
		HealthMC.SetVisible(true);
	}

	Weapon = UTWeapon(UTP.Weapon);
	if(Weapon != none)
	{
		i = Weapon.GetAmmoCount();
		if(i != LastAmmoCount)
		{
			LastAmmoCount = i;
			ClipTF.SetText(i);
		}
		
		BOWeap = BO_Weapon_Base(UTP.Weapon);
		if(BOWeap != none)
		{
			if(BOWeap.ClipCount != LastClipCount)
			{
				LastClipCount = BOWeap.ClipCount;
				ExtraClipTF.SetText(LastClipCount);
			}
		}
	}
}

DefaultProperties
{
	bDisplayWithHudOff=false
	MovieInfo=SwfMovie'BloodOpsGFX.BO_Hud'
	bEnableGammaCorrection = false;
}
