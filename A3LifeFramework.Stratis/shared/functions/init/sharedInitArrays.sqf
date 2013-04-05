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
call compile preprocessfile "shared\arrays\stores\arrayItemStores.sqf";

// Vehicles
call compile preprocessfile "shared\arrays\vehicles\arrayVehicles.sqf";

// Items
call compile preprocessfile "shared\arrays\items\arrayItems.sqf";

// ATMs
call compile preprocessfile "shared\arrays\atms\arrayATMs.sqf"; 

//call compile preprocessfile "shared\arrays\";