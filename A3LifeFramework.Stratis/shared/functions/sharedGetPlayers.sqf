/* sharedGetPlayers script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Gets the player slots and stores them.
*/

private ['_players_blu', '_players_op', '_players_ind', '_players_civ', '_bpc', '_opc', '_ipc', '_cpc'];
_players_blu = [];
_players_op = [];
_players_ind = [];
_players_civ = [];
_bpc = (missionNamespace getVariable "BLU_PLAYERCOUNT");
_opc = (missionNamespace getVariable "OP_PLAYERCOUNT");
_ipc = (missionNamespace getVariable "IND_PLAYERCOUNT");
_cpc = (missionNamespace getVariable "CIV_PLAYERCOUNT");
// Get them from semi-static arrays instead....
if (_bpc > 0) then {
	for "_i" from 1 to _bpc do
	{
	    _players_blu set [count _players_blu, call compile format ["BLU_P_%1", _i]];
	};
};

if (_opc > 0) then {
	for "_i" from 1 to _opc do
	{
	    _players_op set [count _players_op, call compile format ["OP_P_%1", _i]];
	};
};
//_players_ind
if (_ipc > 0) then {
	for "_i" from 1 to _ipc do
	{
	    _players_ind set [count _players_ind, call compile format ["IND_P_%1", _i]];
	};
};

//_players_civ
if (_cpc > 0) then {
	for "_i" from 1 to _cpc do
	{
	    _players_civ set [count _players_civ, call compile format ["CIV_P_%1", _i]];
	};
};


call compile format ["with missionNamespace do 
{
	MV_Shared_PLAYERS_BLU = %1;
	MV_Shared_PLAYERS_OP = %2;
	MV_Shared_PLAYERS_IND = %3;
	MV_Shared_PLAYERS_CIV = %4;
};", _players_blu, _players_op, _players_ind, _players_civ];

diag_log (missionNamespace getVariable "MV_Shared_PLAYERS_BLU");
diag_log (missionNamespace getVariable "MV_Shared_PLAYERS_OP");
diag_log (missionNamespace getVariable "MV_Shared_PLAYERS_IND");
diag_log (missionNamespace getVariable "MV_Shared_PLAYERS_CIV");