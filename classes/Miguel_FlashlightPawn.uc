class Miguel_FlashlightPawn extends UTPawn;

var float Brightness;
var bool bFlashlightOn;
var Color FlashLightColor;
var SpotLightComponent FlashLight;

simulated function PostBeginPlay()
{
	FlashLight = new(self) class'SpotLightComponent';

	FlashLight.SetLightProperties(Brightness,FlashLightColor);

	FlashLight.CastDynamicShadows = true;
	FlashLight.SetEnabled(false);
	FlashLight.OuterConeAngle = 1000;

	AttachComponent(FlashLight);

	super.PostBeginPlay();
}

exec function ToggleFlashlight()
{
	if(bFlashlightOn)
	{
		FlashLight.SetEnabled(false);
		bFlashlightOn = false;
	}
	else if(!bFlashlightOn)
	{
		FlashLight.SetEnabled(True);
		bFlashlightOn = true;
	}
}

simulated function Tick(float DeltaTime)
{
	local Rotator NewRotation;

	super.Tick(DeltaTime);

	if(bFlashlightOn)
	{
		NewRotation = FlashLight.Rotation;
		NewRotation.Pitch = GetViewRotation().Pitch;

		FlashLight.SetRotation(NewRotation);
	}
}

DefaultProperties
{
	// CHANGE THIS TO CHAGE RGB COLOR OF LIGHT
	FlashLightColor = (R = 0, G = 255, B = 255);

	// CHANGE THIS TO CHANGE BRIGHTNESS
	Brightness = 5;
}
