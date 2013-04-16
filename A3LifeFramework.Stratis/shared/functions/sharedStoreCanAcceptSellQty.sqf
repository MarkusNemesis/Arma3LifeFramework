/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

sharedStoreCanAcceptSellQty script
Created: 16/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Checks whether a store can accept a quantity of that size for that item, without breaching it's stock limit for that item.
Params: ['_iName', '_qty', '_sArr']
Return: [boolCanDo, curQty, maxStock, qtyTillMax]
*/

private ['_iName', '_qty', '_curQty', '_iMaxStock', '_canDo', '_return'];
_iName = _this select 0;
_qty = _this select 1;
_sArr = _this select 2;
_canDo = false;

{
	if ((_x select 0) == _iName) exitwith 
	{
		_curQty = _x select 1;
		_iMaxStock = _x select 2;
		if ((_iMaxStock - _curQty) > _qty) then {_canDo = true};
	}; 
} foreach _sArr;

if (!isnil '_curQty') then 
{_return = [_canDo, _curQty, _iMaxStock, (_iMaxStock - _curQty)];}
else
{_return = [false]};

// -- Leave last
_return
