class SinisterVolumeDirt extends Volume
	placeable;

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	`log("DIRT VOLUME TOUCHED");
}

event Untouch( Actor Other )
{
	Super.UnTouch(Other);

	`log("DIRT VOLUME UNTOUCHED");
}

DefaultProperties
{
}
