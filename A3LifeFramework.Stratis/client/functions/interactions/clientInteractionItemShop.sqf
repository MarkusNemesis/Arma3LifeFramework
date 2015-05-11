/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
//

clientInteractionItemShop script
Created: 4/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Runs the ui_itemShop dialog. Enables players to buy and sell items (depending on the store's base item array.).
UI is defined as if in false, so thus, doesn't need to be initted as such.

Inventory options are stored within the data of the inventories listbox.
	- The data is the netID of the inventory's parent object. This includes players.

_uiMode = What mode the UI is in, default false, for buying items from the store.
_selObj = the object that has been selected in the inventory selection list.
_selInventory = The inventory of the selected inventory.
Params: [storeObj]
*/
#define INVRANGE 20

disableSerialization;

private ['_sObj', '_dsp', '_fNo', '_sArr', '_uiMode', '_selObj', '_selInventory'];

// -- Display the dialog:
createDialog "ui_itemShop";

// -- Init vars
_sObj = _this select 0;
_dsp = findDisplay 1414;
_fNo = diag_frameno;
_sArr = _sObj getVariable "storeArray";
_uiMode = false; // False = BUY mode, true = Sell mode.

// -- Get all controls
private ['_lbxInvSelect', '_lbxInventoryStore', '_stxtInfo', '_cmdToggleMode', '_cmdBuySell', '_txtQty', '_frmItemList', '_frmStoreNameFrame'];
_lbxInvSelect = 			_dsp displayCtrl 2023;
_lbxInventoryStore = 		_dsp displayCtrl 2028;
_stxtInfo =	 			_dsp displayCtrl 2027;
_cmdToggleMode =			_dsp displayCtrl 2026;
_cmdBuySell = 				_dsp displayCtrl 2025;
_txtQty =					_dsp displayCtrl 2024;
_frmItemList =			_dsp displayCtrl 2029;
_frmStoreNameFrame = 		_dsp displayCtrl 2030;

// -- Init UINamespace variables.
uiNamespace setVariable ['itemShop_cmdToggleMode', false];
uiNamespace setVariable ['itemShop_lbxInvSelect_lbxSelChanged', true];
uiNamespace setVariable ['itemShop_lbxInventoryStore_lbxSelChanged', false];
uiNamespace setVariable ['itemShop_txtQtyChanged', false];
uiNamespace setVariable ['itemShop_cmdBuySell', false];
uiNamespace setVariable ['itemShop_stxtInfo_update', true];

// -- init non-namespace update flags
private ['_bDisplayUserInventory', '_bDisplayStoreInventory'];
_bDisplayUserInventory = false;
_bDisplayStoreInventory = true;

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
		_tIndex = _lbxInvSelect lbadd (format ['%1, Dist: %2m', _tObj getVariable 'vName', _tDist]); // todo maybe just show vehicle's classname? vname may be too long.
		_lbxInvSelect lbSetData [_tIndex, _x];
	};
} foreach _pKeychain;

// -- set cursel to index 0.
_lbxInvSelect lbSetCurSel 0;

diag_log format ['MV: clientInteractionItemShop: is display null: %1', isnull _dsp];
while {!isnull _dsp && alive player} do
{
	if (_fNo < diag_frameno) then // -- Run once per frame.
	{
		//diag_log format ['MV: clientInteractionItemShop: _uiMode: %1', _uiMode];
		if (uiNamespace getVariable 'itemShop_cmdToggleMode') then 
		{// -- Handle the changing of modes
			uiNamespace setVariable ['itemShop_cmdToggleMode', false];
			
			if (!_uiMode) then // -- it's false, change to SELL mode.
			{
				_uiMode = true;
				// -- Change UI control labels
				_cmdToggleMode ctrlSetText "To Buy Mode";
				_cmdBuySell ctrlSetText "Sell";
				_frmItemList ctrlSetText "Selected Inventory";
				// -- Set flag to display user's selected inventory in store list box.
				_bDisplayUserInventory = true;
			}
			else // -- Sell mode, change to false
			{	
				_uiMode = false;
				// -- Change UI control labels
				_cmdToggleMode ctrlSetText "To Sell Mode";
				_cmdBuySell ctrlSetText "Buy";
				_frmItemList ctrlSetText "Store";
				// -- Flag to display store's store array.
				_bDisplayStoreInventory = true;
			};
			// -- Update item info.
			uiNamespace setVariable ['itemShop_stxtInfo_update', true];
		};
		
		if (uiNamespace getVariable 'itemShop_lbxInvSelect_lbxSelChanged') then 
		{// -- User has selected a new inventory to buy/sell to/from
			uiNamespace setVariable ['itemShop_lbxInvSelect_lbxSelChanged', false];
			
			// -- Only dump inventory into list, if it's set to 'sell' mode.
			if (_uiMode) then
			{// -- Sell mode
				_bDisplayUserInventory = true; // -- Set flag to display new user inventory selection's inventory.
			} else {
				_selObj = objectFromNetId (_lbxInvSelect lbData (lbCurSel _lbxInvSelect));
				_selInventory = _selObj getVariable "Inventory";
				// -- flag the 'selected item' infobox to update.
				uiNamespace setVariable ['itemShop_stxtInfo_update', true];
			};
		};
		
		if (uiNamespace getVariable 'itemShop_lbxInventoryStore_lbxSelChanged') then 
		{
			uiNamespace setVariable ['itemShop_lbxInventoryStore_lbxSelChanged', false];
			// -- Selection in the items listbox has changed.
			
			// -- Update selected item box.
			uiNamespace setVariable ['itemShop_stxtInfo_update', true];
		};
		
		if (uiNamespace getVariable 'itemShop_txtQtyChanged') then 
		{
			uiNamespace setVariable ['itemShop_txtQtyChanged', false];
			// -- Parse the number, floor it, re set it.
			private ['_tqtyText'];
			_tqtyText = (floor (parseNumber (ctrlText _txtQty)));
			if (_tqtyText <= 0) then {_tqtyText = ''} else {_tqtyText = str _tqtyText};
			_txtQty ctrlSetText (_tqtyText);
			// -- update selected item info box.
			uiNamespace setVariable ['itemShop_stxtInfo_update', true];
		};
		
		if (uiNamespace getVariable 'itemShop_cmdBuySell') then 
		{
			uiNamespace setVariable ['itemShop_cmdBuySell', false];
			// -- The user wants to buy/sell something!
			private ['_tHasItem', '_tSHasItem', '_tHasFunds', '_tCanFit', '_tInRange', '_tinv', '_tiName', '_tQty', '_tiInfo', '_tiMaxStock'];
			_tHasItem = false;
			_tSHasItem = false;
			_tHasFunds = false;
			_tCanFit = false;
			_tStockMax = true;
			_tInRange = false;
			_tiName = _lbxInventoryStore lbData (lbCurSel _lbxInventoryStore); // -- Get the selected item's name.
			_tiInfo = [_tiName] call MV_Shared_fnc_GetItemInformation;
			_tQty = parseNumber (ctrlText _txtQty);
			_tiMaxStock = 0;
			if (_uimode) then // -- Sell mode
			{
				private ['_tisExporter'];
				_tinv = _selObj getVariable "Inventory";
				_tisExporter = _sObj getVariable 'isExporter';
				
				// -- Check if this quantity doesn't go over the store's max volume.
				if (!_tisExporter) then 
				{
					_tStockMax = !(([_tiName, _tQty, _sArr] call MV_Shared_fnc_StoreCanAcceptSellQty) select 0);
				} else {_tStockMax = false;};
				
				// -- Has the user got the item.
				_tHasItem = [_tinv, _tiName, _tQty] call MV_Shared_fnc_InventoryHasItem;
				
				// -- Stores have infinite money, and volume. So thus, set these to true.
				_tHasFunds = true;
				_tCanFit = true;
			} else { // -- Buy mode
				private ['_tiPriceTotal', '_invSpace'];
				_tiPriceTotal = (_tiInfo select 2) * _tQty;
				_tinv = _sArr;
				
				// -- Can the player afford this item?
				if (((["Money", player getVariable "Inventory"] call MV_Shared_fnc_SearchInventory) select 1) >= _tiPriceTotal) then {_tHasFunds = true;};
				
				// -- Has the selected inventory got the required volume? 
				_invSpace = [_selObj, _selInventory] call MV_Shared_fnc_GetRemainingInventoryVolume;
				if (((_tiInfo select 1) * _tQty) <= _invSpace) then {_tCanFit = true;};
				
				// -- You're buying, so thus stock limits aren't an issue. Neither is whether you already have that item. Thus, flag '_tStockMax' as false and _tHasItem as true.
				_tStockMax = false;
				_tHasItem = true;
			};
			// -- Has the store got the item.
			_tSHasItem = [_sArr, _tiName, 0] call MV_Shared_fnc_InventoryHasItem;
			
			// -- Is the selected inventory within range of the store.
			if ((_sObj distance _selObj) <= INVRANGE) then {_tInRange = true};
			
			// -- If any errors, feed back to the player.
			if (!_tHasItem) exitwith {["ERROR", localize "STR_MV_INT_ERRORNOSTOCK"] spawn MV_Client_fnc_int_MessageBox;}; // -- error out, hasn't got item in qty.
			if (!_tSHasItem) exitwith {["ERROR", localize "STR_MV_INT_ERRORDOESNOTSTOCK"] spawn MV_Client_fnc_int_MessageBox;}; // -- error out, store doesn't stock this item.
			if (!_tHasFunds) exitwith {["ERROR", localize "STR_MV_INT_ERRORNOFUNDS"] spawn MV_Client_fnc_int_MessageBox;}; // -- error out, player hasn't got the funds to do this transaction.
			if (!_tCanFit) exitwith {["ERROR", localize "STR_MV_INT_ERRORNOVOL"] spawn MV_Client_fnc_int_MessageBox;}; // -- error out, player attempting to buy items too large for selected inventory.
			if (_tStockMax) exitwith {["ERROR", format [localize "STR_MV_INT_ERRORSTOCKMAX", _tQty, _tiName, _tiMaxStock]] spawn MV_Client_fnc_int_MessageBox;}; // -- error out, player attempting to sell item qty that'll overflow the store's stock of that item.
			if (!_tInRange) exitwith {["ERROR", localize "STR_MV_INT_ERRORINVENTORYTOOFAR"] spawn MV_Client_fnc_int_MessageBox;}; // -- error out, player attempting to buy items too far away for selected inventory.
			
			// -- Validation passed. Send event to the server. Format: [playerObj, actionType, storeObj, [Args]] Args format buy: [iName, Qty, destInventoryObj] Args format sell: [iName, Qty, fromInventoryObj]
			["ItemStoreAction", [_uimode, netID _sObj, [_tiName, _tQty, netid _selObj]]] call MV_Client_fnc_SendServerMessage;
			closeDialog 0;
		};
		
		if (_bDisplayUserInventory) then 
		{
			_bDisplayUserInventory = false;
			// -- Displays the user's inventory, in the store list box.
			_selObj = objectFromNetId (_lbxInvSelect lbData (lbCurSel _lbxInvSelect));
			// -- Get the inventory of that selected object.
			_selInventory = _selObj getVariable "Inventory";
			// -- Iterate through array and output to item listbox
			lbclear _lbxInventoryStore;
			{
				private ['_x1', '_tiName', '_tiQty', '_tiVal', '_tIndex'];
				_x1 = _x;
				_tiName = _x1 select 0;
				{
					private ['_x2'];
					_x2 = _x;
					if (!(_tiName == 'Money')) then {
						if (_tiName == (_x2 select 0)) then // -- Only show what the store stocks as available to sell back.
						{
							_tiQty = _x1 select 1;
							// -- Get base value of item from static items array. Could implement a method of supply and demand in future.
							_tiVal = ([_tiName] call MV_Shared_fnc_GetItemInformation) select 2;
							// -- values of items are 10% less for clients selling into the store.
							if (_uiMode) then {_tiVal = floor (_tiVal * 0.9)};
							_tIndex = _lbxInventoryStore lbadd format ["%1, Stock: %2, $%3", _tiName, _tiQty, _tiVal];
							_lbxInventoryStore lbSetData [_tIndex, _tiName];
						};
					};
				} foreach _sArr;
			} foreach _selInventory;
			
			// -- set cursel index 0 on store array listbox.
			_lbxInventoryStore lbSetCurSel 0;
			
			// -- Set storename frame label
			_frmStoreNameFrame ctrlSetText (_selObj getVariable 'vName');
			
			// -- flag the 'selected item' infobox to update.
			uiNamespace setVariable ['itemShop_stxtInfo_update', true];
		};
		
		if (_bDisplayStoreInventory) then 
		{
			_bDisplayStoreInventory = false;
			// -- Displays the store's store array in the store list box.
			lbclear _lbxInventoryStore;
			{
				private ['_tItemName', '_tIStock', '_tIPrice', '_tIndex'];
				_tItemName = _x select 0;
				_tIStock = _x select 1;
				_tIPrice = [_tItemName] call MV_Shared_fnc_ItemGetPrice;
				_tIndex = _lbxInventoryStore lbAdd format ['%1, Stock: %2, $%3', _tItemName, _tIStock, _tIPrice];
				_lbxInventoryStore lbSetData [_tIndex, _tItemName];
			} foreach _sArr;
			
			// -- set cursel index 0 on store array listbox.
			_lbxInventoryStore lbSetCurSel 0;
			
			// -- Set storename frame label
			_frmStoreNameFrame ctrlSetText (_sObj getVariable "mouseOverText");
			
			// -- flag the 'selected item' infobox to update.
			uiNamespace setVariable ['itemShop_stxtInfo_update', true];
		};
		
		if (uiNamespace getVariable 'itemShop_stxtInfo_update') then 
		{// -- Handle the changing of information within the selected item infobox.
			uiNamespace setVariable ['itemShop_stxtInfo_update', false];
			// -- Displays to the user, a number of handy things about what they could potentially do.
			/*
			Displays this:
			Selected Item:
			Name: text
			Volume: volume (cc)
			Quantity: qty
			Value: $value
			
			Total Volume: (volume * qty) (cc)
			Total Cost: $(volume * value)
			
			Inventory space: inventorySpace (cc)
			
			Quantity in Stock: bool(if qty < storeQty) yes/no // Maybe use green/red text to indicate this.
			Can afford?: bool(if totalCost < playerMoney) yes/no // Maybe use green/red text to indicate this.
			Can fit?: bool(if totalvol < invCurvol) yes/no // Maybe use green/red text to indicate this.
			*/
			if (lbSize _lbxInventoryStore == 0) exitwith {_stxtInfo ctrlSetStructuredText (text "No Item Selected...");}; // -- Don't run when list box is empty.
			
			private ['_tcurSel', '_tsText', '_tiInfo', '_tiName', '_tiVol', '_tiQty', '_tiVal', '_invSpace', '_tiStock', '_tinStock', '_tcanAfford', '_tcanFit', '_ttArray'];
			_tcurSel = lbCurSel _lbxInventoryStore;
			_tsText = "";
			
			// -- Get needed variables:
			_tiName = _lbxInventoryStore lbdata _tcurSel;
			_tiInfo = ([_tiName] call MV_Shared_fnc_GetItemInformation);
			_tiVol = _tiInfo select 1;
			_tiVal = _tiInfo select 2;
			if (_uiMode) then {_tiVal = floor (_tiVal * 0.9)}; // -- We're selling items, so thus, pricing is at 10% less than base.
			_tiQty = parseNumber (ctrlText _txtQty);
			_invSpace = _selobj getVariable "storageVolume";//if (isplayer _selObj) then {_invSpace = MV_Shared_PLAYERVOLUME} else {_invSpace = [typeof _selObj] call MV_Shared_fnc_VehicleGetInventoryVolume;};
			_invSpace = _invSpace - ([_selInventory] call MV_Shared_fnc_GetCurrentInventoryVolume);
			
			// --  If selling. Get the stock of the item from either store array or user's inventory.
			if (_uiMode) then 
			{
				{
					if (_tiName == (_x select 0)) exitwith {_tiStock = _x select 1};
				} foreach _selInventory;
			} else {
				{
					if (_tiName == (_x select 0)) exitwith {_tiStock = _x select 1};
				} foreach _sArr;
			};
			
			// -- Check if there's enough of the item to do this transaction.
			if (_tiStock >= _tiQty) then 
			{
				_tinStock = parseText "<t color='#00FF00'>Yes</t>";
			} else {
				_tinStock = "No";
			};
			
			// -- Check only if we're in 'buy' mode.
			if (!_uiMode) then 
			{
				// -- Check if they can afford this transaction.
				if (((["Money", player getVariable "Inventory"] call MV_Shared_fnc_SearchInventory) select 1) >= (_tiVal * _tiQty)) then 
				{
					_tcanAfford = parseText "<t color='#00FF00'>Yes</t>";
				} else {
					_tcanAfford = "No";
				};
				// -- Check if you can fit this transaction into whatever the selected inventory is.
				if ((_tiVol * _tiQty) <= _invSpace) then 
				{
					_tcanFit = parseText "<t color='#00FF00'>Yes</t>";
				} else {
					_tcanFit = "No";
				};
			} else {
				_tcanAfford = "N/A";
				_tcanFit = "N/A";
			};
			
			// -- Create the array that'll be interated to create the final text.
			_ttArray = [
				["Selected Item:"],
				[formatText ["Name: %1", _tiName]],
				[formatText ["Volume: %1 (cc)", _tiVol]],				
				[formatText ["Quantity: %1", _tiQty]],
				[formatText ["Value: $%1", _tiVal]],
				["---------------"],
				[formatText ["Total Volume: %1 (cc)", _tiVol * _tiQty]],
				[formatText ["Total Cost: $%1", _tiVal * _tiQty]],
				["---------------"],
				[formatText ["Inventory Space: %1 (cc)", _invSpace]],
				["---------------"],
				[formatText ["Quantity in Stock: %1", _tinStock]],
				[formatText ["Can Afford? %1", _tcanAfford]],
				[formatText ["Can Fit %1", _tcanFit]]
			];
			// -- Compile the array into the structured text.
			{
				_tsText = formatText ["%1%2%3", _tsText, (_x select 0), lineBreak];
			} foreach _ttArray;
			
			diag_log _tsText;
			
			_stxtInfo ctrlSetStructuredText _tsText;
		};
		// -- Leave last
		_fNo = diag_frameno;
	}
};