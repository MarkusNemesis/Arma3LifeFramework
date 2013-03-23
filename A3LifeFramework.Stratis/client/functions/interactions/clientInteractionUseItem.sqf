/* clientInteractionUseItem script
Created: 20/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
Called by clientCommVarEH, event "UseItemReturn".
Inventory has been validated by both client and server at this point.
Return:
Params: ['_iName', '_qty'];
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

diag_log format ["MV: clientInteractionUseItem: iName: %1, qty: %2, args: %3, fnc: %4", _iName, _qty, _args, _fnc];

// -- Call the function for this item, and pass it's arguments.
call compile format ["[_iName, _qty, _args] spawn %1", _fnc];