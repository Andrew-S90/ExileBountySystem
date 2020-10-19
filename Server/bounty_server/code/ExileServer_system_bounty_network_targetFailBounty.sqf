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
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed! Can't hide in safezones!"]]] call ExileServer_system_network_send_to;
			diag_log format["%1 target failed bounty vs %2: Safezone",_playerObject,(_playerObject getVariable ["ExileBountyHunter", ""])];
		};
		case 1: 
		{ 
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed! Can't hide in territories!"]]] call ExileServer_system_network_send_to;
			diag_log format["%1 target failed bounty vs %2: Territory",_playerObject,(_playerObject getVariable ["ExileBountyHunter", ""])];
		};
		case 2: 
		{ 
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed! Can't hide in the sky!"]]] call ExileServer_system_network_send_to;
			diag_log format["%1 target failed bounty vs %2: Height",_playerObject,(_playerObject getVariable ["ExileBountyHunter", ""])];
		};
		default 
		{ 
			[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed!"]]] call ExileServer_system_network_send_to;
		};
	};
	
	_targetObject = (_playerObject getVariable ["ExileBountyHunter", ""]) call ExileClient_util_player_objectFromPlayerUid;
	_targetObject call ExileServer_system_bounty_targetFailed;
	
	_playerObject setVariable ["ExileBountyHunter", ""];
	_playerObject setVariable ["ExileBountyTargeted", false, true];
	
	_targetObject setVariable ["ExileBountyTarget", ""];
	_targetObject setVariable ["ExileBounty", false, true];
	_targetObject setVariable ["ExileBountyTrader", 30, true];
	_targetObject setVariable ["ExileBountyTerritory", 30, true];
	_targetObject setVariable ["ExileBountyHeight", 30, true];
}
catch
{
	[_sessionID, "toastRequest", ["ErrorTitleOnly", [_exception]]] call ExileServer_system_network_send_to;
};