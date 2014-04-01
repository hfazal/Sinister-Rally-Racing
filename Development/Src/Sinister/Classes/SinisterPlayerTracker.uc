class SinisterPlayerTracker extends Object;

// Player Unique
var Controller c;
var SinisterGame gameContext;
//Tracking the Player on the Map
var float lastCheckinTime;
var int lastCheckpointPassed;
var int lastLapCompleted;

//Weapons
var int weaponChoice;

//Terrain Stuff
var array<String> terrainStack;


function DecreaseVehicleSpeed()
{
	local UTVehicle_Sinister vehicleAtHand;
    vehicleAtHand = UTVehicle_Sinister ( self.c.Pawn );

	if(self.terrainStack[self.terrainStack.Length -1] == "DIRT"){
		 vehicleAtHand.AirSpeed = 950;
	}
	if(self.terrainStack[self.terrainStack.Length -1] == "GRASS"){
		 vehicleAtHand.AirSpeed = 700;
	}
	if(self.terrainStack[self.terrainStack.Length -1] == "SAND"){
		 vehicleAtHand.AirSpeed = 500;
	}
	if(self.terrainStack[self.terrainStack.Length -1] == "WATER"){
		 vehicleAtHand.AirSpeed = 900;
	}
	if(self.terrainStack[self.terrainStack.Length -1] == "ICE"){
		 vehicleAtHand.AirSpeed = 1600;
	}
	if(self.terrainStack[self.terrainStack.Length -1] == "ROAD"){
		 vehicleAtHand.AirSpeed = 1100;
	}
}

function IncreaseVehicleSpeed(string terrainType) {
	DecreaseVehicleSpeed();
}


DefaultProperties
{
	lastCheckinTime = 0;
	lastCheckpointPassed = 0;
	lastLapCompleted = 0;
	weaponChoice = 0;
}
