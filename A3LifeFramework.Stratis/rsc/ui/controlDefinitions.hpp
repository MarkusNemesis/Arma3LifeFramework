/* controlDefinitions hpp
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: defines the controls that can be used in the the creation of dialogs.
*/
//#include ""

#define MV_COLOUR_GREEN 0, 1, 0, 1
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
	style = LB_TEXTURES;
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
	colorText[] = {MV_COLOUR_MAROON};
};

class MV_Button_sm : MV_Button
{
	idc = -1;
	sizeEx = 0.7 * GUI_GRID_H;
};

class MV_MultiLine : RscText
{
	idc = -1;
	colorText[] = {MV_COLOUR_MAROON};
	style = ST_MULTI;
	lineSpacing = 1;
};

class MV_Label : RscText
{
	idc = -1;
	style = ST_LEFT;
	colorText[] = {MV_COLOUR_MAROON};
};

class MV_LabelRight : MV_Label
{
	idc = -1;
	style = ST_RIGHT;
};

class MV_LabelCentre : MV_Label
{
	idc = -1;
	style = ST_CENTER;
};

class MV_title_InteractText : RscStructuredText
{
	idc = -1;
	style = ST_CENTER;
	colorText[] = {MV_COLOUR_GREEN};
	//colorText[] = {MV_COLOUR_MAROON};
	class Attributes 
	{
		color = "#00FF00";
		size = 0.75;
		align = "center";
		valign = "middle";
	};
};

class MV_Textbox : RscEdit
{
	idc = -1;
	style = ST_LEFT;
	colorText[] = {MV_COLOUR_MAROON};
};

class MV_SText : RscStructuredText
{
	idc = -1;
	style = ST_LEFT;
	colorText[] = {MV_COLOUR_MAROON};
	class Attributes 
	{
		color = "#C00000";
		size = 0.75;
		align = "center";
		valign = "middle";
	};
};

/*
---template

class MV_
{
	
};

*/