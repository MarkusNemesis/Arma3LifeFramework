/* serverBuyVehicle script
Created: 14/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Manages the charging, creation and initialisation of client bought vehicles.
*/
//[_vCName, _vPrice, _sPos, _sObj, _playerSlot];
/*
1. Deduct price from player's 'money' variable. x
2. Update store's stock level. create function "serverUpdateStoreArray" which reimposes the entire array (Dirty, but maintains indexes etc).
3. 
4. 
*/
private ['_vCName', '_vPrice', '_sObj', '_pObj', '_spawnMarker'];

_vCName = _this select 0;
_vPrice = _this select 1;
_sObj = _this select 2;
_pObj = _this select 3;
_spawnMarker = _sObj getVariable "spawnObjectServer";

// -- Deduct money from player
_pFunds = [_pObj] call MV_Server_fnc_GetPlayerFunds;
if (_pFunds < _vPrice) exitwith {diag_log format ["ERROR: serverBuyVehicle: Player %1 has insufficient funds to purchase %2.", name _pObj, _vCName]};
[_pObj, _pFunds - _vPrice] call MV_Server_fnc_SetPlayerFunds;

// -- Update store's stock level
[_sobj, [_vCName, -1]] call MV_Server_fnc_AdjustStoreStock; // Hardcoded -1 as you can only buy cars singularly.

// -- Spawn the vehicle! Spawns on the store's spawn marker.
private ['_spVeh', '_sPos', '_kChain'];
_sPos = (getmarkerpos _spawnMarker); //findemptyposition[0, 3, _vCName];
_spVeh = createVehicle [_vCName, [7090,5936,0], [], 0, "NONE"];
_spVeh lock true;

// -- Position the vehicle
_spVeh setposATL [(_sPos select 0) + (random 5), (_sPos select 1) + (random 5), (_sPos select 2)];
_spVeh setdir (markerdir _spawnMarker);

// -- Set the vehicle's variables
_spVeh setVariable ["isInteractable", true, true];
_spVeh setVariable ["interactType", "typeVehicle", true];
_spVeh setVariable ["isInteractableServer", true];
_spVeh setVariable ["interactTypeServer", "typeVehicle"];

// -- Set the vehicle's initline to have it interactable by the player instantly.
_spVeh setvehicleinit "clearWeaponCargo this; clearMagazineCargo this; clearItemCargo this; player reveal this;";
processinitcommands;

// -- Add vehicle to the player's keychain
_kChain = _pObj getVariable "KeyChainServer";
_kChain set [count _kChain, netID _spVeh];

_pObj setVariable ["KeyChain", _kChain, true];
_pObj setVariable ["KeyChainServer", _kChain];