////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Radioman, v1.061, #Wopohu)
////////////////////////////////////////////////////////
class ui_inventory
{
	idd = 1410;
	movingEnable = false;
	enableSimulation = true;
	onLoad = "uiNamespace setVariable ['inventory_isDisplayed', true];";
	onUnload = "uiNamespace setVariable ['inventory_isDisplayed', false];";
	controlsBackground[] = 
	{
		BG,
		frmBGFrame,
		frmControls,
	};
	controls[]=
	{
		lbxInventoryList,
		lblItems,
		stxtSelItemInfobox,
		cmdUse,
		cmdDrop,
		txtQty,
		lblQty
	};

	class BG: MV_GUIBackground
	{
		idc = -1;
		x = 0 * GUI_GRID_W + GUI_GRID_X;
		y = 0 * GUI_GRID_H + GUI_GRID_Y;
		w = 40 * GUI_GRID_W;
		h = 25 * GUI_GRID_H;
	};
	class frmBGFrame: MV_GUIFrame
	{
		idc = -1;
		x = 0.5 * GUI_GRID_W + GUI_GRID_X;
		y = 0.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 39 * GUI_GRID_W;
		h = 24 * GUI_GRID_H;
		text = $STR_MV_DG_INVENTORY;
	};
	class lbxInventoryList: MV_ListBox
	{
		idc = 2001;
		x = 1.5 * GUI_GRID_W + GUI_GRID_X;
		y = 2 * GUI_GRID_H + GUI_GRID_Y;
		w = 13 * GUI_GRID_W;
		h = 22 * GUI_GRID_H;
		onLBSelChanged = "uiNamespace setVariable ['inventory_lbxSelChanged', true];";
	};
	class lblItems: MV_Label
	{
		idc = 2002;
		x = 1.5 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 6 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		text = $STR_MV_DG_ITEMS;
	};
	class stxtSelItemInfobox: MV_SText
	{
		idc = 2003;
		x = 15 * GUI_GRID_W + GUI_GRID_X;
		y = 2 * GUI_GRID_H + GUI_GRID_Y;
		w = 14 * GUI_GRID_W;
		h = 8 * GUI_GRID_H;
	};
	class cmdUse: MV_Button_sm
	{
		idc = 2004;
		text = $STR_MV_DG_USE;
		x = 31 * GUI_GRID_W + GUI_GRID_X;
		y = 2 * GUI_GRID_H + GUI_GRID_Y;
		w = 5.9 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
		action = "uiNamespace setVariable ['inventory_cmdUse', true];";
	};
	class cmdDrop: MV_Button_sm
	{
		idc = 2005;
		text = $STR_MV_DG_DROP;
		x = 31 * GUI_GRID_W + GUI_GRID_X;
		y = 4.3 * GUI_GRID_H + GUI_GRID_Y;
		w = 5.9 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
		action = "uiNamespace setVariable ['inventory_cmdDrop', true];";
	};
	class txtQty: MV_Textbox
	{
		idc = 2006;
		x = 31 * GUI_GRID_W + GUI_GRID_X;
		y = 8 * GUI_GRID_H + GUI_GRID_Y;
		w = 6 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		text = 1;
	};
	class lblQty: MV_Label
	{
		idc = 2007;
		text = $STR_MV_DG_QTY;
		x = 30.9 * GUI_GRID_W + GUI_GRID_X;
		y = 7.1 * GUI_GRID_H + GUI_GRID_Y;
		w = 4 * GUI_GRID_W;
		h = 0.7 * GUI_GRID_H;
	};
	class frmControls: MV_GUIFrame
	{
		idc = 2008;
		x = 30 * GUI_GRID_W + GUI_GRID_X;
		y = 1.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 8 * GUI_GRID_W;
		h = 8.5 * GUI_GRID_H;
		text = $STR_MV_DG_ACTIONS;
	};

};

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
