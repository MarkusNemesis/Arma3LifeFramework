/* serverOnPlayerConnected script
Created: 09/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Runs when a player connects to the server. Stores their name, slotname, etc.
*/

//
private ['_id','_name','_uid', '_slotName', '_retryCount', '_pObj'];
_id = _this select 0;
_name = _this select 1;
_uid = _this select 2;
_slotName = "";
_pObj = objnull;
diag_log format ["MV: serverOnPlayerConnected: %1, %2, %3", _id, _name, _uid];

// ---- Ensure player name __SERVER__ is ignored.
if (_name == "__SERVER__") exitwith {};

call MV_Shared_fnc_GetPlayers;

// ---- Find the player's slot name.
_retryCount = 0;
while {_slotname == "" && _retryCount < 30} do
{
	{
	    if ((getPlayerUID _x) == _uid) exitwith {_slotname = str _x; _pObj = _x};
	} foreach (MV_Shared_PLAYERS_BLU + MV_Shared_PLAYERS_OP + MV_Shared_PLAYERS_IND + MV_Shared_PLAYERS_CIV);
    _retryCount = _retryCount + 1;
    sleep 0.5;
	call MV_Shared_fnc_GetPlayers;
};
if (_slotname == "") exitwith {diag_log format ["MV: serverOnPlayerConnected: CRITICAL ERROR: %1, %2, %3 FAILED TO GET SLOT", _id, _name, _uid];};

// -- Init Player CommVar
call compile format ["%1_CommVar = [];", _slotName];
format ["%1_CommVar", _slotName] addPublicVariableEventHandler {[_this select 1] call MV_Server_fnc_CommVarEH;};
diag_log format ["PublicVar set: %1_CommVar", _slotName];



// ---- Check if the player has played before in this session. iterate through Server_PlayerRegistry
private ['_found', '_prIndex'];
_found = false;
_prIndex = -1;

{
    diag_log format ["%1 vs %2, %3 vs %4", _uid, _x select 2, _name, _x select 1];
    if (_uid == (_x select 2)) exitwith {_found = true;_prIndex = _foreachindex};
} foreach Server_PlayerRegistry;

if (!_found) then // -- If the player has connected for the first time this round
{
    diag_log format ["MV: serverOnPlayerConnected: Player %1 has joined for the first time. UID: %2", _name, _uid];
	// ---- Add player to the Server_PlayerRegistry
	Server_PlayerRegistry set [count Server_PlayerRegistry, [_id, _name, _uid, _slotname]];
	// -- Init the player's missionNamespace array.
	missionNamespace setVariable [format ["%1_missionVar", _uid], []];
	// -- Init first time joiner
    _pObj setVariable ["Money", MV_Params_GPStartFunds, true];
    _pObj setVariable ["BankMoney", 0, true];
    _pObj setVariable ["KeyChain", [], true];
	_pObj setVariable ["storageVolume", (missionNamespace getVariable "MV_Shared_PLAYERVOLUME"), true];
	
    // -- Serverside values
	[_uid, ["Money", [MV_Params_GPStartFunds]]] call MV_Server_fnc_SetMissionVariable;
	[_uid, ["BankMoney", [0]]] call MV_Server_fnc_SetMissionVariable;
	[_uid, ["KeyChain", []]] call MV_Server_fnc_SetMissionVariable;
	[_uid, ["storageVolume", [(missionNamespace getVariable "MV_Shared_PLAYERVOLUME")]]] call MV_Server_fnc_SetMissionVariable;
	
	/*
	[_uid, []] call MV_Server_fnc_SetMissionVariable;
	['netID/UID', ['arrayType', [content,array,etc]];
	*/
}
else // -- otherwise, they've been here before, so lets pick them back up where they left off.
{
    diag_log format ["MV: serverOnPlayerConnected: Player %1 has returned. UID: %2", _name, _uid];
	// -- Update player registry slotname
	Server_PlayerRegistry set [_prIndex, [_id, _name, _uid, _slotname]];
	
	// -- TODO maybe disallow 'money' to be returned, as it could be used to exploit drug trafficking. 
    _pObj setVariable ["Money", ([_uid, "Money"] call MV_Server_fnc_GetMissionVariable) select 0, true];
    _pObj setVariable ["BankMoney", ([_uid, "BankMoney"] call MV_Server_fnc_GetMissionVariable) select 0, true];
    _pObj setVariable ["KeyChain", [_uid, "KeyChain"] call MV_Server_fnc_GetMissionVariable, true];
    
	// [_uid, "ArrayType"] call MV_Server_fnc_GetMissionVariable
};
// -- Init player's inventory as empty. They've joined so thus have lost whatever they had before.
private ['_iMoney'];
_iMoney = [_uid, "Money"] call MV_Server_fnc_GetMissionVariable select 0;
[_uid, ["Inventory", [["Money", _iMoney], ["Light Repair Kit", 5]]]] call MV_Server_fnc_SetMissionVariable;
_pObj setVariable ["Inventory", [["Money", _iMoney], ["Light Repair Kit", 5]], true];
//
_pObj setvehicleinit "this enablesimulation true; this allowdamage true;";
processinitcommands;
_pObj setVariable ["clientInitCompleteAck", true, true]; // Acknowledges to the client that it is inited on both client and server.
