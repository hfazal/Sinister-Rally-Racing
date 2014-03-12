class SinisterHUD extends UTHUD;

var() float DistanceFromX;
var() float DistanceFromY;
var() float WidthOfComponents;

function DrawGameHud()
{
	//HUD should always be 25% of width
	WidthOfComponents = Canvas.ClipX * 0.25;
	DistanceFromX = Canvas.ClipX - WidthOfComponents - 10;

	//Draw Minimap
    BoxMinimap(WidthOfComponents, 200.00, DistanceFromX, Canvas.ClipY - 210);

	//Draw Positional Information
	BoxPositionalInformation(WidthOfComponents, 200.00, DistanceFromX, 10);

	//Box of Positional Information
    //DrawHUDBox(WidthOfComponents, 200.00, DistanceFromX, 10);
}

function BoxMinimap(float width, float height, float widthToStartAt, float heightToStartAt){
	DrawHUDBox(width, height, widthToStartAt, heightToStartAt);
	WriteText("minimap will go here", class'Engine'.static.GetLargeFont(), widthToStartAt, heightToStartAt);
}

function BoxPositionalInformation(float width, float height, float widthToStartAt, float heightToStartAt){
	DrawHUDBox(width, height, widthToStartAt, heightToStartAt);
	WriteText("1st: Player 4 - 0:04\n2nd: You - \n3rd: Player 2 + 0:02\n4th: Player 2 + 0:04", class'Engine'.static.GetLargeFont(), widthToStartAt+10, heightToStartAt+10);
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
