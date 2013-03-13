/* clientInteractionVehicleStore script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
Return:
*/
//[ownerObj, [[VehiclesToSell, StockLevel]], [AccessArray], themeName, StoreName];
private ['_sObj', '_sArr'];
_sObj = _this select 0; // Store keeper object
_sArr = _sObj getVariable "storeArray";

createdialog "ui_vehicleStore";

{
    private ['_found', '_x1', '_x2','_text', '_vCName', '_vTName', '_vPrice', '_vStock'];
    _x1 = _x;
    
    _found = false;
    _text = '';
    _vCName = _x1 select 0;
    _vTName = '';
    _vPrice = '';
    _vStock = 0;
    
    // TODO move this to a function sharedVehicleFetchPrice
    
    {
        _x2 = _x;
        diag_log format ["%1 vs %2", _vCName, _x2 select 0];
        if (_vCName == (_x2 select 0)) then
        {
            _vPrice = _x2 select 1; // Get price from vehicle array
            _vStock = _x1 select 1; // Get stock from store array
            _found = true;
        };
        if (_found) exitwith {};
    } foreach Array_Vehicles;
    
    _vTName = getText (configFile >> 'CfgVehicles' >> _vCName >> "displayName");
    
    _text = format ["%1, Stock: %2, $%3", _vTName, _vStock, _vPrice];
    lbAdd [1992, _text];
} foreach _sArr;

// ----- CRUDE VEHICLE SPAWN IMPLEMENTATION --------

//private ['_veh', '_classname'];
//_classname = (_sArr select lbCurSel 1992) select 0;
//buttonsetaction [1993, format ["[str %1] call MV_Client_fnc_SpawnVehicle"], _classname];
