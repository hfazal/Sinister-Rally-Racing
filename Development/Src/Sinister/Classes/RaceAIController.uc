class RaceAIController extends UTBot;

var array<Race_Pathnode> Waypoints;
var int RaceNode; 
var int CloseEnough;
var SinisterGame gameContext;

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
             V.AirSpeed = Waypoints[RaceNode].MaxSpeed + 100;
             V.GroundSpeed = Waypoints[RaceNode].MaxSpeed;
        }
}


DefaultProperties
{
	CloseEnough=600
}