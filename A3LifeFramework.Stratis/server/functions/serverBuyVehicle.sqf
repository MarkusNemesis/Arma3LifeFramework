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
private ['_vCName', '_vPrice', '_sObj', '_pObj', '_spawnMarker', '_sStock'];

_vCName = _this select 0;
_vPrice = _this select 1;
_sObj = _this select 2;
_pObj = _this select 3;
_spawnMarker = [netId _sObj, "spawnObject"] call MV_Server_fnc_GetMissionVariable select 0; //_sObj getVariable "spawnObjectServer";
_sStock = false;

// -- Deduct money from player
_pFunds = [_pObj] call MV_Server_fnc_GetPlayerFunds;
if (_pFunds < _vPrice) exitwith {
    diag_log format ["ERROR: serverBuyVehicle: Player %1 has insufficient funds to purchase %2.", name _pObj, _vCName];
    [_pObj, "BuyVehicleReturn", [false,'funds']] call MV_Server_fnc_SendClientMessage;
};
[_pObj, _pFunds - _vPrice] call MV_Server_fnc_SetPlayerFunds;

// -- Update store's stock level
_sStock = [_sobj, [_vCName, -1]] call MV_Server_fnc_AdjustStoreStock; // Hardcoded -1 as you can only buy cars singularly.

if (!_sStock) exitwith {
    diag_log format ["ERROR: serverBuyVehicle: Player %1 has insufficient stock to purchase %2.", name _pObj, _vCName];
    [_pObj, "BuyVehicleReturn", [false,'stock']] call MV_Server_fnc_SendClientMessage;
};

// -- Spawn the vehicle! Spawns on the store's spawn marker.
private ['_spVeh', '_sPos', '_kChain', '_vNID'];
_sPos = (getmarkerpos _spawnMarker); //findemptyposition[0, 3, _vCName];
_spVeh = createVehicle [_vCName, [7090,5936,0], [], 0, "NONE"];
_spVeh lock true;

// -- Position the vehicle
_spVeh setpos [(_sPos select 0) + (random 5), (_sPos select 1) + (random 5), (_sPos select 2)]; // TODO implement AGL method
_spVeh setdir (markerdir _spawnMarker);

// -- init vehicle's missionNamespace variable
_vNID = netid _spVeh;
missionNamespace setVariable [format ["%1_missionVar", _vNID], []];

// -- Set the vehicle's variables
_spVeh setVariable ["isInteractable", true, true];
_spVeh setVariable ["interactType", "typeVehicle", true];

[_vNID, ["isInteractable", [true]]] call MV_Server_fnc_SetMissionVariable;
[_vNID, ["interactType", ["typeVehicle"]]] call MV_Server_fnc_SetMissionVariable;

// -- Set the vehicle's initline to have it interactable by the player instantly.
_spVeh setvehicleinit "clearWeaponCargo this; clearMagazineCargo this; clearItemCargo this; player reveal this;";
processinitcommands;

// -- Add vehicle to the player's keychain
_kChain = [getPlayerUID _pObj, "KeyChain"] call MV_Server_fnc_GetMissionVariable; //_pObj getVariable "KeyChainServer";
_kChain set [count _kChain, netID _spVeh];

_pObj setVariable ["KeyChain", _kChain, true];
[getPlayerUID _pObj, ["KeyChain", _kChain]] call MV_Server_fnc_SetMissionVariable;
//_pObj setVariable ["KeyChainServer", _kChain];

// -- Add the vehicle to the collector. It'll be by default assigned 30 minutes before it despawns. This delay is updated every time a user gets in or out of the vehicle
[_spVeh] call MV_Server_fnc_AddGarbage;

// -- Send client success message
[_pObj, "BuyVehicleReturn", [true]] call MV_Server_fnc_SendClientMessage;