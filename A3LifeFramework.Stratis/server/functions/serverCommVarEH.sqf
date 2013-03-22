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
		[_pObj, _iName, _qty] call MV_Server_fnc_ValidateItemUse;
	};
	
	case "RemoveItem":
	{
		private ['_pObj', '_iName', '_qty'];
		_pObj = objectFromNetId (_vParams select 0);
		_iName = _vParams select 1;
		_qty = _vParams select 2;
		[_pObj, _iName, _qty] call MV_Server_fnc_RemoveInventoryItem;
	};
	
	/* -- Called when an item is wanting to do an action, ie, 'repair' or 'stun' etc. Validates item ownership before execution.
	case "UseItemEvent":
	{
		private ['_pObj', '_iName', '_action', '_aArgs'];
		_pObj = objectFromNetId (_vParams select 0);
		_iName = _vParams select 1;
		_action = _vParams select 2;
		_aArgs = _vParams select 3; // -- args like 'qty' etc. and Anything item specific.
		diag_log format ["MV: serverCommVarEH: UseItemEvent: pobj: %1, iName: %2, action: %3, aArgs: %4", _pObj, _iName, _action, _aArgs];
		[_pObj, _iName, _action, _aArgs] call MV_Server_fnc_ItemUseEvents;
	};
	*/
};
