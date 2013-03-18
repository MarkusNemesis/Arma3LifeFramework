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
call compile preprocessFile "server\functions\init\serverInitFunctions.sqf";

// Initialize shared resources
call compile preprocessFile "Shared\sharedInit.sqf";

// init Params
call MV_Shared_fnc_initParams;

// Init global variables
Server_Health = ''; // Variable used for viewing how long a server tick takes, by adding 8 tick's processing time together and divding by 8.
Server_EventArray = []; // Server_EventArray elements contain: ["function_name", [args], priority]
Server_GarbageCollection = []; // This variable is filled with objects to be cleaned up / managed after a set time. [obj, cleandelay]
Server_PlayerRegistry = []; // Format: [id, playerName, UID, playerSlot];
Server_InitPropsArray = []; // Use init line: if (isServer) then {this execVM "server\functions\serverAddProp.sqf";};
Server_PropsArray = []; // Contains all the static world props. 

// OnPlayerConnected
OnPlayerConnected "[_id, _name, _uid] execVM ""Server\functions\serverOnPlayerConnected.sqf"";";

// OnPlayerDisconnected
OnPlayerDisconnected "[_id, _name, _uid] execVM ""Server\functions\serverOnPlayerDisconnected.sqf"";";

// Create spawn haven
private ["_vName", "_object"];
_object = "Land_Cargo_HQ_V1_F" createvehicle [100, 100, 100]; 
_object setposASL [-1000, -1000, 0];
_object allowdamage false;
_object setvehicleinit "Shared_SpawnHaven = this";
processinitcommands;

Server_InitComplete = true;
// -------- CODE AFTER THIS POINT IS RAN DURING MISSION TIME --------
waituntil {time > 0;}; // Checks if the mission has actually started.

// Init stores:
call Compile preprocessFile "server\functions\init\serverInitStores.sqf";

// Init playerslots
call MV_Shared_fnc_GetPlayers;

[MV_Shared_PLAYERS_BLU + MV_Shared_PLAYERS_OP + MV_Shared_PLAYERS_IND + MV_Shared_PLAYERS_CIV] call Compile preprocessFile "Server\functions\init\ServerInitPlayerSlots.sqf";


// YOU MUST Leave this last. This calls the serverCore mainloop.
_runTime = diag_tickTime - _runTime;
diag_log format ["MV: SERVER INIT: FINISHED, Time taken: %1", _runTime];
call compile preprocessFile "server\serverCore.sqf";