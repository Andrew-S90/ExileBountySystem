private ["_sessionID", "_object", "_playerObject", "_started", "_kingTime"];

_sessionID = _this select 0;
_object = _this select 1;

try
{
	_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
	if (isNull _playerObject) then
	{
		throw "Player object not found!";
	};
	
	_started = _object getVariable ["ExileBountyKingStarted", false];
	if (_started) then
	{
		throw "That bounty is already started!";
	};
	
	_kingTime = getNumber(configFile >> "BountySettings" >> "King" >> "time");
	_playerObject setVariable ["ExileBountyTrader", 30, true];
	_playerObject setVariable ["ExileBountyTerritory", 30, true];
	_playerObject setVariable ["ExileBountyHeight", 30, true];
	_object setVariable ["ExileBountyKingEndTime",(time + (_kingTime * 60)),true];
	_object setVariable ["ExileBountyKingStarted", true, true];
	
	_marker = _object getVariable ["ExileKingBountyMarker",""];
	_marker setMarkerType "o_inf";
	_marker setMarkerText "Bounty King";
	
	//[_sessionID, "toastRequest", ["SuccessTitleAndText", ["BountyKing", format["Let the hunt begin! Survive for %1 minutes.", _kingTime]]]] call ExileServer_system_network_send_to;
	[_sessionID, "bountyKingStart", [_kingTime]] call ExileServer_system_network_send_to;
	//different response... starts client side timer
	//server watch timer
	["baguetteRequest", ["New Bounty King appeared!"]] call ExileServer_system_network_send_broadcast;
	
	if (ExileBountyWatcherKing isEqualTo -1) then
	{
		ExileBountyWatcherKing = [3, ExileServer_system_bounty_monitorLoopKing, [], true]  call ExileServer_system_thread_addtask;
	};
	
	//[ExileEscapePlayerStartThreadID] call ExileServer_system_thread_removeTask;
	
}
catch
{
	[_sessionID, "toastRequest", ["ErrorTitleOnly", [_exception]]] call ExileServer_system_network_send_to;
};