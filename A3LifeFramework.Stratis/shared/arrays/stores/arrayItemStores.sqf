/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

arrayItemStores script
Created: 4/04/2013
Author: Markus Davey
Skype: markus.davey
Desc: contains all item stores.
Format: [KeeperObjName, [ ["ItemName", intBaseStock, intMaxStock], [etc, etc] ], [AccessArray], themeName, storeName, ammoCrate, boolHasMarker, boolIsExporter];
boolIsExporter is a flag that states whether items sold to this store will add to it's stock of said item, or whether it's stock is always at 0.
Params: 
Return: 
*/

private ['_Array_Store_Items'];
// Don't forget to end each entry with a comma, EXCEPT the last entry.
_Array_Store_Items = [
	// -- Item stores
	[ItemStoreCiv1, [ ["Blowfish", 0, 1000], ["Whiting", 0, 1000], ["Herring", 0, 1000], ["Sardines", 0, 1000], ["Atlantic Bonito", 0, 1000], ["Anchovies", 0, 1000], ["European Hake", 0, 1000], ["Gilt-Headed Bream", 0, 1000], ["European Seabass", 0, 1000], ["Atlantic Bluefin Tuna", 0, 1000]], [civilian], "CivStore", "Stratis International Fish Exports", objNull,  true, false]
]; // End array


if (isServer) then 
{
	(call M_S_fnc_GLV) setVariable ["Array_Store_Items", _Array_Store_Items];
} else {
	(call M_C_fnc_GLV) setVariable ["Array_Store_Items", _Array_Store_Items];
};