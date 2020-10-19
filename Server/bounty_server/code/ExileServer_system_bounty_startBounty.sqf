 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_sessionID", "_object", "_playerObject", "_started", "_bountyMaxHeight", "_bountyTime", "_headlessClients", "_humanPlayersCount", "_player", "_found", "_count", "_humanPlayers", "_sessionIDTarget"];

_sessionID = _this select 0;
_object = _this select 1;

try
{
	_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
	if (isNull _playerObject) then
	{
		throw "Player object not found!";
	};
	
	_started = _object getVariable ["ExileBountyStarted", false];
	if (_started) then
	{
		throw "That bounty is already started!";
	};
	
	_bountyMaxHeight = getNumber(configFile >> "BountySettings" >> "Bounty" >> "maxHeight");
	_bountyTime = getNumber(configFile >> "BountySettings" >> "Bounty" >> "time");
	_playerObject setVariable ["ExileBountyTrader", 30, true];
	_playerObject setVariable ["ExileBountyTerritory", 30, true];
	_playerObject setVariable ["ExileBountyHeight", 30, true];
	
	_object setVariable ["ExileBountyStarted", true, true];
	
	_headlessClients = entities "HeadlessClient_F";
	_humanPlayersCount = count (allPlayers - _headlessClients);
	
	_player = objNull;
	_found = false;
	_count = 0;
	if (_humanPlayersCount > 1) then
	{
		while {!_found || _count > 200} do
		{
			try 
			{
				_humanPlayers = (allPlayers - _headlessClients);
				_player = selectRandom _humanPlayers;
				
				if !(alive _player) throw false;
				
				if (_player call ExileClient_util_world_isInTraderZone) throw false;
				
				if (_player in units _playerObject) throw false; //check if party member
				
				if (_player setVariable ["ExileBountyTargeted", false]) throw false; //check if already hunted
				
				_object setVariable ["ExileBountyTarget", (getPlayerUID _player), true];
				_player setVariable ["ExileBountyHunter", (getPlayerUID _playerObject)];
				_player setVariable ["ExileBountyTargeted", true, true];
				_playerObject setVariable ["ExileBountyTarget", (getPlayerUID _player)];
				_found = true;
				deleteMarker (_object getVariable ["ExileBountyMarker",""]);
				diag_log format["ExileServer_system_bounty_createBounty Bounty Created %1 is hunting %2",_playerObject,_player];
			}
			catch 
			{
				_count = _count + 1;
			};
		};
		if (_count > 200) then
		{
			throw "Search Error";
		};
	} 
	else
	{
		throw "No one online!";
	};
	
	if (_found) then
	{
		_sessionIDTarget = _player getVariable ["ExileSessionID", -1];
		//find target and set the hunt
		_object setVariable ["ExileBountyEndTime",(time + (_bountyTime * 60)),true];
		
		[_sessionID, "bountyStart", [_player,_bountyTime,_bountyMaxHeight]] call ExileServer_system_network_send_to;
		[_sessionIDTarget, "bountyStartTarget", [_playerObject,_bountyTime,_bountyMaxHeight]] call ExileServer_system_network_send_to;
		if (ExileBountyWatcher isEqualTo -1) then
		{
			ExileBountyWatcher = [3, ExileServer_system_bounty_monitorLoop, [], true]  call ExileServer_system_thread_addtask;
		};
	};
}
catch
{
	[_sessionID, "toastRequest", ["ErrorTitleOnly", [_exception]]] call ExileServer_system_network_send_to;
	
	_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
	_playerObject setVariable ["ExileBounty", false, true];
	_object setVariable ["ExileBountyActivated", false, true];
	_object setVariable ["ExileBountyStarted", false, true];
};