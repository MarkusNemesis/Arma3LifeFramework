/* sharedInit script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Initialises variables that are shared between the client and server namespaces.
Stored in Client_LocObj/Server_LocObj to allow them to be write protected.
Get these variables via (_lObj getVariable "VarNameHere")
*/

private ["_runTime", "_i", '_lObj'];
_runTime =+ time;

if (isServer) then 
{
	_lObj = (call M_S_fnc_GLV);
} else {
	_lObj = (call M_C_fnc_GLV);
};

// Constants
_lObj setVariable ["PRIOR_RANGE", 8];

// Player slots
_lObj setVariable ["MV_Shared_PLAYERS_BLU", []];
_lObj setVariable ["MV_Shared_PLAYERS_OP", []];
_lObj setVariable ["MV_Shared_PLAYERS_IND", []];
_lObj setVariable ["MV_Shared_PLAYERS_CIV", []];

// -- player slots per side
_lObj setVariable ["BLU_PLAYERCOUNT", 10];
_lObj setVariable ["OP_PLAYERCOUNT", 0];
_lObj setVariable ["IND_PLAYERCOUNT", 0];
_lObj setVariable ["CIV_PLAYERCOUNT", 35];

// -- Interaction range
_lObj setVariable ["INT_RANGE", 4];
_lObj setVariable ["REMOTE_KEY_RANGE", 20];

// -- Static volumes
_lObj setVariable ["MV_Shared_PLAYERVOLUME", 25000];
_lObj setVariable ["MV_Shared_PILEVOLUME", 100000];

// -- Animations
_lObj setVariable ["MV_Shared_ANIMATION_BUY", "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon"];
_lObj setVariable ["MV_Shared_ANIMATION_RESTRAIN", "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon"];
_lObj setVariable ["MV_Shared_ANIMATION_RESTRAINED", "InBaseMoves_HandsBehindBack2"];

// -- Game object classes
_lObj setVariable ["MV_Shared_DROPPILECLASS", "Land_Sack_F"];
//_lObj setVariable ["MV_Shared_ATMCLASS", "Land_CashDesk_F"]; // Commented due to ATMs not being of fixed class.

// leave last
_runTime = time - _runTime;
diag_log format ["MV: sharedConstants INIT: FINISHED, Time taken: %1", _runTime];