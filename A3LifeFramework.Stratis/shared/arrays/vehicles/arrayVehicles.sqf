/* arrayVehicles array
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Used to define vehicles as well as their cost.
Format:
["VehicleClassName", intBaseCost, canBeLocked, repairScale, vehicleVolumeCC];
repairScale dictates what 'size' repair kit can be used on this particular vehicle.
*/

// Don't forget to end each entry with a comma, EXCEPT the last entry.
private ['_Array_Vehicles'];
_Array_Vehicles = [
	["c_offroad",8000, true, 1, 750000],
	["B_Quadbike_F", 4500, true, 1, 10000],
    ["B_Hunter_F", 13000, true, 2, 500000],
    ["B_Assaultboat", 2000, true,1, 37500],
    ["C_Rubberboat", 2000, true,1, 37500]
]; // End of array

if (isServer) then 
{
	(call M_S_fnc_GLV) setVariable ["Array_Vehicles", _Array_Vehicles];
} else {
	(call M_C_fnc_GLV) setVariable ["Array_Vehicles", _Array_Vehicles];
};