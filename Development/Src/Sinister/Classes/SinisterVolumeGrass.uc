class SinisterVolumeGrass extends Volume
	placeable;

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	`log("GRASS VOLUME TOUCHED");
}

event Untouch( Actor Other )
{
	Super.UnTouch(Other);

	`log("GRASS VOLUME UNTOUCHED");
}

DefaultProperties
{
}
