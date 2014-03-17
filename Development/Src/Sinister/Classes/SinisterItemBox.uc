class SinisterItemBox extends Actor
	placeable;

var SinisterGame gameContext;

event PostBeginPlay()
{
 Super.PostBeginPlay();
 
   //Cast the GameInfo object to MyGameInfo   
   gameContext = SinisterGame(worldinfo.game);
}

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	//This method is crazy
	//Whatever touches the checkpoint is a pawn posessed by player's controller
	//That controller has a PlayerNum, which will be used to identify how far along they are

	local Pawn                      pawnAtHand;
	local SinisterPlayerTracker     pt;
	local int                       status;
	local float                     myTime;
	//local int                       i;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	pawnAtHand = Pawn( Other );   //attempt to cast the actor that touched 

	if(pawnAtHand != None)
	{	
		foreach gameContext.TheSinisterPlayers(pt){
			if (pt.c.PlayerNum == pawnAtHand.Controller.PlayerNum){
				   `log("I Hit the box");
                   `log("Equip Weapon");
					status=int(RandRange(1,3));
                   `log( "this is my var name " $ status);
				    setHidden(true);
				    myTime = worldinfo.TimeSeconds;
                    `log( "time since touch " $ myTime);
				    setHidden(false);
				
					if(status == 1) {  // set speed boost 
					pt.weaponChoice=1;
					//ActivateRocketBoosters();
				    
					}

					if(status == 2) { //set bear claw
					pt.weaponChoice=2;
					}

					else {    //status must be 3, set homing missle 
					pt.weaponChoice=3;
					}

			}
		}
	}
} 

DefaultProperties
{
	bCollideActors=true    
    bBlockActors=false
    
    Begin Object Class=CylinderComponent Name=CylinderComp
        CollisionRadius=20
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
        StaticMesh = team2package.Box.itembox2
        LightEnvironment = LightEnvironmentComp
    End Object
    
    Components.add( StaticMeshComp )
}
