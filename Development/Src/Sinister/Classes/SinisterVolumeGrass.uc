class SinisterVolumeGrass extends Volume
	placeable;

var SinisterGame gameContext;

event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	gameContext = SinisterGame(worldinfo.game);
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local Pawn                      pawnAtHand;
	local SinisterPlayerTracker     pt;

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	`log("GRASS VOLUME TOUCHED");
	//add GRASS to the stack here

	pawnAtHand = Pawn( Other );                                                     //attempt to cast the actor that touched 

	if(pawnAtHand != None){	                                                        // if the pawn that touched this checkpoint is not null
		foreach gameContext.TheSinisterPlayers(pt){                                 // loop through all the SinisterPlayerTracker objects for the game
			if (pt.c.PlayerNum == pawnAtHand.Controller.PlayerNum){   
				pt.terrainStack.AddItem("GRASS");
				
				//reduce the speed of moving car by 100 units
				pawnAtHand.AirSpeed = pawnAtHand.AirSpeed - 100;
			}
		}
	}
}

event Untouch( Actor Other )
{
	local Pawn                      pawnAtHand;
	local SinisterPlayerTracker     pt;
	local int                       i;
	local bool                      x;


	Super.UnTouch(Other);

	x = false;

	`log("GRASS VOLUME UNTOUCHED");
	//remove the first GRASS from the stack

	pawnAtHand = Pawn( Other );                                                     //attempt to cast the actor that touched 

	if(pawnAtHand != None){	                                                        // if the pawn that touched this checkpoint is not null
		foreach gameContext.TheSinisterPlayers(pt){                                 // loop through all the SinisterPlayerTracker objects for the game
			if (pt.c.PlayerNum == pawnAtHand.Controller.PlayerNum){ 
				for ( i = pt.terrainStack.Length - 1; i > 0; i-- ){
					if ( pt.terrainStack[i] == "GRASS" && x == false ){
						pt.terrainStack.Remove(i, 1);
						x = true;

						//increase the speed of moving car by 100 units
						pawnAtHand.AirSpeed = pawnAtHand.AirSpeed + 100;
					}
				}
			}
		}
	}
}

DefaultProperties
{
}