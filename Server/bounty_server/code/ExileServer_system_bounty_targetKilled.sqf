 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_playerObject", "_headlessClients", "_humanPlayers", "_bountyPoptabs", "_bountyBonus", "_poptabReward", "_playerMoney", "_sessionID"];

_playerObject = _this;

_headlessClients = entities "HeadlessClient_F";
_humanPlayers = count (allPlayers - _headlessClients);

_bountyPoptabs = getNumber(configFile >> "BountySettings" >> "Bounty" >> "poptabs");
_bountyBonus = getNumber(configFile >> "BountySettings" >> "Bounty" >> "bonus");

_poptabReward = _humanPlayers * _bountyPoptabs * _bountyBonus;

_playerObject setVariable ["ExileBountyTrader", 30, true];
_playerObject setVariable ["ExileBountyTerritory", 30, true];
_playerObject setVariable ["ExileBountyHeight", 30, true];
_playerObject setVariable ["ExileBounty", false, true];

_playerMoney = _playerObject getVariable ["ExileMoney", 0];
_playerMoney = floor (_playerMoney + _poptabReward);
	
_playerObject setVariable ["ExileMoney", _playerMoney, true];
format["setPlayerMoney:%1:%2", _playerMoney, _playerObject getVariable ["ExileDatabaseID", 0]] call ExileServer_system_database_query_fireAndForget;
	
_sessionID = _playerObject getVariable ["ExileSessionID", -1];
[_sessionID, "toastRequest", ["SuccessTitleAndText", ["Bounty Target Killed!", format ["+%1<img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='24'/>", _poptabReward]]]] call ExileServer_system_network_send_to;
	
diag_log format["BOUNTY REWARD: %1 EARNED %2 POPTABS: TARGETKILLED",_playerObject,_poptabReward];