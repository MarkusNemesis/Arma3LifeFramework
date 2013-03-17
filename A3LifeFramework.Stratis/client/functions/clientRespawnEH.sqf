/* clientRespawnEH script
Created: 04/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Runs when the player respawns. Adds the 'respawn' event to the clientCore events array.
*/

private ['_pObj', '_corpse'];

_pobj = _this select 0;
_corpse = _this select 1;

// Clear variables for the respawn.
Client_HitArray = [];

// Add previous body to the garbage collector
//[_corpse] call MV_Client_fnc_AddGarbage; // -- See 'clientKilledEH.sqf'

// Leave last
["MV_Client_fnc_SpawnPlayer", [], 1] call MV_Client_fnc_AddEvent;
