/* clientInteractionHUD script
Created: 16/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Handles the display of text when mousing over an interactable object.
*/
if (player getVariable 'isStunned') exitwith {};
private ['_cTarg', '_iType', '_iFilter', '_dialog', '_iText', '_intRange'];
disableSerialization;
_cTarg = cursorTarget;
_intRange = _this select 0; //_intRange = ((["INT_RANGE"] call MV_Client_fnc_GetMissionVariable) select 0);
// -- Check if player is within interaction range of this object.
if (_cTarg distance player > _intRange) exitwith {};

_iText = '';
_iType = '';
_iFilter = [];

if (_cTarg getVariable "isInteractable") then
{
    
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
					if ((netID _cTarg) in (player getVariable "KeyChain")) then
	                {
			    		_iText = composeText [_iText, lineBreak, localize 'STR_MV_INT_HUD_VEHSTORAGE'];
	                };
			    };
			};
		};
		
		// TODO determine if you can 'or' in a case parameter, so that I can merge this with vehicle store. ELSE refactor the isinteractable flags to have more type data.
		case "typeItemStore":
		{
			// -- Check if the player can interact with this type of object.
			_iFilter = _cTarg getVariable "interactFilter";
			if (!(Client_PlayerSide in _iFilter or "ALL" in _iFilter)) exitwith {};
            _iText = localize "STR_MV_INT_HUD_SHOP";
		};
		
		case "typeVehicleStore": // or "typeItemStore" etc.
		{
			// -- Check if the player can interact with this type of object.
			_iFilter = _cTarg getVariable "interactFilter";
			if (!(Client_PlayerSide in _iFilter or "ALL" in _iFilter)) exitwith {};
            _iText = localize "STR_MV_INT_HUD_SHOP";
		};
		
		case "typePile":
		{
			_iText = localize "STR_MV_INT_HUD_PILE";
		};
		
		case "typeATM":
		{
			_iText = localize "STR_MV_INT_HUD_ATM";
		};
		
	};
    
	// -- Display the mid-screen interact hover text.
    10 cutRsc ["ui_interactHUDText", "PLAIN", 0];
    _dialog = uiNamespace getVariable "Client_UI_interactFloatyText";
    if (!isNull _dialog) then
    {
    	(_dialog displayctrl 2000) ctrlSetStructuredText (composeText [_iText]);
    } else {diag_log "ERROR: InteractionHUD Display is null!"};
} else {
    10 cutRsc ["", "PLAIN", 0];
};