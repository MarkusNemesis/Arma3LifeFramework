/* clientKilledEH script
Created: 04/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Runs when the player is killed. It destroys all items inside the Client_PlayerDeathObjectCollection array and adds them to the garbage collector
Also sends a message to the server with the kill stats. ie percentage damage from who etc.
*/

{
    _x setDamage 1; // Kills the object
    [_x] call MV_Client_fnc_AddGarbage;
} foreach Client_PlayerDeathObjectCollection;

Client_PlayerSpawned = false;

// -- Add body to the garbage collector

["AddGarbage", [netID player]] call MV_Client_fnc_SendServerMessage;