/* clientInteractionBuyVehicle script
Created: 14/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: This function checks whether the player can actually purchase this vehicle, before sending the request to the server event queue.
Sends to the server via publicVariableServer.
Params: keeperNetID, vehicleIndex, vehiclePrice 
Return: 
*/

private ['_sObj', '_vIndex', '_vPrice', '_vStock', '_pMoney'];
_sObj = objectFromNetId (_this select 0);
_vIndex = _this select 1;
_vPrice = _this select 2;
_vStock = _this select 3;
_pMoney = player getVariable "Money";

// TODO move string info to string table and localise
if (_vStock <= 0) then {["Information", "You do not have enough money to buy this item"] spawn MV_Client_fnc_int_MessageBox;}; // Error out to the user, saying that there's no stock remaining for that item. TODO create UI message box dialog.

if (_pMoney > _vPrice) then
{
    // -- User can afford this item. 
    
};