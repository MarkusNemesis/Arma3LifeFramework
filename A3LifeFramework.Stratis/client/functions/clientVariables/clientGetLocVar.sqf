/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

clientGetLocVar script
Created: 13/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Gets the location variable name from UI Namespace, then compiles it down to an object, then returns it.
Params: 
Return: clientLocVar
*/

private ['_sLoc'];

_sLoc = (uiNamespace getVariable "client_LocObj");
call compile format ["_sLoc = %1;", _sLoc];

_sLoc