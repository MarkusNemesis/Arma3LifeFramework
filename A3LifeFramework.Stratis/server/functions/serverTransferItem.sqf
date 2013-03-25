/* serverTransferItem script
Created: 24/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Transfers one item from object A to object B.
Validates that objA has the item, and the required qty, and objB has the required volume to accept the item.
If ObjA or B is a player, then a message will be sent to both, saying what has happened. IE, 'Item sent' or 'Item recieved' etc.
Params: ['_objA', '_iName', '_qty', '_objB']
*/

private ['_objA', '_iName', '_qty', '_objB', '_oAID', '_oBID', '_arrPlayers'];

_objA = _this select 0;
_iName = _this select 1;
_qty = _this select 2;
_objB = _this select 3;
_oAID = 0;
_oBID = 0;
_arrPlayers = [];
if (isplayer _objA) then {_oAID = getPlayerUID _objA; _arrPlayers = _arrPlayers + [_objA];} else {_oAID = netID _objA};
if (isplayer _objB) then {_oBID = getPlayerUID _objB; _arrPlayers = _arrPlayers + [_objB];} else {_oBID = netID _objB};

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
if ((typeOf _ObjB) == MV_Shared_DROPPILECLASS) then 
{
	_ObjBMaxVol = (missionNamespace getVariable "MV_Shared_PILEVOLUME");
} else {
	if (isPlayer _objB) exitWith {_ObjBMaxVol = (missionNamespace getVariable "MV_Shared_PLAYERVOLUME");}; // -- TODO 'set' player's max volume via missionvariable, and retrieve it where needed, ie, here.

	if (_ObjB isKindOf "LandVehicle" or _ObjB isKindOf "Air" or _ObjB isKindOf "Ship") exitwith
	{
		private ['_vInfo'];
		// -- Find the _objB vehicle in the vehicles array.
		_vInfo = [typeof _ObjB] call MV_Shared_fnc_GetVehicleArrayInfo;
		if (!isnil '_vInfo') then {_ObjBMaxVol = _vInfo select 4;};
	};
};
if (isnil '_objBMaxVol') exitwith {
	diag_log format ["MV: serverTransferItem: _objBMaxVol is nil"];
	{[_x, "TransferItemReturn", [false , 'ni']] call MV_Server_fnc_SendClientMessage;} foreach _arrPlayers;
};

_objBInv = [_oBID, "Inventory"] call MV_Server_fnc_GetMissionVariable;
_ObjBVol = [_objBInv] call MV_Shared_fnc_GetCurrentInventoryVolume;

_transVol = (([_iName] call MV_Shared_fnc_GetItemInformation) select 1) * _qty;
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