/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

//

arrayATMs script
Created: 27/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Contains all the ATMs in the mission.
These ATMs are pre-placed in the editor.
When you add a new ATM, you MUST add it here.
*/

private ['_Array_ATMs'];

_Array_ATMs = [
	[ATM1, [2884.44,6081.8,4.51421], 210.238]
];

if (isServer) then 
{
	(call M_S_fnc_GLV) setVariable ["Array_ATMs", _Array_ATMs];
} else {
	(call M_C_fnc_GLV) setVariable ["Array_ATMs", _Array_ATMs];
};



/*
position[]={2884.44,4.51421,6081.8};
id=51;
side="EMPTY";
vehicle="Land_CashDesk_F";
skill=0.60000002;
text="ATM1";
init="if (isServer) then {this execVM ""server\functions\serverAddProp.sqf"";};";
angle=210.238;
*/