/* serverInitWorldProps script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Runs through all the objects in the mission added to the Server_PropsArray and sets their init lines.
Sets simulation off and allowdamage false
*/

{
    //if (_x isKindOf 'CAManBase') then {_x switchMove 'AidlPercMstpSnonWnonDnon_Player';};
    _x setvehicleinit "this allowdamage false; this lock true; clearWeaponCargo this; clearMagazineCargo this; clearItemCargo this; if (this isKindOf 'Man') then {this switchMove 'AidlPercMstpSnonWnonDnon_Player';}; this enablesimulation false;";
	processinitcommands;
    Server_PropsArray set [count Server_PropsArray, _x];
    _x = objnull;
    Server_InitPropsArray = Server_InitPropsArray - [objnull];
} foreach Server_InitPropsArray;