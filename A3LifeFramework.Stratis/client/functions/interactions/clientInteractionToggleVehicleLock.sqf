/* clientInteractionToggleVehicleLock script
Created: 16/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Toggles the lock of the vehicle, and outputs to the player.
*/

private ['_obj', '_lType', '_found', '_netID'];
_obj = _this select 0;
_lType = _this select 1;
if (player distance _obj > INT_RANGE) exitwith {};

_found = false;
_netID = netID _obj;
_found = _netID in (player getVariable "KeyChain");

if (_found) then
{
	if (!local _obj) exitwith {["lockRequest", [netId player, netId _obj, _lType]] call MV_Client_fnc_SendServerMessage;};
    if (locked _obj > 1) then {
    	_obj lock false;
        systemchat format ["MV: %1 Unlocked", typeof _obj]; 
    } else {
    	_obj lock true;
        systemchat format ["MV: %1 Locked", typeof _obj]; 
    };
};