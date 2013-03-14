/* clientInteractionVehicleStore script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
Return:
*/
//[ownerObj, [[VehiclesToSell, StockLevel]], [AccessArray], themeName, StoreName];
private ['_sObj', '_sArr', '_sName'];
_sObj = _this select 0; // Store keeper object
_sArr = _sObj getVariable "storeArray";
_sName = _sObj getVariable "mouseOverText";
createdialog "ui_vehicleStore";

// ----- Init UI controls
// -- Populate listbox
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

// -- Set Frame title
ctrlSetText [1997, _sName];

// TODO put 'setaction' for 'buy vehicle' button

// Init pre-selections
lbSetCurSel [1992, 0];

// Run the dialog update loop
private ['_fNo', '_lbSel', '_lbSelPrev'];
_fNo = diag_frameno;
_lbSel = lbCurSel 1992;
_lbSelPrev = -1;

while {dialog && alive player} do
{
    // ---- LB Selection Changed
    _lbSel = lbCurSel 1992;
    if (_lbSel != _lbSelPrev) then
    {
        private ['_sCName', '_sPrice'];
        // -- Get vehicle's class name
        _sCName = (_sArr select _lbSel) select 0;
        
        // -- Get the vehicle's price
        _sPrice = "ERROR";
        {if ((_x select 0) == _sCName) exitwith {_sPrice = _x select 1;} } foreach Array_Vehicles;
        ctrlSetText [1995, format ["Cost: $%1", _sPrice]];
        // TODO Update current money and money remaining labels
    };
    // Leave last
    _fNo = diag_frameno;
    waituntil {diag_frameno > _fNo;}; // Runs the dialog once per frame.
};

// ----- CRUDE VEHICLE SPAWN IMPLEMENTATION --------

//private ['_veh', '_classname'];
//_classname = (_sArr select lbCurSel 1992) select 0;
//buttonsetaction [1993, format ["[str %1] call MV_Client_fnc_SpawnVehicle"], _classname];
