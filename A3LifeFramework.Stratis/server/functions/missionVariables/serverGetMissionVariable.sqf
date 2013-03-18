/* serverGetVariable script
Created: 19/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Simply gets a missionNamespace subarray from the user's personal missionNamespace array.
1. Iterate through the user's misisonnamespace array in search of the specific array type.
1.1 If found, assign _x to a variable and return it
2. If not found, return objNull.
Params: ['netID/UID', 'arrayType'];
Return: ['arrayType1', [content, of, variable]];

Example: [id, "ArrayType"] call MV_Server_fnc_GetMissionVariable;
*/

private ['_ID', '_aType', '_mVarName', '_aReturn'];
_ID = _this select 0;
_aType = _this select 1;
_mVarName = format ["%1_missionVar", _ID];
_aReturn = objNull;
// -- Get this user's array.
diag_log format ["MV: User's varname is: %1", _mVarName];
_mArray = missionNamespace getVariable _mVarName;
{
	if ((_x select 0) == (_aType)) exitwith 
	{
		_aReturn = _x select 1; // Return the contents of the array.
		diag_log format ["MV: serverGetVariable: _x select 1: %1, _x: %2", _x select 1, _x];
	};
} foreach _mArray;

_aReturn