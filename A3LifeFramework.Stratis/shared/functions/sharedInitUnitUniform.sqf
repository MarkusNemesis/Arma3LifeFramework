/* sharedInitUnitUniform script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Dresses based off the preset selected
*/

private ["_unit", "_preset"];

_unit = _this select 0;
_preset = _this select 1;

switch (_preset) do
{
    case "PeaceKeeper1":
    {
        removeallweapons _unit;
	    removeHeadgear _unit;
	    removeVest _unit;
	    removeUniform _unit;
	    _unit addUniform "U_B_CombatUniform_mcam_vest";
	    _unit addheadgear "H_Cap_blu";
	    _unit addVest "V_Chestrig_khk";
    };
    
    case "PeaceKeeper2":
    {
        
    };
};