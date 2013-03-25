/* clientInteractionStorageInventory script
Created: 24/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Runs the ui_inventoryStorageInteract dialog and it's controls.
*/
disableSerialization;

private ['_fNo', '_storageObj', '_iArray', '_storageInv', '_playerInvVol', '_storageInvVol', '_storageMaxVol'];
_fNo = diag_frameno;
_storageObj = _this select 0;
_iArray = player getVariable "Inventory";
_storageInv = _storageObj getVariable "Inventory";
_playerMaxVol = player getVariable "storageVolume";
_storageMaxVol = _storageObj getVariable "storageVolume";
// -- Declare vars
_playerInvVol = 0;
_storageInvVol = 0;

// -- Display Dialog
createDialog "ui_inventoryStorageInteract";

// -- Get all the player's inventory items and put them into the list.
{
	private ['_tItemVol', '_tiQty'];
	lbAdd [2009, format ["%1, Qty: %2", _x select 0, _x select 1]];
	_tItemVol = ([_x select 0] call MV_Shared_fnc_GetItemInformation) select 1;
	_tiQty = _x select 1;
	_playerInvVol = _playerInvVol + (_tItemVol * _tiQty);
} foreach _iArray;

// -- Get all the items in the storage's inventory.
{
	private ['_tItemVol', '_tiQty'];
	lbAdd [2010, format ["%1, Qty: %2", _x select 0, _x select 1]];
	_tItemVol = ([_x select 0] call MV_Shared_fnc_GetItemInformation) select 1;
	_tiQty = _x select 1;
	_storageInvVol = _storageInvVol + (_tItemVol * _tiQty);
} foreach _storageInv;


// -- Init list boxes selections.
lbSetCurSel [2009, 0];
lbSetCurSel [2010, 0];

// -- Set volume labels.
ctrlSetText [2013, format ["Volume: %1 / %2 cc [%3%4]", _playerInvVol, _playerMaxVol, (_playerInvVol / _playerMaxVol) * 100, "%"]];
ctrlSetText [2014, format ["Volume: %1 / %2 cc [%3%4]", _storageInvVol, _storageMaxVol, (_storageInvVol / _storageMaxVol) * 100, "%"]];

// -- Predefine uiNamespace variables
uiNamespace setVariable ['inventoryStorage_cmdToStorage', false];
uiNamespace setVariable ['inventoryStorage_cmdToInventory', false];
uiNamespace getVariable ["inventoryStorage_updateLists", false];
diag_log (findDisplay 1411);
while {!isnull (findDisplay 1411)} do
{
	if (_fNo < diag_frameno) then // -- Run once per frame.
	{
		if (uiNamespace getVariable "inventoryStorage_updateLists") then
		{
			uiNamespace setVariable ["inventoryStorage_updateLists", false];
			_iArray = player getVariable "Inventory";
			_storageInv = _storageObj getVariable "Inventory";
			// -- Clear the list boxes.
			lbClear 2009;
			lbClear 2010;
			_playerInvVol = 0;
			// -- Get all the player's inventory items and put them into the list.
			{
				private ['_tItemVol', '_tiQty'];
				lbAdd [2009, format ["%1, Qty: %2", _x select 0, _x select 1]];
				_tItemVol = ([_x select 0] call MV_Shared_fnc_GetItemInformation) select 1;
				_tiQty = _x select 1;
				_playerInvVol = _playerInvVol + (_tItemVol * _tiQty);
			} foreach _iArray;

			// -- Get all the items in the storage's inventory.
			_storageInvVol = 0;
			{
				private ['_tItemVol', '_tiQty'];
				lbAdd [2010, format ["%1, Qty: %2", _x select 0, _x select 1]];
				_tItemVol = ([_x select 0] call MV_Shared_fnc_GetItemInformation) select 1;
				_tiQty = _x select 1;
				_storageInvVol = _storageInvVol + (_tItemVol * _tiQty);
			} foreach _storageInv;
			
			// -- Set list box selections
			lbSetCurSel [2009, 0];
			lbSetCurSel [2010, 0];
			
			// -- Update volume labels
			ctrlSetText [2013, format ["Volume: %1 / %2 cc [%3%4]", _playerInvVol, _playerMaxVol, (_playerInvVol / _playerMaxVol) * 100, "%"]];
			ctrlSetText [2014, format ["Volume: %1 / %2 cc [%3%4]", _storageInvVol, _storageMaxVol, (_storageInvVol / _storageMaxVol) * 100, "%"]];
		};
		
		if (uiNamespace getVariable "inventoryStorage_cmdToStorage") then
		{
			uiNamespace setVariable ['inventoryStorage_cmdToStorage', false];
			private ['_tqty', '_iName', '_qty', '_lbxInvCurSel', '_hasItem', '_tvol'];
			_lbxInvCurSel = lbCurSel 2009;
			if (isnil '_lbxInvCurSel') exitwith {};
			_iName = ((_iArray select _lbxInvCurSel) select 0);
			_qty = ((_iArray select _lbxInvCurSel) select 1);
			// -- User wants to move an inventory item selection to the storage. Validate Qty
			_tqty = round parseNumber (ctrlText 2015);
			if ((_tqty <= 0) or (_qty < _tqty)) exitwith {["Error", format [localize "STR_MV_INT_ERRORDROPINVALIDQTY", _tqty, _iName]] spawn MV_Client_fnc_int_MessageBox;};
			// -- Validate item is in user inventory
			_hasItem = [_iArray, _iName, _qty] call MV_Shared_fnc_InventoryHasItem;
			if (!_hasItem) exitwith {["ERROR", format [localize "STR_MV_INT_ERRORDROPNOITEM", _iName, _qty]] spawn MV_Client_fnc_int_MessageBox;};
			// -- Has the storage got enough room for this many of this item.
			_tvol = (([_iName] call MV_Shared_fnc_GetItemInformation) select 1) * _tqty;
			if (((_storageMaxVol - _storageInvVol) - _tvol) < 0) exitwith {["Error", format [localize "STR_MV_INT_ERRORSTORAGENOVOL", _tqty, _iName]] spawn MV_Client_fnc_int_MessageBox;};
			
			// -- User has the item, has the qty required and the pile has enough room to recieve the transfer. Send message to server "TransferItem"
			["TransferItem", [netID player ,_iName, _tqty, netID _storageObj]] call MV_Client_fnc_SendServerMessage;
		};
		
		if (uiNamespace getVariable "inventoryStorage_cmdToInventory") then
		{
			uiNamespace setVariable ['inventoryStorage_cmdToInventory', false];
			private ['_tqty', '_iName', '_qty', '_lbxInvCurSel', '_hasItem', '_tvol'];
			_lbxInvCurSel = lbCurSel 2010;
			_iName = ((_storageInv select _lbxInvCurSel) select 0);
			_qty = ((_storageInv select _lbxInvCurSel) select 1);
			// -- User wants to move an inventory item selection to the pile. Validate Qty
			_tqty = round parseNumber (ctrlText 2015);
			if ((_tqty <= 0) or (_qty < _tqty)) exitwith {["Error", format [localize "STR_MV_INT_ERRORDROPINVALIDQTY", _tqty, _iName]] spawn MV_Client_fnc_int_MessageBox;};
			// -- Validate item is in user inventory
			_hasItem = [_storageInv, _iName, _qty] call MV_Shared_fnc_InventoryHasItem;
			if (!_hasItem) exitwith {["ERROR", format [localize "STR_MV_INT_ERRORDROPNOITEM", _iName, _qty]] spawn MV_Client_fnc_int_MessageBox;};
			// -- Has the pile got enough room for this many of this item.
			_tvol = (([_iName] call MV_Shared_fnc_GetItemInformation) select 1) * _tqty;
			if (((_playerMaxVol - _playerInvVol) - _tvol) < 0) exitwith {["Error", format [localize "STR_MV_INT_ERRORSTORAGENOVOL", _tqty, _iName]] spawn MV_Client_fnc_int_MessageBox;};
			
			// -- User has the item, has the qty required and the pile has enough room to recieve the transfer. Send message to server "TransferItem"
			["TransferItem", [netID _storageObj ,_iName, _tqty, netID player]] call MV_Client_fnc_SendServerMessage;
		};
		
		// -- Leave last
		_fNo = diag_frameno;
	};
	
};