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

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	pawnAtHand = Pawn( Other );   //attempt to cast the actor that touched 

	if(pawnAtHand != None)
	{	
		foreach gameContext.TheSinisterPlayers(pt){
			if (pt.pNum == pawnAtHand.Controller.PlayerNum){
				   `log("I Hit the box");
                   `log("Equip Weapon");
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
