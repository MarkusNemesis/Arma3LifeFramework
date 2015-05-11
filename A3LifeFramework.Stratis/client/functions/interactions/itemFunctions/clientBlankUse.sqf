/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

//

clientBlankUse script
Created: 17/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: 
All 'use' scripts MUST exit with setting 'Client_UsingItem' to false.
Return:
*/
Client_UsingItem = true;
private ['_iName','_args'];
_iName = _this select 0;
_args = _this select 1;

// -- Body:


// -- Leave last
Client_UsingItem = false;