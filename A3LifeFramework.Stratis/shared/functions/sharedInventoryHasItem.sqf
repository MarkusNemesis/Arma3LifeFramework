/* sharedInventoryHasItem script
Created: 23/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Checks a user's clientside inventory for whether they have the passed item and the quantity (or more) of that item.
Params: ['_oInv' , '_iName', '_qty'];
Return: Bool hasItem.
*/

private ['_oInv', '_iName', '_qty', '_hasItem', '_iEntry'];
_oInv = _this select 0;
_iName = _this select 1;
_qty = _this select 2;
_hasItem = false;
 

_iEntry = [_iName, _oInv] call MV_Shared_fnc_SearchInventory;

if (!isnil "_iEntry") then
{
	if ((_iEntry select 0) == _iName && (_iEntry select 1) >= _qty) then
	{
		_hasItem = true;
	};
};

_hasItem