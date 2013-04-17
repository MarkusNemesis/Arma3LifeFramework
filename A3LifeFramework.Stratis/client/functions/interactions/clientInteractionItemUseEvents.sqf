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
			private ['_cCatch', '_iName', '_iInfo', '_remVol'];
			_cCatch = _aArgs select 1;
			_remVol = _aArgs select 2;
			_iName = ((vehicle player) getVariable 'NetDeployed') select 1;
			_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
			systemChat format [localize 'STR_MV_ITEM_FISHNETUSECATCHVALID', _cCatch, _remVol];
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
					_eString = localize 'STR_MV_ITEM_FISHNETOVERFLOW';
				};
				
				case 'tf':
				{
					_eString = localize 'STR_MV_ITEM_FISHNETTOOFAST';
				};
				
				case 'shl':
				{
					_eString = localize 'STR_MV_ITEM_FISHNETTOOSHALLOW';
				};
				
				case 'nd':
				{
					_eString = localize 'STR_MV_ITEM_FISHNETNOTDRIVER';
				};
				
				case 'r':
				{
					private ['_cVol'];
					_cVol = _aArgs select 2;
					_eString = format [localize 'STR_MV_ITEM_FISHNETRECALL', _cVol];
				};
				
				case 'f':
				{
					private ['_cVol'];
					_cVol = _aArgs select 2;
					_eString = format [localize 'STR_MV_ITEM_FISHNETRECALLFULLINV', _cVol];
				};
			};
			systemchat _eString;
		};
	};
	
	case "beRestrained":
	{
		// -- Switches player move to 'InBaseMoves_HandsBehindBack2', as they're now restrained. Notifies player that player name has restrained you.
		private ['_restrainer'];
		_restrainer = objectFromNetId ((player getVariable 'isRestrained') select 1) select 1;
		
		// -- Switch animation to 'InBaseMoves_HandsBehindBack2'. Which is the restrained animation.
		["AnimationEvent", [netID player, "InBaseMoves_HandsBehindBack2", 'switchMove']] call MV_Shared_fnc_SendPublicMessage;
		
		// -- Message to client that they have been restrained.
		systemChat format ["You have been restrained by %1.", name _restrainer];
	};
	
// -- Leave last
};
