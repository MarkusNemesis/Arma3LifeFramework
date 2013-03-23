/* arrayItems script
Created: 19/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: All custom inventory items are defined here.
Format: ['itemName', volumeCC, basePrice, [Args,Array], 'useFunction', "ItemInformationString"]
All item 'use' functions MUST return true/false. true = item consumed, false = not.
*/

// TODO localise item descriptions.

// Don't forget to end each entry with a comma, EXCEPT the last entry.
Array_Items = [
	['Money', 0, 1, [], 'MV_Client_fnc_Use_NoUse', 'Money, used to do lots of stuff. Testing however, is not one of them.'],
	['TestItem', 1, 10, ["Args array test", "Hello world"], 'MV_Client_fnc_Use_TestUse', "This is a test object. It tests things"],
	['TestItem2', 5, 50, ["Args array test2", "Hello world Again"], 'MV_Client_fnc_Use_TestUse', "This is also a test object. It also tests things"],
	['Small Spare Tyre Kit', 5, 250, [1, 0.25, 15], 'MV_Client_fnc_Use_TestUse', "Replaces a small land vehicle's wheels with flimsy replacements for temporary use."], // Args: Repair scale 1 (vehicle size), repair coverage (0.1 = wheels) and repair time 15s
	['Light Repair Kit', 5, 400, [1, 0.25, 15], 'MV_Client_fnc_Use_RepairKitUse', "Repairs small land and sea vehicles to running condition. Use only for cursory repairs."] // Args: Repair scale 1 (vehicle size), repair coverage (0.25 = fuel, engine, wheels) and repair time 15s
]; // End array