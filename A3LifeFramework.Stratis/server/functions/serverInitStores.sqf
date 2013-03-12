/* serverInitStores script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Initialises the stores from the static data array.
setVariable must be public.
Stores have multiple interactTypes: typeVehicleStore, typeItemStore, etc. All define how the client handles them on interaction.
*/

call Compile preprocessFile "server\functions\serverInitArrays.sqf";

// ------------------- Init vehicle stores -------------------
//[ownerObj, [[VehiclesToSell, StockLevel]], [AccessArray], themeName, StoreName];
{
    private ['_oObj', '_sArr', '_accArr', '_theme', '_mTxt'];
    _oObj = _x select 0;
    _sArr = _x select 1;
    _accArr = _x select 2;
    _theme = _x select 3; // Cop theme initialises the unit to look like a Peacekeeper
    _mTxt = _x select 4; 
    
    _oObj setVariable ["isInteractable", true, true]; // Whether the object is interactable.
	_oObj setVariable ["interactType", "typeVehicleStore", true]; // Contains the interactType. Defines how the client handles this interaction.
	_oObj setVariable ["storeArray", _sArr, true]; // Contains what the store sells.
	_oObj setVariable ["interactFilter", _accArr, true]; // Contains the 'sides' that can interact with this object
    _oObj setVariable ["mouseOverText", _mTxt, true]; // Text that shows on mouse over.
    
    switch (_theme) do
    {
        case "CivStore":
        {
            // Do nothing
        };
        case "CopStore":
        {
            [_oObj, "PeaceKeeper1"] call MV_Shared_fnc_InitUnitUniform;
        };
    };
} foreach Array_Store_Vehicles;