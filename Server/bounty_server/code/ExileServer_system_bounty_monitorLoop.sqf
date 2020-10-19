 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_currentBounties", "_endLoop", "_playerObject", "_targetUID", "_targetObject", "_sessionID", "_sessionIDTarget", "_result"];
diag_log "Bounty Server Monitor Loop";

_currentBounties = ExileBountyBounties;

_endLoop = true;

{
	if !((_x select 1) isEqualTo "") then
	{
		_endLoop = false;
		_playerObject = (_x select 1) call ExileClient_util_player_objectFromPlayerUid;
		_targetUID = (_x select 0) getVariable ["ExileBountyTarget", ""];
		_targetObject = _targetUID call ExileClient_util_player_objectFromPlayerUid;
		if ( !(_playerObject isEqualTo objNull) && !(_targetObject isEqualTo objNull)) then
		{
			if ((_x select 0) getVariable ["ExileBountyStarted", false]) then
			{
				if !(_playerObject getVariable ["ExileBounty", false]) then
				{
					_sessionID = _playerObject getVariable ["ExileSessionID", -1];
					_sessionIDTarget = _targetObject getVariable ["ExileSessionID", -1];
					
					ExileBountyBounties deleteAt _forEachIndex;
					_playerObject setVariable ["ExileBountyTrader", 30, true];
					_playerObject setVariable ["ExileBountyTerritory", 30, true];
					_playerObject setVariable ["ExileBountyHeight", 30, true];
					_playerObject setVariable ["ExileBounty", false, true];
					_playerObject setVariable ["ExileBountyTarget", ""];
					
					_targetObject setVariable ["ExileBountyHunter", ""];
					
					diag_log format["Bounty Monitor: %1 Failed Bounty!",(_x select 1)];
				};
				
				if (_targetObject getVariable ["ExileBountyHunter", ""] isEqualTo "") then
				{
					_sessionID = _playerObject getVariable ["ExileSessionID", -1];
					
					ExileBountyBounties deleteAt _forEachIndex;
					_playerObject setVariable ["ExileBountyTrader", 30, true];
					_playerObject setVariable ["ExileBountyTerritory", 30, true];
					_playerObject setVariable ["ExileBountyHeight", 30, true];
					_playerObject setVariable ["ExileBounty", false, true];
					_playerObject setVariable ["ExileBountyTarget", ""];
					
					_targetObject setVariable ["ExileBountyHunter", ""];
					
					diag_log format["Bounty Monitor: %1 Won Bounty did not kill!",(_x select 1)];
				};
			};
		}
		else
		{
			if (_targetObject isEqualTo objNull) then
			{
				[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Bounty", "Bounty Failed! Target vanished!"]]] call ExileServer_system_network_send_to;
				//replace with remove marker since target vanished script
			};
			if (_playerObject isEqualTo objNull) then
			{
				[_sessionIDTarget, "toastRequest", ["SuccessTitleAndText", ["Bounty", "Survived the hunt! Hunter vanished!"]]] call ExileServer_system_network_send_to;
				//replace with remove marker since target vanished script
			};
			//disconnected or dead temp
			ExileBountyBounties deleteAt _forEachIndex;
			diag_log format["Bounty Monitor: %1 Failed Bounty! - Not logged in",(_x select 1)];
		};
	};
} forEach _currentBounties;

if (_endLoop) then
{
	_result = [ExileBountyWatcher] call ExileServer_system_thread_removeTask;
	if (_result) then
	{
		ExileBountyWatcher = -1;
	};
};