class SinisterHUD extends UTHUD;

var float DistanceFromX;
var float DistanceFromY;
var float WidthOfComponents;
var SinisterGame gameContext;

//Weapon Icons
var CanvasIcon weaponNitrous;
var CanvasIcon weaponMissile;
var CanvasIcon weaponMine;

event PostBeginPlay()
{
   Super.PostBeginPlay();

	//Cast the GameInfo object to MyGameInfo   
	gameContext = SinisterGame(worldinfo.game);
}

function DrawGameHud()
{
	local SinisterPlayerTracker     pt;

	//HUD should always be 25% of width
	WidthOfComponents = Canvas.ClipX * 0.25;
	DistanceFromX = Canvas.ClipX - WidthOfComponents - 10;

	//Draw Minimap
    BoxMinimap(WidthOfComponents, 200.00, DistanceFromX, Canvas.ClipY - 210);

	//Draw Positional Information
	BoxPositionalInformation(WidthOfComponents, 200.00, DistanceFromX, 10);

	//Draw Weapon box if Neccessary
	foreach gameContext.TheSinisterPlayers(pt){
		if (pt.c.PlayerNum == self.PlayerOwner.PlayerNum){
			switch (pt.weaponChoice) {
				case 0:
					//no weapon
				break;
				case 1:
					//Nitrous
					Canvas.DrawIcon(weaponNitrous, 40, 40, 0.5);
					DrawHUDBox(148, 148, 30, 30);
				break;
				case 2:
					//Missile
					Canvas.DrawIcon(weaponMissile, 40, 40, 0.5);
					DrawHUDBox(148, 148, 30, 30);
				break;
				case 3:
					//Mine
					Canvas.DrawIcon(weaponMine, 40, 40, 0.5);
					DrawHUDBox(148, 148, 30, 30);
				break;
				default:
			}
		}
	}
}

function BoxMinimap(float width, float height, float widthToStartAt, float heightToStartAt){
	local String checkpointlog;

	checkpointlog = "minimap will go here";

	DrawHUDBox(width, height, widthToStartAt, heightToStartAt);

	WriteText(checkpointlog, class'Engine'.static.GetLargeFont(), widthToStartAt, heightToStartAt);
}

function BoxPositionalInformation(float width, float height, float widthToStartAt, float heightToStartAt){
	local SinisterPlayerTracker     pt;
	local String                    checkpointlog;
	local UTVehicle_Sinister        vehicleAtHand;

	checkpointlog = "";

	foreach gameContext.TheSinisterPlayers(pt){
		vehicleAtHand = UTVehicle_Sinister( pt.c.Pawn );
		checkpointlog $= "Player" $ pt.c.PlayerNum $ "\n" $ pt.lastCheckpointPassed $ "/" $ gameContext.checkpointsPerLapCount $ " Checkpoints\nLap " $ (pt.lastLapCompleted + 1) $ "/" $ gameContext.lapCount $ "\n" $ "Speed: " $ int( VSize( vehicleAtHand.Velocity ) * 0.0681825 ) $ "Km/H \n" $ "Terrain Impact: " $ int( vehicleAtHand.AirSpeed );
	}

	DrawHUDBox(width, height, widthToStartAt, heightToStartAt);
	WriteText(checkpointlog, class'Engine'.static.GetLargeFont(), widthToStartAt+10, heightToStartAt+10);
}

function WriteText(string text, Font size, float widthToStartAt, float heightToStartAt)
{
	Canvas.SetPos(widthToStartAt, heightToStartAt);
	Canvas.SetDrawColor(255,255,255,255);
	Canvas.Font = size;
    Canvas.DrawText(text);
}

function DrawHUDBox(float width, float height, float widthToStartAt, float heightToStartAt)
{
	Canvas.SetPos(widthToStartAt, heightToStartAt);
	Canvas.SetDrawColor(0,0,0,100);
	Canvas.DrawRect(width,height);
}

DefaultProperties
{
	//bNoCrosshair = true;
	weaponNitrous = (Texture=Texture2D'team2package.HUD.nitrousIcon')
	weaponMissile = (Texture=Texture2D'team2package.HUD.missileIcon')
	weaponMine = (Texture=Texture2D'team2package.HUD.mineIcon')
}
