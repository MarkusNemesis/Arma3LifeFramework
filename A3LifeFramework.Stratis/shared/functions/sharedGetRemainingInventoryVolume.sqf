/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

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