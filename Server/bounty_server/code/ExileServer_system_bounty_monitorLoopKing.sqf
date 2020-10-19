 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_currentKings", "_currentBounties", "_endLoop", "_playerObject", "_marker", "_result"];
diag_log "Bounty Server Monitor Loop";

_currentKings = ExileBountyKings;
_currentBounties = ExileBountyBounties;
_endLoop = true;

{
	if !((_x select 1) isEqualTo "") then
	{
		_endLoop = false;
		_playerObject = (_x select 1) call ExileClient_util_player_objectFromPlayerUid;
		if !(_playerObject isEqualTo objNull) then
		{
			if ((_x select 0) getVariable ["ExileBountyKingStarted", false]) then
			{
				_marker = (_x select 0) getVariable ["ExileKingBountyMarker",""];
				if (_playerObject getVariable ["ExileBountyKing",false]) then
				{
					_marker setMarkerPos _playerObject;
				}
				else
				{
					ExileBountyKings deleteAt _forEachIndex;
					deleteMarker _marker;
				};
			};
		}
		else
		{
			//disconnected or dead temp
			_marker = (_x select 0) getVariable ["ExileKingBountyMarker",""];
			ExileBountyKings deleteAt _forEachIndex;
			deleteMarker _marker;
			diag_log format["Bounty Monitor: %1 Failed BountyKing! - Not logged in",(_x select 1)];
		};
	};
} forEach _currentKings;


if (_endLoop) then
{
	_result = [ExileBountyWatcherKing] call ExileServer_system_thread_removeTask;
	if (_result) then
	{
		ExileBountyWatcherKing = -1;
	};
};