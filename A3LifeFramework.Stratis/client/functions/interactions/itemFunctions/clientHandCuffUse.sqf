/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

clientHandCuffUse script
Created: 17/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Restrains a player who is stunned, or TODO consents to being restrained via another player's request. (ie, hands up, or equiv workaround)
All 'use' scripts MUST exit with setting 'Client_UsingItem' to false.
Return:
*/
Client_UsingItem = true;
private ['_iName','_args'];
_iName = _this select 0;
_args = _this select 1;

// -- Body:
private ['_tgt', '_intRange'];
_tgt = cursorTarget;
_intRange = ((["INT_RANGE"] call MV_Client_fnc_GetMissionVariable) select 0);
// TODO create a client function to error out via system chat. 
if (!alive _tgt) exitwith {}; // -- Target is not alive. You can't restrain the dead.... TODO chat error out.
if (!(_tgt getVariable 'isStunned')) exitwith {}; // -- Target is not stunned or not consenting to restraint you can't restrain someone who is fidgetting like this! TODO chat error out. add support for consentual restraining. Must use unique object variable, as to not allow exploits.
if ((player distance _tgt) > _intRange) exitwith {}; // -- Restrainee is too far away. TODO chat error out.

// -- Validation complete. Send server message, to restrain the player.
["UseItemEvent", [_iName, 'restrain', [netId _tgt]]] call MV_Client_fnc_SendServerMessage;

// -- Leave last
Client_UsingItem = false;