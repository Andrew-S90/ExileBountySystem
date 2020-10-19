 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_sessionID", "_parameters", "_failType", "_playerObject"];

_sessionID = _this select 0;
_parameters = _this select 1;
_failType = _parameters select 0;

try
{
	_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
	if (isNull _playerObject) then
	{
		throw "Player object not found!";
	};
	
	switch (_failType) do 
	{
		case 0: 
		{
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed! Rewards aren't given to safezone campers!"]]] call ExileServer_system_network_send_to;
			diag_log format["%1 failed bounty king: Safezone",_playerObject];
		};
		case 1: 
		{ 
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed! Rewards aren't given to territory campers!"]]] call ExileServer_system_network_send_to;
			diag_log format["%1 failed bounty king: Territory",_playerObject];
		};
		case 2: 
		{ 
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed! Rewards aren't given to flyboys!"]]] call ExileServer_system_network_send_to;
			diag_log format["%1 failed bounty king: Height",_playerObject];
		};
		case 3: 
		{ 
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed! Time limit reached"]]] call ExileServer_system_network_send_to;
			diag_log format["%1 failed bounty king: Time Limit",_playerObject];
		};
		default 
		{ 
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed!"]]] call ExileServer_system_network_send_to;
		};
	};
	
	_playerObject setVariable ["ExileBountyKing", false, true];
	_playerObject setVariable ["ExileBountyTrader", 30, true];
	_playerObject setVariable ["ExileBountyTerritory", 30, true];
	_playerObject setVariable ["ExileBountyHeight", 30, true];
}
catch
{
	[_sessionID, "toastRequest", ["ErrorTitleOnly", [_exception]]] call ExileServer_system_network_send_to;
};