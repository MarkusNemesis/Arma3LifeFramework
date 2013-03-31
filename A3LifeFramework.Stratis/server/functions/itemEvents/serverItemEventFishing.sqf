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

The cut-off speed for nets is > 10 KPH

This event validates the player and the boat,
Calculates the player's distance travelled since last cycle. which calculates the player's speed. Validates speed, calculates speed multiplier.
Gets current grid fish multiplier, calculates overall catch multiplier.
All fish items are the same volume (as they're not singular fish, they're small piles/groups), so thus the 50 * depth cc cycle catch volume is divided across the fish types randomly.
	ie _vol = (50 * depth); Type1 = random _vol; _vol = _vol - Type1; Type2 = random _vol; etc etc. NOTE: may cause diminishing returns and poorly balance the system.... Be sure to floor the numbers given.
Adds the cycle's catch to the net's inventory, update's the net's current volume use.
Checks if net is full, rounds off the cycles catch so it fills the vehicle's inventory exactly, then puts the net's content into the vehicle's inventory. Notifies player.
also updates the boat's net entry. Format: _veh setVariable 'NetDeployed' [isDeployed, netName, netCurVolume, [[FishType, Qty], [Anotherfish, qty]]]

This event adds its self back to the event array with a trigger time of time + 5, if it passes validation.
Params: ['_pObj', '_fBoat', '_prevPos', '_cPos']
*/

private ['_pObj', '_fBoat', '_prevPos', '_cPos', '_iInfo', '_bSpeed', '_depth', '_mDepth', '_isValid'];
_pObj = objectFromNetId (_this select 0);
_fBoat = objectFromNetId (_this select 1);
_prevPos = _this select 2;
_cPos = getPosASL _fBoat;
_bSpeed = 0;
_depth = 0;
_mDepth = 0;
_isValid = [true];

// -- Validate if player is driver of the boat.
if (_pObj != driver _fBoat) then {
	diag_log "Player is not driver, recalling net.";
	_isValid = [false, 'notDriver'];
}; 

// -- Check user's speed
_cPos = _fboat getPosATL;
_bSpeed = (_prevPos distance _cPos) / 5;
if (_bSpeed > 10) then {diag_log "User went too fast."; _isValid = [false, 'tooFast'];};

// -- Get item data
_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
_mDepth = (_iInfo select 3) select 0;

// -- If the max depth the net can go is GREATER than the current depth, then the net will strike the seabed. So thus, recalling the net.
if (_mDepth > _depth) then {diag_log "User went too shallow."; _isValid = [false, 'shallow'];};

if (!(_isValid select 0)) exitwith 
{
	// -- TODO recall net, empty net's inventory into vehicle inventory, round down if it doesn't fit, etc.
	// TODO send error to player that they've left their position as driver of the boat or gone too fast, or too shallow and that the net has been recalled.
};

// -- Passed validation. Now to calculate yield of fish in this cycle.
// -- TODO, calculate fish in this cycle.

// -- Leave last
['MV_Server_fnc_IEvent_Fishing', [netID _pObj, netID _fBoat, _prevPos, _cPos], time + 5] call MV_Server_fnc_AddEvent;