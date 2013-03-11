/* clientSpawnPlayer script
Created: 02/03/2013
Author: Markus Davey
Skype: markus.davey
Desc: Spawns the player.
*/

private['_spawnPos'];

// Test which side the player is, as to how to handle their spawning in.
switch (Client_PlayerSide) do
{
    case west:
    {
        // Player is a PeaceKeeper
        
        // Init gear
        removeallweapons player;
	    removeHeadgear player;
	    removeVest player;
	    removeUniform player;
	    player addUniform "U_B_CombatUniform_mcam_vest";
	    player addheadgear "H_Cap_blu";
	    player addVest "V_Chestrig_khk";
        for "_i" from 0 to 10 do {player addmagazine ["16Rnd_9x21_Mag", 2];}; // When a player is hit by this bullet, a call is made, asking the shooter which pistol they have. If Rook, stun player.
        player addweapon "hgun_Rook40_F"; // The Rook is the 'stun gun'.
        
        
        // This IF should really be a switch statement.
        if (Client_SpawnType == "first") then 
        {
            diag_log "Spawning for the first time";
            // TODO Play BLUFOR intro
            _spawnPos = getmarkerpos "Spawn_BLU" findEmptyPosition[0, 10, "B_Soldier_F"];
            player setposATL _spawnPos;
        	player setdir markerDir "Spawn_BLU";
            Client_SpawnType = "";
        } else {
            // If the player died, spawn them at the hospital. BLUFOR MAY have their own near-base hospital, or a MASH tent or something.
            // TODO spawn BLUFOR at BLUFOR Hospital/MASH if they died.
            diag_log "Unit has spawned before";
            //
            _spawnPos = getmarkerpos "Spawn_BLU" findEmptyPosition[0, 10, "B_Soldier_F"];
            player setposATL _spawnPos;
        	player setdir markerDir "Spawn_BLU";
        };
    };
    
    case civilian:
    {
        _spawnPos = getmarkerpos "Spawn_CIV" findEmptyPosition[0, 10, "B_Soldier_F"];
        player setposATL _spawnPos;
        player setdir markerDir "Spawn_CIV";
    };
    
    default {diag_log format["Player %1 joined non-supported side %2", Client_PlayerName, Client_PlayerSideStr];};
};


// Leave last --------- Set player as spawned.
Client_PlayerSpawned = true;