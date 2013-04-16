/* clientOnKeyPressEH script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: This script is called every time a key is pressed. Annoying, I know.
*/

private ["_control", "_key", "_shift", "_ctrl", "_alt", '_handled', '_intRange', '_isStunned'];
_control = _this select 0;
_key = _this select 1;
_shift = _this select 2;
_ctrl = _this select 3;
_alt = _this select 4;
_handled = false;
_isStunned = player getVariable 'isStunned'; // TODO if isstunned, then only allow specific keys to be used. ie only allow ESC to be pressed. Maybe others. Replaces 'disableUserInput true'
//diag_log format ["Key Pressed: Key: %1, Shift: %2, Ctrl: %3, Alt: %4", _key, _shift, _ctrl, _alt];

if (Client_CustomKeysEnabled) then 
{
	private ['_target'];
	_target = cursorTarget;
	
    // ---------------- Disable Custom Keys ----------------
    if (_key == 15 && !_alt) then
    {
        Client_CustomKeysEnabled = false;
        titleText ["Custom keys Disabled", "PLAIN DOWN", 0.5]; titleFadeOut 4096;
		_handled = true;
    };
    
    // ---------------- Interact key [E] ----------------
    if (_key == 18) then
    {
        if (dialog || _isStunned) exitwith{}; // Cannot use interact key whilst in a dialog or stunned.
        // If the player is on foot and pressing E
		if (vehicle player == player) then
		{
			_intRange = ((["INT_RANGE"] call MV_Client_fnc_GetMissionVariable) select 0);
            if (player distance _target > _intRange) exitwith {};
	        private ['_isInteractable'];
	        _isInteractable = _target getVariable "isInteractable";
	        if (isnil ('_isInteractable')) then {_isInteractable = false;};
			if (!(_isInteractable)) exitwith {diag_log format ["%1 is not interactable", _target]};
		    // ---------------- Interact with Stores/GetInVehicles ----------------
            private ["_pDistance", "_found", "_fArray"];
            //diag_log "Pre Interact Handler";
            [_target, _shift] call MV_Client_fnc_int_Handler;
			_handled = true;
		};
		
		// If User presses E and they're inside a vehicle, and it's not locked, then getout.
		if (vehicle player != player) then
		{
		    if (locked vehicle player == 1) then 
            {
				if (_shift) exitWith 
				{
					if (netId (vehicle player) in (player getVariable "KeyChain")) then {[(vehicle player)] spawn MV_Client_fnc_int_StorageInventory} else {systemChat localize "STR_MV_INT_ERRORCANNOTEXITLOCKED";};
					_handled = true;
				};
                player action ["getOut", vehicle player];
            } else {systemChat localize "STR_MV_INT_ERRORCANNOTEXITLOCKED";}; // notify the player that the vehicle is locked};
			_handled = true;
		};
	};
	
    // ---------------- Lock key [L] ----------------
    if (_key == 38) then
    {
		if (_isStunned) exitwith {};
        if (vehicle player == player) then
		{// -- On foot
	        [_target, 'key'] call MV_Client_fnc_int_ToggleVehicleLock;
        } else { // -- In vehicle.
            [vehicle player, 'key'] call MV_Client_fnc_int_ToggleVehicleLock;
        };
		_handled = true;
    };
	
	// ---------------- Information key [1] ----------------
	if (_key == 2) then
	{
		
	};
	
	// ---------------- Inventory key [2] ----------------
	if (_key == 3) then
	{
		if (_isStunned) exitwith {};
		if (!dialog) then {
			[] spawn MV_Client_fnc_int_Inventory;
			_handled = true;
		};
	};
	
} else {
	if (_key == 15 && !_alt) then
    {
        Client_CustomKeysEnabled = true;
        titleText ["Custom keys Enabled", "PLAIN DOWN", 0.5]; titleFadeOut 1.5;
		_handled = true;
    };
};

_handled