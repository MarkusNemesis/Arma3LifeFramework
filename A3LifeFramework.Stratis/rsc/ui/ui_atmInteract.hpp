/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

*/

class ui_atmInteract
{
	idd = 1412;
	movingEnable = false;
	enableSimulation = true;
	//onLoad = "uiNamespace setVariable ['blank_isDisplayed', true];";
	//onUnload = "uiNamespace setVariable ['blank_isDisplayed', false];";
	controlsBackground[] = 
	{
		BG,
		BGFrame
	};
	controls[]=
	{
		cmdWithdraw,
		cmdDeposit,
		txtInput,
		stxtAccBalance,
		stxtWalletBalance
	};
	// -- Body

	class BG: MV_GUIBackground
	{
		idc = -1;
		x = 12 * GUI_GRID_W + GUI_GRID_X;
		y = 9.5 * GUI_GRID_H + GUI_GRID_Y;
		w = 14.5 * GUI_GRID_W;
		h = 7.7 * GUI_GRID_H;
	};
	class BGFrame: MV_GUIFrame
	{
		idc = -1;
		x = 12.5 * GUI_GRID_W + GUI_GRID_X;
		y = 10 * GUI_GRID_H + GUI_GRID_Y;
		w = 13.5 * GUI_GRID_W;
		h = 6.7 * GUI_GRID_H;
		text = $STR_MV_DG_ATMTITLE;
	};
	class cmdWithdraw: MV_Button
	{
		idc = 2017;
		text = $STR_MV_DG_WITHDRAW;
		x = 19.5 * GUI_GRID_W + GUI_GRID_X;
		y = 14 * GUI_GRID_H + GUI_GRID_Y;
		w = 6 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
		action = "uiNamespace setVariable ['atm_cmdWithdraw', true];";
	};
	class cmdDeposit: MV_Button
	{
		idc = 2018;
		text = $STR_MV_DG_DEPOSIT;
		x = 13 * GUI_GRID_W + GUI_GRID_X;
		y = 14 * GUI_GRID_H + GUI_GRID_Y;
		w = 6 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
		action = "uiNamespace setVariable ['atm_cmdDeposit', true];";
	};
	class txtInput: MV_Textbox
	{
		idc = 2019;
		x = 13 * GUI_GRID_W + GUI_GRID_X;
		y = 12.8 * GUI_GRID_H + GUI_GRID_Y;
		w = 12.5 * GUI_GRID_W;
		h = 1 * GUI_GRID_H;
		text = 0;
	};
	class stxtAccBalance: MV_SText
	{
		idc = 2020;
		x = 13 * GUI_GRID_W + GUI_GRID_X;
		y = 10.4 * GUI_GRID_H + GUI_GRID_Y;
		w = 6 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
	class stxtWalletBalance: MV_SText
	{
		idc = 2021;
		x = 19.5 * GUI_GRID_W + GUI_GRID_X;
		y = 10.4 * GUI_GRID_H + GUI_GRID_Y;
		w = 6 * GUI_GRID_W;
		h = 2 * GUI_GRID_H;
	};
	
	// -- Footer
};