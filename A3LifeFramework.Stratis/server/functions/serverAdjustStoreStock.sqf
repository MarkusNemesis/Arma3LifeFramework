/* serverAdjustStoreStock script
Created: 15/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Reduces a specific store's stock of a specific item, by class name. Action is type specific.
Params: [storeObj, [classname, quantity]]
Return: Bool : Action successful - True when stock didn't go below 0 else false.
*/

private ['_sObj', '_args', '_sType', '_aSuccess'];
_sObj = _this select 0;
_args = _this select 1;
// Fetch interactType from serverside
_sType = [netId _sObj, "interactType"] call MV_Server_fnc_GetMissionVariable select 0; 
_aSuccess = false;

switch (_sType) do
{
	case "typeVehicleStore":
	{
        private ['_sArr', '_cName', '_qty'];
		// -- Get store array
		_sArr = [netID _sObj, "storeArray"] call MV_Server_fnc_GetMissionVariable;
        // -- Get Classname of item, qty
        _cName = _args select 0;
        _qty = _args select 1; // Positive to add, negative to remove.
        // -- Find classname within store array
        {
            // -- assign a new value to the index
            if ((_x select 0) == _cName) exitwith {
                if ((_x select 1) + _qty > -1) then {
                	_x set [1, (_x select 1) + _qty];
                    _aSuccess = true;
                };
            };
        } foreach _sArr;
        // -- Update the server and public values for the store array
        _sObj setVariable ["storeArray", _sArr, true];
		[netID _sObj, ["storeArray", _sArr]] call MV_Server_fnc_SetMissionVariable;
	};
	
	case "typeItemStore":
	{
		private ['_sArr', '_iName', '_qty'];
		// -- Get store array
		_sArr = [netID _sObj, "storeArray"] call MV_Server_fnc_GetMissionVariable;
        // -- Get Classname of item, qty
        _iName = _args select 0;
        _qty = _args select 1; // Positive to add, negative to remove.
        // -- Find item name within store array
        {
            // -- assign a new value to the index
            if ((_x select 0) == _iName) exitwith {
                if ((_x select 1) + _qty >= 0) then {
                	_x set [1, (_x select 1) + _qty];
                    _aSuccess = true;
                };
            };
        } foreach _sArr;
        // -- Update the server and public values for the store array
        _sObj setVariable ["storeArray", _sArr, true];
		[netID _sObj, ["storeArray", _sArr]] call MV_Server_fnc_SetMissionVariable;
	};
};

_aSuccess