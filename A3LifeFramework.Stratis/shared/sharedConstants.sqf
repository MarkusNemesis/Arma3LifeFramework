/* sharedInit script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Initialises variables that are shared between the client and server namespaces.
Stored in Client_LocObj/Server_LocObj to allow them to be write protected.
In future: Use 'with' to define all these things, vs putting them through 'setvariable' a hundred times. http://community.bistudio.com/wiki/with
Get these variables via (missionNamespace getVariable "VarNameHere")
*/

private ["_runTime", "_i", '_lObj'];
_runTime =+ time;

if (isServer) then 
{
	_lObj = (call M_S_fnc_GLV);
} else {
	_lObj = missionNamespace;
};

// Constants
//PRIOR_RANGE = 8; // Dictates the valid ranges of event priorities
_lObj setVariable ["PRIOR_RANGE", 8];

/* Player slots
MV_Shared_PLAYERS_BLU = [];
MV_Shared_PLAYERS_OP = [];
MV_Shared_PLAYERS_IND = [];
MV_Shared_PLAYERS_CIV = [];
*/

_lObj setVariable ["MV_Shared_PLAYERS_BLU", []];
_lObj setVariable ["MV_Shared_PLAYERS_OP", []];
_lObj setVariable ["MV_Shared_PLAYERS_IND", []];
_lObj setVariable ["MV_Shared_PLAYERS_CIV", []];

/* -- player slots per side
BLU_PLAYERCOUNT = 10;
OP_PLAYERCOUNT = 0;
IND_PLAYERCOUNT = 0;
CIV_PLAYERCOUNT = 35;
*/

_lObj setVariable ["BLU_PLAYERCOUNT", 10];
_lObj setVariable ["OP_PLAYERCOUNT", 0];
_lObj setVariable ["IND_PLAYERCOUNT", 0];
_lObj setVariable ["CIV_PLAYERCOUNT", 35];

/* -- Interaction range
INT_RANGE = 4;
REMOTE_KEY_RANGE = 20;
*/
_lObj setVariable ["INT_RANGE", 4];
_lObj setVariable ["REMOTE_KEY_RANGE", 20];

/* -- Static volumes
MV_Shared_PLAYERVOLUME = 25000; // -- 25,000 cc
MV_Shared_PILEVOLUME = 100000; // -- 100,000 cc
*/
_lObj setVariable ["MV_Shared_PLAYERVOLUME", 25000];
_lObj setVariable ["MV_Shared_PILEVOLUME", 100000];


// -- Animations
//MV_Shared_ANIMATION_BUY = "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
_lObj setVariable ["MV_Shared_ANIMATION_BUY", "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon"];

// -- Game object classes
//MV_Shared_DROPPILECLASS = "Land_Sack_F";
_lObj setVariable ["MV_Shared_DROPPILECLASS", "Land_Sack_F"];
//_lObj setVariable ["MV_Shared_ATMCLASS", "Land_CashDesk_F"]; // Commented due to ATMs not being of fixed class.

// leave last
_runTime = time - _runTime;
diag_log format ["MV: sharedConstants INIT: FINISHED, Time taken: %1", _runTime];