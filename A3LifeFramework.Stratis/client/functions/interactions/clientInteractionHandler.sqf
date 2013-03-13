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
// Check if the client's side is allowed to interact with this object
if (Client_PlayerSide in _iFilter) then
{
    // Client can interact with this object
    diag_log _iType;
    switch (_iType) do
    {
        // Car stores
        case "typeVehicleStore":
        {
            diag_log "Opening vehicle store!";
            [_iObj] spawn MV_Client_fnc_int_VehicleStore;
        };
        
        // Unlock vehicle
        case "typeVehicle":
        {
			if (_target emptyPositions "Driver" > 0) then
			{
			    player action ["getInDriver", _target];
			} 
            else 
            {
			    if (_target emptyPositions "Cargo" > 0) then
				{
			    	player action ["getInCargo", _target];
				};
			};
        };
    }; //End switch
}
else
{
    // User cannot interact with this object because their side is not on the list of allowed interactions.
    // TODO Maybe show a hint or textTitle to reflect this?
};