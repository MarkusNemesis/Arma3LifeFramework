/* clientAddGarbage script
Created: 04/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Adds objects to the garbage collection array for the server. These objects are cleared after the delay time has elapsed.
Return:
*/

private ['_garbage', '_delay'];

_garbage = _this;
_delay = time + (60* 2); // 2 minutes

{
    //Client_PlayerGarbageCollection set [count Client_PlayerGarbageCollection, [_x, _delay]];
    _x setvehicleinit "if (isServer) then {[this] call MV_Server_fnc_AddGarbage};";
	processinitcommands;
    diag_log format ["Client: Garbage sent to collector: %1", _x];
} foreach _garbage;

// TODO: communicate to the server the objects that are to be cleared, in the event of the client being disconnected.