/* arrayCarStores array
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Contains all the vehicle car store static arrays.
Format:
[ownerObj, [[VehiclesToSell, StockLevel]], [AccessArray], themeName, StoreName, spawnMarkerName, boolHasMarker];
ownerObj is the store keeper / interfaceable object.
[VehiclesToSell, Stocklevel] is the array of vehicles this store sells and the amount the store is initialised with.
AccessArray is the array of sides that can access this store. "All" signifies all can use the store.
themeName is a string that defines the store. "CopStore" will set the store keeper's gear to look like a peace keeper etc.
*/
private ['_Array_Store_Vehicles'];
// Don't forget to end each entry with a comma, EXCEPT the last entry.
_Array_Store_Vehicles = [
	// -- Car stores
	[CarStoreCiv1, [["c_offroad", 30], ["B_Quadbike_F", 100]], [civilian], "CivStore", localize "STR_MV_STORES_CARSTORECIV1", "CarStoreCiv1_Spawn", true],
    [CarStoreCop1, [["B_Hunter_F", 45], ["B_Quadbike_F", 100]], [west], "CopStore", localize "STR_MV_Stores_CarStoreCop1", "CarStoreCop1_Spawn", false],
    // -- Boat Stores
    //[BoatStoreCop1, [["B_Assaultboat", 45]], [west], "CopStore", "UN Coast Guard Quartermaster", "BoatStoreCop1_Spawn"], // TODO implement this store in world
    [BoatStoreCiv1, [["C_Rubberboat", 30]], [civilian], "CivStore", localize "STR_MV_STORES_BOATSTORECIV1", "BoatStoreCiv1_Spawn", true]
]; // End array

missionNamespace setVariable ["Array_Store_Vehicles", _Array_Store_Vehicles];
//missionNamespace getVariable "Array_Store_Vehicles";