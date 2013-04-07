/* sharedGetVehicleInventoryVolume script
Created: 07/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Gets the maximum volume of the passed classname's internal inventory.
Params: ["vehicleClassname"]
Return: vehicle's max internal inventory volume.
*/

private ['_vClass', '_return', '_vArray'];
_vClass = _this select 0;
_return = [];
_vArray = missionNamespace getVariable "Array_Vehicles";
{ if ((_x select 0) == _vClass) exitwith {_return = _x select 4;}; } foreach _vArray;

// -- Leave last
_return