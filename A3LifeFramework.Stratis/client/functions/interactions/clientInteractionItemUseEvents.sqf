/* clientInteractionItemUseEvents script
Created: 22/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Handles all client > server item use events. ie, 'repair', 'lockpick', etc.
If the item isn't found, or specifics aren't met, then the server will send a message back to the client to show an error/box/text/etc.
Params: playerObj, itemName, actionStr, actionArgsArray
Return: 
*/
diag_log format ["MV: clientInteractionItemUseEvents: %1", _this];
private ['_iName', '_action', '_aArgs', '_itemArray', '_pInventory'];
_iName = _this select 0;
_action = _this select 1;
_aArgs = _this select 2;

switch (_action) do
{
	// -- Do repair on vehicle.
	case "RKRep":
	{
		private ['_iInfo', '_rVeh'];
		_rVeh = objectFromNetId (_aArgs select 1);
		// -- Get item info to get repair arguments.
		_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
		// -- Call the repair function.
		[(_iInfo select 3) select 1, _rVeh] call MV_Shared_fnc_ItemRepairVehicle;
	};
	
	case "DNet":
	{
		private ['_iInfo'];
		_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
		systemChat format ["You successfully deployed the net. Be sure to stay just below %1 KM/h and at a depth greater than %2, or you'll be forced to recall your net.", 18, (_iInfo select 3) select 0];
		// -- TODO add 'fish finder', water depth gauge and net capacity bar/metre.
	};
	
	case "DNetCyc":
	{
		// -- Runs when a net completes a 5 second serverside event cycle. Either notifies the player of it's ship's inventory status, or that they've gone too fast / ran aground / etc and the net has been recalled.
		private ['_valid'];
		_valid = _aArgs select 0;
		if (_valid) then
		{
			private ['_cCatch', '_iName', '_iInfo'];
			_cCatch = _aArgs select 1;
			_iName = ((vehicle player) getVariable 'NetDeployed') select 1;
			_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
			systemChat format ['Your net catches %1 cc of fish. The net has %2 cc remaining to be filled.', _cCatch, ((_iInfo select 3) select 2) - _cCatch];// -- TODO Localize
		}
		else
		{
			// -- Not valid, so error out.
			private ['_eType', '_eString'];
			_eType = _aArgs select 1;
			_eString = '';
			switch (_eType) do
			{
				case 'ofl':
				{
					_eString = "You recall your net as it is full."; // -- TODO Localize
				};
				
				case 'tf':
				{
					_eString = "You recall your net because you were going too fast.";// -- TODO Localize
				};
				
				case 'shl':
				{
					_eString = "You recall your net because you were going into too shallow waters.";// -- TODO Localize
				};
				
				case 'nd':
				{
					_eString = "You recall your net because you are no longer at the helm.";// -- TODO Localize
				};
				
				case 'r':
				{
					private ['_cVol'];
					_cVol = _aArgs select 2;
					_eString = format ["You recall your net and empty it's contents into your boat's inventory. Netting in a total of %1 cc of fish.", _cVol]; // -- TODO Localize
				};
				
				case 'f':
				{
					_eString = "You recall your net and empty it's contents into your boat's inventory. Your boat's inventory is too full to hold what's been caught, so the remaining are released back into the ocean."; // -- TODO Localize
				};
			};
			systemchat _eString;// -- TODO Localize
		};
	};
};
