 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_player", "_bountyMaxHeight", "_isInTerritory", "_isInTrader", "_traderTime", "_territoryTime", "_heightTime"];

_player = _this select 0;
_bountyMaxHeight = _this select 1;


if (player getVariable ["ExileBounty",false]) then
{
	if(ExileClientBountyFlip) then
	{
		ExileClientBountyMarker setMarkerPosLocal _player;
	}
	else
	{
		ExileClientBountyFlip = !ExileClientBountyFlip;
	};
	
	_isInTerritory = player call ExileClient_util_world_isInTerritory;
	_isInTrader = player call ExileClient_util_world_isInTraderZone;
	_traderTime = player getVariable ["ExileBountyTrader", 30];
	_territoryTime = player getVariable ["ExileBountyTerritory", 30];
	_heightTime = player getVariable ["ExileBountyHeight", 30];
	
	if (((getPosATL player) select 2) < _bountyMaxHeight) then
	{
		if(_isInTrader) then
		{
			if (_traderTime <= 0) then
			{
				player setVariable ["ExileBountyTrader", 30, true];
				player setVariable ["ExileBountyTerritory", 30, true];
				player setVariable ["ExileBountyHeight", 30, true];
				["failBounty", [0]] call ExileClient_system_network_send;
				deleteMarkerLocal ExileClientBountyMarker;
				diag_log format["Bounty Monitor: %1 Failed Bounty! - Too long in Trader!",(_x select 1)];
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
				["failBounty", [1]] call ExileClient_system_network_send;
				deleteMarkerLocal ExileClientBountyMarker;
				diag_log format["Bounty Monitor: %1 Failed Bounty! - Too long in Territory",(_x select 1)];
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
			["failBounty", [2]] call ExileClient_system_network_send;
			deleteMarkerLocal ExileClientBountyMarker;
			diag_log format["Bounty Monitor: %1 Failed Bounty! - Flying too high!",player];
		}
		else
		{
			["ErrorTitleAndText", ["Bounty", format["You have %1 seconds to lower your height before disqualification!",_heightTime]]] call ExileClient_gui_toaster_addTemplateToast;
			player setVariable ["ExileBountyHeight", (_heightTime-3), true];
		};
	};
}
else
{
	deleteMarkerLocal ExileClientBountyMarker;
	diag_log format["LOCAL BOUNTYWATCH STOPPED"];
};