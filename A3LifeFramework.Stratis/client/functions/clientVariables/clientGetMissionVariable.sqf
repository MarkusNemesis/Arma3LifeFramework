/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

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