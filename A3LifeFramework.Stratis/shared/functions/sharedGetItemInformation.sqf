/* sharedGetItemInformation script
Created: 20/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Finds the passed item and returns that items array entry.
Params: 'itemName'
Return: Item array entry
*/
private ['_iName', '_return', '_sArray'];
_iName = _this select 0;
if (isServer) then 
{
	_sArray = (call M_S_fnc_GLV) getVariable "Array_Items";
} else {
	_sArray = (call M_C_fnc_GLV) getVariable "Array_Items";
};
_return = [];

{
	if (_x select 0 == _iName) exitwith {_return = _x};
} foreach _sArray;

_return