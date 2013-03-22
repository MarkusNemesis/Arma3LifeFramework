/* serverSetPlayerFunds.sqf script
Created: 14/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Sets the player's on-hand money.
Params: [pObj]
*/
private ['_pObj','_sQty', '_diff', '_iInv'];
_pObj = _this select 0;
_sQty = _this select 1;
//_diff = ([getPlayerUID _pObj, "Money"] call MV_Server_fnc_GetMissionVariable) - _sQty;

(_this select 0) setVariable ["Money", _this select 1, true];
[getPlayerUID _pObj, ["Money", [_sQty]]] call MV_Server_fnc_SetMissionVariable;

_iInv = [getPlayerUID _pObj, "Inventory"] call MV_Server_fnc_GetMissionVariable;
{
	if ("Money" == _x select 0) exitwith { // -- Item found
		_x set [1, _sQty];
	};
} foreach _iInv;

[getPlayerUID _pObj, ["Inventory", _iInv]] call MV_Server_fnc_SetMissionVariable;
_pObj setVariable ["Inventory", _iInv, true];