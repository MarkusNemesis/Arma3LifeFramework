/* clientInteractionPileInventory script
Created: 24/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Runs the ui_inventoryPileInteract dialog and it's controls.
*/
disableSerialization;
// -- TODO convert this script to act is the primary item transfer script. ie, player <> vehicle, player <> player, etc. meaning, remove all PILE hardcoding.
private ['_fNo', '_pileObj', '_iArray', '_pileInv', '_playerInvVol', '_pileInvVol'];
_fNo = diag_frameno;
_pileObj = _this select 0;
_iArray = player getVariable "Inventory";
_pileInv = _pileObj getVariable "Inventory";

// -- Declare vars
_playerInvVol = 0;
_pileInvVol = 0;

// -- Display Dialog
createDialog "ui_inventoryPileInteract";

// -- Get all the player's inventory items and put them into the list.
{
	private ['_tItemVol', '_tiQty'];
	lbAdd [2009, format ["%1, Qty: %2", _x select 0, _x select 1]];
	_tItemVol = ([_x select 0] call MV_Shared_fnc_GetItemInformation) select 1;
	_tiQty = _x select 1;
	_playerInvVol = _playerInvVol + (_tItemVol * _tiQty);
} foreach _iArray;

// -- Get all the items in the pile's inventory.
{
	private ['_tItemVol', '_tiQty'];
	lbAdd [2010, format ["%1, Qty: %2", _x select 0, _x select 1]];
	_tItemVol = ([_x select 0] call MV_Shared_fnc_GetItemInformation) select 1;
	_tiQty = _x select 1;
	_pileInvVol = _pileInvVol + (_tItemVol * _tiQty);
} foreach _pileInv;


// -- Init list boxes selections.
lbSetCurSel [2009, 0];
lbSetCurSel [2010, 0];

// -- Set volume labels.
ctrlSetText [2013, format ["Volume: %1 / %2 cc [%3%4]", _playerInvVol, MV_Shared_PLAYERVOLUME, (_playerInvVol / MV_Shared_PLAYERVOLUME) * 100, "%"]];
ctrlSetText [2014, format ["Volume: %1 / %2 cc [%3%4]", _pileInvVol, MV_Shared_PILEVOLUME, (_pileInvVol / MV_Shared_PILEVOLUME) * 100, "%"]];

// -- Predefine uiNamespace variables
uiNamespace setVariable ['inventoryPile_cmdToPile', false];
uiNamespace setVariable ['inventoryPile_cmdToInventory', false];
uiNamespace getVariable ["inventoryPile_updateLists", false];
diag_log (findDisplay 1411);
while {!isnull (findDisplay 1411)} do
{
	if (_fNo < diag_frameno) then // -- Run once per frame.
	{
		if (uiNamespace getVariable "inventoryPile_updateLists") then
		{
			uiNamespace setVariable ["inventoryPile_updateLists", false];
			_iArray = player getVariable "Inventory";
			_pileInv = _pileObj getVariable "Inventory";
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

			// -- Get all the items in the pile's inventory.
			_pileInvVol = 0;
			{
				private ['_tItemVol', '_tiQty'];
				lbAdd [2010, format ["%1, Qty: %2", _x select 0, _x select 1]];
				_tItemVol = ([_x select 0] call MV_Shared_fnc_GetItemInformation) select 1;
				_tiQty = _x select 1;
				_pileInvVol = _pileInvVol + (_tItemVol * _tiQty);
			} foreach _pileInv;
			
			// -- Update volume labels
			ctrlSetText [2013, format ["Volume: %1 / %2 cc [%3%4]", _playerInvVol, MV_Shared_PLAYERVOLUME, (_playerInvVol / MV_Shared_PLAYERVOLUME) * 100, "%"]];
			ctrlSetText [2014, format ["Volume: %1 / %2 cc [%3%4]", _pileInvVol, MV_Shared_PILEVOLUME, (_pileInvVol / MV_Shared_PILEVOLUME) * 100, "%"]];
		};
		
		if (uiNamespace getVariable "inventoryPile_cmdToPile") then
		{
			uiNamespace setVariable ['inventoryPile_cmdToPile', false];
			private ['_tqty', '_iName', '_qty', '_lbxInvCurSel', '_hasItem', '_tvol'];
			_lbxInvCurSel = lbCurSel 2009;
			if (isnil '_lbxInvCurSel') exitwith {};
			_iName = ((_iArray select _lbxInvCurSel) select 0);
			_qty = ((_iArray select _lbxInvCurSel) select 1);
			// -- User wants to move an inventory item selection to the pile. Validate Qty
			_tqty = parseNumber (ctrlText 2015);
			if ((_tqty <= 0) or (_qty < _tqty)) exitwith {["Error", format [localize "STR_MV_INT_ERRORDROPINVALIDQTY", _tqty, _iName]] spawn MV_Client_fnc_int_MessageBox;};
			// -- Validate item is in user inventory
			_hasItem = [_iArray, _iName, _qty] call MV_Shared_fnc_InventoryHasItem;
			if (!_hasItem) exitwith {["ERROR", format [localize "STR_MV_INT_ERRORDROPNOITEM", _iName, _qty]] spawn MV_Client_fnc_int_MessageBox;};
			// -- Has the pile got enough room for this many of this item.
			_tvol = (([_iName] call MV_Shared_fnc_GetItemInformation) select 1) * _tqty;
			if (((MV_Shared_PILEVOLUME - _pileInvVol) - _tvol) < 0) exitwith {["Error", format [localize "STR_MV_INT_ERRORPILENOVOL", _tqty, _iName]] spawn MV_Client_fnc_int_MessageBox;};
			
			// -- User has the item, has the qty required and the pile has enough room to recieve the transfer. Send message to server "TransferItem"
			["TransferItem", [netID player ,_iName, _tqty, netID _pileObj]] call MV_Client_fnc_SendServerMessage;
		};
		
		if (uiNamespace getVariable "inventoryPile_cmdToInventory") then
		{
			uiNamespace setVariable ['inventoryPile_cmdToInventory', false];
			private ['_tqty', '_iName', '_qty', '_lbxInvCurSel', '_hasItem', '_tvol'];
			_lbxInvCurSel = lbCurSel 2010;
			_iName = ((_pileInv select _lbxInvCurSel) select 0);
			_qty = ((_pileInv select _lbxInvCurSel) select 1);
			// -- User wants to move an inventory item selection to the pile. Validate Qty
			_tqty = parseNumber (ctrlText 2015);
			if ((_tqty <= 0) or (_qty < _tqty)) exitwith {["Error", format [localize "STR_MV_INT_ERRORDROPINVALIDQTY", _tqty, _iName]] spawn MV_Client_fnc_int_MessageBox;};
			// -- Validate item is in user inventory
			_hasItem = [_pileInv, _iName, _qty] call MV_Shared_fnc_InventoryHasItem;
			if (!_hasItem) exitwith {["ERROR", format [localize "STR_MV_INT_ERRORDROPNOITEM", _iName, _qty]] spawn MV_Client_fnc_int_MessageBox;};
			// -- Has the pile got enough room for this many of this item.
			_tvol = (([_iName] call MV_Shared_fnc_GetItemInformation) select 1) * _tqty;
			if (((MV_Shared_PLAYERVOLUME - _playerInvVol) - _tvol) < 0) exitwith {["Error", format [localize "STR_MV_INT_ERRORPILENOVOL", _tqty, _iName]] spawn MV_Client_fnc_int_MessageBox;};
			
			// -- User has the item, has the qty required and the pile has enough room to recieve the transfer. Send message to server "TransferItem"
			["TransferItem", [netID _pileObj ,_iName, _tqty, netID player]] call MV_Client_fnc_SendServerMessage;
		};
		
		// -- Leave last
		_fNo = diag_frameno;
	};
	
};