/* serverInitPlayerSlots script
Created: 14/09/2012
Author: Markus Davey
Skype: markus.davey
Desc: Initialises the player slots.
Stops the AI from moving / taking over.
CommVars are semi-public variables defined by the server, where client <> server communication can take place.
Each slot has their own commvar, format: Slotname_CommVar
It's used for all actions that require server action, with the exception of garbage collection. 
Return: Null
*/
private ["_players"];

_players = _this select 0;

{
    // -- Disable AI
    _x disableAI "FSM";
    _x disableAI "TARGET";
    _x disableAI "AUTOTARGET";
    _x disableAI "MOVE";
    _x disableAI "ANIM";
    
    // -- Put player object into the spawn haven.
	_x setposASL getposASL Shared_SpawnHaven;
    _x setvehicleinit "this enablesimulation false; this allowdamage false;";
	processinitcommands;
} forEach _players;