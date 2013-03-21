/* clientBlankUse script
Created: 20/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
All 'use' scripts MUST exit with setting 'Client_UsingItem' to false.
Return:
*/
Client_UsingItem = true;
private ['_iName','_args', '_return'];
_iName = _this select 0;
_args = _this select 1;

// -- Body:


// -- Leave last
Client_UsingItem = false;