class SinisterHomingMissile extends Actor
	placeable;

var SinisterGame gameContext;
var SinisterPlayerTracker target;
var vector locationToTarget;

event Tick(float DeltaTime){
	local Vector newLocation;
	local int moveby;
	local Controller bllahfdh;
	local SinisterPlayerTracker pt;

	moveby=30;

	foreach gameContext.TheSinisterPlayers(pt){
		if (target.c.PlayerNum == pt.c.PlayerNum){
			//this is the target
			`log("hi2");
			locationToTarget.X  = pt.c.Pawn.Location.X;
			locationToTarget.Y  = pt.c.Pawn.Location.Y;
			locationToTarget.Z  = pt.c.Pawn.Location.Z;
		}
	}

	newLocation = self.Location;

	//`log("Before Update " $ self.Location.X $ " + " $ self.Location.Y $ " + " $ self.Location.Z );
	//`log("NL Before Update " $ newLocation.X $ " + " $ newLocation.Y $ " + " $ newLocation.Z );
	//X
	if (locationToTarget.X > self.Location.X){
		newLocation.X = newLocation.X + moveby;
	}
	else { // (target.c.Location.X < self.Location.X)
		newLocation.X = newLocation.X - moveby;
	}
	//Y
	if (locationToTarget.Y > self.Location.Y){
		newLocation.Y += moveby;
	}
	else { // (target.c.Location.Y < self.Location.Y)
		newLocation.Y -= moveby;
	}
	//Z
	if ( (locationToTarget.X - self.Location.X <= 60 && locationToTarget.X - self.Location.X >= -60) && (locationToTarget.Y - self.Location.Y <= 60 && locationToTarget.Y - self.Location.Y >= -60)){
		if (target.c.Location.Z > self.Location.Z){
			`log("LESS THAN FOR Z");
			newLocation.Z += moveby;
		}
		else { // (target.c.Location.Z < self.Location.Z)
			`log("LESS THAN FOR Z");
			newLocation.Z -= moveby;
		}
	}
	

	self.SetLocation(newLocation);

	`log("After Update " $ self.Location.X $ " + " $ self.Location.Y $ " + " $ self.Location.Z );
	`log("NL After Update " $ newLocation.X $ " + " $ newLocation.Y $ " + " $ newLocation.Z );
}

event PostBeginPlay()
{
 Super.PostBeginPlay();
 
   //Cast the GameInfo object to MyGameInfo   
   gameContext = SinisterGame(worldinfo.game);
}

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local Pawn                         pawnAtHand;
	local UTVehicle                    vehicleAtHand;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	pawnAtHand = Pawn( Other );   //attempt to cast the actor that touched 
	vehicleAtHand = UTVehicle( Other );

	if(vehicleAtHand != None)
	{	
		pawnAtHand.Suicide();
	}

	self.Destroy(); 
}


DefaultProperties
{
	bCollideActors=true    
    bBlockActors=false

	Begin Object Class=CylinderComponent Name=CylinderComp
        CollisionRadius=30
        CollisionHeight=48
        CollideActors=true        
        BlockActors=false
    End Object
    
    Components.Add( CylinderComp )
    CollisionComponent=CylinderComp    
        
    Begin Object Class=DynamicLightEnvironmentComponent Name=LightEnvironmentComp
        bEnabled = true
    End Object
    
    Components.add( LightEnvironmentComp )
    
    Begin Object Class=StaticMeshComponent Name=StaticMeshComp
        StaticMesh = WP_RocketLauncher.Mesh.S_WP_Rocketlauncher_Rocket_old_lit
        LightEnvironment = LightEnvironmentComp
		Scale = 5.0
    End Object
    
    Components.add( StaticMeshComp )

	moveby = 1
}
