/* serverCommVarEH script
Created: 14/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: CommVars are semi-public variables defined by the server, where client <> server communication can take place.
Contains a switch that handles events. 
Format: ["eventType", [Params,array,etc]];
*/

private ['_vValue', '_eType', '_vParams'];
_vValue = _this select 0;
_eType = _vValue select 0;
_vParams = _vValue select 1;

switch (_eType) do
{
    case "BuyVehicle":
    {
        private ['_sObj', '_vIndex', '_pObj', '_vCName', '_sArr', '_vPrice', '_sPos'];
        _sObj = objectFromNetId (_vParams select 0);
        _vIndex = _vParams select 1;
        _pObj = _vParams select 2;
		_sArr = _sObj getVariable "storeArrayServer";
        _vCName = (_sArr select _vIndex) select 0;
        {if ((_x select 0) == _vCName) exitwith {_vPrice = _x select 1;}} foreach Array_Vehicles; // TODO - Move this line to a shared function.
		
        ['MV_Server_fnc_BuyVehicle', [_vCName, _vPrice, _sObj, _pObj]] call MV_Server_fnc_AddEvent;
    };
    
    /*
    case "":
    {
        
    };
    */
};
