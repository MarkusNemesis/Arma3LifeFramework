/* serverItemUseEvents script
Created: 22/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Handles all client > server item use events. ie, 'repair', 'lockpick', etc.
If the item isn't found, or specifics aren't met, then the server will send a message back to the client to show an error/box/text/etc.
Params: playerObj, itemName, actionStr, actionArgsArray
Return: 
*/
private ['_pObj', '_iName', '_action', '_aArgs', '_itemArray', '_pInventory', '_intRange'];
_pObj = _this select 0;
_iName = _this select 1;
_action = _this select 2;
_aArgs = _this select 3;
_intRange = (missionNamespace getVariable "INT_RANGE");
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
		private ['_rVeh', '_iInfo'];
		_rVeh = objectFromNetId (_aArgs select 0);
		
		// -- Check if vehicle being repaired is in range of user.
		if ((_pobj distance _rVeh) > _intRange) exitwith {diag_log "Out of range";}; // ERROR: vehicle out of range.
		
		if (!local _rVeh) exitwith {
			// -- Repair needs locality, so thus, off to the owning client it goes. 
			["UseItemEvent", [_rVeh, _iName, _action, _aArgs]] call MV_Server_fnc_SendClientMessage;
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
		if (_pObj != driver _veh) exitwith {diag_log "Player not in boat"}; // TODO error out, not in boat.
		// -- Is the boat already using a net.
		_isDeployed = _veh getVariable 'NetDeployed';
		if (isnil '_isDeployed') then {_isDeployed = false};
		if (_isDeployed) exitwith {diag_log 'Boat already has a net, doofus!'}; // TODO error out, already a net.
		// -- Get item info
		_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
		// -- Set the boat's variables to contain that it's deployed and the net's name.
		_veh setVariable ['NetDeployed', [true, _iName, 0, []], true];
		[_aArgs select 0, ['NetDeployed', [true, _iName, 0 []]]] call MV_Server_fnc_SetMissionVariable;
		// -- Return to the player that the item use was successful.
		["UseItemEvent", [_pObj, _iName, "DNet", _aArgs]] call MV_Server_fnc_SendClientMessage;
		// -- Add the item use event to the server mainloop event array.
		['MV_Server_fnc_IEvent_Fishing', [netID _pObj, netID _veh, _pObj getPosASL, _pObj getPosASL]] call MV_Server_fnc_AddEvent;
	};
};