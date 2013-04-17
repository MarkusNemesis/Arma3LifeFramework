/* clientInteractionToggleVehicleLock script
Created: 16/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Toggles the lock of the vehicle, and outputs to the player.
*/

private ['_obj', '_lType', '_found', '_netID', '_intRange'];
_obj = _this select 0;
_lType = _this select 1;
_intRange = ((["INT_RANGE"] call MV_Client_fnc_GetMissionVariable) select 0);
if (player distance _obj > _intRange) exitwith {};

_found = false;
_netID = netID _obj;
_found = _netID in (player getVariable "KeyChain");

if (_found) then
{
	if (!local _obj) exitwith {["lockRequest", [netId _obj, _lType]] call MV_Client_fnc_SendServerMessage;};
    if (locked _obj > 1) then {
    	_obj lock false;
        ['n', format [localize "STR_MV_INT_LOCKUNLOCKED", typeof _obj]] call MV_Client_fnc_SChatMsg;
    } else {
    	_obj lock true;
        ['n', format [localize "STR_MV_INT_LOCKLOCKED", typeof _obj]] call MV_Client_fnc_SChatMsg;
    };
};