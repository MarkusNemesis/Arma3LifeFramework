/* clientInit script
Created: 02/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Initialises all the systems required for the client. Functions, variables, etc.
*/

private ["_runTime"];
_runTime =+ diag_tickTime;

waitUntil {!isNull player}; // Make sure the player exists before starting.
diag_log "MV: CLIENT INIT: STARTED";

// Init client functions
call compile preprocessFileLineNumbers "Client\functions\clientInitFunctions.sqf";

// Initialize shared resources only if not a server. Otherwise the client and server will both init shared.
if (!isServer) then {call compile preprocessFileLineNumbers "Shared\sharedInit.sqf"};

// Client constants
Client_PlayerName = name player;
Client_PlayerSide = side player;
Client_PlayerSideStr = str Client_PlayerSide;
//
// Init client globals
Client_PlayerDeathObjectCollection = []; // This variable is filled with objects that are handled immediatly upon the death of the player.
Client_SpawnType = "first";
Client_PlayerSpawned = false;
Client_HitArray = []; // Stores all the 'hits' the player receives and is collated on player death and sent to the server the top 3 damage sources by %.
Client_EventArray = []; // Client_EventArray elements contain: ["function_name", [args], priority]
Client_ObjectCount = 0; // All objects created by the client's locality are set a name [PlayerName-ObjectNumber] via setVehicleInit and sent to server via _object setvehicleinit "Shared_SpawnHaven = this";
Client_Inventory = [];

// Public Variables
KillMessageBroadcast = "";
//
setViewDistance 2000;

// init Params
call MV_Shared_fnc_initParams;

// Init Event handlers
call MV_Client_fnc_InitEventHandlers;

// SERVER FETCHED VARIABLES ->
// All network fetched variables are initialized here. This should be done as late as possible.
waitUntil{!isnil 'Shared_SpawnHaven'};
//waitUntil{!isnil 'MV_Netvar_VARNAME'};
// <- SERVER FETCHED VARIABLES


Client_InitComplete = true;
// **** CODE AFTER THIS POINT IS RAN DURING MISSION TIME ****
waituntil {time > 0}; // Checks if the mission has actually started.
finishMissionInit;
//

call MV_Shared_fnc_GetPlayers; // Gets the player names.

// Create player spawn event
["MV_Client_fnc_SpawnPlayer", [], 1] call MV_Client_fnc_AddEvent; 
// call MV_Client_fnc_SpawnPlayer;
// YOU MUST Leave this last. This calls the clientCore mainloop.
_runTime = diag_tickTime - _runTime;
diag_log format ["MV: CLIENT INIT: FINISHED, Time taken: %1", _runTime];
call compile preprocessFileLineNumbers "Client\clientCore.sqf";