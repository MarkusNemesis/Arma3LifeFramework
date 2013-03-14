/* clientInteractionVehicleStore script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
Return:
*/
//[ownerObj, [[VehiclesToSell, StockLevel]], [AccessArray], themeName, StoreName];
private ['_dialogHandler','_sObj', '_sArr', '_sName'];
_sObj = _this select 0; // Store keeper object
_sArr = _sObj getVariable "storeArray";
_sName = _sObj getVariable "mouseOverText";
_dialogHandler = createdialog "ui_vehicleStore";

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

// ---- Set Frame title
ctrlSetText [1997, _sName];

// ---- Init pre-selections
lbSetCurSel [1992, 0];

// ---- Run the dialog update loop
private ['_fNo', '_lbSel', '_lbSelPrev', '_pMoney', '_pMoneyPrev', '_sCName', '_sPrice'];
_fNo = diag_frameno;
_lbSel = lbCurSel 1992;
_lbSelPrev = -1;
_pMoney = player getVariable "Money";
_pMoneyPrev = -1;
_sCName = '';
_sPrice = "ERROR";

// -- On first run, all fields in this loop will be run. Effectively initialising the controls.
while {dialog && alive player} do
{
    if (!Client_isMessageBox) then // Don't run if there's a messagebox open.
    {
	    // ---- Current Money Changed
	    _pMoney = player getVariable "Money";
	    if (_pMoney != _pMoneyPrev) then
	    {
			ctrlSetText [1994, format ["Current Money: $%1", _pMoney]];
	        _pMoneyPrev = _pMoney;
	    };
		
	    // ---- LB Selection Changed
	    _lbSel = lbCurSel 1992;
	    if (_lbSel != _lbSelPrev) then
	    {
	        // -- Get vehicle's class name
	        _sCName = (_sArr select _lbSel) select 0;
	        // -- Get the vehicle's price
	        {if ((_x select 0) == _sCName) exitwith {_sPrice = _x select 1;} } foreach Array_Vehicles;
	        
	        // -- Set Cost label
	        ctrlSetText [1995, format ["Cost: $%1", _sPrice]];
	        
	        // -- Set Money Remaining label
			ctrlSetText [1996, format ["Money Remaining: $%1", _pMoney - _sPrice]];
	        
	        // Leave last
	        _lbSelPrev = _lbSel;
	    };
	    
	    // TODO put 'setaction' for 'buy vehicle' button
		buttonsetaction [1993, format ["[%1, %2, %3, %4] call MV_Client_fnc_int_BuyVehicle", str netID _sObj, _lbSel, _sPrice, (_sArr select _lbSel) select 1]]; // NetID, Index, price, stock
    };
    // ---- Leave last
    _fNo = diag_frameno;
    waituntil {diag_frameno > _fNo;}; // Runs the dialog once per frame.
};
