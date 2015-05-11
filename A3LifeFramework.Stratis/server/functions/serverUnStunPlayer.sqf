/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

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