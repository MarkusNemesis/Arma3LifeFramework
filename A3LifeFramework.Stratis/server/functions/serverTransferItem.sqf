/* serverTransferItem script
Created: 24/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Transfers one item from object A to object B.
Validates that objA has the item, and the required qty, and objB has the required volume to accept the item.
If ObjA or B is a player, then a message will be sent to both, saying what has happened. IE, 'Item sent' or 'Item recieved' etc.
Params: ['_objA', '_iName', '_qty', '_objB']
*/

private ['_lObj', '_objA', '_iName', '_qty', '_objB', '_oAID', '_oBID', '_arrPlayers'];
_lObj = (call M_S_fnc_GLV);
_objA = objectFromNetId (_this select 0);
_iName = _this select 1;
_qty = _this select 2;
_objB = objectFromNetId (_this select 3);
_oAID = _this select 0;
_oBID = _this select 3;
_arrPlayers = [];
// -- Which objects are players?
if ([_objA] call MV_Shared_fnc_isPlayerOnFoot) then {_arrPlayers = _arrPlayers + [_objA];};
if ([_objB] call MV_Shared_fnc_isPlayerOnFoot) then {_arrPlayers = _arrPlayers + [_objB];};

// -- Check if _objA has the item that is to be sent.
private ['_objAInv', '_hasItem'];

_objAInv = [_oAID, "Inventory"] call MV_Server_fnc_GetMissionVariable;
_hasItem = [_objAInv, _iName, _qty] call MV_Shared_fnc_InventoryHasItem;

if (!_hasItem) exitwith {
	diag_log format ["MV: serverTransferItem: %1 does not have the item %2 in qty %3", name _objA, _iName, _qty];
	{[_x, "TransferItemReturn", [false , 'i', _iName, _qty]] call MV_Server_fnc_SendClientMessage;} foreach _arrPlayers;
};

// -- Check if _objB has enough volume to accept the items.
private ['_objBInv', '_ObjBVol', '_ObjBMaxVol', '_transVol'];
//if ((typeOf _ObjB) == (Server_LocObj getVariable "MV_Shared_DROPPILECLASS")) then 
//{
//	_ObjBMaxVol = (misServer_LocObjtVariable "MV_Shared_PILEVOLUME");
//} else {

//if ([_objB] call MV_Shared_fnc_isPlayerOnFoot) then {
	_ObjBMaxVol = ([netid _objB, "storageVolume"] call MV_Server_fnc_GetMissionVariable) select 0;
//} else {
//	if (_ObjB isKindOf "LandVehicle" or _ObjB isKindOf "Air" or _ObjB isKindOf "Ship") exitwith
//	{
//		private ['_vInfo'];
//		// -- Find the _objB vehicle in the vehicles array.
//		_vInfo = [typeof _ObjB] call MV_Shared_fnc_GetVehicleArrayInfo;
//		if (!isnil '_vInfo') then {_ObjBMaxVol = _vInfo select 4;};
//	};
//};

if (isnil '_objBMaxVol') exitwith {
	diag_log format ["MV: serverTransferItem: ERROR: _objBMaxVol is nil"];
	{[_x, "TransferItemReturn", [false , 'ni']] call MV_Server_fnc_SendClientMessage;} foreach _arrPlayers;
};

_objBInv = [_oBID, "Inventory"] call MV_Server_fnc_GetMissionVariable;
_ObjBVol = [_objBInv] call MV_Shared_fnc_GetCurrentInventoryVolume;

_transVol = (([_iName] call MV_Shared_fnc_GetItemInformation) select 1) * _qty;
diag_log format ["%1, %2, %3, %4", _ObjBMaxVol, _objBInv, _ObjBVol, _transVol];
if (((_ObjBMaxVol - _ObjBVol) - _transVol) < 0) exitwith {
	diag_log format ["MV: serverTransferItem: _ObjBVol is insufficient to hold the transfer of %2. CurVol: %3, MaxVol %4, TVol: %5", _iName, _ObjBVol, _ObjBMaxVol, _transVol];
	{[_x, "TransferItemReturn", [false , 'v', _iName, _qty, _transVol]] call MV_Server_fnc_SendClientMessage;} foreach _arrPlayers;
};

// -- User has the item, the item's in enough qty, and ObjB can accept the item. So now transfer the item from _objA to _objB.
// -- Remove objects from _ObjA.
[_objA, _iName, _qty] call MV_Server_fnc_RemoveInventoryItem;
// -- Add objects to _ObjB
[_objB, _iName, _qty] call MV_Server_fnc_AddInventoryItem;

// -- Transfer completed, and variables are synced and set. Send message to the player that transfer succeeded.
{[_x, "TransferItemReturn", [true , _iName, _qty, netID _objA, netid _ObjB]] call MV_Server_fnc_SendClientMessage;} foreach _arrPlayers;

// -- Check if ObjB is a pile, and if it has anything in it's inventory. If it has nothing, delete it.
private ['_dpClass', '_dpile', '_dpInv', '_dpID'];
_dpClass = (_lObj getVariable "MV_Shared_DROPPILECLASS");

if (((typeOf _ObjA) == _dpClass)) then 
{
	_dpile = _ObjA;
	_dpID = _oAID;
} else {
	if (((typeOf _ObjB) == _dpClass)) then
	{
		_dpile = _ObjB;
		_dpID = _oBID;
	};
};

if (!isnil '_dpile') then
{
	_dpInv = [_dpID, "Inventory"] call MV_Server_fnc_GetMissionVariable;
	if (count _dpInv == 0) then {[_dpile] call MV_Server_fnc_DeleteWorldObject;};
};