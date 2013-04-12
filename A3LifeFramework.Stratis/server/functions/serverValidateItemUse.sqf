/* serverValidateItemUse script
Created: 20/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Checks with the Server_LocObj record of the user's inventory, as for whether they have the item, and the quantity required in their inventory.
Return: Sends clientMessage whether true or false "UseItemReturn"
*/

private ['_pObj', '_iName', '_qty', '_pInventory', '_itemArray'];

_pObj = _this select 0;
_iName = _this select 1;
_qty = _this select 2;
_return = false;

_pInventory = [netid _pObj, "Inventory"] call MV_Server_fnc_GetMissionVariable;
//diag_log _pInventory;
_itemArray = [_iName, _pInventory] call MV_Shared_fnc_SearchInventory;
// -- If not found in inventory
if (count _itemArray == 0) exitwith {[_pObj, "UseItemReturn", [false , 'i', _iName]] call MV_Server_fnc_SendClientMessage;};
// -- If not enough in inventory
if ((_itemArray select 1) < _qty) exitwith {[_pObj, "UseItemReturn", [false , 'q', _iName, _qty]] call MV_Server_fnc_SendClientMessage;};

// -- If it's passed everything, then it's allowed to be used.
[_pObj, "UseItemReturn", [true ,_iName, _qty]] call MV_Server_fnc_SendClientMessage;