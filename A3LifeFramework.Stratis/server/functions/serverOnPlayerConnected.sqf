/* serverOnPlayerConnected script
Created: 09/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Runs when a player connects to the server. Stores their name, slotname, etc.
*/
private ['_id','_name','_uid', '_slotName', '_retryCount'];
_id = _this select 0;
_name = _this select 1;
_uid = _this select 2;
_slotName = "";
diag_log format ["MV: serverOnPlayerConnected: %1, %2, %3", _id, _name, _uid];

// ---- Ensure player name __SERVER__ is ignored.
if (_name == "__SERVER__") exitwith {};


// ---- Find the player's slot name. Keep trying to find it until it does.
waituntil {Shared_isGetPlayers;};

//_retryCount = 0;
//while {_slotname == "" && _retryCount < 30} do
//{
	{
	    if (_name == name _x) exitwith {_slotname = str _x};
	} foreach MV_Shared_PLAYERS_BLU + MV_Shared_PLAYERS_OP + MV_Shared_PLAYERS_IND + MV_Shared_PLAYERS_CIV;
    //diag_log format ["MV: serverOnPlayerConnected: Searching Player Slot. Name: %1, RetryCount: %2", _slotName, _retryCount];
    //_retryCount = _retryCount + 1;
    //sleep 0.5;
//};
if (_slotname == "") then {diag_log MV_Shared_PLAYERS_BLU + MV_Shared_PLAYERS_OP + MV_Shared_PLAYERS_IND + MV_Shared_PLAYERS_CIV;};
// ---- Add player to the Server_PlayerRegistry
Server_PlayerRegistry set [count Server_PlayerRegistry, [_id, _name, _uid, _slotname]];

// -- Put player object into the spawn haven.
_pObj setposASL getposASL Shared_SpawnHaven;

// -- Init Player CommVars
call compile format ["%1_CommVar = [];", _slotName];
format ["%1_CommVar", _slotName] addPublicVariableEventHandler {[_this select 1] spawn MV_Server_fnc_CommVarEH; diag_log "Public Variable event";};
diag_log format ["PublicVar set for slot %1", _slotName];
diag_log call compile format ["%1_CommVar", _slotName];


// ---- Check if the player has played before in this session. iterate through Server_PlayerData
/*[id, playerName, UID, playerSlot, [Variables e.g. ["Money", 15000], ["KeyChain", [Car1, Car2]], etc]];*/
private ['_found', '_pObj', '_pData'];
_found = false;

//waituntil  {};
call compile format ["_pObj = %1", _slotname];

{
    if (_uid == (_x select 2) && _name == (_x select 1)) exitwith {_found = true;_pData = _x;};
} foreach Server_PlayerData;

if (!_found) then
{
    diag_log format ["MV: serverOnPlayerConnected: Player %1 has joined for the first time. UID: %2", _name, _uid];
    // -- Init first time joiner
    _pObj setVariable ["Money", 15000, true]; // TODO make this a param option for how much money the client starts with.
    _pObj setVariable ["BankMoney", 0, true];
    _pObj setVariable ["KeyChain", [], true];
    
    // -- Serverside values
    _pObj setVariable ["MoneyServer", 15000]; // TODO make this a param option for how much money the client starts with.
    _pObj setVariable ["BankMoneyServer", 0];
    _pObj setVariable ["KeyChainServer", []];
} 
else 
{
    diag_log format ["MV: serverOnPlayerConnected: Player %1 has returned. UID: %2", _name, _uid];
    // -- Init returned player
    private ['_pVars'];
    _pVars = _pData select 4;

    _pObj setVariable ["Money", _pVars select 0, true];
    _pObj setVariable ["BankMoney", _pVars select 1, true];
    _pObj setVariable ["KeyChain", _pVars select 2, true];
    
    // -- Serverside values
    _pObj setVariable ["MoneyServer", _pVars select 0];
    _pObj setVariable ["BankMoneyServer", _pVars select 1];
    _pObj setVariable ["KeyChainServer", _pVars select 2];
};

_pObj setVariable ["clientInitCompleteAck", true, true]; // Acknowledges to the client that it is inited on both client and server.



