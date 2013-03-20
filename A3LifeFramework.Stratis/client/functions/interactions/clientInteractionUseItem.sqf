/* clientInteractionUseItem script
Created: 20/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
Return:
1. Validate Quantity
2. Send servermessage to install 'use' event into server eventArray.
3. Server runs event
	3.1 Checks if user has inventory item
		3.1.1 If false, send clientMessage "UseItemReturn", [false, "i", 'itemName']. Displays error messagebox about lacking the item.
	3.2 Checks if user has enough of that item
		3.2.1 If false, send clientMessage "UseItemReturn", [false, "q", 'itemName', qty]. Displays error messagebox about insufficient quantity.
4. Sends clientMessage "UseItemReturn", [true, "itemName", qty]
*/
diag_log format ["MV: clientInteractionUseItem: %1", _this];
private ['_iName', '_qty', '_iInfo', '_args', '_fnc'];
_iName = _this select 0;
_qty = _this select 1;
_args = [];
_fnc = objNull;

// -- Get Item Info
_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
// -- Get item use arguments, usefunction
_args = _iInfo select 3;
_fnc = _iInfo select 4;

diag_log _fnc;

// -- Call the function for this item, and pass it's arguments.
call compile format ["[_iName, _qty, _args] call %1", _fnc];