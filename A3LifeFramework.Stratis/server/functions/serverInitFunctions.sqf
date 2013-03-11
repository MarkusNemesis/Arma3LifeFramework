/* serverInitFunctions script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Precompiles functions and makes them available. There are restricted to the serverside scope.
*/

MV_Server_fnc_AddGarbage = Compile preprocessFile "server\functions\serverAddGarbage.sqf";
MV_Server_fnc_initPlayerSlots = Compile preprocessFile "Server\functions\ServerInitPlayerSlots.sqf";
MV_Server_fnc_OnPlayerConnected = Compile preprocessFile "Server\functions\serverOnPlayerConnected.sqf";
MV_Server_fnc_OnPlayerDisconnected = Compile preprocessFile "Server\functions\serverOnPlayerDisconnected.sqf";
MV_Server_fnc_RunGarbageCollector = Compile preprocessFile "Server\functions\serverRunGarbageCollector.sqf";
MV_Server_fnc_InitWorldProps = Compile preprocessFile "Server\functions\serverInitWorldProps.sqf";

//MV_Server_fnc_ = Compile preprocessFile "Server\functions\";