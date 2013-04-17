/* serverItemUseEvents script
Created: 22/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Handles all client > server item use events. ie, 'repair', 'lockpick', etc.
If the item isn't found, or specifics aren't met, then the server will send a message back to the client to show an error/box/text/etc.
Params: playerObj, itemName, actionStr, actionArgsArray
Return: 
*/
private ['_lObj', '_pObj', '_iName', '_action', '_aArgs', '_itemArray', '_pInventory', '_intRange'];
_lObj = (call M_S_fnc_GLV);
_pObj = _this select 0;
_iName = _this select 1;
_action = _this select 2;
_aArgs = _this select 3;
_intRange = (_lObj getVariable "INT_RANGE");
diag_log format ["MV: serverItemUseEvents: pObj: %1, iName: %2, action: %3, args: %4", _pObj, _iName, _action, _aArgs];

// -- Get player's inventory.
_pInventory = [netid _pObj, "Inventory"] call MV_Server_fnc_GetMissionVariable;

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
		private ['_rVeh', '_iInfo'];
		_rVeh = objectFromNetId (_aArgs select 0);
		
		// -- Check if vehicle being repaired is in range of user.
		if ((_pobj distance _rVeh) > _intRange) exitwith {diag_log "Out of range";}; // ERROR: vehicle out of range.
		
		if (!local _rVeh) exitwith {
			// -- Repair needs locality, so thus, off to the owning client it goes. 
			[_rVeh, "UseItemEvent", [_iName, _action, _aArgs]] call MV_Server_fnc_SendClientMessage;
		}; // ELSE the server does it here and now.
		
		// -- Get item info to get repair arguments.
		_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
		// -- Call the repair function.
		[(_iInfo select 3) select 1, _rVeh] call MV_Shared_fnc_ItemRepairVehicle;
	};
	
	case "DeployNet":
	{
		diag_log "Deploying net";
		private ['_veh', '_iInfo', '_isDeployed'];
		_veh = objectFromNetId (_aArgs select 0);
		// -- Is the player in a boat
		if (_pObj != driver _veh) exitwith {diag_log "Player not in boat"};
		// -- Is the boat already using a net.
		_isDeployed = [netid _veh, "NetDeployed"] call MV_Server_fnc_GetMissionVariable;//_veh getVariable 'NetDeployed';
		if (isnil '_isDeployed') then {_isDeployed = false} else 
		{
			if ((typeName _isDeployed) != "ARRAY") exitwith {_isDeployed = false};
			_isDeployed = _isDeployed select 0
		};
		if (_isDeployed) exitwith {};
		// -- Get item info
		_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
		// -- Set the boat's variables to contain that it's deployed and the net's name.
		_veh setVariable ['NetDeployed', [true, _iName, []], true];
		[_aArgs select 0, ['NetDeployed', [true, _iName, []]]] call MV_Server_fnc_SetMissionVariable;
		// -- Return to the player that the item use was successful.
		[_pObj, "UseItemEvent", [_iName, "DNet", _aArgs]] call MV_Server_fnc_SendClientMessage;
		// -- Add the item use event to the server mainloop event array.
		['MV_Server_fnc_IEvent_Fishing', [netID _pObj, netID _veh, getPosASL _pObj, getPosASL _pObj], time + 10] call MV_Server_fnc_AddEvent;
	};
	
	case "RecallNet":
	{
		private ['_veh', '_isDeployed'];
		_veh = objectFromNetId (_aArgs select 0);
		_isDeployed = [netid _veh, "NetDeployed"] call MV_Server_fnc_GetMissionVariable;
		if (isnil '_isDeployed') then {_isDeployed = false} else 
		{
			if ((typeName _isDeployed) != "ARRAY") exitwith {_isDeployed = false};
			_isDeployed = _isDeployed select 0
		};
		if (_isDeployed) exitwith {
			diag_log 'Recalling net.';
			[_veh, _pObj, 'r'] call MV_Server_fnc_IEvent_FishingRecallNet;
		};
	};
	
	case "restrain":
	{
		private ['_tgt', '_isStunned'];
		_tgt = objectFromNetId (_aArgs select 0);
		_isStunned = ([netid _tgt, "isStunned"] call MV_Server_fnc_GetMissionVariable) select 0;
		// -- Validate
		if (!isplayer _tgt) exitwith {}; // -- Not a player. TODO chat error out.
		if (!alive _tgt) exitwith {}; // -- Target is not alive. You can't restrain the dead.... TODO chat error out.
		if (!_isStunned) exitwith {}; // -- Target is not stunned or not consenting to restraint you can't restrain someone who is fidgetting like this! TODO chat error out. add support for consentual restraining. Must use unique object variable, as to not allow exploits.
		if ((_pObj distance _tgt) > _intRange) exitwith {}; // -- Restrainee is too far away. TODO chat error out.
		
		// -- Validation passed. Set the restrainee as restrained.
		[netid _tgt, ['isRestrained', [true, [side _pObj, netid _pObj]]]] call MV_Server_fnc_SetMissionVariable;
		_tgt setVariable ['isRestrained', [true, [side _pObj, netid _pObj]], true];
		
		// -- Remove item.
		[_pObj, _iName, 1] call MV_Server_fnc_RemoveInventoryItem;
		
		// -- Send _tgt a client UseItemEvent message. 'beRestrained'
		[_tgt, "UseItemEvent", [_iName, 'beRestrained', []]] call MV_Server_fnc_SendClientMessage;
		
		// -- send restrainer a client useItemEvent message 'hasRestrained'
		[_pObj, "UseItemEvent", [_iName, 'hasRestrained', [true, netid _tgt]]] call MV_Server_fnc_SendClientMessage;
	};
	
// -- Leave last
};