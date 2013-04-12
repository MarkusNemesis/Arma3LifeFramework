/* sharedItemGetPrice script
Created: 04/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
Return:
*/

private ['_iName', '_vPrice', '_iArr'];

_iName = _this select 0;
_vPrice = 0;
if (isServer) then 
{
	_iArr = (call M_S_fnc_GLV) getVariable "Array_Items";
} else {
	_iArr = missionNamespace getVariable "Array_Items";
};
{
    //diag_log format ["%1 vs %2", _iName, _x2 select 0];
    if (_iName == (_x select 0)) exitwith
    {
        _vPrice = _x select 2; // Get price from item array
    };
} foreach _iArr;

_vPrice