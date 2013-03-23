/* clientInteractionDropItem script
Created: 23/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Runs when a user 'drops' an item.
Calls to the server for the server to 'drop' the item from the user's inventory.
1. Client validates if user has item + Qty.
	1.1 If not, it'll error out via error message.
2. Sends message to server via commvar "DropItem"
3. Server validates if user has the item + Qty
4. Server Removes item from user's inventory.
5. Server creates 'pile' near user, if not one already within interact range. 
	5.1 Puts item + qty into said 'pile'.
6. Returns to client via "DropItemReturn". If success = true: Format: ["DropItemReturn", [boolSuccess?, _iName, _Qty]]; if false: ["DropItemReturn", [boolSuccess, "Reason", _iName, _Qty]]
	6.1 If successful, it'll run the 'drop' animation. If failed, it'll create an error box to the player.
Params: ['_iName', '_qty']
*/

diag_log format ["MV: clientInteractionDropItem: %1", _this];
private ['_iName', '_qty', '_hasItem', '_pInv'];
_iName = _this select 0;
_qty = _this select 1;
_pInv = player getVariable "Inventory";

// -- Validate Quantity
if (_qty <= 0) exitwith {["Error", format [localize "STR_MV_INT_ERRORDROPINVALIDQTY", _qty, _iName]] spawn MV_Client_fnc_int_MessageBox;};

_hasItem = [_pInv, _iName, _qty] call MV_Shared_fnc_InventoryHasItem;

if (_hasItem) then
{	// -- Send server message to have the server validate data and then drop the item.
	["DropItem", [netID player ,_iName, _qty]] call MV_Client_fnc_SendServerMessage;
} else {
	// -- Player doesn't have this item, so, error out.
	["ERROR", format [localize "STR_MV_INT_ERRORDROPNOITEM", _iName, _qty]] spawn MV_Client_fnc_int_MessageBox;
};