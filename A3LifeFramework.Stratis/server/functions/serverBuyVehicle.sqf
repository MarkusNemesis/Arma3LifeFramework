/* serverBuyVehicle script
Created: 14/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Manages the charging, creation and initialisation of client bought vehicles.
*/
//[_vCName, _vPrice, _sPos, _sObj, _playerSlot];
private ['_vCName', '_vPrice', '_sObj', '_pObj', '_spawnMarker', '_sStock'];

_vCName = _this select 0;
_vPrice = _this select 1;
_sObj = _this select 2;
_pObj = _this select 3;
_spawnMarker = [netId _sObj, "spawnObject"] call MV_Server_fnc_GetMissionVariable select 0; //_sObj getVariable "spawnObjectServer";
_sStock = false;

// -- Check if player has enough money.
_pFunds = [_pObj] call MV_Server_fnc_GetPlayerFunds;
if (_pFunds < _vPrice) exitwith {
    diag_log format ["ERROR: serverBuyVehicle: Player %1 has insufficient funds to purchase %2.", name _pObj, _vCName];
    [_pObj, "BuyVehicleReturn", [false,'funds']] call MV_Server_fnc_SendClientMessage;
};

// -- Update store's stock level
_sStock = [_sobj, [_vCName, -1]] call MV_Server_fnc_AdjustStoreStock; // Hardcoded -1 as you can only buy cars singularly.

if (!_sStock) exitwith {
    diag_log format ["ERROR: serverBuyVehicle: Player %1 has insufficient stock to purchase %2.", name _pObj, _vCName];
    [_pObj, "BuyVehicleReturn", [false,'stock']] call MV_Server_fnc_SendClientMessage;
};

// -- Deduct money from player
[_pObj, "Money", _vPrice] call MV_Server_fnc_RemoveInventoryItem;//[_pObj, _pFunds - _vPrice] call MV_Server_fnc_SetPlayerFunds;

// -- Spawn the vehicle! Spawns on the store's spawn marker.
private ['_spVeh', '_sPos', '_kChain', '_vNID', '_vInfo'];
_sPos = (getmarkerpos _spawnMarker); //findemptyposition[0, 3, _vCName];
_spVeh = createVehicle [_vCName, _sPos, [], 0, "CAN_COLLIDE"];
_spVeh setdir (markerdir _spawnMarker);
_spVeh lock true;

// -- init vehicle's missionNamespace variable
_vNID = netid _spVeh;
missionNamespace setVariable [format ["%1_missionVar", _vNID], []];

_vInfo = [_vCName] call MV_Shared_fnc_GetVehicleArrayInfo;

// -- Set the vehicle's variables
_spVeh setVariable ["isInteractable", true, true];
_spVeh setVariable ["interactType", "typeVehicle", true];
_spVeh setVariable ["storageVolume", _vInfo select 4, true];
_spVeh setVariable ["Inventory", [], true];
_spVeh setVariable ["vName", format ["%1_%2_%3", _vNID, name _pobj, _vCName], true];

[_vNID, ["isInteractable", [true]]] call MV_Server_fnc_SetMissionVariable;
[_vNID, ["interactType", ["typeVehicle"]]] call MV_Server_fnc_SetMissionVariable;
[_vNID, ["storageVolume", [_vInfo select 4]]] call MV_Server_fnc_SetMissionVariable;
[_vNID, ["Inventory", []]] call MV_Server_fnc_SetMissionVariable;
[_vNID, ["vName", [format ["%1_%2_%3", _vNID, name _pobj, _vCName]]]] call MV_Server_fnc_SetMissionVariable;

// -- Set the vehicle's initline to have it interactable by the player instantly.
_spVeh setvehicleinit "clearWeaponCargo this; clearMagazineCargo this; clearItemCargo this; player reveal this;";
processinitcommands;

// -- Add vehicle to the player's keychain
_kChain = [netid _pObj, "KeyChain"] call MV_Server_fnc_GetMissionVariable; //_pObj getVariable "KeyChainServer";
_kChain set [count _kChain, netID _spVeh];

_pObj setVariable ["KeyChain", _kChain, true];
[netid _pObj, ["KeyChain", _kChain]] call MV_Server_fnc_SetMissionVariable;
//_pObj setVariable ["KeyChainServer", _kChain];

// -- Add the vehicle to the collector. It'll be by default assigned 30 minutes before it despawns. This delay is updated every time a user gets in or out of the vehicle
[_spVeh] call MV_Server_fnc_AddGarbage;

// -- Set the vehicle to be owned by the player who bought it.
//_spVeh setOwner (owner _pObj);

// -- Send client success message
[_pObj, "BuyVehicleReturn", [true]] call MV_Server_fnc_SendClientMessage;