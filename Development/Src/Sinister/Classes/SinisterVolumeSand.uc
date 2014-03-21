class SinisterVolumeSand extends Volume
	placeable;

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	`log("SAND VOLUME TOUCHED");
}

event Untouch( Actor Other )
{
	Super.UnTouch(Other);

	`log("SAND VOLUME UNTOUCHED");
}

DefaultProperties
{
}
