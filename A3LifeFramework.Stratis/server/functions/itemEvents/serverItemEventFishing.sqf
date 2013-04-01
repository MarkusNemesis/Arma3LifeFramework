/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

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

This event adds its self back to the event array with a trigger time of time + 5, if it passes validation.
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
_netVar = _fBoat getVariable 'NetDeployed';

if (!(_netVar select 0)) exitwith {}; // -- Exit gracefully, as the user has stopped fishing in one way shape or form.

// -- Constants
#define BASECATCHVOL 500 // -- cc
_fishArr = ['Blowfish', 'Whiting', 'Herring', 'Sardines', 'Atlantic Bonito', 'Anchovies', 'European Hake', 'Gilt-Headed Bream', 'European Seabass', 'Atlantic Bluefin Tuna'];
#define MAXNETSPEED 18

// -- Validate if player is driver of the boat.
if (_pObj != driver _fBoat) then {
	diag_log "Player is not driver, recalling net.";
	_isValid = [false, 'nd'];
};

// -- Check user's speed
_bSpeed = ((_prevPos distance _cPos) / 5) * 3.6; // -- Result is in ms, so * 3.6 brings it up to KM/h.
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
if (_remNetVol < BASECATCHVOL) then {_isValid = [false, 'ofl']};

if (!(_isValid select 0)) exitwith 
{
	private ['_iName'];
	_iName = _netVar select 1;
	// -- TODO recall net, empty net's inventory into vehicle inventory, round down if it doesn't fit, etc.
	// -- Actual catch qty is based upon array round (catchCC / itemVol). ie 42256cc / 1000 = 42 units of fish
	
	// -- Recall the net
	[_fBoat] call MV_Server_fnc_IEvent_FishingRecallNet;
	
	// -- send error to player that they've left their position as driver of the boat or gone too fast, or too shallow or that the net is full and that the net has been recalled.
	[_pobj, "UseItemEvent", [_iName, 'DNetCyc', _isValid]] call MV_Server_fnc_SendClientMessage;
};

// -- Passed validation. Now to calculate yield of fish in this cycle.
private ['_gridAbundance', '_speedMul', '_catchMul', '_cCatch'];
_gridAbundance = 1; // -- TODO implement actual grid abundance system.
_speedMul = (_bSpeed / MAXNETSPEED);
_catchMul = _speedMul * _gridAbundance;

// -- TODO, calculate fish in this cycle.
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
};
// -- Set the net's new inventory
_netVar set [2, _netInventory];
_fBoat setVariable ['NetDeployed', _netVar, true];
[netid _fBoat, ['NetDeployed', _netVar]] call MV_Server_fnc_SetMissionVariable;


// -- Send client message about cycle's results.
_cCatch = 0;
{_cCatch = _cCatch + (_x select 1);} foreach _netInventory;

// -- Leave last
if (_cCatch >= _netMaxVol) then 
{// -- Net is full, output it to the vehicle's inventory.
	[_fBoat] call MV_Server_fnc_IEvent_FishingRecallNet;
	[_pobj, "UseItemEvent", [_iName, 'DNetCyc', [false, 'r', (floor (_cCatch / 100)) * 100]]] call MV_Server_fnc_SendClientMessage;
} else {
	_cCatch = round (_cCatch - _netVol);
	[_pobj, "UseItemEvent", [_netVar select 1, 'DNetCyc', [true, _cCatch]]] call MV_Server_fnc_SendClientMessage;
	// -- Readd to the event array to run in 5 seconds time.
	['MV_Server_fnc_IEvent_Fishing', [netid _pObj, netID _fBoat, _cPos], time + 5] call MV_Server_fnc_AddEvent;
};