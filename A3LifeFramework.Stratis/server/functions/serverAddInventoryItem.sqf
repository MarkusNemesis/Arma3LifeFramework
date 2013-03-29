/* serverAddInventoryItem script
Created: 24/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Adds an item + specified quantity from a user's inventory.
Params: [User, item, quantity]
Return: null
Example: [_pObj, "Money", _qty] call MV_Server_fnc_AddInventoryItem;
*/

private ['_pObj', '_iName', '_qty', '_iInv', '_id'];
_pObj = _this select 0;
_iName = _this select 1;
_qty = _this select 2;
_id = 0;
if (_qty < 1) then {_qty = 1;};
// -- Get the object's inventory.

if ([_pObj] call MV_Shared_fnc_isPlayerOnFoot) then {
	_id = getPlayerUID _pObj;
	_iInv = [getPlayerUID _pObj, "Inventory"] call MV_Server_fnc_GetMissionVariable;
} else {
	_id = netID _pObj;
	_iInv = [_id, "Inventory"] call MV_Server_fnc_GetMissionVariable;
};

// -- Find the entry in the inventory.
private ['_found'];
_found = false;
{
	if (_iName == _x select 0) exitwith { // -- Item found
		private ['_cQty'];
		_cQty = _x select 1;
		_x set [1, _cQty + _qty];
		_found = true;
	};
} foreach _iInv;

if (!_found) then // -- Item wasn't found, so add it to the array.
{
	_iInv set [count _iInv, [_iName, _qty]];
};

[_id, ["Inventory", _iInv]] call MV_Server_fnc_SetMissionVariable;
_pObj setVariable ["Inventory", _iInv, true];