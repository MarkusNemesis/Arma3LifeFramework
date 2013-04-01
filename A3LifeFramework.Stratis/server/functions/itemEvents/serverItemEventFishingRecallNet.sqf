/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

serverItemEventFishingRecallNet script
Created: 1/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: MV_Server_fnc_IEvent_FishingRecallNet
1. Puts net's inventory into boat's inventory.
	1.1. Validates if boat storage can hold that much.
	1.2. If not, Fits as much as it can in, by order of the array. Cuts off at last value (ie, 700 cc of fish, 300 cc volume left, 300cc goes in, 400 cc is 'released back'.
2. Pulls in the fishing net, sets it's deploy state false.
Params: [objBoat]
*/

private ['_fBoat', '_fBoatVol', '_fBoatInv', '_fBoatVolMax', '_fBoatRemVol', '_nInv'];
_fBoat = _this select 0;

// ---- Empty net's inventory to boat's inventory.
// -- Get boat's max volume and current volume.
_fBoatInv = [netID _fBoat, "Inventory"] call MV_Server_fnc_GetMissionVariable; 
_fBoatVol = [_fBoatInv] call MV_Shared_fnc_GetCurrentInventoryVolume;
_fBoatVolMax = ([typeof _fBoat] call MV_Shared_fnc_GetVehicleArrayInfo) select 4;
_fBoatRemVol = _fBoatVolMax - _fBoatVol;
// -- Get the net's inventory.
_nInv = ([netID _fBoat, "NetDeployed"] call MV_Server_fnc_GetMissionVariable) select 2;
{
	private ['_fishType', '_fishVol', '_qty'];
	_fishType = _x select 0;
	_fishVol = _x select 1;
	_qty = 0;
	if (_fBoatRemVol < _fishVol) exitwith 
	{// -- Boat's inventory doesn't have enough room for all of this fish.
		if ((floor (_fBoatRemVol / 100)) > 0) then {[_fBoat, _fishType, floor (_fBoatRemVol / 100)] call MV_Server_fnc_AddInventoryItem;};
		// -- TODO message to player that the boat's inventory is full, and that remaining fish in the net have been released back.
		[_pobj, "UseItemEvent", [_iName, 'DNetCyc', [false, 'f']]] call MV_Server_fnc_SendClientMessage;
	};
	// -- else carry on.
	_qty = floor (_fishVol / 100);
	[_fBoat, _fishType, _qty] call MV_Server_fnc_AddInventoryItem;
	_fBoatRemVol = _fBoatRemVol - (_qty * 100);
} foreach _nInv;

// -- Recall the net
_fBoat setVariable ['NetDeployed', [false], true];
[netID _fBoat, ['NetDeployed', [false]]] call MV_Server_fnc_SetMissionVariable;