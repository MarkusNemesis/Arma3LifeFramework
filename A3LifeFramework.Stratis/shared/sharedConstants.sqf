/* sharedInit script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Initialises variables that are shared between the client and server namespaces.
Stored in missionNamespace to allow them to be write protected.
In future: Use 'with' to define all these things, vs putting them through 'setvariable' a hundred times. http://community.bistudio.com/wiki/with
Get these variables via (missionNamespace getVariable "VarNameHere")
*/

private ["_runTime", "_i"];
_runTime =+ time;

// Constants
//PRIOR_RANGE = 8; // Dictates the valid ranges of event priorities
missionNamespace setVariable ["PRIOR_RANGE", 8];

/* Player slots
MV_Shared_PLAYERS_BLU = [];
MV_Shared_PLAYERS_OP = [];
MV_Shared_PLAYERS_IND = [];
MV_Shared_PLAYERS_CIV = [];
*/

missionNamespace setVariable ["MV_Shared_PLAYERS_BLU", []];
missionNamespace setVariable ["MV_Shared_PLAYERS_OP", []];
missionNamespace setVariable ["MV_Shared_PLAYERS_IND", []];
missionNamespace setVariable ["MV_Shared_PLAYERS_CIV", []];

/* -- player slots per side
BLU_PLAYERCOUNT = 10;
OP_PLAYERCOUNT = 0;
IND_PLAYERCOUNT = 0;
CIV_PLAYERCOUNT = 35;
*/

missionNamespace setVariable ["BLU_PLAYERCOUNT", 10];
missionNamespace setVariable ["OP_PLAYERCOUNT", 0];
missionNamespace setVariable ["IND_PLAYERCOUNT", 0];
missionNamespace setVariable ["CIV_PLAYERCOUNT", 35];

/* -- Interaction range
INT_RANGE = 4;
REMOTE_KEY_RANGE = 20;
*/
missionNamespace setVariable ["INT_RANGE", 4];
missionNamespace setVariable ["REMOTE_KEY_RANGE", 20];

/* -- Static volumes
MV_Shared_PLAYERVOLUME = 25000; // -- 25,000 cc
MV_Shared_PILEVOLUME = 100000; // -- 100,000 cc
*/
missionNamespace setVariable ["MV_Shared_PLAYERVOLUME", 25000];
missionNamespace setVariable ["MV_Shared_PILEVOLUME", 100000];


// -- Animations
//MV_Shared_ANIMATION_BUY = "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
missionNamespace setVariable ["MV_Shared_ANIMATION_BUY", "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon"];

// -- Game object classes
//MV_Shared_DROPPILECLASS = "Land_Sack_F";
missionNamespace setVariable ["MV_Shared_DROPPILECLASS", "Land_Sack_F"];

// leave last
_runTime = time - _runTime;
diag_log format ["MV: sharedConstants INIT: FINISHED, Time taken: %1", _runTime];