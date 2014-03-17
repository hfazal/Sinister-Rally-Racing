class SinisterHUD extends UTHUD;

var float DistanceFromX;
var float DistanceFromY;
var float WidthOfComponents;
var SinisterGame gameContext;

event PostBeginPlay()
{
   Super.PostBeginPlay();
	//Cast the GameInfo object to MyGameInfo   
   gameContext = SinisterGame(worldinfo.game);
}

function DrawGameHud()
{
	//HUD should always be 25% of width
	WidthOfComponents = Canvas.ClipX * 0.25;
	DistanceFromX = Canvas.ClipX - WidthOfComponents - 10;

	//Draw Minimap
    BoxMinimap(WidthOfComponents, 200.00, DistanceFromX, Canvas.ClipY - 210);

	//Draw Positional Information
	BoxPositionalInformation(WidthOfComponents, 200.00, DistanceFromX, 10);
}

function BoxMinimap(float width, float height, float widthToStartAt, float heightToStartAt){
	local String checkpointlog;

	checkpointlog = "minimap will go here";

	DrawHUDBox(width, height, widthToStartAt, heightToStartAt);

	WriteText(checkpointlog, class'Engine'.static.GetLargeFont(), widthToStartAt, heightToStartAt);
}

function BoxPositionalInformation(float width, float height, float widthToStartAt, float heightToStartAt){
	local SinisterPlayerTracker     pt;
	local String checkpointlog;

	checkpointlog = "";

	foreach gameContext.TheSinisterPlayers(pt){
		checkpointlog $= "Player" $ pt.c.PlayerNum $ "\n" $ pt.lastCheckpointPassed $ "/" $ gameContext.checkpointsPerLapCount $ " Checkpoints\nLap " $ (pt.lastLapCompleted + 1) $ "/" $ gameContext.lapCount $ "\n";
	}

	foreach gameContext.TheSinisterPlayers(pt){
		if (pt.c.PlayerNum == self.PlayerOwner.PlayerNum){
			switch (pt.weaponChoice) {
				case 0:
					checkpointlog $= "No Item\n";
				break;
				case 1:
					checkpointlog $= "Speed Boost\n";
				break;
				case 2:
					checkpointlog $= "Missile\n";
				break;
				case 3:
					checkpointlog $= "Bear Trap\n";
				break;
				default:
			}
		}
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
	Canvas.SetDrawColor(0,0,0,200);
	Canvas.DrawRect(width,height);
}

DefaultProperties
{
	
}
