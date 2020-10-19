 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
class CfgPatches
{
	class bounty_server
	{
		requiredVersion = 0.1;
		requiredAddons[] = {"exile_server_config","exile_server"};
		units[] = {};
		weapons[] = {};
		magazines[] = {};
		ammo[] = {};
	};
};
class CfgFunctions
{
	class bounty_server
	{
		class Bootstrap
		{
			file = "bounty_server\bootstrap";
			class preInit
			{
				preInit = 1;
			};
			class postInit
			{
				postInit = 1;
			};
		};
	};
};


class BountySettings
{
	class King
	{
		enabled = 1;
		
		time = 12; //minutes
		
		respect = 10000; //payout becomes 10,000 respect * 50 (player pop) * 1 (bonus) = 500,000 respect to killer
		
		poptabs = 20000; //payout becomes 20,000 poptabs * 50 (player pop) * 1 (bonus) = 1,000,000 poptabs to killer
		
		bonus = 1; //1x per player.
		
		amount = 3; //how many can be on map + active at the same time
		
		activateDelay = 10; //seconds headstart a target gets to move from the initial location
		
		maxHeight = 500; //meterS
		
		broadcastNewMission = 1; //Broadcasts when a new Bounty King Mission is spawned on the map
		
		blacklist[] =
		{
			"I_Plane_Fighter_03_dynamicLoadout_F", // A-143 Buzzard (CAS)
			"B_Plane_CAS_01_dynamicLoadout_F", // A-164 Wipeout (CAS)
			"O_Plane_CAS_02_dynamicLoadout_F", // To-199 Neophron (CAS)
			"B_Plane_Fighter_01_Stealth_F", // F/A-181 Black Wasp II (Stealth)
			"B_Plane_Fighter_01_F",
			"O_Plane_Fighter_02_F",
			"O_Plane_Fighter_02_Stealth_F", // To-201 Shikra (Stealth)
			"I_Plane_Fighter_04_F", // A-149 Gryphon
			"B_T_VTOL_01_armed_F" // Armed Blackfish
		};
	};
	
	class Bounty
	{
		enabled = 1;
		
		time = 8; //minutes
		
		respect = 5000; //payout becomes 5,000 respect * 50 (player pop) * 1 (bonus) = 250,000 respect to killer
		
		poptabs = 10000; //payout becomes 10,000 poptabs * 50 (player pop) * 1 (bonus) = 500,000 poptabs to killer
		
		bonus = 1; //1x per player.
		
		targetDied = 0.25; //if the target dies by a random player or suicide the hunter gets 25% of the reward
		
		hunterDied = 0.85; //if the hunter dies by a random player or suicide the target gets 85% of the reward
		
		amount = 5; //how many can be on map + active at the same time
		
		activateDelay = 10; //seconds headstart a target gets to move from the initial location
		
		maxHeight = 500; //meterS
		
		broadcastNewMission = 1; //Broadcasts when a new Bounty Mission is spawned on the map
	};
};
