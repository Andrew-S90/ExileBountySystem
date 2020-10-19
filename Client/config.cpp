class CfgNetworkMessages
{
	class startBountyKing
	{
		module="system_bounty";
		parameters[]=
		{
			"OBJECT"
		};
	};

	class bountyKingKilled
	{
		module="system_bounty";
		parameters[]=
		{
			"STRING",
			"STRING"
		};
	};

	class bountyKingSurvived
	{
		module="system_bounty";
		parameters[]=
		{
			"STRING",
			"STRING"
		};
	};

	class bountyKingStart
	{
		module="system_bounty";
		parameters[]=
		{
			"SCALAR",
			"SCALAR"
		};
	};
	
	class surviveBountyKing
	{
		module="system_bounty";
		parameters[]=
		{
			"BOOL"
		};
	};
	
	class failBountyKing
	{
		module="system_bounty";
		parameters[]=
		{
			"SCALAR"
		};
	};

	class startBounty
	{
		module="system_bounty";
		parameters[]=
		{
			"OBJECT"
		};
	};

	class bountyStart
	{
		module="system_bounty";
		parameters[]=
		{
			"OBJECT",
			"SCALAR",
			"SCALAR"
		};
	};

	class bountyStartTarget 
	{
		module="system_bounty";
		parameters[]=
		{
			"OBJECT",
			"SCALAR",
			"SCALAR"
		};
	};

	class failBounty
	{
		module="system_bounty";
		parameters[]=
		{
			"SCALAR"
		};
	};

	class targetFailBounty
	{
		module="system_bounty";
		parameters[]=
		{
			"SCALAR"
		};
	};

	class bountyBaguetteRequest
	{
		module="gui";
		parameters[]=
		{
			"STRING",
			"STRING",
			"BOOL"
		};
	};
};	

//*****************
class CfgExileCustomCode 
{
	/*
		You can overwrite every single file of our code without touching it.
		To do that, add the function name you want to overwrite plus the 
		path to your custom file here. If you wonder how this works, have a
		look at our bootstrap/fn_preInit.sqf function.

		Simply add the following scheme here:

		<Function Name of Exile> = "<New File Name>";

		Example:

		ExileClient_util_fusRoDah = "myaddon\myfunction.sqf";
	*/
	
	//ExileBountySystem Start
	ExileClient_object_player_safezone_checkSafezone = "customcode\client\ExileClient_object_player_safezone_checkSafezone.sqf";
	
	ExileServer_object_player_event_onMpKilled = "customcode\server\ExileServer_object_player_event_onMpKilled.sqf";
	ExileServer_object_vehicle_event_onGetIn = "customcode\server\ExileServer_object_vehicle_event_onGetIn.sqf";
	ExileServer_util_getFragPerks = "customcode\server\ExileServer_util_getFragPerks.sqf";
	//ExileBountySystem End
	
};

//*****************

class CfgInteractionMenus //add two menus to the bottom
{
	class Bounty
	{
		targetType = 2;
		target = "Land_PortableWeatherStation_01_white_F";

		class Actions 
		{			
			class Start: ExileAbstractAction
			{
				title = "Start Bounty Mission";
				condition = "_this call ExileClient_bounty_showCondition";
				action = "_this call ExileClient_bounty_startMission";
			};
		};
	};
	
	class BountyKing
	{
		targetType = 2;
		target = "Land_PortableWeatherStation_01_olive_F";

		class Actions 
		{			
			class Start: ExileAbstractAction
			{
				title = "Start Bounty King Mission";
				condition = "_this call ExileClient_bountyKing_showCondition";
				action = "_this call ExileClient_bountyKing_startMission";
			};
		};
	};
};