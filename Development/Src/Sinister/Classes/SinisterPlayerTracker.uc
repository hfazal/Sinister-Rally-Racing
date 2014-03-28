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

DefaultProperties
{
	lastCheckinTime = 0;
	lastCheckpointPassed = 0;
	lastLapCompleted = 0;
	weaponChoice=0;
}
