/* serverAddEvent script
Created: 14/03/2013
Author: Markus Davey
Skype: markus.davey
Params: "function_name", [args], priority
Desc: Adds an event to the Server_EventArray which is ran by the main loop.
*/

private ["_fName", "_args", "_priority"];

_fName = _this select 0;
_args = _this select 1;
_priority = _this select 2;

Server_EventArray set [count Server_EventArray, [_fName, _args, _priority]];