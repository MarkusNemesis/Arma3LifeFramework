/* clientCommVarEH script
Created: 18/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Triggered when a message is sent to this client's commVar.
*/

private ['_vValue', '_eType', '_vParams'];
_vValue = _this select 0;
_eType = _vValue select 0;
_vParams = _vValue select 1;
diag_log format ["MV: clientCommVarEH: %1", _vValue];

switch (_eType) do
{
	// -- Called when the server sends a variable update. Used to sync variable changes by the server, to that respective client. SYNCS ONLY TO ONE CLIENT, NOT ALL.
	case "vU":
	{
		private ['_variable', '_args'];
		_variable = _vParams select 0;
		_args = _vParams select 1;
	};
	
    // -- Return status of the clients vehicle purchase attempt.
    case "BuyVehicleReturn":
    {
        private ['_pSuccess', '_eType'];
        _pSuccess = _vParams select 0;
        if (!_pSuccess) then {
            _eType = _vParams select 1; // -- Either 'stock' or 'funds'
            ["Server", format [localize "STR_MV_INT_ERRORBUYVEHICLE", _eType]] spawn MV_Client_fnc_int_MessageBox;
        } else {
            // -- Purchase was successful, hint to the client.
            hint localize "STR_MV_INT_VEHPURCHASESUCCESS";
            Client_VehicleBuyCooldown = time + 10; // -- Add 10 second cooldown for buying vehicles.
			player switchMove (missionNamespace getVariable "MV_Shared_ANIMATION_BUY"); // TODO make this broadcast over network. Though, tbh, it can just stay client 'fluff'.
        };
    };
	
	case "UseItemReturn":
	{
		private ['_valid'];
		_valid = (_vParams select 0);
		diag_log format ['Valid: %1', _valid];
		if (!_valid) then
		{
			private ['_reason'];
			_reason = (_vParams select 1);
			if (_reason == 'i') exitwith {["Error", format [localize "STR_MV_INT_ERRORNOITEM", _vParams select 2]] spawn MV_Client_fnc_int_MessageBox;};
			if (_reason == 'q') exitwith {["Error", format [localize "STR_MV_INT_ERRORUSEINVALIDQTY", _vParams select 3, _vParams select 2]] spawn MV_Client_fnc_int_MessageBox;};
		}
		else
		{
			private ['_item', '_qty'];
			_item = _vParams select 1;
			_qty = _vParams select 2;
			diag_log format ["%1, %2", _item, _qty];
			[_item, _qty] call MV_Client_fnc_int_UseItem;
		};
	};
	
	case "TransferItemReturn":
	{
		private ['_valid'];
		_valid = (_vParams select 0);
		diag_log format ['Valid: %1', _valid];
		if (!_valid) then
		{ // -- Transfer failed.
			if (_reason == 'q' or _reason == 'i') exitwith {["Error", format [localize "STR_MV_INT_ERRORPILENOITEM", _vParams select 3, _vParams select 2]] spawn MV_Client_fnc_int_MessageBox;};
			if (_reason == 'v') exitwith {["Error", format [localize "STR_MV_INT_ERRORSTORAGENOVOL", _vParams select 3, _vParams select 2]] spawn MV_Client_fnc_int_MessageBox;};
			if (_reason == 'ni') exitwith {["Error", format [localize "STR_MV_INT_ERRORPILENOINVENTORY"]] spawn MV_Client_fnc_int_MessageBox;};
			// -- Set cooldown, at least stops server message spam.
			Client_TransactionCooldown = time + 1;
		}
		else
		{ // -- Succeeded.
			uiNamespace setVariable ["inventoryStorage_updateLists", true]; // [true , _iName, _qty, netID _objA, netid _ObjB]
			private ['_iName', '_qty', '_objA', '_objB', '_pileCName'];
			_iName = _vParams select 1;
			_qty = _vParams select 2;
			_objA = objectFromNetId (_vParams select 3);
			_objB = objectFromNetId (_vParams select 4);
			_pileCName = (missionNamespace getVariable "MV_Shared_DROPPILECLASS");
			// -- If it's an item pile, output the item pile name. Else, name of player.
			if ((typeOf _objA) == _pileCName) then {_objA = "Item Pile"} else {_objA = name _objA;};
			if ((typeOf _objB) == _pileCName) then {_objB = "Item Pile"} else {_objB = name _objB;};
			systemChat format [localize "STR_MV_INT_SUCCESSPILETRANSFER",_qty, _iName, _objA, _objB];
			// -- Set cooldown
			Client_TransactionCooldown = time + 3;
		};
	};
	
	// -- ItemStoreActionReturn
	case "ISAR":
	{// -- ni, nsi, ms, nr, if, nv
		private ['_reason', '_isarArgs', '_iName', '_iQty', '_invObj'];
		_reason = _vParams select 0;
		_isarArgs = _vParams select 1;
		_iName = _isarArgs select 0;
		_iQty = _isarArgs select 1;
		_invObj = objectFromNetId (_isarArgs select 2);
		
		switch (_reason) do
		{
			case "ni": {["ERROR", localize "STR_MV_INT_ERRORNOSTOCK"] spawn MV_Client_fnc_int_MessageBox;};
			case "nsi": {["ERROR", localize "STR_MV_INT_ERRORNOSTOCK"] spawn MV_Client_fnc_int_MessageBox;};
			case "ms": {["ERROR", format [localize "STR_MV_INT_ERRORSTOCKMAX2", _iQty, _iName]] spawn MV_Client_fnc_int_MessageBox;};
			case "nr": {["ERROR", localize "STR_MV_INT_ERRORINVENTORYTOOFAR"] spawn MV_Client_fnc_int_MessageBox;};
			case "if": {["ERROR", localize "STR_MV_INT_ERRORNOFUNDS"] spawn MV_Client_fnc_int_MessageBox;};
			case "nv": {["ERROR", localize "STR_MV_INT_ERRORNOVOL"] spawn MV_Client_fnc_int_MessageBox;};
			case "ds": {["ERROR", localize "STR_MV_INT_ERRORDOESNOTSTOCK"] spawn MV_Client_fnc_int_MessageBox;};
			case "ss": {systemChat (format [localize "STR_MV_INT_SUCCESSSELLITEM", _iQty, _iName, _isarArgs select 3]); player switchMove MV_Shared_ANIMATION_BUY;};
			case "sb": {systemChat (format [localize "STR_MV_INT_SUCCESSBUYITEM", _iQty, _iName, _isarArgs select 3]); player switchMove MV_Shared_ANIMATION_BUY;};
		};
	};
	
	case "silentLock":
	{ // -- Called when the server wants to unlock a vehicle that is within this user's locality.
		private ['_veh'];
		_veh = objectFromNetId (_vParams select 0);
		if (locked _veh > 1) then {_veh lock false;} else {_veh lock true;};
	};
	
	case "lockReturn":
	{ // -- Called when the server wants to unlock a vehicle that is within this user's locality.
		private ['_veh'];
		_veh = objectFromNetId (_vParams select 0);
		if (locked _veh > 1) then {
			systemchat format ["MV: %1 Unlocked", typeof _veh];
		} else {
			systemchat format ["MV: %1 Locked", typeof _veh]; 
		};
	};
	
	case "UseItemEvent":
	{
		private ['_iName', '_action', '_aArgs'];
		_iName = _vParams select 0;
		_action = _vParams select 1;
		_aArgs = _vParams select 2; // -- args like 'qty' etc. and Anything item specific.
		
		[_iName, _action, _aArgs] call MV_Client_fnc_int_ItemUseEvents;
	};
	
	case "ATMActionReturn":
	{
		private ['_success', '_action', '_qty', '_sString'];
		_success = _vParams select 0;
		_action = _vParams select 1;
		if (_action == 'withdraw') then {_sString = localize 'STR_MV_INT_SUCCESSATMWITHDRAW'} else {_sString = localize 'STR_MV_INT_SUCCESSATMDEPOSIT'};
		if (_success) then {
			_qty = _vParams select 2;
			systemChat format [_sString, _qty];
			player switchMove (missionNamespace getVariable "MV_Shared_ANIMATION_BUY"); // TODO maybe put this across the network.... maybe.
		} else {
			systemChat format [localize 'STR_MV_INT_FAILATMTRANSACTION', _qty];
		};
	};
	
};
