/* init.sqf script
Created: 02/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: If it's a server and dedicated, it'll only run the serverInit. If the server is not dedicated, the client init will also run. 
If it's not a server, it's a client and runs the clientInit.
NOTE: Lots of functionality is broken due to hosting as both a client and server, as client <> server messages do not work.
Return:
*/

Client_InitComplete = false;
Server_InitComplete = false;
enableEnvironment false;
if (isServer) then 
{
    execVM "server\serverInit.sqf"; 
    if (!isDedicated) then 
	{
        waituntil {Server_InitComplete};
    	execVM "client\clientInit.sqf";
    }; // 'server' is a client hosting the mission. Run both main loops. 
};

if (!isServer) then {
    execVM "client\clientInit.sqf";
};