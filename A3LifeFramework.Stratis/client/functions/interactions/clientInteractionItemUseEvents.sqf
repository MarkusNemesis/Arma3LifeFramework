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
		['s', format ["You successfully deployed the net. Be sure to stay just below %1 KM/h and at a depth greater than %2, or you'll be forced to recall your net.", 18, (_iInfo select 3) select 0]] call MV_Client_fnc_SChatMsg;
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
			['i', format [localize 'STR_MV_ITEM_FISHNETUSECATCHVALID', _cCatch, _remVol]] call MV_Client_fnc_SChatMsg;
		}
		else
		{
			// -- Not valid, so error out.
			private ['_eType', '_eString'];
			_eType = _aArgs select 1;
			_eString = [];
			switch (_eType) do
			{
				case 'ofl':
				{
					_eString = ['e', localize 'STR_MV_ITEM_FISHNETOVERFLOW'];
				};
				
				case 'tf':
				{
					_eString = ['e', localize 'STR_MV_ITEM_FISHNETTOOFAST'];
				};
				
				case 'shl':
				{
					_eString = ['e', localize 'STR_MV_ITEM_FISHNETTOOSHALLOW'];
				};
				
				case 'nd':
				{
					_eString = ['e', localize 'STR_MV_ITEM_FISHNETNOTDRIVER'];
				};
				
				case 'r':
				{
					private ['_cVol'];
					_cVol = _aArgs select 2;
					_eString = ['n' ,format [localize 'STR_MV_ITEM_FISHNETRECALL', _cVol]];
				};
				
				case 'f':
				{
					private ['_cVol'];
					_cVol = _aArgs select 2;
					_eString = ['n', format [localize 'STR_MV_ITEM_FISHNETRECALLFULLINV', _cVol]];
				};
			};
			_eString call MV_Client_fnc_SChatMsg;
		};
	};
	
	case "beRestrained":
	{
		// -- Switches player move to 'InBaseMoves_HandsBehindBack2', as they're now restrained. Notifies player that player name has restrained you.
		private ['_restrainer', '_anim'];
		_restrainer = objectFromNetId (((player getVariable 'isRestrained') select 1) select 1);
		_anim = ((["MV_Shared_ANIMATION_RESTRAINED"] call MV_Client_fnc_GetMissionVariable) select 0);
		
		// -- Switch animation to 'InBaseMoves_HandsBehindBack2'. Which is the restrained animation.
		["AnimationEvent", [netID player, _anim, 'switchMove']] call MV_Shared_fnc_SendPublicMessage;
		
		// -- Message to client that they have been restrained.
		['n', format [localize "STR_MV_ITEM_RESTRAINED", name _restrainer]] call MV_Client_fnc_SChatMsg;
	};
	
	case "hasRestrained":
	{
		// -- Switches player move to restraining animation, and notifies player of successful restraining.
		private ['_success'];
		_success = _aArgs select 0;
		if (!_success) exitwith 
		{
			private ['_reason'];
			_reason = _aArgs select 1;
			switch (_reason) do
			{
				case "td": // Target dead
				{
					['f', localize "STR_MV_ITEM_ERRORRESTRAINDEAD"] call MV_Client_fnc_SChatMsg;
				};
				case "ns": // Target not stunned
				{
					['f', localize "STR_MV_ITEM_ERRORRESTRAINNOTSTUNNED"] call MV_Client_fnc_SChatMsg;
				};
				case "tf": // Target too far away.
				{
					['f', localize "STR_MV_ITEM_ERRORRESTRAINTOOFAR"] call MV_Client_fnc_SChatMsg;
				};
			};
		};
		//
		private ['_restrainee', '_anim'];
		_restrainee = objectFromNetId (_aArgs select 1);
		_anim = ((["MV_Shared_ANIMATION_RESTRAIN"] call MV_Client_fnc_GetMissionVariable) select 0);
		
		// -- Switch animation to 'InBaseMoves_HandsBehindBack2'. Which is the restrained animation.
		["AnimationEvent", [netID player, _anim, 'switchMove']] call MV_Shared_fnc_SendPublicMessage;
		
		// -- Message to client that they have been restrained.
		['s', format [localize "STR_MV_ITEM_RESTRAIN", name _restrainee]] call MV_Client_fnc_SChatMsg;
	};
	
// -- Leave last
};
