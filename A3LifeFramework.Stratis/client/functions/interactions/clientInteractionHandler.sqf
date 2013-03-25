/* clientInteractionHandler script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Is called when E is pressed on an object, and that object's getVariable "isInteractable" == true
Calls the respective interact function, based off the object's getVariable "interactType"
Params: [interactObject]
*/

private ['_iObj', '_iType', '_iFilter'];

_iObj = _this select 0;
_iType = _iObj getVariable "interactType";
_iFilter = _iObj getVariable "interactFilter";
diag_log format ["Interaction handler triggered: obj: %1, type: %2, filter: %3", _iObj, _iType, _iFilter];

// -- Check if the client's side is allowed to interact with this object
if (!(Client_PlayerSide in _iFilter or "ALL" in _iFilter)) exitwith {diag_log format ["Client cannot interact with this object. Requires side: %1", _iFilter];};

switch (_iType) do
{
    // Car stores
    case "typeVehicleStore":
    {
        //diag_log "Opening vehicle store!";
    	[_iObj] spawn MV_Client_fnc_int_VehicleStore;
    };
    
    // Unlock vehicle
    case "typeVehicle":
    {	
		// -- Todo make support for vehicle inventories. :S
        //diag_log "Attempting to enter vehicle";
        if (locked _iObj > 1) exitwith {systemChat localize "STR_MV_INT_ERRORCANNOTEXITLOCKED"}; // notify the player that the vehicle is locked
		if (_iObj emptyPositions "Driver" > 0) then
		{
		    player action ["getInDriver", _iObj];
		} 
        else 
        {
		    if (_iObj emptyPositions "Cargo" > 0) then
			{
		    	player action ["getInCargo", _iObj];
			};
		};
    };
	
	case "typePile":
	{
		// -- Open ui_inventoryStorageInteract
		[_iObj] spawn MV_Client_fnc_int_StorageInventory;
	};
}; //End switch