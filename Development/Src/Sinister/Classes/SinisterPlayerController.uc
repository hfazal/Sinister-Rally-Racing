class SinisterPlayerController extends UTPlayerController;

var int CheckpointCounter;

var SinisterGame gameContext;
/** used to track boost duration */
var float BoostStartTime;
var float BoostPowerSpeed;
/** rocket booster properties */
var float BoosterForceMagnitude;
var repnotify bool	bBoostersActivated;
/** How long you can boost */
var float MaxBoostDuration;
/** used to track boost recharging duration */
var float BoostChargeTime;


event PostBeginPlay(){
`log( "POSTBEGIN");
	Super.PostBeginPlay();
   //Cast the GameInfo object to MyGameInfo   
   gameContext = SinisterGame(worldinfo.game);
}

exec function startSpeedBoost() {

	 local UTVehicle_Scorpion vehicleAtHand;
	local SinisterPlayerTracker     pt;
	local vector BoostDir;

	`log( "out of there!");

 foreach gameContext.TheSinisterPlayers(pt){
            if (self.PlayerNum == pt.c.PlayerNum){
                switch (pt.weaponChoice){
                    case 0:
                    //do nothing
                        break;
                    case 1:    //lets say this is the boost
                        //code for the boost
						//`log( "IN THE BOOST");
						//`log( "Got the Boost " $ pt.weaponChoice);
                        //self.Pawn this is the vehicle, but we need to make it a vehicle class
                        vehicleAtHand = UTVehicle_Scorpion( self.Pawn ); // casts it
                        //now here you can call taht method
                        vehicleAtHand.ActivateRocketBoosters(); //or whatever its called
						BoostStartTime=worldInfo.TimeSeconds;

						BoostDir = vector(Rotation);
		if ( VSizeSq(Velocity) < BoostPowerSpeed*BoostPowerSpeed )
		{
			/*
			BoostStartTime=BoostStartTime+1;
			`log( "Made it to boost part");
			bBoostersActivated=TRUE;
			if ( BoostDir.Z > 0.7 )
				vehicleAtHand.AddForce( (1.0 - BoostDir.Z) * BoosterForceMagnitude * BoostDir );
			else
				vehicleAtHand.AddForce( BoosterForceMagnitude * BoostDir );
		}
		else
			vehicleAtHand.AddForce( 0.25 * BoosterForceMagnitude * BoostDir );*/
		
			
				vehicleAtHand.AddForce( BoosterForceMagnitude * BoostDir );
			
				
		}

		`log( "out of there!");
				vehicleAtHand.AddForce(BoostDir * 0);

		/*
				if ( BoostStartTime > MaxBoostDuration ) // Ran out of Boost
				{
					`log( "RANOUT");
					vehicleAtHand.DeactivateRocketBoosters();
					bBoostersActivated = FALSE;
					BoostChargeTime = WorldInfo.TimeSeconds;
					break;
				}		*/

						//`log( "JUST BOOSTED");
					pt.weaponChoice=0;
                        break;
                    case 2:    //lets say this is the missile
                        //code for the missile
						pt.weaponChoice=0;
                        break;
                    case 3:    //lets say this is the bear trap
                        //code for the bear trap
						pt.weaponChoice=0;
                        break;
                }
            }
        }

}
event PlayerTick(float DeltaTime){
   
//`log( "IN THE TICK!");
	Super.PlayerTick(DeltaTime);
//pt.weaponChoice=1;
	//`log( "IN THE TICK!");
	//`log( "My WEAPON IS " $ pt.weaponChoice);

    //if (spacebar was pressed){    //sudo code for keylistener
       
}
//}


DefaultProperties
{
	//bStatic=False;
	CheckpointCounter = 0;
	CameraClass=class'Sinister.SinisterPlayerCamera'
	BoostPowerSpeed=1800.0
	BoosterForceMagnitude=450.0
	//MaxBoostDuration=2.0
	MaxBoostDuration=5.0
	BoostChargeTime=-10.0
}
