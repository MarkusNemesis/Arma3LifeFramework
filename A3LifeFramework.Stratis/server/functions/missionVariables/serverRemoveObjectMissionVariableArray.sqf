/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

//

serverRemoveObjectMissionVariableArray script
Created: 16/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Removes the passed netID's variable array.
MV_Server_fnc_RemoveObjectMissionVariableArray
Params: 
Return: [ObjnetID]
*/

diag_log format ['MV: serverRemoveObjectMissionVariableArray: %1, Object: %2', _this, objectFromNetId (_this select 0)];
private ['_lObj', '_ID', '_obj', '_mVarName'];
_lObj = (call M_S_fnc_GLV);
_ID = _this select 0;
// -- Am I dealing with a player?
_obj = (objectFromNetId _ID);
if (isPlayer _obj) then {
	if ([_obj] call MV_Shared_fnc_isPlayerOnFoot) then 
	{
		_ID = getPlayerUID _obj;
	};
};

_mVarName = format ["%1_missionVar", _ID];

// -- Get this user's array.
diag_log format ["MV: serverRemoveObjectMissionVariableArray: Deleting Varname %1", _mVarName];
_mArray = _lObj setVariable [_mVarName, nil];