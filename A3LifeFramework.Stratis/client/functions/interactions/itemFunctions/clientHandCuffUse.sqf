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
 
if (!isplayer _tgt) exitwith {Client_UsingItem = false;['f', localize "STR_MV_ITEM_ERRORRESTRAINNOPLAYER"] call MV_Client_fnc_SChatMsg;}; // -- Target isn't a player. You can't restrain AI.
if (!alive _tgt) exitwith {Client_UsingItem = false;['f', localize "STR_MV_ITEM_ERRORRESTRAINDEAD"] call MV_Client_fnc_SChatMsg;}; // -- Target is not alive. You can't restrain the dead....
if (!(_tgt getVariable 'isStunned')) exitwith {Client_UsingItem = false;['f', localize "STR_MV_ITEM_ERRORRESTRAINNOTSTUNNED"] call MV_Client_fnc_SChatMsg;}; // -- Target is not stunned or not consenting to restraint you can't restrain someone who is fidgetting like this! TODO add support for consentual restraining. Must use unique object variable, as to not allow exploits.
if ((player distance _tgt) > _intRange) exitwith {Client_UsingItem = false;['f', localize "STR_MV_ITEM_ERRORRESTRAINTOOFAR"] call MV_Client_fnc_SChatMsg;}; // -- Restrainee is too far away.

// -- Display message for attempting to cuff a player.
['f', format [localize "STR_MV_ITEM_RESTRAINATTEMPT", name _tgt]] call MV_Client_fnc_SChatMsg;

// -- Validation complete. Send server message, to restrain the player and remove the item.
["UseItemEvent", [_iName, 'restrain', [netId _tgt]]] call MV_Client_fnc_SendServerMessage;

// -- Leave last
Client_UsingItem = false;