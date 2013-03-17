/* sharedGetPlayers script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Gets the player slots and stores them.
*/
shared_isGetPlayers = false;
MV_Shared_PLAYERS_BLU = [];
MV_Shared_PLAYERS_OP = [];
MV_Shared_PLAYERS_IND = [];
MV_Shared_PLAYERS_CIV = [];
// Get them from semi-static arrays instead....
if (BLU_PLAYERCOUNT > 0) then {
	for "_i" from 1 to BLU_PLAYERCOUNT do
	{
	    MV_Shared_PLAYERS_BLU set [count MV_Shared_PLAYERS_BLU, call compile format ["BLU_P_%1", _i]];
	};
};

if (OP_PLAYERCOUNT > 0) then {
	for "_i" from 1 to OP_PLAYERCOUNT do
	{
	    MV_Shared_PLAYERS_OP set [count MV_Shared_PLAYERS_OP, call compile format ["OP_P_%1", _i]];
	};
};
//MV_Shared_PLAYERS_IND
if (IND_PLAYERCOUNT > 0) then {
	for "_i" from 1 to IND_PLAYERCOUNT do
	{
	    MV_Shared_PLAYERS_IND set [count MV_Shared_PLAYERS_IND, call compile format ["IND_P_%1", _i]];
	};
};

//MV_Shared_PLAYERS_CIV
if (CIV_PLAYERCOUNT > 0) then {
	for "_i" from 1 to CIV_PLAYERCOUNT do
	{
	    MV_Shared_PLAYERS_CIV set [count MV_Shared_PLAYERS_CIV, call compile format ["CIV_P_%1", _i]];
	};
};

diag_log format ["sharedGetPlayers: BLU: %1", MV_Shared_PLAYERS_BLU];
diag_log format ["sharedGetPlayers: OP: %1", MV_Shared_PLAYERS_OP];
diag_log format ["sharedGetPlayers: IND: %1", MV_Shared_PLAYERS_IND];
diag_log format ["sharedGetPlayers: CIV: %1", MV_Shared_PLAYERS_CIV];

shared_isGetPlayers = true;
