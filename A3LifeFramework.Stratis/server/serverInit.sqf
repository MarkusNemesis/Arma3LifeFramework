/* ServerInit script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Initialises all the systems required for the mission. Functions, variables, etc.
*/

private ["_runTime"];
_runTime =+ diag_tickTime;

diag_log "MV: SERVER INIT: STARTED";

// Init server functions
call compile preprocessFileLineNumbers "server\functions\serverInitFunctions.sqf";

// Initialize shared resources
call compile preprocessFileLineNumbers "Shared\sharedInit.sqf";

// init Params
call MV_Shared_fnc_initParams;

// Init global variables
Server_PlayerRegistry = []; // Format: [id, playerName, UID, playerSlot];

// OnPlayerConnected
OnPlayerConnected "[_id, _name, _uid] execVM ""Server\functions\serverOnPlayerConnected.sqf"";";

// OnPlayerDisconnected
OnPlayerDisconnected "[_id, _name, _uid] execVM ""Server\functions\serverOnPlayerDisconnected.sqf"";";

// Create spawn haven
private ["_vName", "_object"];
_object = "Land_Cargo_HQ_V1_F" createvehicle [100, 100, 100]; 
_object setposASL [100, 100, 0];
_object setvehicleinit "Shared_SpawnHaven = this";
processinitcommands;

Server_InitComplete = true;
// -------- CODE AFTER THIS POINT IS RAN DURING MISSION TIME --------
waituntil {time > 0;}; // Checks if the mission has actually started.


// Init playerslots
call MV_Shared_fnc_GetPlayers;
[MV_Shared_PLAYERS_BLU + MV_Shared_PLAYERS_OP + MV_Shared_PLAYERS_IND + MV_Shared_PLAYERS_CIV] call MV_Server_fnc_initPlayerSlots;

// YOU MUST Leave this last. This calls the serverCore mainloop.
_runTime = diag_tickTime - _runTime;
diag_log format ["MV: server INIT: FINISHED, Time taken: %1", _runTime];
call compile preprocessFileLineNumbers "server\serverCore.sqf";