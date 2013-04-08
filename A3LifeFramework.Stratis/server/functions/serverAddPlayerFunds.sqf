/* serverAddPlayerFunds.sqf script
Created: 09/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Adds to the player's on-hand money.
Params: [pObj, qty]

TODO add validation so that only players can have this run on them, not objects.
*/
private ['_pObj','_sQty', '_iInv', '_pNID', '_found'];
_pObj = _this select 0;
_sQty = _this select 1;
_pNID = netid _pObj;
_sQty = _sQty + ([_pNID, "Money"] call MV_Server_fnc_GetMissionVariable);

_pObj setVariable ["Money", _sQty, true];
[_pNID, ["Money", [_sQty]]] call MV_Server_fnc_SetMissionVariable;

_iInv = [_pNID, "Inventory"] call MV_Server_fnc_GetMissionVariable;
_found = false;
{
	if ("Money" == _x select 0) exitwith { // -- Item found
		_x set [1, _sQty];
		_found = true;
	};
} foreach _iInv;
if (!_found) then {_iInv set [count _iInv, ["Money", _sQty]];};

[_pNID, ["Inventory", _iInv]] call MV_Server_fnc_SetMissionVariable;
_pObj setVariable ["Inventory", _iInv, true];