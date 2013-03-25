/* clientInitFunctions script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: declares and compiles all the client specific functions.
Return:
*/

// General
MV_Client_fnc_AddEvent = Compile preprocessFileLineNumbers "client\functions\clientAddEvent.sqf";
MV_Client_fnc_RemoveEvent = Compile preprocessFileLineNumbers "client\functions\clientRemoveEvent.sqf";
MV_Client_fnc_SpawnPlayer = Compile preprocessFileLineNumbers "client\functions\clientSpawnPlayer.sqf";
MV_Client_fnc_AddGarbage = Compile preprocessFileLineNumbers "client\functions\clientAddGarbage.sqf";
MV_Client_fnc_AddDeathObject = Compile preprocessFileLineNumbers "client\functions\clientAddDeathObject.sqf";
MV_Client_fnc_KillMessage = Compile preprocessFileLineNumbers "client\functions\clientKillMessage.sqf";
MV_Client_fnc_InteractableAwareness = Compile preprocessFileLineNumbers "client\functions\clientInteractableAwareness.sqf";
MV_Client_fnc_SendServerMessage = Compile preprocessFileLineNumbers "client\functions\clientSendServerMessage.sqf";


// Event Handlers
MV_Client_fnc_InitEventHandlers = Compile preprocessFileLineNumbers "client\functions\clientInitEventHandlers.sqf";
MV_Client_fnc_KilledEH = Compile preprocessFileLineNumbers "client\functions\clientKilledEH.sqf";
MV_Client_fnc_RespawnEH = Compile preprocessFileLineNumbers "client\functions\clientRespawnEH.sqf";
MV_Client_fnc_HitEH = Compile preprocessFileLineNumbers "client\functions\clientHitEH.sqf";
MV_Client_fnc_OnKeyPressEH = Compile preprocessFileLineNumbers "client\functions\clientOnKeyPressEH.sqf";
MV_Client_fnc_CommVarEH = Compile preprocessFileLineNumbers "client\functions\clientCommVarEH.sqf";
MV_Client_fnc_PublicCommVarEH = Compile preprocessFileLineNumbers "client\functions\clientPublicCommVarEH.sqf";


// MV_Client_fnc_ = Compile preprocessFileLineNumbers "client\functions\";