/* clientInteractionHUD script
Created: 16/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Handles the display of text when mousing over an interactable object.
*/

private ['_cTarg', '_iType', '_iFilter', '_dialog', '_iText'];
disableSerialization;
_cTarg = cursorTarget;

// -- Check if player is within interaction range of this object.
if (_cTarg distance player > INT_RANGE) exitwith {};

_iText = '';
_iType = '';
_iFilter = [];

if (_cTarg getVariable "isInteractable") then
{
    // -- Check if the player can interact with this type of object.
    _iFilter = _cTarg getVariable "interactFilter";
	if (!(Client_PlayerSide in _iFilter or "ALL" in _iFilter)) exitwith {};
    
    // -- Switch to handle interaction types
    _iType = _cTarg getVariable "interactType";
    switch (_iType) do
	{
		case "typeVehicle":
		{
            if (vehicle player == player) then // -- If not in a vehicle
			{
				if (damage _cTarg >= 1) exitwith {}; // -- Vehicle isn't alive, so thus not interactable.
	            if (locked _cTarg > 1) then {
	                // -- If the vehicle is locked and the player has the key, show to unlock it.
	                if ((netID _cTarg) in (player getVariable "KeyChain")) then
	                {
			    		_iText = localize "STR_MV_INT_HUD_UNLOCK";
	                };
			    } else {
			    	_iText = localize "STR_MV_INT_HUD_GETIN";
			    };
			};
		};
		
		case "typeVehicleStore": // or "typeItemStore" etc.
		{
            _iText = localize "STR_MV_INT_HUD_SHOP";
		};
		
		case "typePile":
		{
			_iText = localize "STR_MV_INT_HUD_PILE";
		};
		
	};
    
	// -- For now, we'll only show "Press E to interact". Future may expand functionality. IE, Item objects, "Press E to pickup"
    10 cutRsc ["ui_interactHUDText", "PLAIN", 0];
    _dialog = uiNamespace getVariable "Client_UI_interactFloatyText";
    if (!isNull _dialog) then
    {
    	(_dialog displayctrl 2000) ctrlSetText _iText;
    } else {diag_log "ERROR: InteractionHUD Display is null!"};
} else {
    cutRsc ["", "PLAIN", 0];
};