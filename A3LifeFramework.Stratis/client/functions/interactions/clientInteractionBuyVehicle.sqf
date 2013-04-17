/* clientInteractionBuyVehicle script
Created: 14/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: This function checks whether the player can actually purchase this vehicle, before sending the request to the server event queue.
Sends to the server via publicVariableServer.
Params: keeperNetID, vehicleIndex, vehiclePrice 
Return: 
*/

private ['_sObj', '_vIndex', '_vPrice', '_vStock', '_pMoney', '_eString'];
_sObj = objectFromNetId (_this select 0);
_vIndex = _this select 1;
_vPrice = _this select 2;
_vStock = _this select 3;
_pMoney = (["Money", player getVariable "Inventory"] call MV_Shared_fnc_SearchInventory) select 1;//player getVariable "Money";

//diag_log format ["BuyVehicle: Obj: %1, Index: %2, Price: %3, "]

if (Client_VehicleBuyCooldown > time) exitwith {[localize "STR_MV_DG_INFORMATION", localize "STR_MV_INT_ERRORCOOLDOWN"] spawn MV_Client_fnc_int_MessageBox;};

if (_vStock <= 0) exitwith {[localize "STR_MV_DG_INFORMATION", localize "STR_MV_INT_ERRORNOSTOCK"] spawn MV_Client_fnc_int_MessageBox;}; // Error out to the user, saying that there's no stock remaining for that item.

if (_pMoney < _vPrice) exitwith {[localize "STR_MV_DG_INFORMATION", localize "STR_MV_INT_ERRORNOFUNDS"] spawn MV_Client_fnc_int_MessageBox;};

// -- Item is in stock, and user has enough money, send event to server.
["BuyVehicle", [(_this select 0), _vIndex]] call MV_Client_fnc_SendServerMessage;