/* serverInitPlayerSlots script
Created: 14/09/2012
Author: Markus Davey
Skype: markus.davey
Desc: Initialises the player slots.
Stops the AI from moving / taking over.
Return: Null
*/
private ["_players"];

_players = _this select 0;

{
    // Disable AI
    _x disableAI "FSM";
    _x disableAI "TARGET";
    _x disableAI "AUTOTARGET";
    _x disableAI "MOVE";
    _x disableAI "ANIM";
    
    // Put the AI inside the spawn haven.
    _x setposASL getposASL Shared_SpawnHaven;
    //diag_log format ["Moving slot %1 to spawn haven", name _x];
    
} forEach _players;

