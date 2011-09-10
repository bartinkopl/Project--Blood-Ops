class BO_GameInfo extends UTGame;

DefaultProperties
{
	Acronym="BO"
	MapPrefixes[0]="BO"

	bIgnoreTeamForVoiceChat=true

	bGivePhysicsGun=false

	PlayerControllerClass=class'BO_PlayerController'
	DefaultPawnClass=class'BO_PlayerPawn'

	HUDType=class'BO_SFHud'

	bUseClassicHUD=true

	bDelayedStart=false
	bRestartLevel=false
	Name="Default_BO_GameInfo"

	DefaultInventory(0)=class'BO_Weap_Knife'
	DefaultInventory(1)=class'BO_Weap_Grenade'
	DefaultInventory(2)=class'BO_Weap_Mac10'
}
