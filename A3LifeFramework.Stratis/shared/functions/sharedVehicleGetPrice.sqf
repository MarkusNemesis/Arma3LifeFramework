/* sharedVehicleGetPrice script
Created: 18/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
Return:
*/

private ['_cName', '_vPrice', '_arrV'];

_cName = _this select 0;
_vPrice = 0;
_arrV = missionNamespace getVariable "Array_Vehicles";
{
    //diag_log format ["%1 vs %2", _cName, _x2 select 0];
    if (_cName == (_x select 0)) exitwith
    {
        _vPrice = _x select 1; // Get price from vehicle array
    };
} foreach _arrV;

_vPrice