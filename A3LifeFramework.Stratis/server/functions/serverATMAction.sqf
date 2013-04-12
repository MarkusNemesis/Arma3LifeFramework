/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

serverATMAction script
Created: 26/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
Params: 
Return: 
*/

private ['_pObj', '_qty', '_action', '_pbMoney', '_pwMoney', '_pNID'];
_pobj = _this select 0;
_qty = _this select 1;
_action = _this select 2;
_pNID = netid _pObj;

_pwMoney = [_pObj] call MV_Server_fnc_GetPlayerFunds;//([_pNID, "money"] call MV_Server_fnc_GetMissionVariable) select 0;
_pbMoney = ([_pNID, "bankmoney"] call MV_Server_fnc_GetMissionVariable) select 0;

switch (_action) do
{
	case "withdraw":
	{
		if (_qty < 0 || _qty > _pbMoney) exitwith {diag_log format ["MV: serverATMAction: ADMIN: Error! player %1 attempted to withdraw $%2, bypassing client validation!", name _pObj, _qty];[_pObj, "ATMActionReturn", [false, _action]] call MV_Server_fnc_SendClientMessage;};
		// -- Subtract the money from the player's bank account.
		[_pNID, ["bankmoney", [(_pbMoney - _qty)]]] call MV_Server_fnc_SetMissionVariable;
		_pObj setVariable ["bankmoney", (_pbMoney - _qty), true];
		// -- Validation passed, carry out transaction.
		[_pObj, "Money", _qty] call MV_Server_fnc_AddInventoryItem;//[_pObj, _pwMoney + _qty] call MV_Server_fnc_SetPlayerFunds;
		[_pObj, "ATMActionReturn", [true, _action, _qty]] call MV_Server_fnc_SendClientMessage;
	};
	
	case "deposit":
	{
		if (_qty < 0 || _qty > _pwMoney) exitwith {diag_log format ["MV: serverATMAction: ADMIN: Error! player %1 attempted to deposit $%2, bypassing client validation!", name _pObj, _qty];[_pObj, "ATMActionReturn", [false, _action]] call MV_Server_fnc_SendClientMessage;};
		// -- Subtract the money from the player's wallet.
		[_pObj, "Money", _qty] call MV_Server_fnc_RemoveInventoryItem;//[_pObj, _pwMoney - _qty] call MV_Server_fnc_SetPlayerFunds;
		
		// -- Validation passed, carry out transaction.
		[_pNID, ["bankmoney", [(_pbMoney + _qty)]]] call MV_Server_fnc_SetMissionVariable;
		_pObj setVariable ["bankmoney", (_pbMoney + _qty), true];
		[_pObj, "ATMActionReturn", [true, _action, _qty]] call MV_Server_fnc_SendClientMessage;
	};
	
	default {}; // -- Invalid action.
};