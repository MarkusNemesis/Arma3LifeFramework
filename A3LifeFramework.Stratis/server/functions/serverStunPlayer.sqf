/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

//

serverStunPlayer script
Created: 14/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Validates the stun, and sends appropriate messages to those involved. IE:
Validates if person who 'hit' the player, actually has the required weapon and range from the target to successfully stun.
If valid, carry out action against the player who was hit.

Supports both shot stunning and melee stunning.
Params: [_action, _hitby, _args] - args format: action 'ss': [_projectile], 'ms': []
Return: 
*/

private ['_pObj' ,'_action', '_hitBy', '_args', '_ssTime', '_msTime'];
_pObj = _this select 0;
_action = _this select 1;
_hitBy = _this select 2;
_args = _this select 3;

//

switch (_action) do
{
	case 'ss': // -- shot stun
	{
		_ssTime = 15;
		//private ['_proj'];
		//_proj = _args select 0;
		
		// -- Validate stun, check projectile
		//if (_proj != "B_9x21_Ball") exitwith {/* Not shot with a stun projectile */};
		
		if (_pObj getVariable 'isStunned') exitwith 
		{
			// -- Update player's recovery delay.
		};
		// -- Set player as stunned.
		_pObj setVariable ['isStunned', true, true];
		[netid _pObj, ["isStunned", [true, time + _ssTime]]] call MV_Server_fnc_SetMissionVariable;
		
		// -- Add event to server event array, to unstun player.
		['MV_Server_fnc_UnStunPlayer', [_pObj], time + _ssTime] call MV_Server_fnc_AddEvent;
		
		// -- Send player messages
		[_hitBy, "stunPlayerReturn", [_action, netid _pObj]] call MV_Server_fnc_SendClientMessage;
	};
	
	case 'ms': // -- melee stun
	{
		_msTime = 10;
	};
};