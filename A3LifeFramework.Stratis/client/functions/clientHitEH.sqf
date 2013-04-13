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
*/

private ['_washit', '_hitby', '_dmg', '_projectile'];

_washit = _this select 0;
_dmg = _this select 2;
_hitby = _this select 3;
_projectile = _this select 4;

// -- Check if hit by stun weapon (Rook)
if (_projectile == "B_9x21_Ball") then // -- washit by a potential stun weapon. 
{
	// -- Check if the shooter has a rook.
	if ((handgunWeapon _hitby) == "hgun_Rook40_F") then // If user was hit by a stun rook, then stun the player.
	{
		/*
		set fatigue to max
		send network animation - TODO create 'runNetworkAnimation' function which sends an animation event over the network.
		set a flag that disables 'onKeyPress' EH, or similar.
		TODO TODO TODO
		*/
	};
};

// -- Leave last, return value.
_dmg