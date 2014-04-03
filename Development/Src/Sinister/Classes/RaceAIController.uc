class RaceAIController extends UTBot;

var array<Race_Pathnode> Waypoints;
var int RaceNode; //declare it at the start so you can use it throughout the script
var int CloseEnough;

simulated function PostBeginPlay()
{
	local Race_PathNode Current;

	super.PostBeginPlay();
    //add the pathnodes to the array
	foreach WorldInfo.AllActors(class'Race_Pathnode',Current)
		{
			Waypoints.AddItem( Current );
		}

}

simulated function Tick(float DeltaTime)
{
   //use local as its only needed in this function
  local int Distance;

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
             V.AirSpeed = Waypoints[RaceNode].MaxSpeed;
             V.GroundSpeed = Waypoints[RaceNode].MaxSpeed;
        }
}

//also give closeenough some velue in default properties
DefaultProperties
{
CloseEnough=600
}