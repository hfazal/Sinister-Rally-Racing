class SinisterVolumeWater extends Volume
	placeable;

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	`log("WATER VOLUME TOUCHED");
}

event Untouch( Actor Other )
{
	Super.UnTouch(Other);

	`log("WATER VOLUME UNTOUCHED");
}

DefaultProperties
{
}
