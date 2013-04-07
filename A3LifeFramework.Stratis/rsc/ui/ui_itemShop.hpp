/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

*/

class ui_itemShop
{
	idd = 1414;
	movingEnable = false;
	enableSimulation = true;
	//onLoad = "uiNamespace setVariable ['blank_isDisplayed', true];";
	//onUnload = "uiNamespace setVariable ['blank_isDisplayed', false];";
	controlsBackground[] = 
	{
		MVBG1,
		MVFRM1,
		MVBG2,
		MVFRM2,
		MVFRM3,
		MVFRM4
	};
	controls[]=
	{
		lbxInvSelect,
		txtQty,
		cmdBuySell,
		cmdToggleMode,
		stxtInfo,
		lblQty,
		lbxInventoryStore
	};
	// -- Body
	
	////////////////////////////////////////////////////////
	// GUI EDITOR OUTPUT START (by Radioman, v1.061, #Qyfyhy)
	////////////////////////////////////////////////////////

	class MVBG1: MV_GUIBackground
	{
		idc = -1;
		x = 11 * GUI_GRID_W + GUI_GRID_X;
		y = 0 * GUI_GRID_H + GUI_GRID_Y;
		w = 29 * GUI_GRID_W;
		h = 25 * GUI_GRID_H;
	};
	class MVFRM1: MV_GUIFrame
	{
		idc = -1;
		text = "StoreName"; //--- ToDo: Localize;
		x = 11.4 * GUI_GRID_W + GUI_GRID_X;
		y = 0.4 * GUI_GRID_H + GUI_GRID_Y;
		w = 28.2 * GUI_GRID_W;
		h = 24.2 * GUI_GRID_H;
	};
	class MVBG2: MV_GUIBackground
	{
		idc = -1;
		x = 0 * GUI_GRID_W + GUI_GRID_X;
		y = 0 * GUI_GRID_H + GUI_GRID_Y;
		w = 10 * GUI_GRID_W;
		h = 12.7 * GUI_GRID_H;
	};
	class MVFRM2: MV_GUIFrame
	{// -- Select inventory frame
		idc = -1;
		text = "Select Inventory"; //--- ToDo: Localize;
		x = 0.5 * GUI_GRID_W + GUI_GRID_X;
		y = 0.4 * GUI_GRID_H + GUI_GRID_Y;
		w = 9 * GUI_GRID_W;
		h = 9 * GUI_GRID_H;
	};
	class lbxInvSelect: MV_ListBox
	{// -- select inventory
		idc = 2023;
		x = 1 * GUI_GRID_W + GUI_GRID_X;
		y = 1 * GUI_GRID_H + GUI_GRID_Y;
		w = 8 * GUI_GRID_W;
		h = 8.1 * GUI_GRID_H;
		sizeEx = 0.7 * GUI_GRID_H;
		onLBSelChanged = "uiNamespace setVariable ['itemShop_lbxInvSelect_lbxSelChanged', true];";
	};
	class MVFRM4: MV_GUIFrame
	{// -- frame for selected inventory / store stock.
		idc = 2029;
		text = "Inventory/Store"; //--- ToDo: Localize;
		x = 11.4 * GUI_GRID_W + GUI_GRID_X;
		y = 1.2 * GUI_GRID_H + GUI_GRID_Y;
		w = 14.6 * GUI_GRID_W;
		h = 23.4 * GUI_GRID_H;
	};
	class txtQty: MV_Textbox
	{// -- Quantity text box.
		idc = 2024;
		text = 1;
		x = 27.2 * GUI_GRID_W + GUI_GRID_X;
		y = 3 * GUI_GRID_H + GUI_GRID_Y;
		w = 8.8 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		onKeyDown = "uiNamespace setVariable ['itemShop_txtQtyChanged', true];";
	};
	class cmdBuySell: MV_Button
	{// -- Buys/sells the selected item at the entered qty.
		idc = 2025;
		text = "Buy"; //--- ToDo: Localize;
		x = 27 * GUI_GRID_W + GUI_GRID_X;
		y = 4 * GUI_GRID_H + GUI_GRID_Y;
		w = 8.9 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
		action = "uiNamespace setVariable ['itemShop_cmdBuySell', true];";
	};
	class MVFRM3: MV_GUIFrame
	{// -- Mode frame.
		idc = -1;
		text = "Mode"; //--- ToDo: Localize;
		x = 0.5 * GUI_GRID_W + GUI_GRID_X;
		y = 9.4 * GUI_GRID_H + GUI_GRID_Y;
		w = 9 * GUI_GRID_W;
		h = 3 * GUI_GRID_H;
	};
	class cmdToggleMode: MV_Button
	{// -- Switches the mode of the UI between buy and sell modes.
		idc = 2026;
		text = "To Buy Mode"; //--- ToDo: Localize;
		x = 1 * GUI_GRID_W + GUI_GRID_X;
		y = 10 * GUI_GRID_H + GUI_GRID_Y;
		w = 8 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
		action = "uiNamespace setVariable ['itemShop_cmdToggleMode', true];";
	};
	class stxtInfo: MV_SText
	{// -- Output of what's being bought, what the total cost/value is, what the total volume is, destination inventory.
		idc = 2027;
		x = 27.1 * GUI_GRID_W + GUI_GRID_X;
		y = 7 * GUI_GRID_H + GUI_GRID_Y;
		w = 11.8 * GUI_GRID_W;
		h = 17 * GUI_GRID_H;
		class Attributes 
		{
			color = "#C00000";
			size = 0.75;
			align = "left";
			valign = "middle";
		};
	};
	class lblQty: MV_Label
	{// -- Text input for quantity to buy/sell
		idc = -1;
		text = "Quantity:"; //--- ToDo: Localize;
		x = 27.1 * GUI_GRID_W + GUI_GRID_X;
		y = 1.9 * GUI_GRID_H + GUI_GRID_Y;
		w = 9 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
	};
	class lbxInventoryStore: MV_ListBox
	{// -- Listbox for selected inventory / store stock.
		idc = 2028;
		x = 12 * GUI_GRID_W + GUI_GRID_X;
		y = 2 * GUI_GRID_H + GUI_GRID_Y;
		w = 13.5 * GUI_GRID_W;
		h = 22 * GUI_GRID_H;
		sizeEx = 0.7 * GUI_GRID_H;
		onLBSelChanged = "uiNamespace setVariable ['itemShop_lbxInventoryStore_lbxSelChanged', true];";
	};
	////////////////////////////////////////////////////////
	// GUI EDITOR OUTPUT END
	////////////////////////////////////////////////////////
};