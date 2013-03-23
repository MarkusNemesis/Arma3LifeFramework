/* serverTransferItem script
Created: 24/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Transfers one item from object A to object B.
Validates that objA has the item, and the required qty, and objB has the required volume to accept the item.
If ObjA or B is a player, then a message will be sent to both, saying what has happened. IE, 'Item sent' or 'Item recieved' etc.
Params: ['_objA', '_iName', '_qty', '_objB']
*/

private ['_objA', '_iName', '_qty', '_objB', '_oAID', '_oBID'];

_objA = _this select 0;
_iName = _this select 1;
_qty = _this select 2;
_objB = _this select 3;
_oAID = 0;
_oBID = 0;
if (isplayer _objA) then {_oAID = _objA getPlayerUID} else {_oAID = netID _objA};
if (isplayer _objB) then {_oBID = _oBID getPlayerUID} else {_oBID = netID _objB};

// -- Check if _objA has the item that is to be sent.
private ['_objAInv', '_hasItem'];
_objAInv = [_oAID, "Inventory"] call MV_Server_fnc_GetMissionVariable;
_hasItem = [_objAInv, _iName, _qty] call MV_Shared_fnc_InventoryHasItem;

if (!_hasItem) exitwith {}; // -- TODO Message back to player that they don't have the item.

// -- Check if _objB has enough volume to accept the items.
private ['_objBInv', '_ObjBVol', '_ObjBMaxVol', '_transVol'];
if ((typeOf _ObjB) == MV_Shared_DROPPILECLASS) then {_ObjBMaxVol = MV_Shared_PILEVOLUME;} else {
	if (_ObjB isKindOf "LandVehicle" or _ObjB isKindOf "Air" or _ObjB isKindOf "Ship") then
	{
		private ['_vInfo']
		// -- Find the _objB vehicle in the vehicles array.
		_vInfo = [typeof _ObjB] call MV_Shared_fnc_GetVehicleArrayInfo;
		if (!isnil '_vInfo') then {_ObjBMaxVol = _vInfo select 4;};
	};
};
if (isnil '_objBMaxVol') exitwith {}; // -- TODO error message to player that the object they're trying to transfor to, doesn't exist...

_objBInv = [_objB, "Inventory"] call MV_Server_fnc_GetMissionVariable;
_ObjBVol = [_objBInv] call MV_Shared_fnc_GetCurrentInventoryVolume;

_transVol = (([_iName] call MV_Shared_fnc_GetItemInformation) select 1) * _qty;
if (((_ObjBMaxVol - _ObjBVol) - _transVol) < 0) exitwith {}; // TODO Error out to the player that the inventory they're attempting to transfer to has insufficient volume remaining.

// -- User has the item, the item's in enough qty, and ObjB can accept the item. So now transfer the item from _objA to _objB.
// -- Remove objects from _ObjA.
[_objA, _iName, _qty] call MV_Server_fnc_RemoveInventoryItem;
// -- Add objects to _ObjB
[_objB, _iName, _qty] call MV_Server_fnc_AddInventoryItem;

// -- Transfer completed, and variables are synced and set. Send message to the player that transfer succeeded.
// -- TODO message player the above.