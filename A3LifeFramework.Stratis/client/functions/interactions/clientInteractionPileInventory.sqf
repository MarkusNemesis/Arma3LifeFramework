/* clientInteractionPileInventory script
Created: 24/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Runs the ui_inventoryPileInteract dialog and it's controls.
*/
disableSerialization;

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

while {!isnull (findDisplay 1411)} do
{
	if (_fNo < diag_frameno) then // -- Run once per frame.
	{
		if (uiNamespace getVariable "inventoryPile_cmdToPile") then
		{
			uiNamespace setVariable ['inventoryPile_cmdToPile', false];
			private ['_tqty', '_iName', '_qty', '_lbxInvCurSel', '_hasItem', '_tvol'];
			_lbxInvCurSel = lbCurSel 2009;
			_iName = ((_iArray select _lbxInvCurSel) select 0);
			_qty = ((_iArray select _lbxInvCurSel) select 1);
			// -- User wants to move an inventory item selection to the pile. Validate Qty
			_tqty = parseNumber (ctrlText 2015);
			if ((_tqty <= 0) or (_qty < _tqty)) exitwith {["Error", format [localize "STR_MV_INT_ERRORDROPINVALIDQTY", _qty, _iName]] spawn MV_Client_fnc_int_MessageBox;
			// -- Validate item is in user inventory
			_hasItem = [_iArray, _iName, _qty] call MV_Shared_fnc_InventoryHasItem;
			if (!_hasItem) exitwith {["ERROR", format [localize "STR_MV_INT_ERRORDROPNOITEM", _iName, _qty]] spawn MV_Client_fnc_int_MessageBox;};
			// -- Has the pile got enough room for this many of this item.
			_tvol = (([_iName] call MV_Shared_fnc_GetItemInformation) select 1) * _tqty;
			if (((MV_Shared_PILEVOLUME - _pileInvVol) - _tvol) < 0) exitwith {["Error", format [localize "STR_MV_INT_ERRORPILENOVOL", _qty, _iName]] spawn MV_Client_fnc_int_MessageBox;};
			
			// -- User has the item, has the qty required and the pile has enough room to recieve the transfer. Send message to server "TransferItem"
			["TransferItem", [netID player ,_iName, _qty, netID _pileObj]] call MV_Client_fnc_SendServerMessage;
		};
		
		// -- Leave last
		_fNo = diag_frameno;
	};
	
};