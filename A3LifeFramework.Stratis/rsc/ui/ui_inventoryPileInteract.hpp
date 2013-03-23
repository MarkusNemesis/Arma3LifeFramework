class ui_inventoryPileInteract
{
	idd = 1411;
	movingEnable = false;
	enableSimulation = true;
	onLoad = "uiNamespace setVariable ['inventoryPile_isDisplayed', true];";
	onUnload = "uiNamespace setVariable ['inventoryPile_isDisplayed', false];";
	controlsBackground[] = 
	{
		BG,
		BG_Frame,
		Inv_Frame,
		Pile_Frame
	};
	controls[]=
	{
		LbxInv,
		LbxPile,
		cmdToPile,
		cmdToInventory,
		lblInvCapacity,
		lblPileCapacity,
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
	class BG_Frame: MV_GUIFrame
	{
		idc = -1;
		x = 0.4 * GUI_GRID_W + GUI_GRID_X;
		y = 0.4 * GUI_GRID_H + GUI_GRID_Y;
		w = 39.2 * GUI_GRID_W;
		h = 24.2 * GUI_GRID_H;
	};
	class Inv_Frame: MV_GUIFrame
	{
		idc = -1;
		text = $STR_MV_DG_INVENTORY;
		x = 0.4 * GUI_GRID_W + GUI_GRID_X;
		y = 1.1 * GUI_GRID_H + GUI_GRID_Y;
		w = 15.6 * GUI_GRID_W;
		h = 23.5 * GUI_GRID_H;
	};
	class Pile_Frame: MV_GUIFrame
	{
		idc = -1;
		text = $STR_MV_DG_PILE;
		x = 24 * GUI_GRID_W + GUI_GRID_X;
		y = 1.1 * GUI_GRID_H + GUI_GRID_Y;
		w = 15.6 * GUI_GRID_W;
		h = 23.5 * GUI_GRID_H;
	};
	class LbxInv: MV_ListBox
	{ // -- Inventory box
		idc = 2009;
		x = 1 * GUI_GRID_W + GUI_GRID_X;
		y = 1.6 * GUI_GRID_H + GUI_GRID_Y;
		w = 14 * GUI_GRID_W;
		h = 21.4 * GUI_GRID_H;
	};
	class LbxPile: MV_ListBox
	{ // -- Pile box
		idc = 2010;
		x = 25 * GUI_GRID_W + GUI_GRID_X;
		y = 1.6 * GUI_GRID_H + GUI_GRID_Y;
		w = 14.1 * GUI_GRID_W;
		h = 21.4 * GUI_GRID_H;
	};
	class cmdToPile: MV_Button
	{
		idc = 2011;
		text = $STR_MV_DG_TOPILE;
		x = 16.6 * GUI_GRID_W + GUI_GRID_X;
		y = 8 * GUI_GRID_H + GUI_GRID_Y;
		w = 6.8 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
		action = "uiNamespace setVariable ['inventoryPile_cmdToPile', true];";
	};
	class cmdToInventory: MV_Button
	{
		idc = 2012;
		text = $STR_MV_DG_TOINVENTORY;
		x = 16.65 * GUI_GRID_W + GUI_GRID_X;
		y = 10.96 * GUI_GRID_H + GUI_GRID_Y;
		w = 6.8 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
		action = "uiNamespace setVariable ['inventoryPile_cmdToInventory', true];";
	};
	class lblInvCapacity: MV_LabelCentre
	{
		idc = 2013;
		x = 1 * GUI_GRID_W + GUI_GRID_X;
		y = 23.3 * GUI_GRID_H + GUI_GRID_Y;
		w = 14 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class lblPileCapacity: MV_LabelCentre
	{
		idc = 2014;
		x = 25 * GUI_GRID_W + GUI_GRID_X;
		y = 23.3 * GUI_GRID_H + GUI_GRID_Y;
		w = 14 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	
	class txtQty: MV_Textbox
	{
		idc = 2015;
		x = 17 * GUI_GRID_W + GUI_GRID_X;
		y = 14.1 * GUI_GRID_H + GUI_GRID_Y;
		w = 6 * GUI_GRID_W;
		h = 0.9 * GUI_GRID_H;
	};
	class lblQty: MV_LabelCentre
	{
		idc = 2016;
		text = $STR_MV_DG_QTY;
		x = 17 * GUI_GRID_W + GUI_GRID_X;
		y = 13 * GUI_GRID_H + GUI_GRID_Y;
		w = 5.8 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	
};