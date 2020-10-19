 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_sessionID", "_parameters", "_won", "_playerObject", "_isInTerritory", "_isInTrader", "_headlessClients", "_humanPlayers", "_kingPoptabs", "_kingRespect", "_kingBonus", "_kingMaxHeight", "_reward", "_poptabReward", "_respectReward", "_playerRespect", "_playerMoney", "_marker"];

_sessionID = _this select 0;
_parameters = _this select 1;
_won = _parameters select 0;

try
{
	_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
	if (isNull _playerObject) then
	{
		throw "Player object not found!";
	};
	
	if !(alive _playerObject) then
	{
		throw "Player object dead!";
	};
	
	if (_won) then 
	{
		_isInTerritory = _playerObject call ExileClient_util_world_isInTerritory;
		_isInTrader = _playerObject call ExileClient_util_world_isInTraderZone;
		_headlessClients = entities "HeadlessClient_F";
		_humanPlayers = count (allPlayers - _headlessClients);
		_kingPoptabs = getNumber(configFile >> "BountySettings" >> "King" >> "poptabs");
		_kingRespect = getNumber(configFile >> "BountySettings" >> "King" >> "respect");
		_kingBonus = getNumber(configFile >> "BountySettings" >> "King" >> "bonus");
		_kingMaxHeight = getNumber(configFile >> "BountySettings" >> "King" >> "maxHeight");
		
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
		if !((getPosATL _playerObject) inArea [[worldSize/2,worldSize/2,0], (worldSize/2), (worldSize/2), 0, true]) then
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
			
			_playerRespect = _playerObject getVariable ["ExileScore", 0];
			_playerMoney = _playerObject getVariable ["ExileMoney", 0];
			
			_playerRespect = floor (_playerRespect + _respectReward);
			_playerMoney = floor (_playerMoney + _poptabReward);
			
			_playerObject setVariable ["ExileScore", _playerRespect];
			format["setAccountScore:%1:%2", _playerRespect, (getPlayerUID _playerObject)] call ExileServer_system_database_query_fireAndForget;
			
			_playerObject setVariable ["ExileMoney", _playerMoney, true];
			format["setPlayerMoney:%1:%2", _playerMoney, _playerObject getVariable ["ExileDatabaseID", 0]] call ExileServer_system_database_query_fireAndForget;
			
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
catch
{
	_playerObject setVariable ["ExileBountyKing", false, true];
	_playerObject setVariable ["ExileBountyTrader", 30, true];
	_playerObject setVariable ["ExileBountyTerritory", 30, true];
	_playerObject setVariable ["ExileBountyHeight", 30, true];
	[_sessionID, "toastRequest", ["ErrorTitleOnly", [_exception]]] call ExileServer_system_network_send_to;
};