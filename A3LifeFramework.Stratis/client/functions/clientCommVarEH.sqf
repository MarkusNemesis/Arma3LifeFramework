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
			player switchMove MV_Shared_ANIMATION_BUY;
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
			if (_reason == 'q') exitwith {["Error", format [localize "STR_MV_INT_ERRORINVALIDQTY", _vParams select 3, _vParams select 2]] spawn MV_Client_fnc_int_MessageBox;};
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
			if (_reason == 'v') exitwith {["Error", format [localize "STR_MV_INT_ERRORPILENOVOL", _vParams select 3, _vParams select 2]] spawn MV_Client_fnc_int_MessageBox;};
			if (_reason == 'ni') exitwith {["Error", format [localize "STR_MV_INT_ERRORPILENOINVENTORY"]] spawn MV_Client_fnc_int_MessageBox;};
		}
		else
		{ // -- Succeeded.
			uiNamespace setVariable ["inventoryPile_updateLists", true]; // [true , _iName, _qty, netID _objA, netid _ObjB]
			private ['_iName', '_qty', '_objA', '_objB'];
			_iName = _vParams select 1;
			_qty = _vParams select 2;
			_objA = objectFromNetId (_vParams select 3);
			_objB = objectFromNetId (_vParams select 4);
			// -- If it's an item pile, output the item pile name. Else, name of player.
			if ((typeOf _objA) == MV_Shared_DROPPILECLASS) then {_objA = "Item Pile"} else {_objA = name _objA;};
			if ((typeOf _objB) == MV_Shared_DROPPILECLASS) then {_objB = "Item Pile"} else {_objB = name _objB;};
			systemChat format [localize "STR_MV_INT_SUCCESSPILETRANSFER",_qty, _iName, _objA, _objB];
		};
	};
	
	/*
	case "UseItemEvent":
	{
		private ['_iName', '_action', '_aArgs'];
		_iName = _vParams select 1;
		_action = _vParams select 2;
		_aArgs = _vParams select 3; // -- args like 'qty' etc. and Anything item specific.
		diag_log format ["MV: clientCommVarEH: UseItemEvent: iName: %1, action: %2, aArgs: %3", _iName, _action, _aArgs];
		[_iName, _action, _aArgs] call MV_Client_fnc_int_ItemUseEvents;
	};
	*/
};
