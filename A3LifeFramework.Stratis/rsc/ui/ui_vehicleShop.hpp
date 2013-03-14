////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Radioman, v1.061, #Fepefy)
////////////////////////////////////////////////////////

#define GUI_GRID_X	(0)
#define GUI_GRID_Y	(0)
#define GUI_GRID_W	(0.025)
#define GUI_GRID_H	(0.04)
#define GUI_GRID_WAbs	(1)
#define GUI_GRID_HAbs	(1)

class ui_vehicleStore
{
	idd = 1408;
	movingEnable = false;
	enableSimulation = true;
	controlsBackground[] = 
	{
		BG,
		BGFrame,
	};
	objects[] = {};
	controls[]=
	{
		
		lbxForSale,
		cmdBuy,
		lblCurrentMoney,
		lblCurrentCost,
		lblRemaining
	};
	
	class BG: MV_GUIBackground
	{
		idc = -1;
		x = 0 * GUI_GRID_W + GUI_GRID_X;
		y = 0 * GUI_GRID_H + GUI_GRID_Y;
		w = 40 * GUI_GRID_W;
		h = 25 * GUI_GRID_H;
	};
	class BGFrame: MV_GUIFrame
	{
		idc = 1997;
		text = "Vehicle Store"; //--- ToDo: Localize;
		x = 0.5 * GUI_GRID_W + GUI_GRID_X;
		y = 0.3 * GUI_GRID_H + GUI_GRID_Y;
		w = 39 * GUI_GRID_W;
		h = 24.1 * GUI_GRID_H;
		sizeEx = 0.6 * GUI_GRID_H;
	};
	class lbxForSale: MV_ListBox
	{
		idc = 1992;
		x = 1 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 11 * GUI_GRID_W;
		h = 21 * GUI_GRID_H;
		sizeEx = 0.6 * GUI_GRID_H;
	};
	class cmdBuy: MV_Button
	{
		idc = 1993;
		text = "Buy Selected"; //--- ToDo: Localize;
		x = 3 * GUI_GRID_W + GUI_GRID_X;
		y = 22.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 7 * GUI_GRID_W;
		h = 1.5 * GUI_GRID_H;
	};
	class lblCurrentMoney: MV_LabelRight
	{
		idc = 1994;
		text = "Current Money: $0"; //--- ToDo: Localize;
		x = 13 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 7.9 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		sizeEx = 0.6 * GUI_GRID_H;
	};
	class lblCurrentCost: MV_LabelRight
	{
		idc = 1995;
		text = "Current Cost: $0"; //--- ToDo: Localize;
		x = 13 * GUI_GRID_W + GUI_GRID_X;
		y = 2 * GUI_GRID_H + GUI_GRID_Y;
		w = 7.9 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		sizeEx = 0.6 * GUI_GRID_H;
	};
	class lblRemaining: MV_LabelRight
	{
		idc = 1996;
		text = "Money Remaining: $0"; //--- ToDo: Localize;
		x = 13 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 7.9 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		sizeEx = 0.6 * GUI_GRID_H;
	};
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
