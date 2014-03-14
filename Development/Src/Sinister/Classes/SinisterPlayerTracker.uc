class SinisterPlayerTracker extends Object;

var int pNum;              //unique to each player
var float lastCheckinTime;
var int lastCheckpointPassed;
var Controller c;

DefaultProperties
{
	pNum = -1;
	lastCheckinTime = 0;
	lastCheckpointPassed = 0;
}
