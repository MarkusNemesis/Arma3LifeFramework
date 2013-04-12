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
private ['_sLoc' ,"_players"];
_sLoc = (call M_S_fnc_GLV);
_players = (_sLoc getVariable "MV_Shared_PLAYERS_BLU") + (_sLoc getVariable "MV_Shared_PLAYERS_OP") + (_sLoc getVariable "MV_Shared_PLAYERS_IND") + (_sLoc getVariable "MV_Shared_PLAYERS_CIV");

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