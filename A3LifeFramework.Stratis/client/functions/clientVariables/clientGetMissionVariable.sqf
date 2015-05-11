/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

//

clientGetVariable script
Created: 13/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Simply gets a variable from the clientside variable object.
ALWAYS returns an array. Never a single value. If you want a single value, 'select 0' from the return value after calling.
Params: ['arrayType'];
Return: [[content, of, variable]];

Example: ["ArrayType"] call MV_client_fnc_GetMissionVariable;
*/
diag_log format ['MV: clientGetVariable: %1, Object: %2', _this];
private ['_lObj', '_aType', '_aReturn'];
_lObj = (call M_C_fnc_GLV);
_aType = _this select 0;

_aReturn = (_lObj getVariable _aType);

// -- If it's not an array (ie, singular value), wrap as an array.
if (!((typename _aReturn) == "ARRAY")) then {_aReturn = [_aReturn];};

_aReturn