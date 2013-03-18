/* serverSetVariable script
Created: 19/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Sets serverside only variables.
1. Searches for pre-existing entries.
1.1 Updates entry as if it were a setVariable command.
2. If entry doesn't exist, creates a new one. via [	['arrayType1', [content, of, variable]	], ['arrayType2', [content, of, variable]	]	];
Params: ['netID/UID', ['arrayType', [content,array,etc]];
Example: [_sNetID, ["isInteractable", [true]]] call MV_Server_fnc_SetMissionVariable;

Objects need to init their variable before it can be used: Use missionNamespace setVariable [format ["%1_missionVar", id], []];
*/

private ['_ID', '_args', '_mVarName','_mArray', '_found'];

_ID = _this select 0;
_args = _this select 1;
_mVarName = format ["%1_missionVar", _ID];
_found = false;
_mArray = [];
// -- Find the array that contains the type of array we're after.
//diag_log format ["MV: User's varname is: %1", _mVarName];
_mArray = missionNamespace getVariable _mVarName;
{
	if ((_x select 0) == (_args select 0)) exitwith 
	{
		_mArray set [_foreachindex, _args];
		_found = true;
	};
} foreach _mArray;

// -- If it's not found, then just tack the 'set' to the end of the array.
if (!_found) then 
{
	_mArray set [count _mArray, _args];
};

// -- Finally, set the missionNamespace variable again.
missionNamespace setVariable [_mVarName, _mArray];