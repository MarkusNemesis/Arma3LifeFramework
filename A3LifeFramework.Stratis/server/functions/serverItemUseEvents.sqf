/* serverItemUseEvents script
Created: 22/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Handles all client > server item use events. ie, 'repair', 'lockpick', etc.
If the item isn't found, or specifics aren't met, then the server will send a message back to the client to show an error/box/text/etc.
Params: playerObj, itemName, actionStr, actionArgsArray
Return: 
*/
private ['_pObj', '_iName', '_action', '_aArgs', '_itemArray', '_pInventory'];
_pObj = _this select 0;
_iName = _this select 1;
_action = _this select 2;
_aArgs = _this select 3;
// -- Get player's inventory.

diag_log format ["MV: serverItemUseEvents: pObj: %1, iName: %2, action: %3, args: %4", _pObj, _iName, _action, _aArgs];

_pInventory = [getPlayerUID _pObj, "Inventory"] call MV_Server_fnc_GetMissionVariable;

// -- Check if user has said object in inventory
_itemArray = [_iName, _pInventory] call MV_Shared_fnc_SearchInventory;
// -- If not found in inventory
if (count _itemArray == 0) exitwith {[_pObj, "UseItemReturn", [false , 'i', _iName]] call MV_Server_fnc_SendClientMessage;};
diag_log "Has item";
switch (_action) do
{
	// -- Do repair on vehicle.
	case "RKRep":
	{
		diag_log "Doing action RKRep";
		private ['_rVeh', '_iInfo', '_rCoverage', '_rLvl', '_rParts'];
		_rVeh = objectFromNetId (_aArgs select 0);
		
		// -- Check if vehicle being repaired is in range of user.
		if ((_pobj distance _rVeh) > INT_RANGE) exitwith {diag_log "Out of range";}; // ERROR: vehicle out of range.
		
		if (!local _rVeh) exitwith {
			// -- Repair needs locality, so thus, off to the client it goes. 
			["UseItemEvent", [netID player, _iName, _action, _aArgs]] call MV_Client_fnc_SendServerMessage;
		}; // ELSE the server does it here and now.
		
		// -- Get item info to get repair arguments.
		_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
		// -- Apply repair to vehicle. Repairs 'hitEngine' and 'hitFuel' to half. Checks if those values are < .5, if so, left alone. Replaces all wheels.
		_rCoverage = (_iInfo select 3) select 1;
		_rLvl = 1 - _rCoverage;
		_rParts = [];
		// -- _rCoverage dictates the level of repair that the vehicle will get, per part, as well as the number of parts repaired.
		if (_rCoverage >= 0.1) then {_rParts = _rParts + ["LBWHEEL", "LFWHEEL", "RFWHEEL", "RBWHEEL"];};
		if (_rCoverage >= 0.25) then {_rParts = _rParts + ["Fuel","Engine"];};
		// -- Set vehicle to be owned by the server.
		{
			private ['_p'];
			_p = format ['Hit%1', _x];
			if ((_rVeh getHitPointDamage _p) > _rCoverage) then
			{
				_rVeh setHitPointDamage [_p, (_rLvl)];
			};
		} foreach _rParts;
	};
};