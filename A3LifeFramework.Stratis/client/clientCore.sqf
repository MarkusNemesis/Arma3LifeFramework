/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

//

clientCore script
Created: 02/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: This is the script where the main loop of the client lives. This loop runs once per frame.
Events can have a priority setting. This setting dictates how many frames will pass between each event execution. 
Priorities are any number between 1-8. A priority of 1 will run once every frame. A priority of 4, will run every 4 frames. etc
This helps distribute functions across a spectrum of how often a function is ran. 
This can off-set non time-critical functions, and leave more room for other more important events.
*/

private ["_pFrame", "_runPrior", '_pRange', '_iRange', '_restrainAnim'];
//
_runPrior = 1;
_pFrame = diag_frameno;
_pRange = ((["PRIOR_RANGE"] call MV_Client_fnc_GetMissionVariable) select 0);
_iRange = ((["INT_RANGE"] call MV_Client_fnc_GetMissionVariable) select 0);
_restrainAnim = ((["MV_Shared_ANIMATION_RESTRAINED"] call MV_Client_fnc_GetMissionVariable) select 0);
diag_log "MV: STARTING CLIENT MAINLOOP";
while {true} do // This is the main loop. EVERYTHING clientside happens here.
{
    // -------- Run Priority 1 - Runs every frame --------
	{
		if (!isnil '_x') then { // -- Somehow, this can happen....
			private ['_fname', '_args', '_eTime'];
			_fname = _x select 0;
			_args = _x select 1;
			_eTime = _x select 2;
			if (!isnil '_fname') then {
				if (_eTime < time) then { // -- Call only when it's ready to be.
					diag_log format ["MV: CLIENT: Running event from array: %1 , %2. Frame: %3, EventCount: %4", _fname, _args, diag_frameno, count Client_EventArray];
					[_forEachIndex] call MV_Client_fnc_RemoveEvent; // -- Removes before running, as, if it causes an error, the mainloop will reboot, and thankfully not catch the same bugged event and crash infinitely.
					call compile format ["_args call %1", _fname];
				}; 
			} else {
				[_forEachIndex] call MV_Client_fnc_RemoveEvent;
			}; // -- Event is a null event, and thus removed.
			
		};
    } foreach Client_EventArray;
	
    /* -- Check if the player is spawned
    if (Client_PlayerSpawned) then
    {
		
    };
    */
    // -------- Run Priority 2 - Runs every 2 frames --------
    if (_runPrior % 2 == 0) then
    {
        // -- Check if the player is spawned
	    if (Client_PlayerSpawned) then
	    {
            if (Client_CustomKeysEnabled) then
            {
				// -- Interaction Floaty text
	            [_iRange] call MV_Client_fnc_int_HUD;
            };
	    };
    };
    
    // -------- Run Priority 4 - Runs every 4 frames --------
    if (_runPrior % 4 == 0) then
    {
        
    };
    
    // -------- Run Priority 8 - Runs every 8 frames --------
    if (_runPrior % 8 == 0) then
    {
        if (Client_PlayerSpawned) then
	    {
			if (!(alive player)) exitwith {};
			// -- 'reveal's to the player all interactable objects within interact distance (5 m)
	        [_iRange] call MV_Client_fnc_InteractableAwareness;
			// -- If player is restrained. Check to ensure they're in the restrained pose, as long as they're not in a vehicle. TODO move this to own function?
			private ['_isRestrained'];
			_isRestrained = if (count (player getVariable 'isRestrained') > 1) then {true} else {false};
			if (_isRestrained && (vehicle player == player)) then
			{
				if ((animationState player) != _restrainAnim) then
				{
					["AnimationEvent", [netID player, _restrainAnim, 'switchMove']] call MV_Shared_fnc_SendPublicMessage;
				};
			};
            // --  check if player is in a vehicle, and wasn't before to update vehicle's garbage collection delay.
            if (vehicle player != player) then // -- Player is in vehicle.
            {
                if (!Client_InVehicle) then {["UpdateGarbage", [netID vehicle player]] call MV_Client_fnc_SendServerMessage;};
                Client_InVehicle = true;
                Client_Vehicle = vehicle player;
            } else {// -- If not in vehicle, but was, set Client_InVehicle = false and update garbage.
                if (Client_InVehicle) then {["UpdateGarbage", [netID Client_Vehicle]] call MV_Client_fnc_SendServerMessage;};
                Client_InVehicle = false;
                Client_Vehicle = objnull;
            };
        };
    };
    
    // Leave this last.
    _runPrior = _runPrior + 1;
    if (_runPrior > _pRange) then {_runPrior = 1;};
    _pFrame = diag_frameno;
	Sleep 0.001;
    waituntil {diag_frameno > _pFrame}; // Main loop runs once per tick.Let the scheduler recycle
};