class BO_SFHud extends UDKHUD;

var BO_SFHudMovie HudMovie;

singular event Destroyed()
{
	if(HudMovie != none)
	{
		HudMovie.Close(true);
		HudMovie = none;
	}
	super.Destroyed();
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	HudMovie = new class'BO_SFHudMovie';
	HudMovie.SetTimingMode(TM_Real);
	HudMovie.Init();
}

//simulated function DrawEnemyInfo()
//{
//	local BO_MechAI Enemy;
//	local BO_PlayerPawn UTP;
//	local Vector OwnerPosition;

//	UTP = BO_PlayerPawn(PlayerOwner.Pawn);

//	//foreach UTP.VisibleActors(class'BO_MechAI', Enemy, 1000)
//	//{
//	//	OwnerPosition = Enemy.Location;
//	//	Enemy.TargetedHud.ScreenPosition = Canvas.Project(OwnerPosition);
//	//	Enemy.TargetedHud.StartTrack();
//	//	Enemy.bIsVisible = true;
//	//	`log("HAHAHAHAH");
//	//}
//}

event PostRender()
{
	HudMovie.TickHUD();
	//DrawEnemyInfo();

	super.PostRender();
}

DefaultProperties
{
}
