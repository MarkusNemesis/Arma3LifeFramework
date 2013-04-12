/* sharedGetCurrentInventoryVolume script
Created: 24/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: MV_Shared_fnc_GetCurrentInventoryVolume
Tallies up the volume of all the objects currently in the passed inventory.
Params: [_objInventory]
Return: volumeInCC
*/
diag_log format ["MV: sharedGetCurrentInventoryVolume: %1", _this];
private ['_iArray', '_rVol'];
_iArray = _this select 0;
_rVol = 0;
{
	private ['_tItemVol', '_tiQty'];
	_tItemVol = ([_x select 0] call MV_Shared_fnc_GetItemInformation) select 1;
	_tiQty = _x select 1;
	_rVol = _rVol + (_tItemVol * _tiQty);
} foreach _iArray;

diag_log format ["MV: sharedGetCurrentInventoryVolume: Return: %1", _rVol];
// Return
_rVol