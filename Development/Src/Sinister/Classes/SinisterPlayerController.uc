class SinisterPlayerController extends UTPlayerController;

var int CheckpointCounter;

var SinisterGame gameContext;
/** used to track boost duration */
var float BoostStartTime;
var float BoostPowerSpeed;
/** rocket booster properties */
var float BoosterForceMagnitude;
var repnotify bool	bBoostersActivated;
/** How long you can boost */
var float MaxBoostDuration;
/** used to track boost recharging duration */
var float BoostChargeTime;
const offsetItemBoxBy = 200.00;
var vector hello;


simulated event PostBeginPlay(){
`log( "POSTBEGIN");
	Super.PostBeginPlay();
   //Cast the GameInfo object to MyGameInfo   
   gameContext = SinisterGame(worldinfo.game);
}

exec function respawnSinisterPlayer(){
	local int checkpointToSpawnAt;
	local Vector locationToSpawnAt;
	local SinisterPlayerTracker     pt;
	local SinisterPlayerTracker     persistantpt;
	local SinisterCheckpoint pc;
	local UTVehicle_Sinister           vehicleAtHand;

	`log("printing r");

	vehicleAtHand = UTVehicle_Sinister( self.Pawn );

	foreach gameContext.TheSinisterPlayers(pt){
		if (self.PlayerNum == pt.c.PlayerNum){
			checkpointToSpawnAt = pt.lastCheckpointPassed;
			`log("printing checkpointToSpawnAt -- ");
			`log(checkpointToSpawnAt);
			break;
			//gameContext.RespawnCar(pt.c);
			//pt.c.SetLocation(locationToSpawnAt);		
		}
	}

	foreach gameContext.TheSinisterCheckpoints(pc){
		if (checkpointToSpawnAt == pc.CheckpointOrder){
			`log("printing pc.CheckpointOrder -- ");
			`log(pc.CheckpointOrder);
			locationToSpawnAt = pt.c.Location;
			`log("printing pc.Location -- ");
			`log(pc.Location);
			//break;

			vehicleAtHand.Destroy();
			//self.Destroy();
			gameContext.RespawnCar(pt.c, pt.c.Location);
			//gameContext.RespawnCar(pt.c);
			//pt.c.SetLocation(locationToSpawnAt);
			//pc.SetLocation(pc.Location);
		}
	}

	//self.Destroy();
}

exec function startSpeedBoost() {

	local UTVehicle_Sinister vehicleAtHand;
	local SinisterPlayerTracker     pt;
	local SinisterPlayerTracker     pt2;
	local int adjustXBy;
	local int adjustYBy;
	local SinisterHomingMissile x;

	foreach gameContext.TheSinisterPlayers(pt){
		if (self.PlayerNum == pt.c.PlayerNum){
			vehicleAtHand = UTVehicle_Sinister( self.Pawn ); // casts it
			//`log(vehicleAtHand.Location.X $ " " $ vehicleAtHand.Location.Y $ " " $ vehicleAtHand.Location.Z $ " " $ vehicleAtHand.Rotation.Yaw);
				
			switch (pt.weaponChoice){
				case 0:
					//do nothing
					break;
				case 1:    //lets say this is the boost
					//code for the boost
					vehicleAtHand.ActivateRocketBoosters();
					vehicleAtHand.bBoostersActivated = TRUE;
					vehicleAtHand.BoostStartTime = WorldInfo.TimeSeconds;

					pt.weaponChoice=0;
					break;
				case 2:    //lets say this is the missile
					//code for the missile
					hello.X=vehicleAtHand.Location.X;
					hello.Y=vehicleAtHand.Location.Y;
					hello.Z=vehicleAtHand.Location.Z + 150.00;

					x = Spawn(class'SinisterHomingMissile',,,hello);
					foreach gameContext.TheSinisterPlayers(pt2){
						if (self.PlayerNum != pt2.c.PlayerNum){
							x.target = pt2;
						}
					}

					pt.weaponChoice=0;
					break;
				case 3:    //lets say this is the bear trap
					//code for the bear trap
					//figure out which way the car is facing so we can decide where to spawn the beartrap

					if ( vehicleAtHand.Rotation.Yaw >= 8192 && vehicleAtHand.Rotation.Yaw <= 24576 ){
						//facing north
						adjustYBy = offsetItemBoxBy * -1.0;
					}
					else if ( vehicleAtHand.Rotation.Yaw >= -24576 && vehicleAtHand.Rotation.Yaw <= -8192 ){
						//facing south
						adjustYBy = offsetItemBoxBy;
					}
					else if ( (vehicleAtHand.Rotation.Yaw >= 24576 && vehicleAtHand.Rotation.Yaw <= 32768) || (vehicleAtHand.Rotation.Yaw >= -32768 && vehicleAtHand.Rotation.Yaw <= -8192) ){
						//facing east
						adjustXBy = offsetItemBoxBy;
					}
					else if ( (vehicleAtHand.Rotation.Yaw >= 0 && vehicleAtHand.Rotation.Yaw <= 8192) || (vehicleAtHand.Rotation.Yaw >= -8192 && vehicleAtHand.Rotation.Yaw <= 0) ){
						//facing west
						adjustXBy = offsetItemBoxBy * -1.0;
					}

					hello.X=vehicleAtHand.Location.X + adjustXBy;
					hello.Y=vehicleAtHand.Location.Y + adjustYBy;
					hello.Z=vehicleAtHand.Location.Z + 15.00;

					Spawn(class'SinisterBearTrap',,,hello);
					pt.weaponChoice=0;
                    break;
                }
            }
        }

}

DefaultProperties
{
	CheckpointCounter = 0;
	CameraClass=class'Sinister.SinisterPlayerCamera'
	BoostPowerSpeed=1800.0
	BoosterForceMagnitude=450.0
	MaxBoostDuration=5.0
	BoostChargeTime=-10.0
}
