/* 
Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

//

clientFishingNetUse script
Created: 20/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: If the player is in a boat, has the keys, and is in the driver's seat, on water and it's deeper than the net's depth, they can 'deploy' their fishing net. 
Deploying assigns a variable to the boat, variable: 'NetDeployed', boolisDeployed, strNetName
An option needs to be added to the player so that they can undeploy the net. 
I would leave the net item in the player's inventory, and if they ever dismount, they take the net with them.
If they 'use' the net whilst it is deployed, they'll recall the net.
All 'use' scripts MUST exit with setting 'Client_UsingItem' to false.
Return:
*/

Client_UsingItem = true;
private ['_iName','_args', '_useVehicle', '_isDeployed'];
_iName = _this select 0;
_args = _this select 2;
_useVehicle = vehicle player;

diag_log format ['MV: clientFishingNetUse: _iName: %1, _Args: %2, _useVehicle: %3', _iName, _args, _useVehicle];

_isDeployed = _useVehicle getVariable 'NetDeployed';
if (isnil '_isDeployed') then {_isDeployed = false} else {_isDeployed = _isDeployed select 0};
diag_log format ['_isDeployed: %1', _isDeployed];

// -- If the net is deployed,
if (_isDeployed) exitwith 
{
	// -- Recall the net.
	["UseItemEvent", [_iName, 'RecallNet', [netId _useVehicle]]] call MV_Client_fnc_SendServerMessage;
	Client_UsingItem = false;
};

// -- Check if user is in a boat.
if (!(_useVehicle isKindOf 'ship')) exitwith {["Error",localize "STR_MV_ITEM_FISHNETUSENOTBOAT"] spawn MV_Client_fnc_int_MessageBox;diag_log "Not boat";Client_UsingItem = false;}; 

// -- Check if user is in driver's position
if (driver _useVehicle != player) exitwith {["Error",localize "STR_MV_ITEM_FISHNETUSENOTDRIVER"] spawn MV_Client_fnc_int_MessageBox;diag_log "Not driver";Client_UsingItem = false;};

// -- Check if user has the keys to this vehicle.
if (!((netID _usevehicle) in (player getVariable 'keychain'))) exitwith {["Error",localize "STR_MV_ITEM_FISHNETUSENOKEYS"] spawn MV_Client_fnc_int_MessageBox;diag_log "No keys";Client_UsingItem = false;}; 

// -- Check if the player is on water...
if (!surfaceIsWater (getPosATL player)) exitwith {["Error",localize "STR_MV_ITEM_FISHNETUSENOTONWATER"] spawn MV_Client_fnc_int_MessageBox;diag_log 'Not on water!';Client_UsingItem = false;}; 

// -- Check if water is deep enough.
private ['_nDepth', '_mDepth'];
_nDepth = ((getPosATL player) select 2);
_mDepth = _args select 0;
diag_log format ['_nDepth: %1, _mDepth: %2', _nDepth, _mDepth];
if (_nDepth < _mDepth) exitwith {["Error", format [localize "STR_MV_ITEM_FISHNETUSETOOSHALLOW", _mDepth]] spawn MV_Client_fnc_int_MessageBox;diag_log 'Too shallow!';Client_UsingItem = false;};
	
// -- Passed validation. Send server message to deploy the net.
["UseItemEvent", [_iName, 'DeployNet', [netId _useVehicle]]] call MV_Client_fnc_SendServerMessage;

// -- Leave last
Client_UsingItem = false;