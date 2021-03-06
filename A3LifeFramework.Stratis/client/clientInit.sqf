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

// -- Create map location for clientside only variable storage. Variable name is created by random number generator. 
private ['_slocN', '_sLoc'];
_slocN = format ['%1%2%3', (profileName), (round (random 10000)), round ((diag_ticktime) * 100)];
call compile format ["%1 = createLocation ['NameVillage', [0, 0, 0], 1, 1];", _slocN];
uiNamespace setVariable ["Client_LocObj", _slocN];
diag_log format ["MV: clientInit: Location Var name generated: %1", _slocN];

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
Client_UsingItem = false;
Client_TransactionCooldown = time; // -- used to limit how often this player can transfer/drop items. Limit is set at author's discretion. 
player setVariable ['isStunned', false];
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
//player setVariable ['clientInitComplete', true, true];
// **** CODE AFTER THIS POINT IS RAN DURING MISSION TIME ****
waituntil {time > 0}; // Checks if the mission has actually started.
startLoadingScreen ["Loading..."];
finishMissionInit;
//

// -- Start KeyDown event handler
(findDisplay 46) displayAddEventHandler ["KeyDown","private ['_return']; _return = (_this call MV_Client_fnc_OnKeyPressEH); _return"];

// ---- Gets the player names.
if (!isServer) then {call MV_Shared_fnc_GetPlayers;};

// TODO Remove this before final DEBUG
if (name player == "Radioman") then {[] spawn {while {true} do {hint Server_Health; sleep 0.25;};};};

// -- Only start when the server has finished initializing the player's connection.
waitUntil {player getvariable "clientInitCompleteAck"};

// ---- Create player spawn event
["MV_Client_fnc_SpawnPlayer", [], 1] call MV_Client_fnc_AddEvent; 

// ---- YOU MUST Leave this last. This calls the clientCore mainloop.
_runTime = diag_tickTime - _runTime;
diag_log format ["MV: CLIENT INIT: FINISHED, Time taken: %1", _runTime];
//
endLoadingScreen;
titleText ["Loading...", "BLACK FADED", 30];
//
private ['_mainloop', '_lHandle'];
_mainloop = compile preprocessFileLineNumbers "Client\clientCore.sqf";
_lHandle = [] spawn _mainloop;
while {true} do
{
	waitUntil {sleep 1; scriptDone _lHandle}; // -- Handles whether the mainloop has died and thus, starts it back up again.
	_lHandle = [] spawn _mainloop;
};
