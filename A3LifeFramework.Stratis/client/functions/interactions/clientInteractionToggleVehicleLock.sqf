/* clientInteractionToggleVehicleLock script
Created: 16/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Toggles the lock of the vehicle, and outputs to the player.
*/

private ['_obj', '_found', '_netID'];
_obj = _this select 0;
if (player distance _obj > 5) exitwith {};

_found = false;
_netID = netID _obj;
_found = _netID in (player getVariable "KeyChain");

if (_found) then
{
    if (locked _obj > 1) then {
    	_obj lock false;
        systemchat format ["MV: %1 Unlocked", typeof _obj]; // TODO Localise
    } else {
    	_obj lock true;
        systemchat format ["MV: %1 Locked", typeof _obj]; // TODO Localise
    };
};