/* serverDropItem script
Created: 23/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Handles the dropping of items. Called by the serverCommVarEH, under event 'DropItem'.
1. Checks if user has the item and the qty wanting to be dropped.
2. Creates the 'pile' object.
3. Sets the pile to be interactable
4. Set the pile's inventory.
Params: [_Obj, _iName, _qty]
*/
diag_log format ["MV: serverDropItem: %1", _this];
private ['_lObj', '_Obj' ,'_iName', '_qty', '_hasItem', '_pInv'];
_lObj = (call M_S_fnc_GLV);
_Obj = _this select 0;
_iName = _this select 1;
_qty = _this select 2;

if (_qty <= 0) exitwith {diag_log format ["MV: serverDropItem: ADMIN: Object %1 attempted to drop %2 of item %3, which they do not have!", name _Obj, _qty, _iName];};

_pInv = [netId _Obj, "Inventory"] call MV_Server_fnc_GetMissionVariable;

if (!isnil "_pInv") then
{
	private ['_Pile'];
	_hasItem = [_pInv, _iName, _qty] call MV_Shared_fnc_InventoryHasItem;
	if (_hasItem) then
	{
		// -- Remove item from object's inventory.
		[_Obj, _iName, _qty] call MV_Server_fnc_RemoveInventoryItem;
		diag_log "MV: serverDropItem: Creating pile.";
		// -- Create the pile and assign it it's inventory.
		_Pile = createVehicle [(_lObj getVariable "MV_Shared_DROPPILECLASS"), getposATL _obj, [], 0, "CAN_COLLIDE"];
		// -- Set global publics
		_Pile setVariable ['isInteractable', true, true];
		_Pile setVariable ['interactType', "typePile", true];
		_Pile setVariable ['Inventory', [[_iName, _qty]], true];
		_Pile setVariable ['storageVolume', (_lObj getVariable "MV_Shared_PILEVOLUME"), true];
		
		// -- Set server _lObj variables
		private ['_pID'];
		_pID = netID _Pile;
		_lObj setVariable [format ["%1_missionVar", _pID], []];
		[_pID, ["isInteractable", [true]]] call MV_Server_fnc_SetMissionVariable;
		[_pID, ["interactType", ['typePile']]] call MV_Server_fnc_SetMissionVariable;
		[_pID, ["Inventory", [[_iName, _qty]]]] call MV_Server_fnc_SetMissionVariable;
		[_pID, ["storageVolume", [(_lObj getVariable "MV_Shared_PILEVOLUME")]]] call MV_Server_fnc_SetMissionVariable;
		
		// -- Set vehicle init.
		_Pile setvehicleinit "this allowDamage false;";
		processInitCommands;
		// -- Add to garbage collector.
		[_Pile] call MV_Server_fnc_AddGarbage;
	};

};