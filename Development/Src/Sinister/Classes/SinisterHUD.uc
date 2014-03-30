class SinisterHUD extends UTHUD;

var float DistanceFromX;
var float DistanceFromY;
var float WidthOfComponents;
var SinisterGame gameContext;

//Weapon Icons
var CanvasIcon weaponNitrous;
var CanvasIcon weaponMissile;
var CanvasIcon weaponMine;

//Start Countdown
var int countdown;

//Minimap
var SinisterMiniMap GameMinimap;
var float TileSize;
var int MapDim;
var int BoxSize;
var Color PlayerColors[3];

simulated event PostBeginPlay()
{
	//local PlayerController c;
	//local SinisterPlayerTracker pt;

	Super.PostBeginPlay();

	//Cast the GameInfo object to MyGameInfo   
	gameContext = SinisterGame(worldinfo.game);

	//Initialize minimap
	GameMinimap = gameContext.GameMinimap;

	//PAUSE GAME for countdown
	SetTimer(1);
}

simulated function Timer()
{    
	if (countdown >= 0){
		countdown--;
		SetTimer(1);
	}
	else {
		countdown--;
		//UNPAUSE GAME for end of countdown
	}
}

function DrawHUD(){
	super.DrawHUD();

	DrawMap();
}

function float GetPlayerHeading()
{
	local Vector v;
	local Rotator r;
	local float f;

	r.Yaw = PlayerOwner.Pawn.Rotation.Yaw;
	v = vector(r);
	f = GetHeadingAngle(v);
	f = UnwindHeading(f);

	while (f < 0){
		f += PI * 2.0f;
	}

	return f;
}

function DrawGameHud()
{
	local SinisterPlayerTracker     pt;

	if (countdown > 0){
		WriteText(String( countdown ), class'Engine'.static.GetLargeFont(), Canvas.ClipX / 2, Canvas.ClipY / 2);
	}
	else if (countdown == 0) {
		WriteText("GO", class'Engine'.static.GetLargeFont(), Canvas.ClipX / 2, Canvas.ClipY / 2);
	}
	else {
		//HUD should always be 25% of width
		WidthOfComponents = Canvas.ClipX * 0.25;
		DistanceFromX = Canvas.ClipX - WidthOfComponents - 10;

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
						Canvas.DrawIcon(weaponNitrous, 40, Canvas.ClipY-20-148, 0.5);
						DrawHUDBox(148, 148, 30, Canvas.ClipY-30-148);
					break;
					case 2:
						//Missile
						Canvas.DrawIcon(weaponMissile, 40, Canvas.ClipY-20-148, 0.5);
						DrawHUDBox(148, 148, 30, Canvas.ClipY-30-148);
					break;
					case 3:
						//Mine
						Canvas.DrawIcon(weaponMine, 40, Canvas.ClipY-20-148, 0.5);
						DrawHUDBox(148, 148, 30, Canvas.ClipY-30-148);
					break;
					default:
				}
			}
		}
	}
}

function DrawMap()
{
	local Float TrueNorth,PlayerHeading;
	local Float MapRotation,CompassRotation;
	local Vector PlayerPos, ClampedPlayerPos, RotPlayerPos, DisplayPlayerPos, StartPos;
	local LinearColor MapOffset;
	local Float ActualMapRange;
	local Controller C;
	local MaterialInstanceConstant GameMinimapMIC;
	local MaterialInstanceConstant GameCompassMIC;
	local SinisterPlayerTracker     pt;
	local SinisterCheckpoint checkpointAtHand;

	//Set MapDim & BoxSize accounting for the current resolution 		
	MapPosition.X = default.MapPosition.X * FullWidth;
	MapPosition.Y = default.MapPosition.Y * FullHeight;
	MapDim = default.MapDim * ResolutionScale;
	BoxSize = default.BoxSize * ResolutionScale;

	//Calculate map range values
	ActualMapRange = FMax(	GameMinimap.MapRangeMax.X - GameMinimap.MapRangeMin.X,
						GameMinimap.MapRangeMax.Y - GameMinimap.MapRangeMin.Y);

	//Calculate normalized player position
	PlayerPos.X = (PlayerOwner.Pawn.Location.Y - GameMinimap.MapCenter.Y) / ActualMapRange;
	PlayerPos.Y = (GameMinimap.MapCenter.X - PlayerOwner.Pawn.Location.X) / ActualMapRange;

	//Calculate clamped player position
	ClampedPlayerPos.X = FClamp(PlayerPos.X,-0.5 + (TileSize / 2.0),0.5 - (TileSize / 2.0));
	ClampedPlayerPos.Y = FClamp(PlayerPos.Y,-0.5 + (TileSize / 2.0),0.5 - (TileSize / 2.0));

	//Get north direction and player's heading
	TrueNorth = GameMinimap.GetRadianHeading();
	Playerheading = GetPlayerHeading();

	//Calculate rotation values
	if(GameMinimap.bForwardAlwaysUp)
	{
		MapRotation = PlayerHeading;
		CompassRotation = PlayerHeading - TrueNorth;
	}
	else
	{
		MapRotation = PlayerHeading - TrueNorth;
		CompassRotation = MapRotation;
	}

	//Calculate position for displaying the player in the map
	DisplayPlayerPos.X = VSize(PlayerPos) * Cos( ATan2(PlayerPos.Y, PlayerPos.X) - MapRotation);
	DisplayPlayerPos.Y = VSize(PlayerPos) * Sin( ATan2(PlayerPos.Y, PlayerPos.X) - MapRotation);

	//Calculate player location after rotation
	RotPlayerPos.X = VSize(ClampedPlayerPos) * Cos( ATan2(ClampedPlayerPos.Y, ClampedPlayerPos.X) - MapRotation);
	RotPlayerPos.Y = VSize(ClampedPlayerPos) * Sin( ATan2(ClampedPlayerPos.Y, ClampedPlayerPos.X) - MapRotation);

	//Calculate upper left UV coordinate
	StartPos.X = FClamp(RotPlayerPos.X + (0.5 - (TileSize / 2.0)),0.0,1.0 - TileSize);
	StartPos.Y = FClamp(RotPlayerPos.Y + (0.5 - (TileSize / 2.0)),0.0,1.0 - TileSize);
	//StartPos.X = FClamp(DisplayPlayerPos.X + (0.5 - (TileSize / 2.0)),TileSize/-2,1.0 - TileSize/2);
	//StartPos.Y = FClamp(DisplayPlayerPos.Y + (0.5 - (TileSize / 2.0)),TileSize/-2,1.0 - TileSize/2);

	//Calculate texture panning for alpha
	MapOffset.R =  FClamp(-1.0 * RotPlayerPos.X,-0.5 + (TileSize / 2.0),0.5 - (TileSize / 2.0));
	MapOffset.G =  FClamp(-1.0 * RotPlayerPos.Y,-0.5 + (TileSize / 2.0),0.5 - (TileSize / 2.0));
	//MapOffset.R =  FClamp(-1.0 * DisplayPlayerPos.X,-0.5,0.5);
	//MapOffset.G =  FClamp(-1.0 * DisplayPlayerPos.Y,-0.5,0.5);

	GameMinimapMIC = new(Outer) class'MaterialInstanceConstant';
	GameMinimapMIC.SetParent( GameMinimap.Minimap );
	GameCompassMIC = new(Outer) class'MaterialInstanceConstant';
	GameCompassMIC.SetParent( GameMinimap.CompassOverlay );
	//Set the material parameter values
	GameMinimapMIC.SetScalarParameterValue('MapRotation',MapRotation);
	GameMinimapMIC.SetScalarParameterValue('TileSize',TileSize);
	GameMinimapMIC.SetVectorParameterValue('MapOffset',MapOffset);
	GameCompassMIC.SetScalarParameterValue('CompassRotation',CompassRotation);

	//Draw the map
	Canvas.SetPos(MapPosition.X,MapPosition.Y);
	Canvas.DrawMaterialTile(GameMinimapMIC,MapDim,MapDim,StartPos.X,StartPos.Y,TileSize,TileSize);

	//Draw the player's location
	Canvas.SetPos(	MapPosition.X + MapDim * (((DisplayPlayerPos.X + 0.5) - StartPos.X) / TileSize) - (BoxSize / 2),
				MapPosition.Y + MapDim * (((DisplayPlayerPos.Y + 0.5) - StartPos.Y) / TileSize) - (BoxSize / 2));
	Canvas.SetDrawColor(PlayerColors[0].R,
					PlayerColors[0].G,
					PlayerColors[0].B,
					PlayerColors[0].A);
	Canvas.DrawBox(BoxSize,BoxSize);
	
	/*****************************
	*  Draw Other Players
	*****************************/

	foreach WorldInfo.AllControllers(class'Controller',C)
	{
		if(PlayerController(C) != PlayerOwner)
		{
			//Calculate normalized player position
			PlayerPos.Y = (GameMinimap.MapCenter.X - C.Pawn.Location.X) / ActualMapRange;
			PlayerPos.X = (C.Pawn.Location.Y - GameMinimap.MapCenter.Y) / ActualMapRange;

			//Calculate position for displaying the player in the map
			DisplayPlayerPos.X = VSize(PlayerPos) * Cos( ATan2(PlayerPos.Y, PlayerPos.X) - MapRotation);
			DisplayPlayerPos.Y = VSize(PlayerPos) * Sin( ATan2(PlayerPos.Y, PlayerPos.X) - MapRotation);

			if(VSize(DisplayPlayerPos - RotPlayerPos) <= ((TileSize / 2.0) - (TileSize * Sqrt(2 * Square(BoxSize / 2)) / MapDim)))
			{
				//Draw the player's location
				Canvas.SetPos(	MapPosition.X + MapDim * (((DisplayPlayerPos.X + 0.5) - StartPos.X) / TileSize) - (BoxSize / 2),
							MapPosition.Y + MapDim * (((DisplayPlayerPos.Y + 0.5) - StartPos.Y) / TileSize) - (BoxSize / 2));
				Canvas.SetDrawColor(PlayerColors[1].R,
								PlayerColors[1].G,
								PlayerColors[1].B,
								PlayerColors[1].A);
				Canvas.DrawBox(BoxSize,BoxSize);
			}
		}
	}

	/*****************************
	*  Draw Next Checkpoint (I cant believe I'm doing this.....)
	*****************************/

	foreach gameContext.TheSinisterPlayers(pt)
	{
		if (PlayerController(pt.c) == PlayerOwner)
		{
			foreach gameContext.TheSinisterCheckpoints(checkpointAtHand)
			{
				if (checkpointAtHand.CheckpointOrder == pt.lastCheckpointPassed+1){
					//Calculate normalized player position
					PlayerPos.Y = (GameMinimap.MapCenter.X - checkpointAtHand.Location.X) / ActualMapRange;
					PlayerPos.X = (checkpointAtHand.Location.Y - GameMinimap.MapCenter.Y) / ActualMapRange;

					//Calculate position for displaying the player in the map
					DisplayPlayerPos.X = VSize(PlayerPos) * Cos( ATan2(PlayerPos.Y, PlayerPos.X) - MapRotation);
					DisplayPlayerPos.Y = VSize(PlayerPos) * Sin( ATan2(PlayerPos.Y, PlayerPos.X) - MapRotation);

					if(VSize(DisplayPlayerPos - RotPlayerPos) <= ((TileSize / 2.0) - (TileSize * Sqrt(2 * Square(BoxSize / 2)) / MapDim)))
					{
						//Draw the player's location
						Canvas.SetPos(	MapPosition.X + MapDim * (((DisplayPlayerPos.X + 0.5) - StartPos.X) / TileSize) - (BoxSize / 2),
									MapPosition.Y + MapDim * (((DisplayPlayerPos.Y + 0.5) - StartPos.Y) / TileSize) - (BoxSize / 2));
						Canvas.SetDrawColor(PlayerColors[2].R,
										PlayerColors[2].G,
										PlayerColors[2].B,
										PlayerColors[2].A);
						Canvas.DrawBox(BoxSize,BoxSize);
					}
					break;
				}
			}
			break;
		}
	}

	//Draw the compass overlay
	Canvas.SetPos(MapPosition.X,MapPosition.Y);
	Canvas.DrawMaterialTile(GameCompassMIC,MapDim,MapDim,0.0,0.0,1.0,1.0);
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
	weaponNitrous = (Texture=Texture2D'team2package.HUD.nitrousIcon')
	weaponMissile = (Texture=Texture2D'team2package.HUD.missileIcon')
	weaponMine = (Texture=Texture2D'team2package.HUD.mineIcon')
	countdown = 3
	MapDim=256
	BoxSize=12
	PlayerColors(0)=(R=255,G=255,B=255,A=255)
	PlayerColors(1)=(R=255,G=0,B=0,A=255)
	PlayerColors(2)=(R=255,G=140,B=0,A=255)
	TileSize=0.4
	MapPosition=(X=0.000000,Y=0.000000)
}
