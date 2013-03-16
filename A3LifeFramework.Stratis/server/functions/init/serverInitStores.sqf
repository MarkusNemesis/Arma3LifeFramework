/* serverInitStores script
Created: 12/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Initialises the stores from the static data array.
setVariable must be public.
Stores have multiple interactTypes: typeVehicleStore, typeItemStore, etc. All define how the client handles them on interaction.
*/

// ------------------- Init vehicle stores -------------------
//[ownerObj, [[VehiclesToSell, StockLevel]], [AccessArray], themeName, StoreName];
{
    private ['_oObj', '_sArr', '_accArr', '_theme', '_mTxt', '_spawnObject'];
    _oObj = _x select 0;
    _sArr = _x select 1;
    _accArr = _x select 2;
    _theme = _x select 3; // Cop theme initialises the unit to look like a Peacekeeper
    _mTxt = _x select 4; 
    _spawnObject = _x select 5;
    
    // -- Set Public Variables
    _oObj setVariable ["isInteractable", true, true]; // Whether the object is interactable.
	_oObj setVariable ["interactType", "typeVehicleStore", true]; // Contains the interactType. Defines how the client handles this interaction.
	_oObj setVariable ["storeArray", _sArr, true]; // Contains what the store sells.
	_oObj setVariable ["interactFilter", _accArr, true]; // Contains the 'sides' that can interact with this object
    _oObj setVariable ["mouseOverText", _mTxt, true]; // Text that shows on mouse over.
    
    
    // -- Set Serverside Variables
    _oObj setVariable ["isInteractableServer", true];
	_oObj setVariable ["interactTypeServer", "typeVehicleStore"];
	_oObj setVariable ["storeArrayServer", _sArr];
	_oObj setVariable ["interactFilterServer", _accArr];
    _oObj setVariable ["mouseOverTextServer", _mTxt];
    _oObj setVariable ["spawnObjectServer", _spawnObject];
    
    
    // -- Disable AI
    _oObj disableAI "FSM";
    _oObj disableAI "TARGET";
    _oObj disableAI "AUTOTARGET";
    _oObj disableAI "MOVE";
    _oObj disableAI "ANIM";
    
    switch (_theme) do
    {
        case "CivStore":
        {
            // Do nothing... Yet
        };
        case "CopStore":
        {
            [_oObj, "PeaceKeeper1"] call MV_Shared_fnc_InitUnitUniform;
        };
    };
} foreach Array_Store_Vehicles;