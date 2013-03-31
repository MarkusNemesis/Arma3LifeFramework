/* clientInteractionItemUseEvents script
Created: 22/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Handles all client > server item use events. ie, 'repair', 'lockpick', etc.
If the item isn't found, or specifics aren't met, then the server will send a message back to the client to show an error/box/text/etc.
Params: playerObj, itemName, actionStr, actionArgsArray
Return: 
*/
private ['_iName', '_action', '_aArgs', '_itemArray', '_pInventory'];
_iName = _this select 0;
_action = _this select 1;
_aArgs = _this select 2;

switch (_action) do
{
	// -- Do repair on vehicle.
	case "RKRep":
	{
		private ['_iInfo', '_rVeh'];
		_rVeh = objectFromNetId (_aArgs select 1);
		// -- Get item info to get repair arguments.
		_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
		// -- Call the repair function.
		[(_iInfo select 3) select 1, _rVeh] call MV_Shared_fnc_ItemRepairVehicle;
	};
	
	case "DNet":
	{
		private ['_iInfo'];
		_iInfo = [_iName] call MV_Shared_fnc_GetItemInformation;
		systemChat format ["You successfully deployed the net. Be sure to stay just below %1 KM/h and at a depth greater than %2, or you'll be forced to recall your net.", 10, (_iInfo select 3) select 0];
		// -- TODO add 'fish finder', water depth gauge and net capacity bar/metre.
	};
	
	case "DNetCyc":
	{
		// -- Runs when a net completes a 5 second serverside event cycle. Either notifies the player of it's ship's inventory status, or that they've gone too fast / ran aground / etc and the net has been recalled.
		// -- TODO this
	};
};
