/* clientInit script
Created: 02/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Initialises all the systems required for the client. Functions, variables, etc.
*/

private ["_runTime"];
_runTime =+ diag_tickTime;

waitUntil {!isNull player}; // Make sure the player exists before starting.
waitUntil {player getvariable "clientInitCompleteAck"};
diag_log "MV: CLIENT INIT: STARTED";

// Init client functions
call compile preprocessFile "Client\functions\clientInitFunctions.sqf";

// Initialize shared resources only if not a server. Otherwise the client and server will both init shared.
if (!isServer) then {call compile preprocessFile "Shared\sharedInit.sqf"};

// -- Load interaction functions
call compile preprocessFile "Client\functions\interactions\clientInitInteractions.sqf";

// -- Load item use functions
call compile preprocessFile "Client\functions\interactions\itemFunctions\clientInitItemFunctions.sqf";

// Client constants
Client_PlayerName = name player;
//Client_PlayerSlot = player;
Client_PlayerSlotStr = str player;
Client_PlayerSide = side player;
Client_PlayerSideStr = str Client_PlayerSide;
//
// Init client globals
Client_PlayerDeathObjectCollection = []; // This variable is filled with objects that are handled immediatly upon the death of the player.
Client_SpawnType = "first";
Client_PlayerSpawned = false;
Client_EventArray = []; // Client_EventArray elements contain: ["function_name", [args], priority]
Client_CustomKeysEnabled = true;
Client_isMessageBox = false; // Is true when there's a message box open. Helps in stopping loops from running whilst their dialog is not open due to a message.
Client_VehicleBuyCooldown = time; // Used to limit how often players can buy vehicles. You can buy one every 10 or so seconds. Stops spamming.
Client_InVehicle = false; // Used for updating the garbage collector on vehicle interactions.
Client_Vehicle = objnull;

// Declare client's commVar
call compile format ["%1_CommVar = '';", Client_PlayerSlotStr];
format ["%1_CommVar", Client_PlayerSlotStr] addPublicVariableEventHandler {[_this select 1] call MV_Client_fnc_CommVarEH};
// Public Variables
KillMessageBroadcast = "";
//

setViewDistance 2000;
setterraingrid 50;

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
player setVariable ['clientInitComplete', true, true];
// **** CODE AFTER THIS POINT IS RAN DURING MISSION TIME ****
waituntil {time > 0}; // Checks if the mission has actually started.
finishMissionInit;
//

// -- Start KeyDown event handler
(findDisplay 46) displayAddEventHandler ["KeyDown","_this call MV_Client_fnc_OnKeyPressEH;"];

// ---- Gets the player names.
if (!isServer) then {call MV_Shared_fnc_GetPlayers;};

// TODO Remove this before final DEBUG
[] spawn {while {true} do {hint Server_Health; sleep 0.25;};};

// ---- Create player spawn event
["MV_Client_fnc_SpawnPlayer", [], 1] call MV_Client_fnc_AddEvent; 

// ---- YOU MUST Leave this last. This calls the clientCore mainloop.
_runTime = diag_tickTime - _runTime;
diag_log format ["MV: CLIENT INIT: FINISHED, Time taken: %1", _runTime];
call compile preprocessFileLineNumbers "Client\clientCore.sqf";