class SinisterCheckpoint extends Actor
	placeable;

var SinisterGame gameContext;
var () int CheckpointOrder;


event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if (CheckpointOrder == 1){
		SetHidden(false);
	}
	else {
		SetHidden(true);
	}
   //Cast the GameInfo object to MyGameInfo   
   gameContext = SinisterGame(worldinfo.game);
   gameContext.TheSinisterCheckpoints.AddItem(self);
}

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	//This method is crazy
	//Whatever touches the checkpoint is a pawn posessed by player's controller
	//That controller has a PlayerNum, which will be used to identify how far along they are

	local Pawn                      pawnAtHand;
	local SinisterPlayerTracker     pt;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	pawnAtHand = Pawn( Other );                                                     //attempt to cast the actor that touched 

	if(pawnAtHand != None){	                                                        // if the pawn that touched this checkpoint is not null
		foreach gameContext.TheSinisterPlayers(pt){                                 // loop through all the SinisterPlayerTracker objects for the game
			if (pt.c.PlayerNum == pawnAtHand.Controller.PlayerNum){                 // if that SinisterPlayerTracker matches the pawn's controller/owner
				if ((pt.lastCheckpointPassed+1) == CheckpointOrder){                // if that player's last tracked checkpoint + 1 matches this checkpoint
					if (pt.lastCheckpointPassed+1 == gameContext.checkpointsPerLapCount){
						pt.lastCheckpointPassed = 0;
						pt.lastLapCompleted += 1;
					}
					else{
						pt.lastCheckpointPassed += 1;                                   // add one to the player's count	
					}
					pt.lastCheckinTime = WorldInfo.TimeSeconds;
					gameContext.onlyDisplayCheckpoint(pt.lastCheckpointPassed+1);           // hide/show the correct checkpoints
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
        CollisionRadius=500
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
        StaticMesh = CastleEffects.TouchToMoveArrow
        LightEnvironment = LightEnvironmentComp
    End Object
    
    Components.add( StaticMeshComp )
}
