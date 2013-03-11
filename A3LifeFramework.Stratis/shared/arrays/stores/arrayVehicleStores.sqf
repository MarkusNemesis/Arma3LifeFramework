/* arrayCarStores array
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Contains all the vehicle car store static arrays.
Format:
[ownerObj, [[VehiclesToSell, StockLevel]], [AccessArray], themeName];
ownerObj is the store keeper / interfaceable object.
[VehiclesToSell, Stocklevel] is the array of vehicles this store sells and the amount the store is initialised with.
AccessArray is the array of sides that can access this store. "All" signifies all can use the store.
themeName is a string that defines the store. "CopStore" will set the store keeper's gear to look like a peace keeper etc.
*/

// Don't forget to end each entry with a comma, EXCEPT the last entry.

Array_Store_Vehicles = [ 
	[CarStoreCiv1, [["c_offroad", 30], ["B_Quadbike_F", 100]], [str civilian], "CivStore"],
    [CarStoreCop1, [["B_Hunter_F", 45]], [str west], "CopStore"]
];
