/* sharedItemGetPrice script
Created: 04/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
Return:
*/

private ['_iName', '_vPrice'];

_iName = _this select 0;
_vPrice = 0;

{
    //diag_log format ["%1 vs %2", _iName, _x2 select 0];
    if (_iName == (_x select 0)) exitwith
    {
        _vPrice = _x select 1; // Get price from item array
    };
} foreach missionNamespace getVariable "Array_Items";

_vPrice