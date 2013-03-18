/* serverGetPlayerFunds.sqf script
Created: 14/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Gets the player's on-hand money.
Params: [pObj]
Return: Player's on-hand money
*/

private ['_pMoney'];
_pMoney = 0;
_pMoney = [getPlayerUID (_this select 0), "Money"] call MV_Server_fnc_GetMissionVariable select 0; //(_this select 0) getVariable "MoneyServer";

// Return
_pMoney