/* sharedInitVehicleStore script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Goes through the Array_Store_Vehicles and initialises them.
*/
//[ownerObj, [[VehiclesToSell, StockLevel]], [AccessArray], themeName];
{
    private ['_oObj', '_vArr', '_aArr', '_theme'];
    _oObj = _x select 0;
    _vArr = _x select 1;
    _aArr = _x select 2;
    _theme = _x select 3;
    
    
    switch (_theme) do
    {
        case "CivStore":
        {};
        
        case "CopStore":
        {
            if (isServer) then
            {
	            removeallweapons _oObj;
			    removeHeadgear _oObj;
			    removeVest _oObj;
			    removeUniform _oObj;
			    _oObj addUniform "U_B_CombatUniform_mcam_vest";
			    _oObj addheadgear "H_Cap_blu";
			    _oObj addVest "V_Chestrig_khk";
            };
        };
    };
    
} foreach Array_Store_Vehicles;