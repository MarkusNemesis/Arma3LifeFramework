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
_iArray = [["Money", player getVariable "Money"]]; {_iArray set [count _iArray, _x]} foreach Client_tmp_Inventory; // TODO remove and replace with return value from server.
// -- Display Dialog
_bool = createDialog "ui_inventory";

// -- Get all the inventory items and put them into the list.
//lbadd [2001, format ["%1, Qty: %2", "Money", player getVariable "Money"]]; // TODO localise and get variable by request
{
	lbAdd [2001, format ["%1, Qty: %2", _x select 0, _x select 1]];
} foreach _iArray;
// -- Set listbox selection to index 0 (money)
lbSetCurSel [2001, 0];

// -- Predefine uiNamespace variables.
uiNamespace setVariable ['inventory_lbxSelChanged', true];
//
while {!isnull (findDisplay 1410)} do
{
	if (_fNo < diag_frameno) then // -- Run once per frame.
	{
		if (uiNamespace getVariable "inventory_lbxSelChanged") then
		{
			// -- Set the text inside the infobox with handy information of the selected item.
			_infoArr = [(_iArray select (lbCurSel 2001)) select 0] call MV_Shared_fnc_GetItemInformation;
			if (count _infoArr > 0) then
			{// TODO Localise these text values.
				private ['_iDesc', '_iUnits', '_estVal', '_sTxt'];
				_iDesc = parseText format ["Description:<br />%1<br />", _infoArr select 5];
				_iUnits = parseText format ["m3:<br />%1<br />",_infoArr select 1];
				_estVal = parseText format ["Approx. Value/unit:<br />%1<br />",_infoArr select 2];
				
				_sTxt = composeText [_iUnits, _estVal, _iDesc];
				((findDisplay 1410) displayctrl 2003) ctrlSetStructuredText _sTxt;
			};
			uiNamespace setVariable ['inventory_lbxSelChanged', false];
		};
		
		// -- Leave last
		_fNo = diag_frameno;
	};
};