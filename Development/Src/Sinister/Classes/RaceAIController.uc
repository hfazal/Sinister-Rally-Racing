class RaceAIController extends UTBot;

var array<Race_Pathnode> Waypoints;
var int RaceNode; 
var int CloseEnough;
var SinisterGame gameContext;
var vector hello;
const offsetItemBoxBy = 200.00;


simulated function PostBeginPlay()
{
	local Race_PathNode Current;
	local SinisterPlayerTracker     pt;

	super.PostBeginPlay();

	gameContext = SinisterGame(worldinfo.game);

    //add the pathnodes to the array
	foreach WorldInfo.AllActors(class'Race_Pathnode',Current)
	{
		Waypoints.AddItem( Current );
	}

	pt = New class'SinisterPlayerTracker';
	pt.c = self;
	pt.terrainStack.AddItem("ROAD");
	pt.human = false;
	gameContext.TheSinisterPlayers.AddItem(pt);
}

simulated function Tick(float DeltaTime)
{
	local int Distance;
	local SinisterPlayerTracker     pt;
	 gameContext = SinisterGame(worldinfo.game);

	super.Tick(DeltaTime);

	Distance = VSize2D(Pawn.Location - Waypoints[RaceNode].Location);

	if (Distance <= CloseEnough)
	{
			RaceNode++;
	}

	if (RaceNode >= Waypoints.Length)
	{
		RaceNode = 0;
	}
	GoToState('Racing');

	foreach gameContext.TheSinisterPlayers(pt){
		if (!pt.human) {
			shootWeapon();
		}
	}
}

exec function shootWeapon() {

	local UTVehicle_Sinister vehicleAtHand;
	local SinisterPlayerTracker     pt;
	local SinisterPlayerTracker     pt2;
	local int adjustXBy;
	local int adjustYBy;
	local SinisterHomingMissile x;

	foreach gameContext.TheSinisterPlayers(pt){
		if (self.PlayerNum == pt.c.PlayerNum){
			vehicleAtHand = UTVehicle_Sinister( self.Pawn ); // casts it
			//`log(vehicleAtHand.Location.X $ " " $ vehicleAtHand.Location.Y $ " " $ vehicleAtHand.Location.Z $ " " $ vehicleAtHand.Rotation.Yaw);
				
			switch (pt.weaponChoice){
				case 0:
					//do nothing
					break;
				case 1:    //lets say this is the boost
					//code for the boost
					vehicleAtHand.ActivateRocketBoosters();
					vehicleAtHand.bBoostersActivated = TRUE;
					vehicleAtHand.BoostStartTime = WorldInfo.TimeSeconds;

					pt.weaponChoice=0;
					break;
				case 2:    //lets say this is the missile
					//code for the missile
					/*hello.X=vehicleAtHand.Location.X;
					hello.Y=vehicleAtHand.Location.Y;
					hello.Z=vehicleAtHand.Location.Z + 150.00;

					x = Spawn(class'SinisterHomingMissile',,,hello);
					foreach gameContext.TheSinisterPlayers(pt2){
						if (self.PlayerNum != pt2.c.PlayerNum){
							x.target = pt2;
						}
					}
				*/
					pt.weaponChoice=0;
					break;
				case 3:    //lets say this is the bear trap
					//code for the bear trap
					//figure out which way the car is facing so we can decide where to spawn the beartrap

					if ( vehicleAtHand.Rotation.Yaw >= 8192 && vehicleAtHand.Rotation.Yaw <= 24576 ){
						//facing north
						adjustYBy = offsetItemBoxBy * -1.0;
					}
					else if ( vehicleAtHand.Rotation.Yaw >= -24576 && vehicleAtHand.Rotation.Yaw <= -8192 ){
						//facing south
						adjustYBy = offsetItemBoxBy;
					}
					else if ( (vehicleAtHand.Rotation.Yaw >= 24576 && vehicleAtHand.Rotation.Yaw <= 32768) || (vehicleAtHand.Rotation.Yaw >= -32768 && vehicleAtHand.Rotation.Yaw <= -8192) ){
						//facing east
						adjustXBy = offsetItemBoxBy;
					}
					else if ( (vehicleAtHand.Rotation.Yaw >= 0 && vehicleAtHand.Rotation.Yaw <= 8192) || (vehicleAtHand.Rotation.Yaw >= -8192 && vehicleAtHand.Rotation.Yaw <= 0) ){
						//facing west
						adjustXBy = offsetItemBoxBy * -1.0;
					}

					hello.X=vehicleAtHand.Location.X + adjustXBy;
					hello.Y=vehicleAtHand.Location.Y + adjustYBy;
					hello.Z=vehicleAtHand.Location.Z + 15.00;

					Spawn(class'SinisterBearTrap',,,hello);
					pt.weaponChoice=0;
                    break;
                }
            }
        }

}

state Racing
{
Begin:

if (Waypoints[RaceNode] != None)// make sure there is a pathnode to move to
{
//set the max speed
SetMaxDesiredSpeed();
//move to it
MoveTo(Waypoints[RaceNode].Location);
}
}

function SetMaxDesiredSpeed()
{
       local Vehicle V;
       V = Vehicle(Pawn);

       if (V != None)
	{
             V.AirSpeed = Waypoints[RaceNode].MaxSpeed + 100;
             V.GroundSpeed = Waypoints[RaceNode].MaxSpeed;
        }
}


DefaultProperties
{
	CloseEnough=600
}