/* clientInteractionInventory script
Created: 20/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Displays and runs the inventory UI
1. Init controls
	1.1 List user's inventory into listbox
	1.2 Set default selection to index 0 IF there's anything in the inventory.
	1.3 Populate the item info box.
2. Set up eventhandlers for controls
	2.1 Done via uiNamespace variables set on the events within the dialog.hpp
*/
disableSerialization;
private ['_fNo', '_iArray', '_infoArr', '_bool'];
_fNo = diag_frameno;
_iArray = player getVariable "Inventory";
// -- Display Dialog
_bool = createDialog "ui_inventory";

{
	lbAdd [2001, format ["%1, Qty: %2", _x select 0, _x select 1]];
} foreach _iArray;
// -- Set listbox selection to index 0 (money)
lbSetCurSel [2001, 0];

// -- Predefine uiNamespace variables.
uiNamespace setVariable ['inventory_lbxSelChanged', true];
uiNamespace setVariable ['inventory_cmdUse', false];
uiNamespace setVariable ['inventory_cmdDrop', false];
//
while {!isnull (findDisplay 1410)} do
{
	if (_fNo < diag_frameno) then // -- Run once per frame.
	{
		if (uiNamespace getVariable "inventory_lbxSelChanged") then
		{
			uiNamespace setVariable ['inventory_lbxSelChanged', false];
			// -- Set the text inside the infobox with handy information of the selected item.
			_infoArr = [(_iArray select (lbCurSel 2001)) select 0] call MV_Shared_fnc_GetItemInformation;
			if (count _infoArr > 0) then
			{
				private ['_iDesc', '_iUnits', '_estVal', '_sTxt'];
				_iDesc = parseText format ["%1:<br />%2<br />", localize "STR_MV_DG_DESC",_infoArr select 5];
				_iUnits = parseText format ["%1:<br />%2<br />", localize "STR_MV_DG_VOLUME", _infoArr select 1];
				_estVal = parseText format ["%1:<br />%2<br />", localize "STR_MV_DG_APPROXVALUE", _infoArr select 2];
				
				_sTxt = composeText [_iUnits, _estVal, _iDesc];
				((findDisplay 1410) displayctrl 2003) ctrlSetStructuredText _sTxt;
			};
		};
		
		if (uiNamespace getVariable 'inventory_cmdUse') then
		{
			uiNamespace setVariable ['inventory_cmdUse', false];
			// -- If the client is already using an item. Error out.
			if (Client_UsingItem) exitwith {["Error", format [localize "STR_MV_INT_ERRORALREADYUSINGITEM", _iName]] spawn MV_Client_fnc_int_MessageBox;};
			// -- otherwise, start the 'use' validation process.
			private ['_iSel', '_iInfo', '_iName', '_qty', '_iArrayEntry'];
			// -- Get the item index
			_iSel = lbCurSel 2001;
			// -- Get item name, qty
			_iName = (_iArray select _iSel) select 0;
			_qty = round parseNumber (ctrlText 2006);
			_iArrayEntry = [_iName, _iArray] call MV_Shared_fnc_SearchInventory;
			// -- Validate qty
			if (_qty <= 0 or _qty > (_iArrayEntry select 1)) exitwith
			{
				["Error", format [localize "STR_MV_INT_ERRORINVALIDQTY", _qty, _iName]] spawn MV_Client_fnc_int_MessageBox;
			};
			closeDialog 0;
			// -- Send event to server for the use of this item
			["UseItem", [netID player ,_iName, _qty]] call MV_Client_fnc_SendServerMessage;
		};
		
		if (uiNamespace getVariable 'inventory_cmdDrop') then
		{
			uiNamespace setVariable ['inventory_cmdDrop', false];
			private ['_iSel', '_iInfo', '_iName', '_qty'];
			// -- Get the item index
			_iSel = lbCurSel 2001;
			// -- Get item name, qty
			_iName = (_iArray select _iSel) select 0;
			_qty = round parseNumber (ctrlText 2006);
			closeDialog 0;
			[_iName, _qty] call MV_Client_fnc_int_DropItem;
		};
		
		// -- Leave last
		_fNo = diag_frameno;
	};
};