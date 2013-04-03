/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

clientInteractionItemShop script
Created: 4/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Runs the ui_itemShop dialog. Enables players to buy and sell items (depending on the store's base item array.).
UI is defined as if in BUYMODE, so thus, doesn't need to be initted as such.

Inventory options are stored within the data of the inventories listbox.
	- The data is the netID of the inventory's parent object. This includes players.

_uiMode = What mode the UI is in, default BUYMODE, for buying items from the store.
_selObj = the object that has been selected in the inventory selection list.
_selInventory = The inventory of the selected inventory.
Params: [storeObj]
*/
#define BUYMODE false
#define SELLMODE true
#define INVRANGE 20

disableSerialization;

private ['_sObj', '_dsp', '_fNo', '_uiMode', '_uiModeChanged', '_selObj', '_selInventory'];
_sObj = _this select 0;
_dsp = findDisplay 1414;
_fNo = diag_frameno;

_uiMode = BUYMODE;

// -- Get all controls
private ['_lbxInvSelect', '_lbxInventoryStore', '_stxtInfo', '_cmdToggleMode', '_cmdBuySell', '_txtQty', '_frmItemList'];
_lbxInvSelect = 			_dsp displayCtrl 2023;
_lbxInventoryStore = 		_dsp displayCtrl 2028;
_stxtInfo =	 			_dsp displayCtrl 2027;
_cmdToggleMode =			_dsp displayCtrl 2026;
_cmdBuySell = 				_dsp displayCtrl 2025;
_txtQty =					_dsp displayCtrl 2024;
_frmItemList =			_dsp displayCtrl 2029;

// -- Init UINamespace variables.
uiNamespace setVariable ['itemShop_cmdToggleMode', false];
uiNamespace setVariable ['itemShop_lbxInvSelect_lbxSelChanged', true];
uiNamespace setVariable ['itemShop_lbxInventoryStore_lbxSelChanged', true];
uiNamespace setVariable ['itemShop_txtQtyChanged', false];
uiNamespace setVariable ['itemShop_cmdBuySell', false];

// ---- Populate the 'select inventory' listbox.
private ['_tIndex', '_pKeychain'];
_tIndex = -1;
_pKeychain = player getVariable 'Keychain';

// -- add player as topmost entry.
_tIndex = _lbxInvSelect lbadd (name player);
_lbxInvSelect lbSetData [_tIndex, netId player];

// -- Go through the player's keychain, resolve the netIDs to objects, get distances, if within INVRANGE, add to list and add to array. format: vName, Dist Xm
{
	private ['_tObj', '_tDist'];
	_tObj = objectFromNetId _x;
	_tDist = round (player distance _tObj);
	if (_tDist < INVRANGE) then 
	{
		_tIndex = _lbxInvSelect lbadd (format ['%1, Dist: %2m', _tObj getVariable 'vName'], _tDist); // todo maybe just show vehicle's classname? vname may be too long.
		_lbxInvSelect lbSetData [_tIndex, _x];
	};
} foreach _pKeychain;

// -- set cursel to index 0.
_lbxInvSelect lbSetCurSel 0;

// ---- init controls
// -- populate store listbox with store's items array. Itemname, qty: stock
private ['_sArr'];
_sArr = _sObj getVariable "storeArray";
{
	private ['_tItemName', '_tIStock', '_tIPrice'];
	_tItemName = _x select 0;
	_tIStock = _x select 1;
	_tIPrice = [_tItemName] call MV_Shared_fnc_ItemGetPrice;
	_lbxInventoryStore lbAdd format ['%1, Stock: %2, $%3', _tItemName, _tIStock];
} foreach _sArr;

// -- set cursel index 0 on store array listbox.
_lbxInventoryStore lbSetCurSel 0;

while {!isnull _dsp} do
{
	if (_fNo < diag_frameno) then // -- Run once per frame.
	{
		if (uiNamespace getVariable 'itemShop_cmdToggleMode') then 
		{// -- Handle the changing of modes
			uiNamespace setVariable ['itemShop_cmdToggleMode', false];
			
			if (_uiMode) then // -- it's BUYMODE, change to SELL mode.
			{
				_uiMode = SELLMODE;
				// -- Change UI control labels
				_cmdToggleMode ctrlSetText "To Buy Mode";
				_cmdBuySell ctrlSetText "Sell";
				_frmItemList ctrlSetText "Selected Inventory";
			}
			else // -- Sell mode, change to BUYMODE
			{	
				_uiMode = BUYMODE;
				// -- Change UI control labels
				_cmdToggleMode ctrlSetText "To Sell Mode";
				_cmdBuySell ctrlSetText "Buy";
				_frmItemList ctrlSetText "Store";
			};
			// -- Flag the inventory listbox to update, as it technically has changed.
			
		};
		
		if (_uiModeChanged) then 
		{
			_uiModeChanged = false;
			// -- the UI mode changed, so thus, we must update the 
		};
		
		if (uiNamespace getVariable 'itemShop_lbxInvSelect_lbxSelChanged') then 
		{
			uiNamespace setVariable ['itemShop_lbxInvSelect_lbxSelChanged', false];
			_selObj = objectFromNetId (_lbxInvSelect lbData (lbCurSel _lbxInvSelect));
			// -- Get the inventory of that selected object.
			_selInventory = _selObj getVariable 'inventory'; 
			
			if (_uiMode) then // -- it's BUYMODE
			{
				
			} else {// -- Sell mode
				// -- Update the item listbox with the new array.
			};
			
		};
		
		if (uiNamespace getVariable 'itemShop_lbxInventoryStore_lbxSelChanged') then 
		{
			uiNamespace setVariable ['itemShop_lbxInventoryStore_lbxSelChanged', false];
			// -- Selection in the items listbox has changed. Get object data (from selection index, within the stores array and items array mission vars)
			
		};
		
		if (uiNamespace getVariable 'itemShop_txtQtyChanged') then 
		{
			uiNamespace setVariable ['itemShop_txtQtyChanged', false];
		};
		
		if (uiNamespace getVariable 'itemShop_cmdBuySell') then 
		{
			uiNamespace setVariable ['itemShop_cmdBuySell', false];
		};
		
		// -- Leave last
		_fNo = diag_frameno;
	}
};