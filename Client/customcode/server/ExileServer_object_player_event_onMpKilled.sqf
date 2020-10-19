/**
 * ExileServer_object_player_event_onMpKilled
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_victim", "_killer", "_instigator", "_countDeath", "_countKill", "_killSummary", "_killingPlayer", "_killType", "_oldVictimRespect", "_newVictimRespect", "_oldKillerRespect", "_newKillerRespect", "_unknownReasons", "_systemChat", "_modifyVictimRespect", "_respectLoss", "_perks", "_minRespectTransfer", "_respectTransfer", "_perkNames", "_killerStatsNeedUpdate", "_newKillerFrags", "_victimStatsNeedUpdate", "_newVictimDeaths", "_victimPosition"];
_victim = _this select 0;
_killer = _this select 1;
_instigator = _this select 2;
if (!isServer || hasInterface || isNull _victim) exitWith {};
_victim setVariable ["ExileDiedAt", time];
if !(isPlayer _victim) exitWith {};
_victim setVariable ["ExileIsDead", true]; 
_victim setVariable ["ExileName", name _victim, true]; 
_countDeath = false;
_countKill = false;
_killSummary = [];
_killingPlayer = _killer call ExileServer_util_getFragKiller;
_killType = [_victim, _killer, _killingPlayer, _instigator] call ExileServer_util_getFragType;
_oldVictimRespect = _victim getVariable ["ExileScore", 0];
_newVictimRespect = _oldVictimRespect;
_oldKillerRespect = 0;

//ExileBountySystem Start
_headlessClients = entities "HeadlessClient_F";
_bountyKing = _victim getVariable ["ExileBountyKing", false];
_humanPlayers = count (allPlayers - _headlessClients);
_kingPoptabs = getNumber(configFile >> "BountySettings" >> "King" >> "poptabs");
_kingBonus = getNumber(configFile >> "BountySettings" >> "King" >> "bonus");
_bountyPoptabs = getNumber(configFile >> "BountySettings" >> "Bounty" >> "poptabs");
_bountyBonus = getNumber(configFile >> "BountySettings" >> "Bounty" >> "bonus");
_teamKilled = false;
//ExileBountySystem End

if !(isNull _killingPlayer) then 
{
	_oldKillerRespect = _killingPlayer getVariable ["ExileScore", 0];
};
_newKillerRespect = _oldKillerRespect;
switch (_killType) do 
{
	default 
	{
		_unknownReasons = 
		[
			"%1 died because... Arma.",
			"%1 died because the universe hates him.",
			"%1 died a mysterious death.",
			"%1 died and nobody knows why.",
			"%1 died because that's why.",
			"%1 died because %1 was very unlucky.",
			"%1 died due to Arma bugs and is probably very salty right now.",
			"%1 died an awkward death.",
			"%1 died. Yes, %1 is dead. Like really dead-dead."
		];
		_countDeath = true;
		_systemChat = format [selectRandom _unknownReasons, name _victim];
		_newVictimRespect = _oldVictimRespect - round ((abs _oldVictimRespect) / 100 * (getNumber (configFile >> "CfgSettings" >> "Respect" >> "Percentages" >> "unlucky")));
	};
	case 1:
	{
		_countDeath = true;
		_modifyVictimRespect = true;
		_systemChat = format ["%1 commited suicide!", name _victim];
		_newVictimRespect = _oldVictimRespect - round ((abs _oldVictimRespect) / 100 * (getNumber (configFile >> "CfgSettings" >> "Respect" >> "Percentages" >> "suicide")));
	};
	case 2:
	{
		_countDeath = true;
		_countKill = false;
		_systemChat = format ["%1 died while playing Russian Roulette!", name _victim];
		_newVictimRespect = _oldVictimRespect; 
		_victim call ExileServer_system_russianRoulette_event_onPlayerDied;
	};
	case 3:
	{
		_countDeath = true;
		_countKill = false;
		_systemChat = format ["%1 crashed to death!", name _victim];
		_newVictimRespect = _oldVictimRespect - round ((abs _oldVictimRespect) / 100 * (getNumber (configFile >> "CfgSettings" >> "Respect" >> "Percentages" >> "crash")));
	};
	case 4:
	{
		_countDeath = true;
		_countKill = false;
		_systemChat = format ["%1 was killed by an NPC!", name _victim];
		_newVictimRespect = _oldVictimRespect - round ((abs _oldVictimRespect) / 100 * (getNumber (configFile >> "CfgSettings" >> "Respect" >> "Percentages" >> "npc")));
	};
	case 5:
	{
		_countDeath = false;
		_countKill = false;
		_systemChat = format ["%1 was team-killed by %2!", name _victim, name _killingPlayer];
		_respectLoss = round ((abs _oldKillerRespect) / 100 * (getNumber (configFile >> "CfgSettings" >> "Respect" >> "Percentages" >> "friendyFire")));
		_newKillerRespect = _oldKillerRespect - _respectLoss;
		_killSummary pushBack ["FRIENDLY FIRE", -1 * _respectLoss];
		_teamKilled = true;
	};
	case 6:
	{
		_countDeath = false;
		_countKill = false;
		_systemChat = format ["%1 was killed by %2! (BAMBI SLAYER)", name _victim, name _killingPlayer];
		_respectLoss = round ((abs _oldKillerRespect) / 100 * (getNumber (configFile >> "CfgSettings" >> "Respect" >> "Percentages" >> "bambiKill")));
		_newKillerRespect = _oldKillerRespect - _respectLoss;
		_killSummary pushBack ["BAMBI SLAYER", -1 * _respectLoss];
	};
	case 7:
	{
		_countDeath = true;
		_countKill = true;
		_perks = [_victim, _killer, _killingPlayer] call ExileServer_util_getFragPerks;
		_minRespectTransfer = getNumber (configFile >> "CfgSettings" >> "Respect" >> "minRespectTransfer");
		_respectTransfer = round ((abs _oldVictimRespect) / 100 * (getNumber (configFile >> "CfgSettings" >> "Respect" >> "Percentages" >> "frag")));
		if (_respectTransfer < _minRespectTransfer) then
		{
			_respectTransfer = _minRespectTransfer;
		};
		_newVictimRespect = _oldVictimRespect - _respectTransfer;
		_newKillerRespect = _oldKillerRespect + _respectTransfer;
		_killSummary pushBack ["ENEMY FRAGGED", _respectTransfer];
		if (_perks isEqualTo []) then 
		{
			_systemChat = format ["%1 was killed by %2!", name _victim, name _killingPlayer];
		}
		else 
		{
			_perkNames = [];
			{
				_perkNames pushBack (_x select 0);
				_killSummary pushBack _x;
				_newKillerRespect = _newKillerRespect + (_x select 1);
			} 
			forEach _perks;
			_systemChat = format ["%1 was killed by %2! (%3)", name _victim, name _killingPlayer, _perkNames joinString ", "];
		};
	};
};
if !(isNull _killingPlayer) then 
{
	if !(_killSummary isEqualTo []) then 
	{	
		[_killingPlayer, "showFragRequest", [_killSummary]] call ExileServer_system_network_send_to;
	};
};
if !(isNull _killingPlayer) then 
{
	_killerStatsNeedUpdate = false;
	if (_countKill) then
	{
		_newKillerFrags = _killingPlayer getVariable ["ExileKills", 0];
		_newKillerFrags = _newKillerFrags + 1;
		_killerStatsNeedUpdate = true;
		_killingPlayer setVariable ["ExileKills", _newKillerFrags];
		format["addAccountKill:%1", getPlayerUID _killingPlayer] call ExileServer_system_database_query_fireAndForget;
	};
	if !(_newKillerRespect isEqualTo _oldKillerRespect) then 
	{
		_killingPlayer setVariable ["ExileScore", _newKillerRespect];
		_killerStatsNeedUpdate = true;
		format["setAccountScore:%1:%2", _newKillerRespect, getPlayerUID _killingPlayer] call ExileServer_system_database_query_fireAndForget;
	};
	//ExileBountySystem Start
	if (_bountyKing) then 
	{
		_poptabReward = _humanPlayers * _kingPoptabs * _kingBonus;
		_bountyKings = ExileBountyKings;
		{
			if((_x select 1) isEqualTo (getPlayerUID _victim)) then
			{
				_marker = (_x select 0) getVariable ["ExileKingBountyMarker",""];
				_victim setVariable ["ExileBountyTrader", 30, true];
				_victim setVariable ["ExileBountyTerritory", 30, true];
				_victim setVariable ["ExileBountyHeight", 30, true];
				_victim setVariable ["ExileBountyKing", false, true];
				deleteMarker _marker;
				ExileBountyKings deleteAt _forEachIndex;
			};
		} 
		forEach _bountyKings;
		if !((getPlayerUID _killingPlayer) isEqualTo (getPlayerUID _victim)) then
		{
			if !(_teamKilled) then
			{
				_playerMoney = _killingPlayer getVariable ["ExileMoney", 0];
				_playerMoney = floor (_playerMoney + _poptabReward);
				
				_killingPlayer setVariable ["ExileMoney", _playerMoney, true];
				format["setPlayerMoney:%1:%2", _playerMoney, _killingPlayer getVariable ["ExileDatabaseID", 0]] call ExileServer_system_database_query_fireAndForget;
				
				_sessionID = _killingPlayer getVariable ["ExileSessionID", -1];
				[_sessionID, "toastRequest", ["SuccessTitleAndText", ["Bounty King Killed!", format ["+%1<img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='24'/>", _poptabReward]]]] call ExileServer_system_network_send_to;
			};
			
		};
		_killerStatsNeedUpdate = true;
	};
	if (_victim getVariable ["ExileBountyHunter", ""] isEqualTo (getPlayerUID _killingPlayer)) then //if hunter kills target 
	{
		_killingPlayer setVariable ["ExileBounty", false, true];
		_killingPlayer setVariable ["ExileBountyTarget", ""];
		_victim setVariable ["ExileBountyHunter", ""];
		_victim setVariable ["ExileBountyTargeted", false, true];
		
		_killingPlayer call ExileServer_system_bounty_targetKilled;
		_killerStatsNeedUpdate = true;
	};
	if (_victim getVariable ["ExileBountyTarget", ""] isEqualTo (getPlayerUID _killingPlayer)) then //target kills hunter
	{
		_victim setVariable ["ExileBounty", false, true];
		_victim setVariable ["ExileBountyTarget", ""];
		_killingPlayer setVariable ["ExileBountyHunter", ""];
		_killingPlayer setVariable ["ExileBountyTargeted", false, true];
		
		_killingPlayer call ExileServer_system_bounty_hunterKilled;
		_killerStatsNeedUpdate = true;
	};
	
	if !(_victim getVariable ["ExileBountyTarget", ""] isEqualTo "") then //hunter dies 
	{
		_playerObject = (_victim getVariable ["ExileBountyTarget", ""]) call ExileClient_util_player_objectFromPlayerUid;
		_playerObject call ExileServer_system_bounty_hunterDied;
		_victim setVariable ["ExileBountyTarget", ""];
		_victim setVariable ["ExileBounty", false, true];
		_victim setVariable ["ExileBountyTrader", 30, true];
		_victim setVariable ["ExileBountyTerritory", 30, true];
		_victim setVariable ["ExileBountyHeight", 30, true];
		
		_playerObject setVariable ["ExileBountyHunter", ""];
		_playerObject setVariable ["ExileBountyTargeted", false, true];
	};
	
	if !(_victim getVariable ["ExileBountyHunter", ""] isEqualTo "") then //target dies 
	{
		_playerObject = (_victim getVariable ["ExileBountyHunter", ""]) call ExileClient_util_player_objectFromPlayerUid;
		_playerObject call ExileServer_system_bounty_targetDied;
		_victim setVariable ["ExileBountyHunter", ""];
		_victim setVariable ["ExileBountyTargeted", false, true];
		_playerObject setVariable ["ExileBountyTarget", ""];
		_playerObject setVariable ["ExileBounty", false, true];
	};
	//ExileBountySystem End
	if (_killerStatsNeedUpdate) then 
	{
		_killingPlayer call ExileServer_object_player_sendStatsUpdate;
	};
};
_victimStatsNeedUpdate = false;
if (_countDeath) then
{
	_newVictimDeaths = _victim getVariable ["ExileDeaths", 0];
	_newVictimDeaths = _newVictimDeaths + 1;
	_victim setVariable ["ExileDeaths", _newVictimDeaths];
	_victimStatsNeedUpdate = true;
	format["addAccountDeath:%1", getPlayerUID _victim] call ExileServer_system_database_query_fireAndForget;
};
if !(_newVictimRespect isEqualTo _oldVictimRespect) then 
{
	_victim setVariable ["ExileScore", _newVictimRespect];
	_victimStatsNeedUpdate = true;
	format["setAccountScore:%1:%2", _newVictimRespect, getPlayerUID _victim] call ExileServer_system_database_query_fireAndForget;
};
if (_victimStatsNeedUpdate) then 
{
	_victim call ExileServer_object_player_sendStatsUpdate;
};
if ((vehicle _victim) isEqualTo _victim) then 
{
	if !(underwater _victim) then 
	{
		if !(_victim call ExileClient_util_world_isInTraderZone) then 
		{
			_victim call ExileServer_object_flies_spawn;
		};
	};
};
//ExileBountySystem Start
if (_bountyKing) then 
{
	_bountyKings = ExileBountyKings;
	{
		if((_x select 1) isEqualTo (getPlayerUID _victim)) then
		{
			_marker = (_x select 0) getVariable ["ExileKingBountyMarker",""];
			_victim setVariable ["ExileBountyTrader", 30, true];
			_victim setVariable ["ExileBountyTerritory", 30, true];
			_victim setVariable ["ExileBountyHeight", 30, true];
			_victim setVariable ["ExileBountyKing", false, true];
			deleteMarker _marker;
			ExileBountyKings deleteAt _forEachIndex;
		};
	} forEach _bountyKings;
	["bountyBaguetteRequest", ["Bounty King Killed!","BountyKing",true]] call ExileServer_system_network_send_broadcast;
};
//ExileBountySystem End
if !(_systemChat isEqualTo "") then 
{
	if ((getNumber (configFile >> "CfgSettings" >> "KillFeed" >> "showKillFeed")) isEqualTo 1) then 
	{
		["systemChatRequest", [_systemChat]] call ExileServer_system_network_send_broadcast;
	};
};
if !(_systemChat isEqualTo "") then 
{
	if ((getNumber (configFile >> "CfgSettings" >> "Logging" >> "deathLogging")) isEqualTo 1) then
	{
		"extDB2" callExtension format["1:DEATH:%1", _systemChat];
	};
};
if (getNumber(configFile >> "CfgSettings" >> "Escape" >> "enableEscape") isEqualTo 1) then 
{
	[_killer, _victim, _killType] spawn ExileServer_system_escape_deathCheck;
}
else
{
	_victimPosition = getPos _victim;
	format["insertPlayerHistory:%1:%2:%3:%4:%5", getPlayerUID _victim, name _victim, _victimPosition select 0, _victimPosition select 1, _victimPosition select 2] call ExileServer_system_database_query_fireAndForget;
	format["deletePlayer:%1", _victim getVariable ["ExileDatabaseId", -1]] call ExileServer_system_database_query_fireAndForget;
};
true