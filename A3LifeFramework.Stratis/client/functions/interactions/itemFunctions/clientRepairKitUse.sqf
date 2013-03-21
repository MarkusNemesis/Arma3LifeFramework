/* clientRepairKitUse script
Created: 20/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
All 'use' scripts MUST exit with setting 'Client_UsingItem' to false.
Return:
*/
Client_UsingItem = true;
private ['_iName','_args', '_return'];
_iName = _this select 0;
_args = _this select 1;

// -- Body:
private ['_repairScale', '_rTarg', '_vInfo'];
_repairScale = _args select 0;
_rTarg = cursorTarget;

// -- Is it close enough?
if ((player distance _rTarg) > INT_RANGE) exitwith {["Error", localize "STR_MV_ITEM_REPAIRKITFAILEDDISTANCE"] spawn MV_Client_fnc_int_MessageBox; Client_UsingItem = false;};

// -- Is it a vehicle?
if (!(_rTarg isKindOf "LandVehicle" or _rTarg isKindOf "Air" or _rTarg isKindOf "Ship")) exitwith {["Error", localize "STR_MV_ITEM_REPAIRKITFAILEDNOVEHICLE"] spawn MV_Client_fnc_int_MessageBox; Client_UsingItem = false;};

// -- Is the vehicle unlocked?
if (locked _rTarg > 1) exitwith {["Error", localize "STR_MV_ITEM_REPAIRKITFAILEDLOCKED"] spawn MV_Client_fnc_int_MessageBox; Client_UsingItem = false;};

// -- Find the vehicle on the vehicles array.
_vInfo = [typeof _rTarg] call MV_Shared_fnc_GetVehicleArrayInfo;
if (count _vInfo == 0) exitwith {["Error", localize "STR_MV_ITEM_REPAIRKITFAILEDCANNOTREPAIR"] spawn MV_Client_fnc_int_MessageBox; Client_UsingItem = false;};



// -- Leave last
Client_UsingItem = false;