/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

sharedGetRemainingInventoryVolume script
Created: 16/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Gets the remaining volume of an inventory.
MV_Shared_fnc_GetRemainingInventoryVolume
Params: [Object]
Return: [remainingVolume]
*/

private ['_obj', '_objInv', '_remVol'];
_obj = _this select 0;
if ((count _this) > 1) then 
{
	_objInv = _this select 1;
} else {
	_objInv = _obj getVariable "Inventory";
};
//
_remVol = 0;
//
_remVol = _obj getVariable "storageVolume";
_remVol = _remVol - ([_objInv] call MV_Shared_fnc_GetCurrentInventoryVolume);

// -- Leave last.
_remVol