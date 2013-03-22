/* clientRepairKitUse script
Created: 20/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
All 'use' scripts MUST exit with setting 'Client_UsingItem' to false.
Return:
*/
Client_UsingItem = true;
private ['_iName', '_qty', '_args', '_return'];
_iName = _this select 0;
_qty = _this select 1;
_args = _this select 2;

// -- Body:
private ['_repairScale', '_rTarg', '_vInfo', '_rTime'];
_repairScale = _args select 0;
_rAmount = _args select 1;
_rTime = _args select 2;
_rTarg = cursorTarget;

if (_qty > 1) then {_qty = 1}; // -- Limit Qty to 1, as you only use one at a time.

// -- Is it a vehicle?
if (!(_rTarg isKindOf "LandVehicle" or _rTarg isKindOf "Air" or _rTarg isKindOf "Ship")) exitwith {["Error", localize "STR_MV_ITEM_REPAIRKITFAILEDNOVEHICLE"] spawn MV_Client_fnc_int_MessageBox; Client_UsingItem = false;};

// -- Is it close enough?
if ((player distance _rTarg) > INT_RANGE) exitwith {["Error", localize "STR_MV_ITEM_REPAIRKITFAILEDDISTANCE"] spawn MV_Client_fnc_int_MessageBox; Client_UsingItem = false;};

// -- Is the vehicle unlocked?
if (locked _rTarg > 1) exitwith {["Error", localize "STR_MV_ITEM_REPAIRKITFAILEDLOCKED"] spawn MV_Client_fnc_int_MessageBox; Client_UsingItem = false;};

// -- Find the vehicle on the vehicles array.
_vInfo = [typeof _rTarg] call MV_Shared_fnc_GetVehicleArrayInfo;
// -- Not in the array OR it's not interactable.
if (count _vInfo == 0 or !(_rTarg getVariable "isInteractable")) exitwith {["Error", localize "STR_MV_ITEM_REPAIRKITFAILEDCANNOTREPAIR"] spawn MV_Client_fnc_int_MessageBox; Client_UsingItem = false;};

// -- Is this kit large enough?
if ((_vInfo select 3) > _repairScale) exitwith {["Error", localize "STR_MV_ITEM_REPAIRKITFAILEDINVALIDKIT"] spawn MV_Client_fnc_int_MessageBox; Client_UsingItem = false;};

// -- It's in range, it's a vehicle, it's unlocked, you have a valid kit and the vehicle is in the vehicle array. So repair it!
private ['_eTime', '_fNo', '_anim'];
_eTime = time + _rTime;
_fNo = diag_frameno;
_anim = "InBaseMoves_repairVehicleKnl";
player switchMove _anim;
while {time < _eTime} do 
{
	// -- Player stops playing the 'repair' animation. Thus, they have been interrupted. ERROR out.
	if ((animationState player) != _anim) exitwith {cutText [localize "STR_MV_ITEM_REPAIRKITFAILEDINTERRUPTED", "PLAIN"]; Client_UsingItem = false;};
	if ((player distance _rTarg) > INT_RANGE) exitwith {cutText [localize "STR_MV_ITEM_REPAIRKITFAILEDDISTANCE", "PLAIN"]; Client_UsingItem = false;};
	
	// -- Leave last
	waitUntil {_fNo < diag_frameno};
	_fNo = diag_frameno;
};
// -- If the client got interrupted, this'll be false. So, exit the script.
if (!Client_UsingItem) exitwith {};

// -- Leave last
// -- Reset user animation
player switchMove "";

// -- Action successful, repair vehicle.
// -- Get item info to get repair arguments.
private ['_iInfo', '_rLvl', '_rParts'];
_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
// -- Apply repair to vehicle. Repairs 'hitEngine' and 'hitFuel' to half. Checks if those values are < .5, if so, left alone. Replaces all wheels.
_rAmount = (_iInfo select 3) select 1;
_rLvl = 1 - _rAmount;
_rParts = [];
if (_rAmount >= 0.1) then {_rParts = _rParts + ["LBWHEEL", "LFWHEEL", "RFWHEEL", "RBWHEEL"];};
if (_rAmount >= 0.25) then {_rParts = _rParts + ["Fuel","Engine"];};
// -- Set vehicle to be owned by the server.
{
	private ['_p'];
	_p = format ['Hit%1', _x];
	if ((_rTarg getHitPointDamage _p) > _rAmount) then
	{
		_rTarg setHitPointDamage [_p, (_rLvl)];
	};
} foreach _rParts;

// -- Remove item from player inventory
["RemoveItem", [netID player, _iName, _qty]] call MV_Client_fnc_SendServerMessage;
Client_UsingItem = false;