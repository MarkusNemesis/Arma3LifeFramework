/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
//

serverItemStoreAction script
Created: 8/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Added to the event array when a user attempts to buy/sell an item at an item store.
MV_Server_fnc_ItemStoreAction
Params: [playerObj, actionType, [Args]]
Return: Sends client message back whether action was a success or not. Feedback to player: Format: ['Reason', [iName, qty, dest/srcObj]];
*/

diag_log format ["MV: serverItemStoreAction: %1", _this];

private ['_pObj', '_aMode', '_strObj', '_iaArgs', '_sArr'];
_pObj = _this select 0;
_aMode = _this select 1;
_strObj = _this select 2;
_iaArgs = _this select 3;
_sArr = [netID _strObj, "storeArray"] call MV_Server_fnc_GetMissionVariable; 
// -- args
_iName = _iaArgs select 0;
_iQty = _iaArgs select 1;

if (_iQty <= 0) exitwith {[_pobj, "ISAR", ['iq', [_iName, _iQty]]] call MV_Server_fnc_SendClientMessage;};

switch (_aMode) do
{
	case true: // -- Sell mode
	{
		private ['_iSrcObj'];
		_iSrcObj = objectFromNetId (_iaArgs select 2);
		/*
		Valdation: 
		Store has item
		Inventory has item + qty
		maxStock check
		check source inventory distance <= 20m
		*/
		private ['_tiIsMaxStock', '_tisrcInv', '_tisExporter'];
		_tiIsMaxStock = true;
		_tisExporter = [netID _strObj, "isExporter"] call MV_Server_fnc_GetMissionVariable select 0; 
		//
		// -- Check if store has the item, so thus, can also have that item sold to them.
		if (!([_sArr, _iName, 0] call MV_Shared_fnc_InventoryHasItem)) exitwith {[_pobj, "ISAR", ['ds', [_iName, _iQty, netid _iSrcObj]]] call MV_Server_fnc_SendClientMessage;};
		
		// -- Check if selected inventory has item + qty
		_tisrcInv = [netID _iSrcObj, "Inventory"] call MV_Server_fnc_GetMissionVariable;
		if (!([_tisrcInv, _iName, _iQty] call MV_Shared_fnc_InventoryHasItem)) exitwith {[_pobj, "ISAR", ['ni', [_iName, _iQty, netid _iSrcObj]]] call MV_Server_fnc_SendClientMessage;};
		
		// -- Check if sale will put item over max item stock.
		if (!_tisExporter) then 
		{
			_tiIsMaxStock = !(([_iName, _iQty, _sArr] call MV_Shared_fnc_StoreCanAcceptSellQty) select 0);
		} else {_tiIsMaxStock = false};
		if (_tiIsMaxStock) exitwith {[_pobj, "ISAR", ['ms', [_iName, _iQty, netid _iSrcObj]]] call MV_Server_fnc_SendClientMessage;};
		
		// -- Check if source inventory is within 20m of the store keeper.
		if ((_strObj distance _iSrcObj) > 20) exitwith {[_pobj, "ISAR", ['nr', [_iName, _iQty, netid _iSrcObj]]] call MV_Server_fnc_SendClientMessage;};
		
		// -- Passed validation, actually do the transaction.
		/* selling from selectedInventory TO the store.
		1. Subtract item + qty from selected inventory. 
		2. Add qty to the stock of the item in the store. [_sobj, [_vCName, -1]] call MV_Server_fnc_AdjustStoreStock;
		3. Give (itemValue * qty) to user.
		4. Report back to the client.
		*/
		private ['_tiInfo', '_ttPrice'];
		// -- Subtract item + qty from selected Inventory.
		[_iSrcObj, _iName, _iQty] call MV_Server_fnc_RemoveInventoryItem;
		// -- Add qty to stock in the store.
		[_strObj, [_iName, _iQty]] call MV_Server_fnc_AdjustStoreStock;
		// -- Give (itemValue * qty) * 0.9 to user.
		_tiInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
		_ttPrice = ((_tiInfo select 2) * _iQty) * 0.9; // -- Remove 10% value for selling.
		[_pObj, "Money", _ttPrice] call MV_Server_fnc_AddInventoryItem;//[_pObj, _ttPrice] call MV_Server_fnc_AddPlayerFunds;
		// -- Report back to user about their successful transaction
		[_pobj, "ISAR", ['ss', [_iName, _iQty, netid _iSrcObj, _ttPrice]]] call MV_Server_fnc_SendClientMessage;
		
	};
	case false: // -- Buy mode
	{
		private ['_iDestObj'];
		_iDestObj = objectFromNetId (_iaArgs select 2);
		/*
		Validation:
		Store has item + qty
		User has the funds for price
		DestObj in range
		DestObj has enough volume for transaction.
		*/
		private ['_pInv', '_tiInfo', '_tiTPrice', '_destInv', '_destVol'];
		//
		_pInv = [netID _pObj, "Inventory"] call MV_Server_fnc_GetMissionVariable; 
		//
		// -- Check if store has the item AND the required Qty.
		if (!([_sArr, _iName, _iQty] call MV_Shared_fnc_InventoryHasItem)) exitwith {[_pobj, "ISAR", ['nsi', [_iName, _iQty, netid _iDestObj]]] call MV_Server_fnc_SendClientMessage;};
		
		// -- Check if player has sufficient funds for this transaction.
		_tiInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
		_tiTPrice = (_tiInfo select 2) * _iQty;
		if (!([_pInv, "Money", _tiTPrice] call MV_Shared_fnc_InventoryHasItem)) exitwith {[_pobj, "ISAR", ['if', [_iName, _iQty, netid _iDestObj]]] call MV_Server_fnc_SendClientMessage;};
		
		// -- Check if destination object is in range.
		if ((_strObj distance _iDestObj) > 20) exitwith {[_pobj, "ISAR", ['nr', [_iName, _iQty, netid _iDestObj]]] call MV_Server_fnc_SendClientMessage;};
		
		// -- Check if destObj has enough inventory space.
		_destInv = [netID _iDestObj, "Inventory"] call MV_Server_fnc_GetMissionVariable;
		_destvol = ([netid _iDestObj, "storageVolume"] call MV_Server_fnc_GetMissionVariable) select 0; //if (isplayer _iDestObj) then {_destVol = MV_Shared_PLAYERVOLUME} else {_destVol = [typeof _iDestObj] call MV_Shared_fnc_VehicleGetInventoryVolume;};
		_destVol = _destVol - ([_destInv] call MV_Shared_fnc_GetCurrentInventoryVolume);
		if (!(((_tiInfo select 1) * _iQty) <= _destVol)) exitwith {[_pobj, "ISAR", ['nv', [_iName, _iQty, netid _iDestObj]]] call MV_Server_fnc_SendClientMessage;};
		
		// -- Passed validation, actually do the transaction.
		/* Buying FROM the store, TO the selected inventory.
		Subtract money from player
		Subtract stock from store.
		Add item + qty to selected inventory object's inventory.
		Report back to user about successful transaction.
		*/
		// -- Subtract money from player's inventory.
		[_pObj, "Money", _tiTPrice] call MV_Server_fnc_RemoveInventoryItem;//[_pObj, -_tiTPrice] call MV_Server_fnc_AddPlayerFunds;
		// -- Subtract stock from store.
		[_strObj, [_iName, -_iQty]] call MV_Server_fnc_AdjustStoreStock;
		// -- Add item + qty to selected inventory's inventory.
		[_iDestObj, _iName, _iQty] call MV_Server_fnc_AddInventoryItem;
		// -- Report back to player about successful purchase.
		[_pobj, "ISAR", ['sb', [_iName, _iQty, netid _iDestObj, _tiTPrice]]] call MV_Server_fnc_SendClientMessage;
	};
};