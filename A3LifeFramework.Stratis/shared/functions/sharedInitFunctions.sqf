/* sharedInitFunctions script
Created: 02/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Precompiles functions and makes them available. They are not restricted and can be called on both server and client.
*/

MV_Shared_fnc_initParams = Compile preprocessFileLineNumbers "shared\functions\sharedInitParams.sqf";
MV_Shared_fnc_GetPlayers = Compile preprocessFileLineNumbers "shared\functions\sharedGetPlayers.sqf";
MV_Shared_fnc_SetSuperAI = Compile preprocessFileLineNumbers "shared\functions\sharedSetSuperAI.sqf";
MV_Shared_fnc_InitUnitUniform = Compile preprocessFileLineNumbers "shared\functions\sharedInitUnitUniform.sqf";


// MV_Shared_fnc_ = Compile preprocessFileLineNumbers "shared\functions\";