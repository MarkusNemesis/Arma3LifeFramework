/* sharedSearchInventory script
Created: 21/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Iterates through the given inventory array, in search of the item requested.
Params: itemName, [Array inventory]
Return: Array: If found, returns item's array, else, empty array.
*/

private ['_iName', '_iArray', '_aReturn'];
_iName = _this select 0;
_iArray = _this select 1;
_aReturn = [];
{
	if (_iName == _x select 0) exitwith { // -- Item found
		_aReturn = _x;
	};
} foreach _iArray;

_aReturn