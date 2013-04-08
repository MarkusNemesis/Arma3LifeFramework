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

// -- Get/Set Server variables
MV_Server_fnc_SetMissionVariable = Compile preprocessFileLineNumbers "Server\functions\missionVariables\serverSetMissionVariable.sqf";
MV_Server_fnc_GetMissionVariable = Compile preprocessFileLineNumbers "Server\functions\missionVariables\serverGetMissionVariable.sqf";

MV_Server_fnc_OnPlayerConnected = Compile preprocessFileLineNumbers "Server\functions\serverOnPlayerConnected.sqf";
MV_Server_fnc_OnPlayerDisconnected = Compile preprocessFileLineNumbers "Server\functions\serverOnPlayerDisconnected.sqf";
MV_Server_fnc_InitWorldProps = Compile preprocessFileLineNumbers "Server\functions\init\serverInitWorldProps.sqf";
MV_Server_fnc_CommVarEH = Compile preprocessFileLineNumbers "Server\functions\serverCommVarEH.sqf";
MV_Server_fnc_BuyVehicle = Compile preprocessFileLineNumbers "Server\functions\serverBuyVehicle.sqf";
MV_Server_fnc_AddEvent = Compile preprocessFileLineNumbers "Server\functions\serverAddEvent.sqf";
MV_Server_fnc_RemoveEvent = Compile preprocessFileLineNumbers "Server\functions\serverRemoveEvent.sqf";
MV_Server_fnc_GetPlayerFunds = Compile preprocessFileLineNumbers "Server\functions\serverGetPlayerFunds.sqf";
MV_Server_fnc_SetPlayerFunds = Compile preprocessFileLineNumbers "Server\functions\serverSetPlayerFunds.sqf";
MV_Server_fnc_AddPlayerFunds = Compile preprocessFileLineNumbers "Server\functions\serverAddPlayerFunds.sqf";
MV_Server_fnc_AdjustStoreStock = Compile preprocessFileLineNumbers "Server\functions\serverAdjustStoreStock.sqf";
MV_Server_fnc_SendClientMessage = Compile preprocessFileLineNumbers "Server\functions\serverSendClientMessage.sqf";

// -- Item handling
MV_Server_fnc_ValidateItemUse = Compile preprocessFileLineNumbers "Server\functions\serverValidateItemUse.sqf";
MV_Server_fnc_ItemUseEvents = Compile preprocessFileLineNumbers "Server\functions\serverItemUseEvents.sqf";
MV_Server_fnc_RemoveInventoryItem = Compile preprocessFileLineNumbers "Server\functions\serverRemoveInventoryItem.sqf";
MV_Server_fnc_DropItem = Compile preprocessFileLineNumbers "Server\functions\serverDropItem.sqf";
MV_Server_fnc_TransferItem = Compile preprocessFileLineNumbers "Server\functions\serverTransferItem.sqf";
MV_Server_fnc_AddInventoryItem = Compile preprocessFileLineNumbers "Server\functions\serverAddInventoryItem.sqf";

// -- Item events
// - Fishing
MV_Server_fnc_IEvent_Fishing = Compile preprocessFileLineNumbers "Server\functions\itemEvents\serverItemEventFishing.sqf";
MV_Server_fnc_IEvent_FishingRecallNet = Compile preprocessFileLineNumbers "Server\functions\itemEvents\serverItemEventFishingRecallNet.sqf";


// -- ATM interaction
MV_Server_fnc_ATMAction = Compile preprocessFileLineNumbers "Server\functions\serverATMAction.sqf";

// -- Item store interaction
MV_Server_fnc_ItemStoreAction = Compile preprocessFileLineNumbers "Server\functions\serverItemStoreAction.sqf";


//MV_Server_fnc_ = Compile preprocessFileLineNumbers "Server\functions\";