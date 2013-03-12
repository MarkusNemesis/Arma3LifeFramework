/* serverInitFunctions script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Precompiles functions and makes them available. There are restricted to the serverside scope.
*/

MV_Server_fnc_AddGarbage = Compile preprocessFileLineNumbers "server\functions\serverAddGarbage.sqf";
//MV_Server_fnc_initPlayerSlots = Compile preprocessFileLineNumbers "Server\functions\ServerInitPlayerSlots.sqf"; defunct
MV_Server_fnc_OnPlayerConnected = Compile preprocessFileLineNumbers "Server\functions\serverOnPlayerConnected.sqf";
MV_Server_fnc_OnPlayerDisconnected = Compile preprocessFileLineNumbers "Server\functions\serverOnPlayerDisconnected.sqf";
MV_Server_fnc_RunGarbageCollector = Compile preprocessFileLineNumbers "Server\functions\serverRunGarbageCollector.sqf";
MV_Server_fnc_InitWorldProps = Compile preprocessFileLineNumbers "Server\functions\serverInitWorldProps.sqf";

//MV_Server_fnc_ = Compile preprocessFileLineNumbers "Server\functions\";