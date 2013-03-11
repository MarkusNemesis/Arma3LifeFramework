/* serverAddGarbage script
Created: 04/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Adds objects to the garbage collection array for this client. These objects are cleared after the delay time has elapsed.
Return:
*/

private ['_garbage', '_delay'];

_garbage = _this;
_delay = time + (60* 2); // 2 minutes

{
    Server_GarbageCollection set [count Server_GarbageCollection, [_x, _delay]];
    diag_log format ["Server: Garbage added to collector: %1", _x];
} foreach _garbage;
