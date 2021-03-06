/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

//

serverItemEventFishing script
Created: 31/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Occurs every 5 seconds that a player is fishing.
Base fishing rate is (50 * depth) cc every 5 seconds. With a 10,000 CC, 20m depth net, it's 50 seconds to fill, at best case scenario. (perfect speed, 1x abundance, etc.)
Best case scenario fishing multiplier is 1.0x, the multiplier is calulated thusly: (boatSpeed / netMaxSpeed) * gridAbundanceMul = Catch multiplier
All fish types have an equal chance of being caught, but more valuable fish exist at deeper depths. This is defined within the net's item array info as 'fish depth' (_args select 0)

The cut-off speed for nets is > 25 KPH

This event validates the player and the boat,
Calculates the player's distance travelled since last cycle. which calculates the player's speed. Validates speed, calculates speed multiplier.
Gets current grid fish multiplier, calculates overall catch multiplier.
All fish items are the same volume (as they're not singular fish, they're small piles/groups), so thus the 50 * depth cc cycle catch volume is divided across the fish types randomly.
	ie _vol = (100 * depth); Type1 = random _vol; _vol = _vol - Type1; Type2 = random _vol; etc etc. NOTE: may cause diminishing returns and poorly balance the system.... Be sure to floor the numbers given.
Adds the cycle's catch to the net's inventory, update's the net's current volume use.
Checks if net is full, rounds off the cycles catch so it fills the vehicle's inventory exactly, then puts the net's content into the vehicle's inventory. Notifies player.
also updates the boat's net entry. Format: _veh setVariable 'NetDeployed' [isDeployed, netName, netCurVolume, [[FishType, Qty], [Anotherfish, qty]]]

Capturable fish are listed in a static array in this script. This could change to be more intelligent in future. Each point in the array is symbolises 10 metres of depth.
The array starts from 0 depth.

This event adds its self back to the event array with a trigger time of time + 10, if it passes validation.
Params: ['_pObj', '_fBoat', '_prevPos', '_cPos']
*/

private ['_pObj', '_fBoat', '_fishArr', '_prevPos', '_cPos', '_netVar', '_iInfo', '_bSpeed', '_depth', '_mDepth', '_isValid'];
_pObj = objectFromNetId (_this select 0);
_fBoat = objectFromNetId (_this select 1);
_prevPos = _this select 2;
_cPos = getPosASL _fBoat;
_bSpeed = 0;
_depth = 0;
_mDepth = 0;
_isValid = [true];

// -- Get the net's array.
_netVar = [netid _fboat, "NetDeployed"] call MV_Server_fnc_GetMissionVariable;//_fBoat getVariable 'NetDeployed';
diag_log format ['MV: serverItemEventFishing: isDeployed: %1', _netVar select 0];
if (!(_netVar select 0)) exitwith {}; // -- Exit gracefully, as the user has stopped fishing in one way shape or form.

// -- Constants
#define MAXNETSPEED 18
#define CYCLETIME 10
#define BASECATCHVOL 1000 // -- cc
_fishArr = ['Blowfish', 'Whiting', 'Herring', 'Sardines', 'Atlantic Bonito', 'Anchovies', 'European Hake', 'Gilt-Headed Bream', 'European Seabass', 'Atlantic Bluefin Tuna'];


// -- Validate if player is driver of the boat.
if (_pObj != driver _fBoat) then {
	diag_log "Player is not driver, recalling net.";
	_isValid = [false, 'nd'];
};

// -- Check user's speed
_bSpeed = ((_prevPos distance _cPos) / CYCLETIME) * 3.6; // -- Result is in ms, so * 3.6 brings it up to KM/h.
if (_bSpeed > MAXNETSPEED) then {diag_log "User went too fast."; _isValid = [false, 'tf'];};

diag_log format ["Distance: %1, Speed: %2", (_prevPos distance _cPos), _bSpeed];

// -- Get item data
_iInfo = [_netVar select 1] call MV_Shared_fnc_GetItemInformation;

// -- If the max depth the net can go is GREATER than the current depth, then the net will strike the seabed. So thus, recalling the net.
_mDepth = (_iInfo select 3) select 0;
_depth = (getPosATL _pObj) select 2;
if (_mDepth > _depth) then {diag_log format ["User went too shallow. Depth: %1, netDepth: %2", _depth, _mDepth]; _isValid = [false, 'shl'];};

private ['_netVol', '_netMaxVol', '_remNetVol', '_netInventory'];
_netVol = 0;
_netMaxVol = 0;
_netInventory = [];

// -- Get the current inventory of the net
_netInventory = _netVar select 2;

// -- Calculate it's current volume.
{_netVol = _netVol + (_x select 1);} foreach _netInventory;
_netMaxVol = (_iInfo select 3) select 2;
_remNetVol = _netMaxVol - _netVol;

// -- See if this fishing cycle could possibly overflow the net.
if (_remNetVol < BASECATCHVOL) then {_isValid = [false, 'r']};

if (!(_isValid select 0)) exitwith 
{
	// -- Recall the net
	[_fBoat, _pobj, _isValid select 1] call MV_Server_fnc_IEvent_FishingRecallNet;
};

// -- Passed validation. Now to calculate yield of fish in this cycle.
private ['_gridAbundance', '_speedMul', '_catchMul', '_cCatch'];
_gridAbundance = 1; // -- TODO implement actual grid abundance system.
_speedMul = (_bSpeed / MAXNETSPEED);
_catchMul = _speedMul * _gridAbundance;
_cCatch = 0;
// -- Add the fish from this cycle to the net's array. This loop will add in order of lowest depth to highest. It will also only add up to the depth the net goes down to.
diag_log format ["_catchMul: %1 across %2 types of fish.", _catchMul, (_mDepth / 10)+ 1];
diag_log format ["_gridAbundance: %1, _speedMul: %2, _catchMul: %3", _gridAbundance, _speedMul, _catchMul];
for "_i" from 0 to (_mDepth / 10) do 
{
	private ['_x', '_cVol'];
	_x = _netInventory select _i;
	
	if (isnil '_x') then {
		private ['_fName'];
		_fName = _fishArr select _i;
		_cVol = (BASECATCHVOL * (random _catchMul));
		_netInventory set [_i, [_fName, _cVol]];
	} else {
		_cVol = _x select 1;
		_cVol = _cVol + (BASECATCHVOL * (random _catchMul));
		diag_log format ['Updating entry in net array: %1, %2', _x select 0, _cVol];
		_netInventory set [_i, [_x select 0, _cVol]];
	};
	_cCatch = _cCatch + _cVol;
};
// -- Set the net's new inventory
_netVar set [2, _netInventory];
_fBoat setVariable ['NetDeployed', _netVar, true];
[netid _fBoat, ['NetDeployed', _netVar]] call MV_Server_fnc_SetMissionVariable;

// -- Leave last
if (_cCatch >= _netMaxVol) then 
{// -- Net is full, output it to the vehicle's inventory.
	[_fBoat, _pobj, 'r'] call MV_Server_fnc_IEvent_FishingRecallNet;
} else {
	// -- Send client message about cycle's results.
	[_pobj, "UseItemEvent", [_netVar select 1, 'DNetCyc', [true, round (_cCatch - _netVol), round (_netMaxVol - _cCatch)]]] call MV_Server_fnc_SendClientMessage;
	// -- Readd to the event array to run in CYCLETIME seconds time.
	['MV_Server_fnc_IEvent_Fishing', [netid _pObj, netID _fBoat, _cPos], time + CYCLETIME] call MV_Server_fnc_AddEvent;
};