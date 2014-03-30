class SinisterVehicle extends UTVehicle_Scorpion
	placeable;

var SinisterGame gameContext;


simulated event PostBeginPlay()
{
 Super.PostBeginPlay();
 
   //Cast the GameInfo object to MyGameInfo   
   gameContext = SinisterGame(worldinfo.game);

   bBoostersActivated=false;
   bTryToBoost=false;

    `log( "my Booster is " $bBoostersActivated );
	`log( "I tried to boost " $bTryToBoost );

   DeactivateRocketBoosters();

   if ( bTryToBoost )
		{
			// turbo mode
			if ( !bBoostersActivated )
			{
				if ( WorldInfo.TimeSeconds - BoostChargeTime > BoostChargeDuration ) // Starting boost
				{
					//ActivateRocketBoosters();
					//bBoostersActivated = TRUE;
					//BoostStartTime = WorldInfo.TimeSeconds;
				}
			}
		}
}

event Tick( FLOAT DeltaSeconds ) {

super.Tick(DeltaSeconds);

if ( bTryToBoost )
		{
			// turbo mode
			if ( !bBoostersActivated )
			{
				if ( WorldInfo.TimeSeconds - BoostChargeTime > BoostChargeDuration ) // Starting boost
				{
					//ActivateRocketBoosters();
					//bBoostersActivated = TRUE;
					//BoostStartTime = WorldInfo.TimeSeconds;
				}
			}
		}

}

DefaultProperties
{
	bBoostersActivated=false;
	bTryToBoost=false;
}
