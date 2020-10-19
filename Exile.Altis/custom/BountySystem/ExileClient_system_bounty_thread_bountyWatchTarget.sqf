 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_player", "_bountyMaxHeight", "_isInTerritory", "_isInTrader", "_traderTime", "_territoryTime", "_heightTime", "_distance", "_display", "_distanceBar"];

_player = _this select 0;
_bountyMaxHeight = _this select 1;

if (player getVariable ["ExileBountyTargeted",false]) then
{
	_isInTerritory = player call ExileClient_util_world_isInTerritory;
	_isInTrader = player call ExileClient_util_world_isInTraderZone;
	_traderTime = player getVariable ["ExileBountyTrader", 30];
	_territoryTime = player getVariable ["ExileBountyTerritory", 30];
	_heightTime = player getVariable ["ExileBountyHeight", 30];

	_distance = player distance2D _player;
	_display = uiNamespace getVariable [ "LowerBountyTimer", controlNull ];
	_distanceBar = _display displayCtrl 5305;

	if(_distance >= 2500) then
	{
		_distanceBar progressSetPosition 0.01; 
		_distanceBar ctrlSetTextColor [1,1,1,1];
	};
	
	if((_distance < 2500) && (_distance >= 1000)) then
	{
		_distanceBar progressSetPosition 0.25; 
		_distanceBar ctrlSetTextColor [1,1,1,1];
	};
	
	if((_distance < 1000) && (_distance >= 500)) then
	{
		_distanceBar progressSetPosition 0.5; 
		_distanceBar ctrlSetTextColor [1,1,0,1];
	};
	
	if((_distance < 500) && (_distance >= 250)) then
	{
		_distanceBar progressSetPosition 0.75; 
		_distanceBar ctrlSetTextColor [1,0.65,0,1];
	};
	
	if(_distance < 250) then
	{
		_distanceBar progressSetPosition 1; 
		_distanceBar ctrlSetTextColor [1,0,0,1];
	};
	
	
	if (((getPosATL player) select 2) < _bountyMaxHeight) then
	{
		if(_isInTrader) then
		{
			if (_traderTime <= 0) then
			{
				player setVariable ["ExileBountyTrader", 30, true];
				player setVariable ["ExileBountyTerritory", 30, true];
				player setVariable ["ExileBountyHeight", 30, true];
				["targetFailBounty", [0]] call ExileClient_system_network_send;
				diag_log format["Bounty Monitor: %1 Failed Bounty Target! - Too long in Trader!",(_x select 1)];
			}
			else
			{
				["ErrorTitleAndText", ["Bounty", format["You have %1 seconds to leave the trader before disqualification!",_traderTime]]] call ExileClient_gui_toaster_addTemplateToast;
				player setVariable ["ExileBountyTrader", (_traderTime-3), true];
			};
			
		};
		
		if(_isInTerritory && (((getPosATL player) select 2) <= 75)) then
		{
			if (_territoryTime <= 0) then
			{
				player setVariable ["ExileBountyTrader", 30, true];
				player setVariable ["ExileBountyTerritory", 30, true];
				player setVariable ["ExileBountyHeight", 30, true];
				["targetFailBounty", [1]] call ExileClient_system_network_send;
				diag_log format["Bounty Monitor: %1 Failed Bounty Target! - Too long in Territory",(_x select 1)];
			}
			else
			{
				["ErrorTitleAndText", ["Bounty", format["You have %1 seconds to leave the territory before disqualification!",_territoryTime]]] call ExileClient_gui_toaster_addTemplateToast;
				player setVariable ["ExileBountyTerritory", (_territoryTime-3), true];
			};
		};
	}
	else
	{
		if (_heightTime <= 0) then
		{
			player setVariable ["ExileBountyTrader", 30, true];
			player setVariable ["ExileBountyTerritory", 30, true];
			player setVariable ["ExileBountyHeight", 30, true];
			["targetFailBounty", [2]] call ExileClient_system_network_send;
			diag_log format["Bounty Monitor: %1 Failed Bounty Target! - Flying too high!",player];
		}
		else
		{
			["ErrorTitleAndText", ["Bounty", format["You have %1 seconds to lower your height before disqualification!",_heightTime]]] call ExileClient_gui_toaster_addTemplateToast;
			player setVariable ["ExileBountyHeight", (_heightTime-3), true];
		};
	};
};