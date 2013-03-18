/* serverInitFunctions script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Precompiles functions and makes them available. There are restricted to the serverside scope.
*/

// -- Garbage Collector - garbageCollector
MV_Server_fnc_AddGarbage = Compile preprocessFileLineNumbers "server\functions\garbageCollector\serverAddGarbage.sqf";
MV_Server_fnc_RunGarbageCollector = Compile preprocessFileLineNumbers "Server\functions\garbageCollector\serverRunGarbageCollector.sqf";
MV_Server_fnc_UpdateGarbageObject = Compile preprocessFileLineNumbers "Server\functions\garbageCollector\serverUpdateGarbageObject.sqf";

//MV_Server_fnc_initPlayerSlots = Compile preprocessFileLineNumbers "Server\functions\init\ServerInitPlayerSlots.sqf"; defunct
MV_Server_fnc_OnPlayerConnected = Compile preprocessFileLineNumbers "Server\functions\serverOnPlayerConnected.sqf";
MV_Server_fnc_OnPlayerDisconnected = Compile preprocessFileLineNumbers "Server\functions\serverOnPlayerDisconnected.sqf";
MV_Server_fnc_InitWorldProps = Compile preprocessFileLineNumbers "Server\functions\init\serverInitWorldProps.sqf";
MV_Server_fnc_CommVarEH = Compile preprocessFileLineNumbers "Server\functions\serverCommVarEH.sqf";
MV_Server_fnc_BuyVehicle = Compile preprocessFileLineNumbers "Server\functions\serverBuyVehicle.sqf";
MV_Server_fnc_AddEvent = Compile preprocessFileLineNumbers "Server\functions\serverAddEvent.sqf";
MV_Server_fnc_RemoveEvent = Compile preprocessFileLineNumbers "Server\functions\serverRemoveEvent.sqf";
MV_Server_fnc_GetPlayerFunds = Compile preprocessFileLineNumbers "Server\functions\serverGetPlayerFunds.sqf";
MV_Server_fnc_SetPlayerFunds = Compile preprocessFileLineNumbers "Server\functions\serverSetPlayerFunds.sqf";
MV_Server_fnc_AdjustStoreStock = Compile preprocessFileLineNumbers "Server\functions\serverAdjustStoreStock.sqf";
MV_Server_fnc_SendClientMessage = Compile preprocessFileLineNumbers "Server\functions\serverSendClientMessage.sqf";

//MV_Server_fnc_ = Compile preprocessFileLineNumbers "Server\functions\";