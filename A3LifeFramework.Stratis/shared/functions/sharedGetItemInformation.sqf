/* sharedGetItemInformation script
Created: 20/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Finds the passed item and returns that items array entry.
Params: 'itemName'
Return: Item array entry
*/
private ['_iName', '_return'];
_iName = _this select 0;
_return = [];

{
	if (_x select 0 == _iName) exitwith {_return = _x};
} foreach Array_Items;

_return