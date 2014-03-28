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
		 vehicleAtHand.AirSpeed = vehicleAtHand.AirSpeed - 40;
	}
	if(self.terrainStack[self.terrainStack.Length -1] == "GRASS"){
		 vehicleAtHand.AirSpeed = vehicleAtHand.AirSpeed - 100;
	}
	if(self.terrainStack[self.terrainStack.Length -1] == "SAND"){
		 vehicleAtHand.AirSpeed = vehicleAtHand.AirSpeed - 500;
	}
	if(self.terrainStack[self.terrainStack.Length -1] == "WATER"){
		 vehicleAtHand.AirSpeed = vehicleAtHand.AirSpeed - 200;
	}
	if(self.terrainStack[self.terrainStack.Length -1] == "ICE"){
		 vehicleAtHand.AirSpeed = vehicleAtHand.AirSpeed - 300;
	}

}

function IncreaseVehicleSpeed(string terrainType) {
	local UTVehicle_Sinister vehicleAtHand;
    vehicleAtHand = UTVehicle_Sinister ( self.c.Pawn );

	if(terrainType == "DIRT"){
		 vehicleAtHand.AirSpeed = vehicleAtHand.AirSpeed + 40;
	}
	if(terrainType == "GRASS"){
		 vehicleAtHand.AirSpeed = vehicleAtHand.AirSpeed + 100;
	}
	if(terrainType == "SAND"){
		 vehicleAtHand.AirSpeed = vehicleAtHand.AirSpeed + 500;
	}
	if(terrainType == "WATER"){
		 vehicleAtHand.AirSpeed = vehicleAtHand.AirSpeed + 200;
	}
	if(terrainType == "ICE"){
		 vehicleAtHand.AirSpeed = vehicleAtHand.AirSpeed + 300;
	}
}


DefaultProperties
{
	lastCheckinTime = 0;
	lastCheckpointPassed = 0;
	lastLapCompleted = 0;
	weaponChoice=0;
}
