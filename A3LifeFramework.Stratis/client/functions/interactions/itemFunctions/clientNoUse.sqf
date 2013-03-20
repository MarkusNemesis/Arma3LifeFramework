/* clientNoUse script
Created: 20/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Outputs to the player that this item cannot be used this way.
*/

private ['_iName','_args'];
_iName = _this select 0;
_args = _this select 1;

// -- Body:
["Error", format [localize "STR_MV_INT_ERRORITEMNOUSE", _iName]] spawn MV_Client_fnc_int_MessageBox;
