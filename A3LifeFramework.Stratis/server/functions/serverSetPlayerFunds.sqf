/* serverSetPlayerFunds.sqf script
Created: 14/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Sets the player's on-hand money.
Params: [pObj]
*/
private ['_pObj','_sQty', '_diff', '_iInv', '_pNID'];
_pObj = _this select 0;
_sQty = _this select 1;
_pNID = netid _pObj;
//_diff = ([_pNID, "Money"] call MV_Server_fnc_GetMissionVariable) - _sQty;

(_pObj) setVariable ["Money", _sQty, true];
[_pNID, ["Money", [_sQty]]] call MV_Server_fnc_SetMissionVariable;

_iInv = [_pNID, "Inventory"] call MV_Server_fnc_GetMissionVariable;
{
	if ("Money" == _x select 0) exitwith { // -- Item found
		_x set [1, _sQty];
	};
} foreach _iInv;

[_pNID, ["Inventory", _iInv]] call MV_Server_fnc_SetMissionVariable;
_pObj setVariable ["Inventory", _iInv, true];