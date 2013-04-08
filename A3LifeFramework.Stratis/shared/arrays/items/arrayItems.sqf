/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

arrayItems script
Created: 19/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: All custom inventory items are defined here.
Format: ['itemName', volumeCC, basePrice, [Args,Array], 'useFunction', "ItemInformationString"]
All item 'use' functions MUST return true/false. true = item consumed, false = not.
TODO try fetching static data from an html file via htmlLoad. May not be possible due to headless nature of the server. http://community.bistudio.com/wiki/htmlLoad
*/

// TODO localise item descriptions.
private ['_Array_Items'];
// Don't forget to end each entry with a comma, EXCEPT the last entry.
_Array_Items = [
	['Money', 					0, 1, [], 'MV_Client_fnc_Use_NoUse', 'Money, used to do lots of stuff. Testing however, is not one of them.'],
	['TestItem', 				1, 10, ["Args array test", "Hello world"], 'MV_Client_fnc_Use_TestUse', "This is a test object. It tests things"],
	['TestItem2', 				5, 50, ["Args array test2", "Hello world Again"], 'MV_Client_fnc_Use_TestUse', "This is also a test object. It also tests things"],
	['Small Spare Tyre Kit', 	10000, 250, [1, 0.1, 15], 'MV_Client_fnc_Use_TestUse', "Replaces a small land vehicle's wheels with flimsy replacements for temporary use."], // Args: Repair scale 1 (vehicle size), repair coverage (0.1 = wheels) and repair time 15s
	['Light Repair Kit', 		15000, 400, [1, 0.25, 15], 'MV_Client_fnc_Use_RepairKitUse', "Repairs small land and sea vehicles to running condition. Use only for cursory repairs."], // Args: Repair scale 1 (vehicle size), repair coverage (0.25 = fuel, engine, wheels) and repair time 15s
	['Fishing net (Small)', 	10000, 75, [20, 'sml', 12500], 'MV_Client_fnc_Use_FishingNetUse', "A small fishing net, for use on small boats / dinghys. Perfect for the casual fisherman or budding entrepreneur."], // Args: Fish depth: 20, Size, (sml, med, lar), net catch volume
	// -- Fish: Note: Fish volume is hardcoded as 100 in other scripts. Changes in volumes must be done here AND whereever else.
	['Atlantic Bluefin Tuna', 	100, 100, [90], 'MV_Client_fnc_Use_NoUse', 'A unit of fish'], // Args: Depth: int
	['European Seabass', 		100, 90, [80], 'MV_Client_fnc_Use_NoUse', 'A unit of fish'], // Args: Depth: int
	['Gilt-Headed Bream', 		100, 80, [70], 'MV_Client_fnc_Use_NoUse', 'A unit of fish'], // Args: Depth: int
	['European Hake', 			100, 70, [60], 'MV_Client_fnc_Use_NoUse', 'A unit of fish'], // Args: Depth: int
	['Anchovies', 				100, 60, [50], 'MV_Client_fnc_Use_NoUse', 'A unit of fish'], // Args: Depth: int
	['Atlantic Bonito', 		100, 50, [40], 'MV_Client_fnc_Use_NoUse', 'A unit of fish'], // Args: Depth: int
	['Sardines', 				100, 40, [30], 'MV_Client_fnc_Use_NoUse', 'A unit of fish'], // Args: Depth: int
	['Herring',			 		100, 30, [20], 'MV_Client_fnc_Use_NoUse', 'A unit of fish'], // Args: Depth: int
	['Whiting', 				100, 20, [10], 'MV_Client_fnc_Use_NoUse', 'A unit of fish'], // Args: Depth: int
	['Blowfish', 				100, 10, [0], 'MV_Client_fnc_Use_NoUse', 'A unit of fish']   // Args: Depth: int
]; // End array

missionNamespace setVariable ["Array_Items", _Array_Items];