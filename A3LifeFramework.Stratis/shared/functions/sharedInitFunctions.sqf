/* sharedInitFunctions script
Created: 02/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Precompiles functions and makes them available. They are not restricted and can be called on both server and client.
*/

MV_Shared_fnc_initParams = Compile preprocessFileLineNumbers "shared\functions\sharedInitParams.sqf";
MV_Shared_fnc_GetPlayers = Compile preprocessFileLineNumbers "shared\functions\sharedGetPlayers.sqf";
MV_Shared_fnc_SetSuperAI = Compile preprocessFileLineNumbers "shared\functions\sharedSetSuperAI.sqf";
MV_Shared_fnc_InitUnitUniform = Compile preprocessFileLineNumbers "shared\functions\sharedInitUnitUniform.sqf";
MV_Shared_fnc_VehicleGetPrice = Compile preprocessFileLineNumbers "shared\functions\sharedVehicleGetPrice.sqf";
MV_Shared_fnc_GetItemInformation = Compile preprocessFileLineNumbers "shared\functions\sharedGetItemInformation.sqf";
MV_Shared_fnc_SearchInventory = Compile preprocessFileLineNumbers "shared\functions\sharedSearchInventory.sqf";
MV_Shared_fnc_GetVehicleArrayInfo = Compile preprocessFileLineNumbers "shared\functions\sharedGetVehicleArrayInfo.sqf";
MV_Shared_fnc_InventoryHasItem = Compile preprocessFileLineNumbers "shared\functions\sharedInventoryHasItem.sqf";
MV_Shared_fnc_GetCurrentInventoryVolume = Compile preprocessFileLineNumbers "shared\functions\sharedGetCurrentInventoryVolume.sqf";
MV_Shared_fnc_SendPublicMessage = Compile preprocessFileLineNumbers "shared\functions\sharedSendPublicMessage.sqf";
MV_Shared_fnc_isPlayerOnFoot = Compile preprocessFileLineNumbers "shared\functions\sharedisPlayerOnFoot.sqf";
MV_Shared_fnc_ItemGetPrice = Compile preprocessFileLineNumbers "shared\functions\sharedItemGetPrice.sqf";

// -- Item use functions
MV_Shared_fnc_ItemRepairVehicle = Compile preprocessFileLineNumbers "shared\functions\itemsFunctions\sharedItemRepairVehicle.sqf";

// MV_Shared_fnc_ = Compile preprocessFileLineNumbers "shared\functions\";