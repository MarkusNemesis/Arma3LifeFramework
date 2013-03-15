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
_pMoney = player getVariable "Money";

//diag_log format ["BuyVehicle: Obj: %1, Index: %2, Price: %3, "]

// TODO move string info to string table and localise
if (_vStock <= 0) exitwith {["Information", "There is not enough of this item in stock"] spawn MV_Client_fnc_int_MessageBox;}; // Error out to the user, saying that there's no stock remaining for that item. TODO create UI message box dialog.

if (_pMoney < _vPrice) exitwith {["Information", "You do not have enough money to buy this item"] spawn MV_Client_fnc_int_MessageBox;};

// -- Item is in stock, and user has enough money, send event to server.
_eString = call compile format ["[""BuyVehicle"", [%1, %2, %3]]", str (_this select 0), _vIndex, Client_PlayerSlotStr];

call compile format ["%1_CommVar = %2;", Client_PlayerSlotStr, _eString]; // TODO make this a function?

publicVariableServer format ["%1_CommVar", Client_PlayerSlotStr];