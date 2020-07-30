private ["_currentKings", "_currentBounties", "_headlessClients", "_humanPlayers", "_kingPoptabs", "_kingRespect", "_kingBonus", "_kingMaxHeight", "_endLoop", "_playerObject", "_marker", "_bountyKingEndTime", "_isInTerritory", "_isInTrader", "_traderTime", "_territoryTime", "_heightTime", "_sessionID", "_poptabReward", "_respectReward", "_playerRespect", "_playerMoney", "_result"];
diag_log "Bounty Server Monitor Loop";

_currentKings = ExileBountyKings;
_currentBounties = ExileBountyBounties;
_headlessClients = entities "HeadlessClient_F";
_humanPlayers = count (allPlayers - _headlessClients);
_kingPoptabs = getNumber(configFile >> "BountySettings" >> "King" >> "poptabs");
_kingRespect = getNumber(configFile >> "BountySettings" >> "King" >> "respect");
_kingBonus = getNumber(configFile >> "BountySettings" >> "King" >> "bonus");
_kingMaxHeight = getNumber(configFile >> "BountySettings" >> "King" >> "maxHeight");

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
				_marker setMarkerPos _playerObject;
				_bountyKingEndTime = (_x select 0) getVariable ["ExileBountyKingEndTime", 0];
				_isInTerritory = _playerObject call ExileClient_util_world_isInTerritory;
				_isInTrader = _playerObject call ExileClient_util_world_isInTraderZone;
				_traderTime = _playerObject getVariable ["ExileBountyTrader", 30];
				_territoryTime = _playerObject getVariable ["ExileBountyTerritory", 30];
				_heightTime = _playerObject getVariable ["ExileBountyHeight", 30];
				_sessionID = _playerObject getVariable ["ExileSessionID", -1];
				
				if (((getPosATL _playerObject) select 2) < _kingMaxHeight) then
				{
					if(_isInTrader) then
					{
						if (_traderTime <= 0) then
						{
							[_sessionID, "toastRequest", ["ErrorTitleAndText", ["BountyKing", "Bounty Failed! Rewards aren't given to safezone campers!"]]] call ExileServer_system_network_send_to;
							_playerObject setVariable ["ExileBountyTrader", 30, true];
							_playerObject setVariable ["ExileBountyTerritory", 30, true];
							_playerObject setVariable ["ExileBountyHeight", 30, true];
							_playerObject setVariable ["ExileBountyKing", false, true];
							ExileBountyKings deleteAt _forEachIndex;
							deleteMarker _marker;
							diag_log format["Bounty Monitor: %1 Failed BountyKing! - Too long in Trader!",(_x select 1)];
						}
						else
						{
							[_sessionID, "toastRequest", ["ErrorTitleAndText", ["BountyKing", format["You have %1 seconds to leave the trader before disqualification!",_traderTime]]]] call ExileServer_system_network_send_to;
							_playerObject setVariable ["ExileBountyTrader", (_traderTime-3), true];
						};
						
					};
					
					if(_isInTerritory && (((getPosATL _playerObject) select 2) <= 75)) then
					{
						if (_territoryTime <= 0) then
						{
							[_sessionID, "toastRequest", ["ErrorTitleAndText", ["BountyKing", "Bounty Failed! Rewards aren't given to territory campers!"]]] call ExileServer_system_network_send_to;
							_playerObject setVariable ["ExileBountyTrader", 30, true];
							_playerObject setVariable ["ExileBountyTerritory", 30, true];
							_playerObject setVariable ["ExileBountyHeight", 30, true];
							_playerObject setVariable ["ExileBountyKing", false, true];
							ExileBountyKings deleteAt _forEachIndex;
							deleteMarker _marker;
							diag_log format["Bounty Monitor: %1 Failed BountyKing! - Too long in Territory",(_x select 1)];
						}
						else
						{
							[_sessionID, "toastRequest", ["ErrorTitleAndText", ["BountyKing", format["You have %1 seconds to leave the territory before disqualification!",_territoryTime]]]] call ExileServer_system_network_send_to;
							_playerObject setVariable ["ExileBountyTerritory", (_territoryTime-3), true];
						};
					};
					
					if (time > _bountyKingEndTime) then
					{
						_reward = true;
						if (_isInTerritory && (((getPosATL _playerObject) select 2) <= 75)) then
						{
							_reward = false;
							diag_log format["Bounty Monitor: %1 Survived BountyKing! But failed due to being in a territory!",(_x select 1)];
						};
						if !(((getPosATL _playerObject) select 2) < _kingMaxHeight) then
						{
							_reward = false;
							diag_log format["Bounty Monitor: %1 Survived BountyKing! But failed due to being too high!",(_x select 1)];
						};
						if (_isInTrader) then
						{
							_reward = false;
							diag_log format["Bounty Monitor: %1 Survived BountyKing! But failed due to being in a trader!",(_x select 1)];
						};
						if !((getposatl _playerObject) inArea [[worldSize/2,worldSize/2,0], (worldSize/2), (worldSize/2), 0, true]) then
						{
							_reward = false;
							diag_log format["Bounty Monitor: %1 Survived BountyKing! But failed due to being outside the map!",(_x select 1)];
						};
						if (_reward) then
						{
							_poptabReward = _humanPlayers * _kingPoptabs * _kingBonus;
							_respectReward = _humanPlayers * _kingRespect * _kingBonus;
							_playerObject setVariable ["ExileBountyTrader", 30, true];
							_playerObject setVariable ["ExileBountyTerritory", 30, true];
							_playerObject setVariable ["ExileBountyHeight", 30, true];
							_playerObject setVariable ["ExileBountyKing", false, true];
							ExileBountyKings deleteAt _forEachIndex;
							deleteMarker _marker;
							
							_playerRespect = _playerObject getVariable ["ExileScore", 0];
							_playerMoney = _playerObject getVariable ["ExileMoney", 0];
							
							_playerRespect = floor (_playerRespect + _respectReward);
							_playerMoney = floor (_playerMoney + _poptabReward);
							
							_playerObject setVariable ["ExileScore", _playerRespect];
							format["setAccountScore:%1:%2", _playerRespect, (getPlayerUID _playerObject)] call ExileServer_system_database_query_fireAndForget;
							
							_playerObject setVariable ["ExileMoney", _playerMoney, true];
							format["setPlayerMoney:%1:%2", _playerMoney, _playerObject getVariable ["ExileDatabaseID", 0]] call ExileServer_system_database_query_fireAndForget;
							
							//[_sessionID, "toastRequest", ["SuccessTitleAndText", ["BountyKing", "You survived!"]]] call ExileServer_system_network_send_to;
							[_sessionID, "bountyKingSurvived", [str(_poptabReward),str(_respectReward)]] call ExileServer_system_network_send_to;
							diag_log format["Bounty Monitor: %1 Survived BountyKing! Earned: %2 poptabs %3 respect",(_x select 1),_poptabReward,_respectReward];
						}
						else
						{
							_playerObject setVariable ["ExileBountyKing", false, true];
							ExileBountyKings deleteAt _forEachIndex;
							deleteMarker _marker;
							_playerObject setVariable ["ExileBountyTrader", 30, true];
							_playerObject setVariable ["ExileBountyTerritory", 30, true];
							_playerObject setVariable ["ExileBountyHeight", 30, true];
							_playerObject setVariable ["ExileBountyKing", false, true];
						};
					};
				}
				else
				{
					if (_heightTime <= 0) then
					{
						[_sessionID, "toastRequest", ["ErrorTitleAndText", ["BountyKing", "Bounty Failed! Rewards aren't given to flyboys!"]]] call ExileServer_system_network_send_to;
						_playerObject setVariable ["ExileBountyTrader", 30, true];
						_playerObject setVariable ["ExileBountyTerritory", 30, true];
						_playerObject setVariable ["ExileBountyHeight", 30, true];
						_playerObject setVariable ["ExileBountyKing", false, true];
						ExileBountyKings deleteAt _forEachIndex;
						deleteMarker _marker;
						diag_log format["Bounty Monitor: %1 Failed BountyKing! - Hiding too high!",(_x select 1)];
					}
					else
					{
						[_sessionID, "toastRequest", ["ErrorTitleAndText", ["BountyKing", format["You have %1 seconds to lower your height before disqualification!",_heightTime]]]] call ExileServer_system_network_send_to;
						_playerObject setVariable ["ExileBountyHeight", (_heightTime-3), true];
					};
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

/*
{
	if !((_x select 1) isEqualTo "") then
	{
		_playerObject = (_x select 1) call ExileClient_util_player_objectFromPlayerUid;
		if !(_playerObject isEqualTo objNull) then
		{
			if ((ExileBountyFlop % 2) isEqualTo 0) then
			{
				_marker = (_x select 0) getVariable ["ExileBountyMarker",""];
				_marker setMarkerPos _playerObject;
			}
			else
			{
				ExileBountyFlop = ExileBountyFlop + 1;
			};
		}
		else
		{
		 
		};
	};
} forEach ExileBountyBounties;*/


if (_endLoop) then
{
	_result = [ExileBountyWatcherKing] call ExileServer_system_thread_removeTask;
	if (_result) then
	{
		ExileBountyWatcherKing = -1;
	};
};