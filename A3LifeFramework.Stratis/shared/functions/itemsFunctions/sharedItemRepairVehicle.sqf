/* sharedItemRepairVehicle script
Created: 25/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Repairs the vehicle based off the passed repair kit information.
Params: [repAmount, targetVeh]
Return: 
*/

// -- Get item info to get repair arguments.
private ['_rAmount', '_rLvl', '_rTarg', '_rParts'];
// -- Apply repair to vehicle. Repairs 'hitEngine' and 'hitFuel' to half. Checks if those values are < .5, if so, left alone. Replaces all wheels.
_rAmount = _this select 0;
_rTarg = _this select 1;
_rLvl = 1 - _rAmount;
_rParts = [];
if (_rAmount >= 0.1) then {_rParts = _rParts + ["LBWHEEL", "LFWHEEL", "RFWHEEL", "RBWHEEL"];};
if (_rAmount >= 0.25) then {_rParts = _rParts + ["Fuel","Engine"];};
{
	private ['_p'];
	_p = format ['Hit%1', _x];
	if ((_rTarg getHitPointDamage _p) > _rAmount) then
	{
		_rTarg setHitPointDamage [_p, (_rLvl)];
	};
} foreach _rParts;
