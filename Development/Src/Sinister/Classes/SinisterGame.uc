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
var() int lapCount;                                     // defaulted to 2, in future will be alterable via main menu
const checkpointsPerLapCount = 19;                      // one lap is 19
var SinisterMiniMap GameMinimap;

event Tick(float DeltaTime){
	local SinisterPlayerTracker     pt;

	super.Tick(DeltaTime);

	//check for game end
	foreach TheSinisterPlayers(pt){
		if (pt.lastLapCompleted == lapCount){
			EndGame(pt.c.PlayerReplicationInfo, "Player" $ pt.c.PlayerNum $ " Won");
			bGameEnded = true;
		}
	}
}

function InitGame( string Options, out string ErrorMessage )
{
	local SinisterMiniMap minimap;
	local Controller C;
	local SinisterPlayerTracker pt;

	Super.InitGame(Options,ErrorMessage);

	foreach AllActors(class'SinisterMiniMap',minimap)
	{
	   GameMinimap = minimap;
	   break;
	}
}

function StartMatch(){
	local Controller C;
	local SinisterPlayerTracker pt;

	super.StartMatch();

	//Build Array of SinisterPlayerTrackers
	//only adds local player
	foreach AllActors(class'Controller', C){
		pt = New class'SinisterPlayerTracker';
		pt.c = C;
		pt.terrainStack.AddItem("ROAD");
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

function RespawnCar(Controller aPlayer, Vector location)
{

	//aPlayer.Destroy();
	
     //ForceRespawn();
	Super.RestartPlayer(aPlayer);
	//aPlayer.Location = location;
	aPlayer.SetLocation(location);
	//aPlayer.SetLocation(location);

}

DefaultProperties
{
	PlayerControllerClass=class'Sinister.SinisterPlayerController'
	DefaultPawnClass=class'Sinister.SinisterPawn'
	HUDType=class'Sinister.SinisterHUD'
	bUseClassicHUD=true
	bDelayedStart=false
	lapCount=2
	MapPrefixes(0)="COM"
}
