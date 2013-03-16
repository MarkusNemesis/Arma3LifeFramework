/* sharedInit script
Created: 01/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Initialises all things that are shared between the client and server namespaces.
*/

private ["_runTime"];
_runTime =+ diag_tickTime;

// Init shared constant variables
call compile preprocessFile "shared\sharedConstants.sqf";

// Init shared functions
call compile preprocessFile "shared\functions\sharedInitFunctions.sqf";

// -- Init Arrays
call Compile preprocessFile "shared\functions\init\sharedInitArrays.sqf";

// leave last
_runTime = diag_tickTime - _runTime;
diag_log format ["MV: shared INIT: FINISHED, Time taken: %1", _runTime];