/* serverCore script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: This is the script where the main loop of the server lives. This loop runs once per frame.
Events can have a priority setting. This setting dictates how many frames will pass between each event execution. 
Priorities are any number between 1-8. A priority of 1 will run once every frame. A priority of 4, will run every 4 frames. etc
This helps distribute functions across a spectrum of how often a function is ran. 
This can off-set non time-critical functions, and leave more room for other more important events.
*/

private ["_pFrame", "_runPrior", "_tTime"];
//
_runPrior = 1;
_pFrame = diag_frameno;
_avgTTime = 0;
_tTime = diag_ticktime;

diag_log "MV: STARTING SERVER MAINLOOP";
while {true} do // This is the main loop. EVERYTHING serverside happens here.
{
    // -------- Run Priority 1 - Runs every frame --------
    {
        private ['_fname', '_args', '_priority'];
        _fname = _x select 0;
        _args = _x select 1;
        _priority = _x select 2;
        call compile format ["_args call %1", _fname];
        diag_log format ["MV: SERVER: Running event from array: %1 , %2. Frame: %3, EventCount: %4", _fname, _args, diag_frameno, count Server_EventArray];
        if (format ["%1", _fname] == "any") exitwith {[_forEachIndex] call MV_Server_fnc_RemoveEvent;}; // -- Event is a null event, and thus removed.
        [_forEachIndex] call MV_Server_fnc_RemoveEvent;
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
    if (_runPrior > PRIOR_RANGE) then 
    {
        _runPrior = 1;
        //diag_log format ["Server: Mainloop tick time avg: %1ms", (_avgTTime / PRIOR_RANGE) * 1000];
        _tTime = diag_ticktime - _tTime;
        Server_Health = format ["Server: Mainloop tick time avg: %1ms. FrameNo: %2", (_tTime / PRIOR_RANGE) * 1000, diag_frameno];
		publicVariable "Server_Health";
        _tTime = diag_ticktime;
    };
    _pFrame = diag_frameno;
    waituntil {diag_frameno > _pFrame;}; // Main loop runs once per tick. Let the scheduler recycle
};