/* sharedInitArrays script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Initialises the arrays
preprocessfile is used as to not clog RAM with one-time-use functions.
*/

diag_log format ["MV: Shared: Initialising Arrays"];

// Stores
call compile preprocessfile "shared\arrays\stores\arrayVehicleStores.sqf";

// Vehicles
call compile preprocessfile "shared\arrays\vehicles\arrayVehicles.sqf";


//call compile preprocessfile "server\arrays\";