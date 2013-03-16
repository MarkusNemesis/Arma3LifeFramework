class RscTitles
{
   class ui_interactHUDText
   {
		idd = -1;
		movingEnable = false;
		enableSimulation = true;
		controlsBackground[] = {};
		objects[] = {};
		controls[]=
		{
			lblInteractText
		};
		onLoad = "uiNamespace setVariable [""Client_UI_interactFloatyText"", _this select 0]";
		onUnload = "uiNamespace setVariable [""Client_UI_interactFloatyText"", objnull]";
		duration=0.1;
		fadein = 0;
        fadeout = 0;
		class lblInteractText: MV_title_InteractText
		{
			idc = 2000;
			x = 13.2 * GUI_GRID_W + GUI_GRID_X;
			y = 15.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 14.8 * GUI_GRID_W;
			h = 1.7 * GUI_GRID_H;
			sizeEx = 0.75 * GUI_GRID_H;
			shadow = 1;
		};
   };
}; 