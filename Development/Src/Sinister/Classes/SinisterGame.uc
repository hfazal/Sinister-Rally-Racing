/**
 * Sinister Rally Racing
 * 
 * DPS937 - Team 2 - Husain Fazal, Michael Veis, Robert Stanica, Sukhbir Ghotra
 * 
 */


class SinisterGame extends UTGame;

DefaultProperties
{
	PlayerControllerClass=class'Sinister.SinisterPlayerController'
	DefaultPawnClass=class'Sinister.SinisterPawn'
	HUDType=class'Sinister.SinisterHUD'
	bUseClassicHUD=true
	bDelayedStart=false
}
