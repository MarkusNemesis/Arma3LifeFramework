/* serverCommVarEH script
Created: 14/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: CommVars are semi-public variables defined by the server, where client <> server communication can take place.
Contains a switch that handles events. 
Format: ["eventType", [Params,array,etc]];
*/

private ['_vValue', '_eType', '_vParams'];
_vValue = _this select 0;
_eType = _vValue select 0;
_vParams = _vValue select 1;
diag_log format ["MV: serverCommVarEH: %1, %2, %3", _vValue, _eType, _vParams];

switch (_eType) do
{
    // -- Client is buying a vehicle
    case "BuyVehicle":
    {
        private ['_sObj', '_vIndex', '_pObj', '_vCName', '_sArr', '_vPrice', '_sPos'];
        _sObj = objectFromNetId (_vParams select 0);
        _vIndex = _vParams select 1;
        _pObj = objectFromNetId (_vParams select 2);
		_sArr = [netId _sObj, "storeArray"] call MV_Server_fnc_GetMissionVariable; // _sObj getVariable "storeArrayServer";
        _vCName = (_sArr select _vIndex) select 0;
        _vPrice = [_vCName] call MV_Shared_fnc_VehicleGetPrice;
        diag_log format ["MV: serverCommVarEH sending event: %1, %2, %3, %4", _vCName, _vPrice, _sObj, _pObj];
        ['MV_Server_fnc_BuyVehicle', [_vCName, _vPrice, _sObj, _pObj]] call MV_Server_fnc_AddEvent;
        diag_log Server_EventArray;
    };
    
    // -- Client has sent garbage for the collector.
    case "AddGarbage":
	{
		private ['_nObj'];
        [objectFromNetID (_vParams select 0)] call MV_Server_fnc_AddGarbage
	};
    
	// -- Updates a garbage item's removal delay.
    case "UpdateGarbage":
	{
		private ['_nObj'];
        [objectFromNetID (_vParams select 0)] call MV_Server_fnc_UpdateGarbageObject
	};
	
	// -- Called when a user is requesting to initiate the use of an item.
	case "UseItem":
	{
		private ['_pObj', '_iName', '_qty'];
		_pObj = objectFromNetId (_vParams select 0);
		_iName = _vParams select 1;
		_qty = _vParams select 2;
		//[_pObj, _iName, _qty] call MV_Server_fnc_ValidateItemUse;
		['MV_Server_fnc_ValidateItemUse', [_pObj, _iName, _qty]] call MV_Server_fnc_AddEvent;
	};
	
	case "DropItem":
	{
		private ['_Obj', '_iName', '_qty'];
		_Obj = objectFromNetId (_vParams select 0);
		_iName = _vParams select 1;
		_qty = _vParams select 2;
		//[_Obj, _iName, _qty] call MV_Server_fnc_DropItem;
		['MV_Server_fnc_DropItem', [_Obj, _iName, _qty]] call MV_Server_fnc_AddEvent;
	};
	
	case "TransferItem":
	{
		private ['_Obj', '_iName', '_qty', '_pileObj'];
		_Obj = objectFromNetId (_vParams select 0);
		_iName = _vParams select 1;
		_qty = _vParams select 2;
		_pileObj = objectFromNetId (_vParams select 3);
		//[_Obj, _iName, _qty, _pileObj] call MV_Server_fnc_TransferItem;
		['MV_Server_fnc_TransferItem', [_Obj, _iName, _qty, _pileObj]] call MV_Server_fnc_AddEvent;
	};
	
	case "RemoveItem":
	{
		private ['_pObj', '_iName', '_qty'];
		_pObj = objectFromNetId (_vParams select 0);
		_iName = _vParams select 1;
		_qty = _vParams select 2;
		//[_pObj, _iName, _qty] call MV_Server_fnc_RemoveInventoryItem;
		['MV_Server_fnc_RemoveInventoryItem', [_pObj, _iName, _qty]] call MV_Server_fnc_AddEvent;
	};
	
	case "lockRequest":
	{
		private ['_pObj', '_veh', '_lType']; // -- _lType is the 'locking type', be it 'remote' or 'key'. Dictates whether to check for int distance, or remote distance. TODO implement remote locking.
		_pObj = objectFromNetId (_vParams select 0);
		_veh = objectFromNetId (_vParams select 1);
		_lType = _vParams select 2;
		// -- Check if the player has this vehicle in their keychain.
		private ['_pChain', '_validDistance', '_intRange', '_remoteKeyRange'];
		_intRange = (missionNamespace getVariable "INT_RANGE");
		_remoteKeyRange = (missionNamespace getVariable "REMOTE_KEY_RANGE");
		if (_lType == 'remote') then {_validDistance = _remoteKeyRange} else {_validDistance = _intRange};
		_pChain = [getPlayerUID _pObj, "keychain"] call MV_Server_fnc_GetMissionVariable;
		if ((_vParams select 1) in _pChain) then
		{
			if (_pObj distance _veh > _validDistance) exitwith {}; // -- User is too far away from vehicle to interact with it.
			if (_lType == 'remote') then {
				// -- Remote lock code here.
			};
			if (local _veh) then { // -- Vehicle is local to the server, unlock it.
				if (locked _veh > 1) then {_veh lock false;} else {_veh lock true;};
			} else { // -- Send CommVar message to vehicle owner to unlock the vehicle.
				[_veh, "silentLock", [netID _veh]] call MV_Server_fnc_SendClientMessage;
			};
			// -- Send message to unlock request client that the vehicle is now un/locked.
			[_pObj, "lockReturn", [netID _veh]] call MV_Server_fnc_SendClientMessage;
		};
	};
	
	// -- Called when an item is wanting to do an action, ie, 'repair' or 'stun' etc. Validates item ownership before execution.
	case "UseItemEvent":
	{
		private ['_pObj', '_iName', '_action', '_aArgs'];
		_pObj = objectFromNetId (_vParams select 0);
		_iName = _vParams select 1;
		_action = _vParams select 2;
		_aArgs = _vParams select 3; // -- args like 'qty' or vehicle etc. and Anything item specific.
		diag_log format ["MV: serverCommVarEH: UseItemEvent: pobj: %1, iName: %2, action: %3, aArgs: %4", _pObj, _iName, _action, _aArgs];
		[_pObj, _iName, _action, _aArgs] call MV_Server_fnc_ItemUseEvents;
	};
	
	// -- Called when a player is wanting to either deposit or withdraw money from an ATM.
	case "atmAction":
	{
		private ['_pObj', '_qty', '_action'];
		_pObj = objectFromNetId (_vParams select 0);
		_qty = _vParams select 1;
		_action = _vParams select 2;
		// -- add to event queue, as this needs to be done in series.
		['MV_Server_fnc_ATMAction', [_pObj, _qty, _action]] call MV_Server_fnc_AddEvent;
	};
};




