/* sharedInitParams script
Created: 02/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Puts the parameter settings from the paramsArray into global shared variables. 
The order they're assigned MUST match the order they are in, within the parameters.hpp file. MUST
*/

if (!isnil "paramsArray") then 
{
    Private['_i'];
	_i = 0;
    
    MV_Params_GPStartFunds = paramsArray select _i; _i = _i + 1;
    MV_Params_GCDelayVehicles = paramsArray select _i; _i = _i + 1;
    MV_Params_GCDelayCorpses = paramsArray select _i; _i = _i + 1;
    
    
    // MV_Params_ = paramsArray select _i; _i = _i + 1;
};