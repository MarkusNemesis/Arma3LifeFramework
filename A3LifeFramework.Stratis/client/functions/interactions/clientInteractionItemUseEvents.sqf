/* clientInteractionItemUseEvents script
Created: 22/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Handles all client > server item use events. ie, 'repair', 'lockpick', etc.
If the item isn't found, or specifics aren't met, then the server will send a message back to the client to show an error/box/text/etc.
Params: playerObj, itemName, actionStr, actionArgsArray
Return: 
*/
private ['_iName', '_action', '_aArgs', '_itemArray', '_pInventory'];
_iName = _this select 0;
_action = _this select 1;
_aArgs = _this select 2;

switch (_action) do
{
	// -- Do repair on vehicle.
	case "RKRep":
	{
		/*
		diag_log "Doing action RKRep";
		private ['_rVeh', '_iInfo', '_rCoverage', '_rLvl', '_rParts'];
		_rVeh = objectFromNetId (_aArgs select 1);
		// -- Get item info to get repair arguments.
		_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
		// -- Apply repair to vehicle. Repairs 'hitEngine' and 'hitFuel' to half. Checks if those values are < .5, if so, left alone. Replaces all wheels.
		_rCoverage = (_iInfo select 3) select 1;
		_rLvl = 1 - _rCoverage;
		_rParts = [];
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
		*/
		private ['_iInfo', '_rVeh'];
		_rVeh = objectFromNetId (_aArgs select 1);
		// -- Get item info to get repair arguments.
		_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
		// -- Call the repair function.
		[(_iInfo select 3) select 1, _rVeh] call MV_Shared_fnc_ItemRepairVehicle;
	};
};
