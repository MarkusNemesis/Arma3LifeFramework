/* serverBuyVehicle script
Created: 14/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Manages the charging, creation and initialisation of client bought vehicles.
*/
//[_vCName, _vPrice, _sPos, _sObj, _playerSlot];
/*
1. Deduct price from player's 'money' variable. create function "serverUpdatePlayerMoney.sqf"
2. Update store's stock level. create function "serverUpdateStoreArray" which reimposes the entire array (Dirty, but maintains indexes etc).
3. 
4. 
*/
private ['_vCName', '_vPrice', '_sPos', '_sObj', '_pObj'];

_vCName = _this select 0;
_vPrice = _this select 1;
_sPos = _this select 2;
_sObj = _this select 3;
_pObj = _this select 4;

// TODO finish this function.