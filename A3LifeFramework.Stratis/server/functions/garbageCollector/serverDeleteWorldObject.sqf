/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

serverDeleteWorldObject script
Created: 12/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Deletes a world object.
Remove object from the Garbage collector (if present)
call 'onRemove' script stored within it (in mission var)
TODO TODO TODO clear object's variables via simply searching for it's netID and setting the object's array to objnull and removing it from the array.
TODO implement 'onRemove' script and store in created objects.
Params: [Obj, garbagecollectorAction]
Return: 
*/
diag_log format ["MV: serverDeleteWorldObject: %1", _this];
private ['_dObj', '_gcA'];

_dObj = _this select 0; // object
//_gcA = _this select 1; // bool

// -- Remove object from garbage collector, if not a gcA (garbage collector Action) TODO


// -- Run object's 'onRemove' function from it's mission var. TODO


// -- Remove the object's variable array. TODO


// -- Remove the object
private ['_crw'];
_crw = crew _dObj;
{
	if ((!isPlayer _x) && (damage _x < 1)) then {[_x] call MV_Server_fnc_DeleteWorldObject;} else {_x action ["getOut", _dObj]; unassignVehicle _x;};
} foreach _crw;

unassignVehicle _dObj; // Maybe replace with leaveVehicle. Functionality is unclear.
_dObj setPos [-1000,-1000,-1000];
deleteVehicle _dObj;