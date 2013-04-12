/* serverAddInventoryItem script
Created: 24/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Adds an item + specified quantity from an object's inventory.
Params: [User, item, quantity]
Return: null
Example: [_Obj, "Item", _qty] call MV_Server_fnc_AddInventoryItem;
*/

private ['_Obj', '_iName', '_qty', '_iInv', '_id'];
_Obj = _this select 0;
_iName = _this select 1;
_qty = _this select 2;

// -- If we're adding money to a player object, then divert to MV_Server_fnc_AddPlayerFunds.
//if (_iName == "Money" && [_Obj] call MV_Shared_fnc_isPlayerOnFoot ) exitwith {[_Obj, _qty] call MV_Server_fnc_AddPlayerFunds};

_id = netID _Obj;
if (_qty < 1) then {_qty = 1;};

// -- Get the object's inventory.
_iInv = [_id, "Inventory"] call MV_Server_fnc_GetMissionVariable;

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
_Obj setVariable ["Inventory", _iInv, true];