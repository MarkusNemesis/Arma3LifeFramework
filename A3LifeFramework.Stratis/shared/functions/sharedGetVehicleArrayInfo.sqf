/* sharedGetVehicleArrayInfo script
Created: 22/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Gets the info array entry for the vehicle class name passed as a param.
Params: ["vehicleClassname"]
Return: vehicle Info array. (See shared/arrays/vehicles)
*/

private ['_vClass', '_return', '_vArray'];
_vClass = _this select 0;
_return = [];
_vArray = missionNamespace getVariable "Array_Vehicles";
{ if ((_x select 0) == _vClass) exitwith {_return = _x;}; } foreach _vArray;

// -- Leave last
_return