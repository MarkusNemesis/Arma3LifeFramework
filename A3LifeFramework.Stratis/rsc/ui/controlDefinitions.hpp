/* controlDefinitions hpp
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: defines the controls that can be used in the the creation of dialogs.
*/
//#include ""

#define MV_COLOUR_MAROON 0.75, 0, 0, 1
#define MV_COLOUR_DARKMIDGREY 0.25, 0.25, 0.25, 0.75
#define MV_COLOUR_DARKGREY 0.1, 0.1, 0.1, 0.75


//#define MV_COLOUR_

class MV_GUIBackground : RscText
{
	access = 0;
	type = CT_STATIC;
	style = ST_BACKGROUND;
	idc = -1;
	colorBackground[] = {MV_COLOUR_DARKGREY};
	colorText[] = {MV_COLOUR_MAROON};
};

class MV_GUIFrame : RscFrame
{
	idc = -1;
	style = ST_FRAME;
	shadow = 2;
	colorBackground[] = {MV_COLOUR_DARKGREY};
	colorText[] = {MV_COLOUR_MAROON};
	sizeEx = 0.02;
	text = "";
};

class MV_ListBox : RscListbox
{
	idc = -1;
	style = LB_MULTI;
	colorBackground[] = {MV_COLOUR_DARKMIDGREY};
	colorText[] = {MV_COLOUR_MAROON};
	
	arrowEmpty = "#(argb,8,8,3)color(0.75, 0, 0, 1)";
	arrowFull = "#(argb,8,8,3)color(0.75, 0, 0, 1)";
	
	class ScrollBar
	 {
		color[] = {MV_COLOUR_DARKMIDGREY};
		colorActive[] = {MV_COLOUR_DARKMIDGREY};
		colorDisabled[] = {MV_COLOUR_DARKGREY};
		thumb = "#(argb,8,8,3)color(0.1, 0.1, 0.1, 1)";
		arrowEmpty = "#(argb,8,8,3)color(0.75, 0, 0, 1)";
		arrowFull = "#(argb,8,8,3)color(0.75, 0, 0, 1)";
		border = "#(argb,8,8,3)color(0.25, 0.25, 0.25, 1)";
		shadow = 0;
	 };
};

class MV_Button : RscButton
{
	idc = -1;
	type = CT_BUTTON;
	style = ST_CENTER;
	
};

class MV_Label : RscText
{
	idc = -1;
	colorText[] = {MV_COLOUR_MAROON};
};

class MV_LabelRight : MV_Label
{
	idc = -1;
	style = ST_RIGHT;
};

/*
---template

class MV_
{
	
};

*/