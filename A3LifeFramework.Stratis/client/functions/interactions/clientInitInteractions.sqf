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

// MV_Client_fnc_int_ = Compile preprocessFileLineNumbers "client\functions\interactions\";