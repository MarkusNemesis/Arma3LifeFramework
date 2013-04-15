/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

serverUnStunPlayer script
Created: 15/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Essentially unstuns the stunned player.
Params: [_pObj]
*/

private ['_player'];
_player = _this select 0;
_player setVariable ['isStunned', false, true];
[netid _player, ["isStunned", [false, time]]] call MV_Server_fnc_SetMissionVariable;
[_player, "stunPlayerReturn", ['us']] call MV_Server_fnc_SendClientMessage;