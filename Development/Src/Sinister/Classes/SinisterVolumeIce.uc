class SinisterVolumeIce extends Volume
	placeable;

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	`log("ICE VOLUME TOUCHED");
}

event Untouch( Actor Other )
{
	Super.UnTouch(Other);

	`log("ICE VOLUME UNTOUCHED");
}

DefaultProperties
{
}
