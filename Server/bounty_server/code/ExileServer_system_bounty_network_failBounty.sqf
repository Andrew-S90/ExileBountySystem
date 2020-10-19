 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_sessionID", "_parameters", "_failType", "_playerObject", "_targetObject"];

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
			diag_log format["%1 failed bounty vs %2: Safezone",_playerObject,(_playerObject getVariable ["ExileBountyTarget", ""])];
		};
		case 1: 
		{ 
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed! Rewards aren't given to territory campers!"]]] call ExileServer_system_network_send_to;
			diag_log format["%1 failed bounty vs %2: Territory",_playerObject,(_playerObject getVariable ["ExileBountyTarget", ""])];
		};
		case 2: 
		{ 
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed! Rewards aren't given to flyboys!"]]] call ExileServer_system_network_send_to;
			diag_log format["%1 failed bounty vs %2: Height",_playerObject,(_playerObject getVariable ["ExileBountyTarget", ""])];
		};
		case 3: 
		{ 
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed! Time limit reached"]]] call ExileServer_system_network_send_to;
			diag_log format["%1 failed bounty vs %2: Time Limit",_playerObject,(_playerObject getVariable ["ExileBountyTarget", ""])];
		};
		default 
		{ 
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed!"]]] call ExileServer_system_network_send_to;
		};
	};
	
	_targetObject = (_playerObject getVariable ["ExileBountyTarget", ""]) call ExileClient_util_player_objectFromPlayerUid;
	_targetObject call ExileServer_system_bounty_hunterFailed;
	_targetObject setVariable ["ExileBountyHunter", ""];
	_targetObject setVariable ["ExileBountyTargeted", false, true];
	
	_playerObject setVariable ["ExileBountyTarget", ""];
	_playerObject setVariable ["ExileBounty", false, true];
	_playerObject setVariable ["ExileBountyTrader", 30, true];
	_playerObject setVariable ["ExileBountyTerritory", 30, true];
	_playerObject setVariable ["ExileBountyHeight", 30, true];
}
catch
{
	[_sessionID, "toastRequest", ["ErrorTitleOnly", [_exception]]] call ExileServer_system_network_send_to;
};