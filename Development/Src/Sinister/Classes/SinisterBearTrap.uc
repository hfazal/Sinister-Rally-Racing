class SinisterBearTrap extends Actor
	placeable;

var SinisterGame gameContext;

event PostBeginPlay()
{
 Super.PostBeginPlay();
 
   //Cast the GameInfo object to MyGameInfo   
   gameContext = SinisterGame(worldinfo.game);
}

event SetInitialState(){
	`log(self.Location.Z $ " : THE HEIGHT");
}

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	//This method is crazy
	//Whatever touches the checkpoint is a pawn posessed by player's controller
	//That controller has a PlayerNum, which will be used to identify how far along they are

	local Pawn                      pawnAtHand;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	pawnAtHand = Pawn( Other );   //attempt to cast the actor that touched 
//	sinisterowner = SinisterPlayerOwner( self.Owner );	

	if(pawnAtHand != None)
	{	
		pawnAtHand.Suicide();
	}

	self.Destroy();
} 

DefaultProperties
{
	//bStatic=False;
	//PlayerControllerClass=class'Sinister.SinisterPlayerController'
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
        StaticMesh = VH_Scorpion.Mesh.S_Scorpion_Projectile_Bomb
        LightEnvironment = LightEnvironmentComp
    End Object
    
    Components.add( StaticMeshComp )

}
