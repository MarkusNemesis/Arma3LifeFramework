/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
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
//	Item name					Vol		Val		Args							Use function											Item Description
_Array_Items = [
	['Money', 					0, 		1, 		[], 							'MV_Client_fnc_Use_NoUse', 								'Money, used to do lots of stuff. Testing however, is not one of them.'],
	['Small Spare Tyre Kit', 	10000, 250, 	[1, 0.1, 15], 					'MV_Client_fnc_Use_TestUse', 							"Replaces a small land vehicle's wheels with flimsy replacements for temporary use."], // Args: Repair scale 1 (vehicle size), repair coverage (0.1 = wheels) and repair time 15s
	['Light Repair Kit', 		15000,	400, 	[1, 0.25, 15], 				'MV_Client_fnc_Use_RepairKitUse', 						"Repairs small land and sea vehicles to running condition. Use only for cursory repairs."], // Args: Repair scale 1 (vehicle size), repair coverage (0.25 = fuel, engine, wheels) and repair time 15s
	['Fishing net (Small)', 	10000,	75, 	[20, 'sml', 12500], 			'MV_Client_fnc_Use_FishingNetUse', 						"A small fishing net, for use on small boats / dinghys. Perfect for the casual fisherman or budding entrepreneur."], // Args: Fish depth: 20, Size, (sml, med, lar), net catch volume
	// -- Fish: Note: Fish volume is hardcoded as 100 in other scripts. Changes in volumes must be done here AND whereever else. TODO make fish volumes non-static. ie, higher valued fish will have larger volumes.
	['Atlantic Bluefin Tuna', 	100,	100, 	[90], 							'MV_Client_fnc_Use_NoUse', 								'A unit of fish'], // Args: Depth: int
	['European Seabass', 		100,	90, 	[80], 							'MV_Client_fnc_Use_NoUse', 								'A unit of fish'], // Args: Depth: int
	['Gilt-Headed Bream', 		100, 	80, 	[70], 							'MV_Client_fnc_Use_NoUse', 								'A unit of fish'], // Args: Depth: int
	['European Hake', 			100, 	70, 	[60], 							'MV_Client_fnc_Use_NoUse', 								'A unit of fish'], // Args: Depth: int
	['Anchovies', 				100, 	60, 	[50], 							'MV_Client_fnc_Use_NoUse', 								'A unit of fish'], // Args: Depth: int
	['Atlantic Bonito', 		100, 	50, 	[40], 							'MV_Client_fnc_Use_NoUse', 								'A unit of fish'], // Args: Depth: int
	['Sardines', 				100, 	40, 	[30], 							'MV_Client_fnc_Use_NoUse', 								'A unit of fish'], // Args: Depth: int
	['Herring',			 		100, 	30, 	[20], 							'MV_Client_fnc_Use_NoUse', 								'A unit of fish'], // Args: Depth: int
	['Whiting', 				100, 	20, 	[10], 							'MV_Client_fnc_Use_NoUse', 								'A unit of fish'], // Args: Depth: int
	['Blowfish', 				100, 	10, 	[0], 							'MV_Client_fnc_Use_NoUse', 								'A unit of fish'],   // Args: Depth: int
	['Zip-cuffs', 				100, 	3, 		[false, "p", 60, true],			'MV_Client_fnc_Use_HandCuffUse', 						"A simple pair of plastic, disposable, zip-tie hand cuffs. Used for restraining people en-masse. Whether legally, or illegally. You're pretty sure someone could work their way out of these pretty quickly if you took your eye off them for just a moment; Especially if they had a knife, or a pair of toddler safety scissors."],   // Args: boolhasLock, strCuffMaterial, intRestrainTime, boolSingleUseOnly
	['Handcuffs', 				350, 	55,		[true, "m", 180, false],		'MV_Client_fnc_Use_HandCuffUse', 						"A sturdy metal pair of conventional hand-cuffs. Fitted with a picky lock, these things don't look all that easy to get out of. Let's just hope no-one loses the key."]   // Args: boolhasLock, strCuffMaterial, intRestrainTime, boolSingleUseOnly
]; // End array


if (isServer) then 
{
	(call M_S_fnc_GLV) setVariable ["Array_Items", _Array_Items];
} else {
	(call M_C_fnc_GLV) setVariable ["Array_Items", _Array_Items];
};