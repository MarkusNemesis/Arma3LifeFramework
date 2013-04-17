/* 
Copyright (c) 2013 by Markus Davey.

This work is licensed under the 
Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. 
To view a copy of this license, 
visit http://creativecommons.org/licenses/by-nc-nd/3.0/.

//

serverCore script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: This is the script where the main loop of the server lives. This loop runs once per frame.
Events can have a priority setting. This setting dictates how many frames will pass between each event execution. 
Priorities are any number between 1-8. A priority of 1 will run once every frame. A priority of 4, will run every 4 frames. etc
This helps distribute functions across a spectrum of how often a function is ran. 
This can off-set non time-critical functions, and leave more room for other more important events.
*/

private ["_pFrame", "_runPrior", "_tTime", '_pRange'];
//
_runPrior = 1;
_pFrame = diag_frameno;
_avgTTime = 0;
_tTime = diag_ticktime;
_pRange = ((call M_S_fnc_GLV) getVariable "PRIOR_RANGE");
diag_log "MV: STARTING SERVER MAINLOOP";
while {true} do // This is the main loop. EVERYTHING serverside happens here, with the exception of event handler calls.
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
					diag_log format ["MV: SERVER: Running event from array: %1 , %2. Frame: %3, EventCount: %4", _fname, _args, diag_frameno, count Server_EventArray];
					[_forEachIndex] call MV_Server_fnc_RemoveEvent; // -- Removes before running, as, if it causes an error, the mainloop will reboot, and thankfully not catch the same bugged event and crash infinitely.
					call compile format ["_args call %1", _fname];
				}; 
			} else {
				[_forEachIndex] call MV_Server_fnc_RemoveEvent;
			}; // -- Event is a null event, and thus removed.
			
		};
    } foreach Server_EventArray;
    
    // -------- Run Priority 2 - Runs every 2 frames --------
    if (_runPrior % 2 == 0) then
    {
        
    };
    
    // -------- Run Priority 4 - Runs every 4 frames --------
    if (_runPrior % 4 == 0) then
    {
		// Run the garbage collector
        call MV_Server_fnc_RunGarbageCollector;
    };
    
    // -------- Run Priority 8 - Runs every 8 frames --------
    if (_runPrior % 8 == 0) then
    {
        if (time > 3 && time < 5) then {call MV_Server_fnc_InitWorldProps;};
    };
    
    // Leave this last.
    _runPrior = _runPrior + 1;
    if (_runPrior > _pRange) then 
    {
        _runPrior = 1;
        //diag_log format ["Server: Mainloop tick time avg: %1ms", (_avgTTime / _pRange) * 1000];
        _tTime = diag_ticktime - _tTime;
        Server_Health = format ["Server: Mainloop tick time avg: %1ms. FrameNo: %2", round ((_tTime / _pRange) * 1000), diag_frameno];
		publicVariable "Server_Health";
        _tTime = diag_ticktime;
		if ((diag_frameno - _pFrame) > 1) then {diag_log format ["MV: serverCore: WARN: Loop skipped %1 frames!", diag_frameno - _pFrame];};
    };
    _pFrame = diag_frameno;
	Sleep 0.001;
    waituntil {diag_frameno > _pFrame;}; // Main loop runs once per tick. Let the scheduler recycle
};