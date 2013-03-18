/* blank script
Created: 18/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
Return:
*/

private ['_cName', '_vPrice'];

_cName = _this select 0;
_vPrice = -1;

{
    //diag_log format ["%1 vs %2", _vCName, _x2 select 0];
    if (_vCName == (_x select 0)) exitwith
    {
        _vPrice = _x select 1; // Get price from vehicle array
    };
} foreach Array_Vehicles;

_vPrice