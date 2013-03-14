////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Radioman, v1.061, #Baxyme)
////////////////////////////////////////////////////////

class ui_messageBox1 {
	idd = 1409;
	movingEnable = false;
	enableSimulation = true;
	onUnload = "Client_isMessageBox = false;";
	controlsBackground[] = 
	{
		MBX_BG,
		MBX_Frame,
	};
	objects[] = {};
	controls[]=
	{
		MBX_Text,
		MBX_Button
	};
	
	class MBX_BG: MV_GUIBackground
	{
		idc = -1;
		x = 10 * GUI_GRID_W + GUI_GRID_X;
		y = 9 * GUI_GRID_H + GUI_GRID_Y;
		w = 20 * GUI_GRID_W;
		h = 8 * GUI_GRID_H;
	};
	class MBX_Frame : MV_GUIFrame
	{
		idc = 1997;
		x = 10.3 * GUI_GRID_W + GUI_GRID_X;
		y = 9.3 * GUI_GRID_H + GUI_GRID_Y;
		w = 19.5 * GUI_GRID_W;
		h = 7.5 * GUI_GRID_H;
		sizeEx = 0.6 * GUI_GRID_H;
	};
	class MBX_Text: MV_MultiLine
	{
		idc = 1998;
		x = 11 * GUI_GRID_W + GUI_GRID_X;
		y = 10 * GUI_GRID_H + GUI_GRID_Y;
		w = 18 * GUI_GRID_W;
		h = 4.2 * GUI_GRID_H;
		sizeEx = 0.6 * GUI_GRID_H;
		style = ST_CENTER;
	};
	class MBX_Button: MV_Button
	{
		idc = 1999;
		x = 16.6 * GUI_GRID_W + GUI_GRID_X;
		y = 14.8 * GUI_GRID_H + GUI_GRID_Y;
		w = 6.9 * GUI_GRID_W;
		h = 1.5 * GUI_GRID_H;
		sizeEx = 0.6 * GUI_GRID_H;
		text = "Okay";
		action = "closeDialog 0;";
	};
};