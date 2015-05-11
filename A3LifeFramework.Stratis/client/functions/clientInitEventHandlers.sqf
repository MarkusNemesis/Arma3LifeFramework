/* 

Copyright (c) 2013 by Markus Davey.

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

//

clientInitEventHandlers script
Created: 04/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Initialises all the event handlers that are run on the client.
Return:
*/

Client_KilledEH = player addEventHandler ["killed", {_this call MV_Client_fnc_KilledEH}];
Client_RespawnEH = player addEventHandler ["respawn", {_this call MV_Client_fnc_RespawnEH}];
Client_HitEH = player addEventHandler ["HandleDamage", {_this call MV_Client_fnc_HitEH}];
"PublicMessageBroadcast" addPublicVariableEventHandler {_this call MV_Client_fnc_PublicCommVarEH}; // Format: ["Type", [Array, Args]]
//"KillMessageBroadcast" addPublicVariableEventHandler {call MV_Client_fnc_KillMessage};