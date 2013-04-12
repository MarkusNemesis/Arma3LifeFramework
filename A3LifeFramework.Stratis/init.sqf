/* init.sqf script
Created: 02/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Starts the mission. If you're a client, you run as a client, if you're a server, you run as a server.
PLEASE NOTE: HOSTING AS A HOST CLIENT WILL NOT WORK WITH THIS MISSION. RUNNING LIKE THIS BREAKS MANY FEATURES AND SO THUS IS PURPOSEFULLY DISABLED.
Return:
*/

Client_InitComplete = false;
Server_InitComplete = false;
enableEnvironment false;
// -- If server, start server side.
if (isServer) then 
{
    if (!isDedicated) exitwith {titleText ["NOTE: HOSTING AS A HOST CLIENT WILL NOT WORK WITH THIS MISSION. RUNNING LIKE THIS BREAKS MANY FEATURES AND SO THUS IS PURPOSEFULLY DISABLED.", "BLACK FADED", 4096];};
	execVM "server\serverInit.sqf"; 
};

// -- If not server, but has interface, start client side.
if (!isServer /*&& hasInterface*/) then {
    execVM "client\clientInit.sqf";
};

/* -- If not server and doesn't hasinterface, then run Headless Client script.
if (!isServer && !hasInterface) then {
    execVM "headlessclient\hcInit.sqf";
};
*/