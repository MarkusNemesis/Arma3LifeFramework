/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

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
diag_log format ['MV: serverItemEventFishingRecallNet: %1', _this];

private ['_fBoat', '_pobj', '_rReason', '_fBoatVol', '_fBoatInv', '_fBoatVolMax', '_fBoatRemVol', '_nArr', '_nInv', '_cVol'];
_fBoat = _this select 0;
_pobj = _this select 1;
_rReason = _this select 2;
_cVol = 0;

// ---- Empty net's inventory to boat's inventory.
// -- Get boat's max volume and current volume.
_fBoatInv = [netID _fBoat, "Inventory"] call MV_Server_fnc_GetMissionVariable; 
_fBoatVol = [_fBoatInv] call MV_Shared_fnc_GetCurrentInventoryVolume;
_fBoatVolMax = ([typeof _fBoat] call MV_Shared_fnc_GetVehicleArrayInfo) select 4;
_fBoatRemVol = _fBoatVolMax - _fBoatVol;
// -- Get the net's inventory.
_nArr = [netID _fBoat, "NetDeployed"] call MV_Server_fnc_GetMissionVariable;
_nInv = (_nArr) select 2;
{
	private ['_fishType', '_fishVol', '_qty', '_tvol'];
	_fishType = _x select 0;
	_fishVol = _x select 1;
	_tvol = 0;
	_qty = 0;
	if (_fBoatRemVol < _fishVol) exitwith 
	{// -- Boat's inventory doesn't have enough room for all of this fish.
		_qty =  floor (_fBoatRemVol / 100);
		if (_qty > 0) then 
		{
			[_fBoat, _fishType, _qty] call MV_Server_fnc_AddInventoryItem;
			_cVol = _cVol + (_qty * 100);
			_rReason = 'f';
		};
	};
	// -- else carry on.
	_qty = floor (_fishVol / 100);
	[_fBoat, _fishType, _qty] call MV_Server_fnc_AddInventoryItem;
	_fBoatRemVol = _fBoatRemVol - (_qty * 100);
	_cVol = _cVol + (_qty * 100);
} foreach _nInv;

// -- Recall the net
_fBoat setVariable ['NetDeployed', [false], true];
[netID _fBoat, ['NetDeployed', [false]]] call MV_Server_fnc_SetMissionVariable;

// -- Message the client.
switch (_rReason) do
{	
	// -- Recall
	case 'r':
	{
		[_pobj, "UseItemEvent", [_nArr select 1, 'DNetCyc', [false, 'r', _cVol]]] call MV_Server_fnc_SendClientMessage;
	};
	// -- Full
	case 'f':
	{
		[_pobj, "UseItemEvent", [_nArr select 1, 'DNetCyc', [false, 'f', _cVol]]] call MV_Server_fnc_SendClientMessage;
	};
	default 
	{
		// -- send error to player that they've left their position as driver of the boat or gone too fast, or too shallow or that the net is full and that the net has been recalled.
		[_pobj, "UseItemEvent", [_nArr select 1, 'DNetCyc', [false, _rReason]]] call MV_Server_fnc_SendClientMessage;
	};
};
