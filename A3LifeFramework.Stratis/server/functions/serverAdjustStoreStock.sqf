/* serverAdjustStoreStock script
Created: 15/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Reduces a specific store's stock of a specific item, by class name. Action is type specific.
Params: [storeObj, [classname, quantity]]
*/

private ['_sObj', '_args', '_sType'];
_sObj = _this select 0;
_args = _this select 1;
// Fetch interactType from serverside
_sType = _sObj getVariable "interactTypeServer";

switch (_sType) do
{
	case "typeVehicleStore":
	{
        private ['_sArr', '_cName', '_qty'];
		// -- Get store array
        _sArr = _sObj getVariable "storeArrayServer";
        // -- Get Classname of item, qty
        _cName = _args select 0;
        _qty = _args select 1; // Positive to add, negative to remove.
        // -- Find classname within store array
        {
            // -- assign a new value to the index, using _x set [1, [(_x select 1) - _qty]];
            if ((_x select 0) == _cName) exitwith {_x set [1, (_x select 1) + _qty];};
        } foreach _sArr;
        // -- Update the server and public values for the store array
        _sObj setVariable ["storeArray", _sArr, true];
        _sObj setVariable ["storeArrayServer", _sArr];
	};
	
    
};