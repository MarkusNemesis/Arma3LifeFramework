/* clientInitInteractions script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Compiles the interaction functions
Return:
*/

MV_Client_fnc_int_Handler = Compile preprocessFileLineNumbers "client\functions\interactions\clientInteractionHandler.sqf";
MV_Client_fnc_int_VehicleStore = Compile preprocessFileLineNumbers "client\functions\interactions\clientInteractionVehicleStore.sqf";
MV_Client_fnc_int_BuyVehicle = Compile preprocessFileLineNumbers "client\functions\interactions\clientInteractionBuyVehicle.sqf";
MV_Client_fnc_int_MessageBox = Compile preprocessFileLineNumbers "client\functions\interactions\clientInteractionsMessagebox.sqf";
MV_Client_fnc_int_ToggleVehicleLock = Compile preprocessFileLineNumbers "client\functions\interactions\clientInteractionToggleVehicleLock.sqf";
MV_Client_fnc_int_HUD = Compile preprocessFileLineNumbers "client\functions\interactions\clientInteractionHUD.sqf";
MV_Client_fnc_int_InteractionInventory = Compile preprocessFileLineNumbers "client\functions\interactions\clientInteractionInventory.sqf";
MV_Client_fnc_int_InteractionUseItem = Compile preprocessFileLineNumbers "client\functions\interactions\clientInteractionUseItem.sqf";


// MV_Client_fnc_int_ = Compile preprocessFileLineNumbers "client\functions\interactions\";