/* sharedGetVehicleArrayInfo script
Created: 22/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Gets the info array entry for the vehicle class name passed as a param.
Params: ["vehicleClassname"]
Return: vehicle Info array. (See shared/arrays/vehicles)
*/

private ['_vClass', '_return'];
_vClass = _this select 0;
_return = [];
{ if ((_x select 0) == _vClass) exitwith {_return = _x;}; } foreach Array_Vehicles;

// -- Leave last
_return