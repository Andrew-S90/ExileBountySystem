 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_playerObject", "_perks", "_headlessClients", "_humanPlayers", "_bountyPoptabs", "_bountyBonus", "_bountyRespect", "_penalty", "_respectReward", "_poptabReward", "_playerMoney", "_oldKillerRespect", "_newKillerRespect", "_sessionID"];

_playerObject = _this;
_perks = [];
_headlessClients = entities "HeadlessClient_F";
_humanPlayers = count (allPlayers - _headlessClients);

_bountyPoptabs = getNumber(configFile >> "BountySettings" >> "Bounty" >> "poptabs");
_bountyBonus = getNumber(configFile >> "BountySettings" >> "Bounty" >> "bonus");
_bountyRespect = getNumber(configFile >> "BountySettings" >> "Bounty" >> "respect");
_penalty = getNumber(configFile >> "BountySettings" >> "Bounty" >> "targetDied");

_respectReward = _humanPlayers * _bountyRespect * _bountyBonus * _penalty;

_poptabReward = _humanPlayers * _bountyPoptabs * _bountyBonus * _penalty;

_playerMoney = _playerObject getVariable ["ExileMoney", 0];
_playerMoney = floor (_playerMoney + _poptabReward);
	
_playerObject setVariable ["ExileMoney", _playerMoney, true];
format["setPlayerMoney:%1:%2", _playerMoney, _playerObject getVariable ["ExileDatabaseID", 0]] call ExileServer_system_database_query_fireAndForget;

_oldKillerRespect = _playerObject getVariable ["ExileScore", 0];
_newKillerRespect = _oldKillerRespect + _respectReward;
_playerObject setVariable ["ExileScore", _newKillerRespect];


format["setAccountScore:%1:%2", _newKillerRespect, getPlayerUID _playerObject] call ExileServer_system_database_query_fireAndForget;
	
_sessionID = _playerObject getVariable ["ExileSessionID", -1];
[_sessionID, "toastRequest", ["SuccessTitleAndText", ["Bounty Target Died!", format ["+%1<img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='24'/>", _poptabReward]]]] call ExileServer_system_network_send_to;
_perks pushBack ["Bounty Target Died!", _respectReward];
[_playerObject, "showFragRequest", [_perks]] call ExileServer_system_network_send_to;

_playerObject call ExileServer_object_player_sendStatsUpdate;
	
diag_log format["BOUNTY REWARD: %1 EARNED %2 POPTABS AND %3 RESPECT: TARGETDIED",_playerObject,_poptabReward,_respectReward];