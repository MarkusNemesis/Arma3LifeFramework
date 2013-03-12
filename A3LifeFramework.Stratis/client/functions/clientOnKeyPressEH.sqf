/* clientOnKeyPressEH script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: This script is called every time a key is pressed. Annoying, I know.
*/

private ["_control", "_key", "_shift", "_ctrl", "_alt"];
_control = _this select 0;
_key = _this select 1;
_shift = _this select 2;
_ctrl = _this select 3;
_alt = _this select 4;

//diag_log format ["Key Pressed: Key: %1, Shift: %2, Ctrl: %3, Alt: %4", _key, _shift, _ctrl, _alt];



if (Client_CustomKeysEnabled) then 
{
	private ['_target'];
	_target = cursorTarget;
	
    // ---------------- Disable Custom Keys ----------------
    if (_key == 15) then
    {
        Client_CustomKeysEnabled = false;
        titleText ["Custom keys Disabled", "PLAIN DOWN", 0.5];
    };
    
    // E pressed
    if (_key == 18) then
    { 
		// If the player is on foot and pressing E
		if (vehicle player == player) then
		{
		    // ---------------- Interface with stores ----------------
            private ["_pDistance", "_found", "_fArray"];
            
		    
		    // ---------------- Interface with Vehicles ----------------
		    // Getting into vehicles
		    if (_target distance player < 5) then
		    {
			    if (_target emptyPositions "Driver" > 0) then
			    {
			        player action ["getInDriver", _target];
			    } else {
		            if (_target emptyPositions "Cargo" > 0) then
			    	{
			        	player action ["getInCargo", _target];
			    	};
		        };
		    };
		    
		};
		
		// If User presses E and they're inside a vehicle, and it's not locked, then getout.
		if (vehicle player != player) then
		{
		    if (locked vehicle player == 1) then {player action ["getOut", vehicle player];};
		};
	};
} else {
	if (_key == 15) then
    {
        Client_CustomKeysEnabled = true;
        titleText ["Custom keys Enabled", "PLAIN DOWN", 0.5];
    };
};