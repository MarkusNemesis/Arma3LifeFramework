/* sharedInit script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Initialises variables that are shared between the client and server namespaces.
*/

private ["_runTime", "_i"];
_runTime =+ time;

// Constants
PRIOR_RANGE = 8; // Dictates the valid ranges of event priorities

// Player slots
MV_Shared_PLAYERS_BLU = [];
MV_Shared_PLAYERS_OP = [];
MV_Shared_PLAYERS_IND = [];
MV_Shared_PLAYERS_CIV = [];

// -- player slots per side
BLU_PLAYERCOUNT = 10;
OP_PLAYERCOUNT = 0;
IND_PLAYERCOUNT = 0;
CIV_PLAYERCOUNT = 35;

// -- Interaction range
INT_RANGE = 4;

MV_Shared_PLAYERVOLUME = 25000; // -- 25,000 cc
MV_Shared_PILEVOLUME = 100000; // -- 100,000 cc

// -- Animations
MV_Shared_ANIMATION_BUY = "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";

// -- Game object classes
MV_Shared_DROPPILECLASS = "Land_Sack_F";

// leave last
_runTime = time - _runTime;
diag_log format ["MV: sharedConstants INIT: FINISHED, Time taken: %1", _runTime];