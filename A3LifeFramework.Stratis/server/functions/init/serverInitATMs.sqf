/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

//

serverInitATMs script
Created: 27/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Initialises all the ATMs defined in the Array_ATMs shared missionVariable.
Format: [ATMName, positionASL, direction]
*/

private ['_Array_ATMs'];
_Array_ATMs = (call M_S_fnc_GLV) getVariable "Array_ATMs";

{
	private ['_atm', '_pos', '_dir'];
	_atm = _x select 0;
	_pos = _x select 1;
	_dir = _x select 2;
	
	_atm setPosASL _pos;
	_atm setDir _dir;
	// -- Set object variables
	_atm setVariable ['isInteractable', true, true];
	_atm setVariable ['interactType', 'typeATM', true];
	_atm setVariable ['interactType', 'typeATM', true];
	// -- Set serverside variables
	private ['_sNetID'];
	_sNetID = netID _atm;
	(call M_S_fnc_GLV) setVariable [format ["%1_missionVar", _sNetID], []];
	[_sNetID, ["isInteractable", [true]]] call MV_Server_fnc_SetMissionVariable;
	[_sNetID, ["interactType", ["typeATM"]]] call MV_Server_fnc_SetMissionVariable;
	
	// -- Init the ATM like a prop.
	private ['_initString'];
	
	_initString = format [
	"
		_marker = createMarkerLocal ['%1marker', getposATL this]; 
		_marker setMarkerShapeLocal 'ICON'; 
		'%1marker' setMarkerTypeLocal 'mil_box'; 
		_marker setMarkerSizeLocal [0.5,0.5]; 
		'%1marker' setMarkerTextLocal 'ATM'; 
		'%1marker' setMarkerColorLocal 'ColorGreen';
		this allowdamage false; 
		this lock true; 
		clearWeaponCargo this; 
		clearMagazineCargo this; 
		clearItemCargo this; 
		if (this isKindOf 'Man') then {this switchMove 'AidlPercMstpSnonWnonDnon_Player';}; 
		this enablesimulation false;
	", _atm];
	_atm setvehicleinit _initString;
	processinitcommands;
	
} foreach _Array_ATMs;