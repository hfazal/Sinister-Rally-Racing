/**
 * Sinister Rally Racing
 * 
 * DPS937 - Team 2 - Husain Fazal, Michael Veis, Robert Stanica, Sukhbir Ghotra
 * 
 */


class SinisterGame extends UTGame;
//We need UTGame for the HUD and Weapon Abilities, dont change this.

var array<SinisterPlayerTracker> TheSinisterPlayers;
var array<SinisterCheckpoint> TheSinisterCheckpoints;
const checkpointTotal = 19; //one lap is 19


event Tick(float DeltaTime){
	local SinisterPlayerTracker     pt;

	super.Tick(DeltaTime);

	//check for game end
	foreach TheSinisterPlayers(pt){
		if (pt.lastCheckpointPassed == checkpointTotal){
			EndGame(pt.c.PlayerReplicationInfo, "Player" $ pt.pNum $ " Won");
			bGameEnded = true;
		}
	}
}

function StartMatch(){
	local Controller C;
	local SinisterPlayerTracker pt;

	super.StartMatch();

	//make sure this is "adding" by value not reference
	foreach WorldInfo.AllControllers(class'Controller', C){
		pt = New class'SinisterPlayerTracker';
		pt.pNum = C.PlayerNum;
		pt.c = C;
		TheSinisterPlayers.AddItem(pt);
	}
}

function EndGame(PlayerReplicationInfo Winner, string Reason){
	super.EndGame(Winner, Reason);

	RestartGame();
}

function onlyDisplayCheckpoint(int checkpointToMakeVisible){
	local SinisterCheckpoint checkpointAtHand;

	foreach TheSinisterCheckpoints(checkpointAtHand){
		if (checkpointAtHand.CheckpointOrder != checkpointToMakeVisible){
			checkpointAtHand.SetHidden(true);
		}
		else {
			checkpointAtHand.SetHidden(false);
		}
	}
}

DefaultProperties
{
	PlayerControllerClass=class'Sinister.SinisterPlayerController'
	//AIControllerClass=class'Sinister.SinisterAIController'
	DefaultPawnClass=class'Sinister.SinisterPawn'
	HUDType=class'Sinister.SinisterHUD'
	bUseClassicHUD=true
	bDelayedStart=false
}