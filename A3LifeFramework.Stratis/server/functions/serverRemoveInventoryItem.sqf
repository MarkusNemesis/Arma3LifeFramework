/* serverRemoveInventoryItem script
Created: 22/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Removes an item + specified quantity from a user's inventory.
Params: [User, item, quantity]
Return: null
Example: [_pObj, "Money", _qty] call MV_Server_fnc_RemoveInventoryItem;
*/

private ['_pObj', '_iName', '_qty', '_iInv', '_id'];
_pObj = _this select 0;
_iName = _this select 1;
_qty = _this select 2;
_id = 0;
if (_qty < 1) then {_qty = 1;};
// -- Get the object's inventory.

if (isPlayer _pObj) then {
	_id = getPlayerUID _pObj;
	_iInv = [getPlayerUID _pObj, "Inventory"] call MV_Server_fnc_GetMissionVariable;
} else {
	_id = netID _pObj;
	_iInv = [(_this select 0), "Inventory"] call MV_Server_fnc_GetMissionVariable;
};

// -- Find the entry in the inventory.
{
	if (_iName == _x select 0) exitwith { // -- Item found
		private ['_cQty'];
		_cQty = _x select 1;
		// -- If we have more than what we're subtracting, then update the entry.
		if (_cQty > _qty) then {
			_x set [1, _cQty - _qty];
		} else { // Else remove the entry.
			if ((_cQty - _qty) < 0) then {diag_log format ["MV: serverRemoveInventoryItem: ADMIN NOTICE: Player/Object %1 just removed more of item %2 than they had.", _pObj, _iName];};
			_iInv set [_foreachindex, objnull];
			_iInv = _iInv - [objnull];
		};
	};
} foreach _iInv;

[_id, ["Inventory", _iInv]] call MV_Server_fnc_SetMissionVariable;
_pObj setVariable ["Inventory", _iInv, true];