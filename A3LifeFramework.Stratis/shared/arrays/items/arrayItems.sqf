/* arrayItems script
Created: 19/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: All custom inventory items are defined here.
Format: ['itemName', volumeM3, basePrice, [Args,Array], 'useFunction', 'ItemInformationString', 'dropItemClassName']
All item 'use' functions MUST return true/false. true = item consumed, false = not.
*/

// TODO localise item descriptions.

// Don't forget to end each entry with a comma, EXCEPT the last entry.
Array_Items = [
	['Money', 0.01, 1, [], 'MV_Client_fnc_Use_NoUse', 'Money, used to do lots of stuff. Testing however, is not one of them.', 'Land_Sack_F'],
	['TestItem', 1, 10, ["Args array test", "Hello world"], 'MV_Client_fnc_Use_TestUse', 'This is a test object. It tests things', 'Land_Sack_F'],
	['TestItem2', 5, 50, ["Args array test2", "Hello world Again"], 'MV_Client_fnc_Use_TestUse', 'This is also a test object. It also tests things', 'Land_Sack_F'],
	['Light Repair Kit', 5, 50, [1, 'light'], 'MV_Client_fnc_Use_TestUse', 'Repairs small vehicles to running condition. Use only for cursory repairs.', 'Land_Sack_F'] // Args: Repair scale 1, repair amount 'light'.
]; // End array