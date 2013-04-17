// -- Put the line below in your initline. this, brightess, ambient, colour, offset 
[this, 0.002, [50, 45, 35], [50, 45, 35], [0, 0, 0]] call compile preprocessFileLineNumbers "initLamp.sqf";

// -- Put the script below into "initLamp.sqf"
/*
initLamp script
Created: 18/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: Creates a light source on the passed object, using the passed values for parameters.
initline: [this, 0.002, [50, 45, 35], [50, 45, 35], [0, 0, 0]] call compile preprocessFileLineNumbers "initLamp.sqf";
Params: object, brightess, ambient, colour, offset 
*/
// -- Script start
private ['_obj', '_lBright', '_lAmb', '_lColour', '_lOffset', '_light'];

_obj = _this select 0;
_lBright = _this select 1;
_lAmb = _this select 2;
_lColour = _this select 3;
_lOffset = _this select 4;

_light = "#lightpoint" createVehicle getpos _obj;
_light setLightBrightness _lBright; 
_light setLightAmbient _lAmb; 
_light setLightColor _lColour; 
_light lightAttachObject [_obj, _lOffset];
// -- Script end