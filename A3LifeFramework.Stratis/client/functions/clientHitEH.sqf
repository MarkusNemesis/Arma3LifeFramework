/* Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

clientHitEH script
Created: 04/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Handles hits on players. 
Used primarily for the 'stun' mechanism.
Bugged due to this: http://feedback.arma3.com/view.php?id=6644
*/
diag_log format ["MV: clientHitEH: %1", _this];
if (!(alive _washit)) exitwith {};

private ['_washit', '_hitby', '_dmg', '_projectile'];

_washit = _this select 0;
_dmg = _this select 2;
_hitby = _this select 3;
_projectile = _this select 4;

// -- Check if hit by stun weapon (Rook 9mm)
if (_projectile == "B_9x21_Ball") then // -- washit by a potential stun weapon. 
{
	// -- Check if the shooter has a rook.
	if ((handgunWeapon _hitby) == "hgun_Rook40_F") then // If user was hit by a stun rook, then stun the player.
	{
		/*
		nullify damage
		set fatigue to max
		send network animation
		disable user input
		set a flag that disables 'onKeyPress' EH, or similar.
		TODO TODO TODO
		*/
		// -- Remove damage from the round
		_dmg = 0;
		if (_washit getVariable 'isStunned') exitwith {};
		_washit setVariable ['isStunned', true];
		// -- Set fatigue to max for visual and actual effect.
		_washit setFatigue 1;
		// -- Play network animation AcinPercMstpSnonWnonDnon_agony
		if (_washit != (vehicle _washit)) then 
		{
			["AnimationEvent", [netID _washit, "KIA_Driver_High01", 'switchMove']] call MV_Shared_fnc_SendPublicMessage;
		} else {
			["AnimationEvent", [netID _washit, "AcinPercMstpSnonWnonDnon_agony", 'switchMove']] call MV_Shared_fnc_SendPublicMessage;
		};
		// -- Disable user input.
		disableUserInput true;
		// -- Send server message about the stunning revelation. Hurr
		["stunPlayer", ['ss', netid _hitby, [/*_projectile*/]]] call MV_Client_fnc_SendServerMessage; // Format: ['ss' = shotStun, hitby, _projectile]
		// -- White out the player's screen.
		12 cutText ["You have been stunned!", "WHITE IN", 13];
		// -- Camera shake!!!!!
		addCamShake [25, 10, 100];
	};
};
diag_log format ["MV: clientHitEH: Return Value: %1", _dmg];
// -- Leave last, return value.
_dmg