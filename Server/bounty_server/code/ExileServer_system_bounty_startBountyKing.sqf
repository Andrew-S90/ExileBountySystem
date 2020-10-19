 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_sessionID", "_object", "_playerObject", "_started", "_kingTime", "_bountyMaxHeight", "_marker"];

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
	_bountyMaxHeight = getNumber(configFile >> "BountySettings" >> "King" >> "maxHeight");
	_playerObject setVariable ["ExileBountyTrader", 30, true];
	_playerObject setVariable ["ExileBountyTerritory", 30, true];
	_playerObject setVariable ["ExileBountyHeight", 30, true];
	_object setVariable ["ExileBountyKingEndTime",(time + (_kingTime * 60)),true];
	_object setVariable ["ExileBountyKingStarted", true, true];
	
	_marker = _object getVariable ["ExileKingBountyMarker",""];
	_marker setMarkerType "o_inf";
	_marker setMarkerText "Bounty King";
	
	[_sessionID, "bountyKingStart", [_kingTime,_bountyMaxHeight]] call ExileServer_system_network_send_to;
	//different response... starts client side timer
	//server watch timer
	["bountyBaguetteRequest", ["New Bounty King appeared!","BountyKing",true]] call ExileServer_system_network_send_broadcast;
	
	if (ExileBountyWatcherKing isEqualTo -1) then
	{
		ExileBountyWatcherKing = [3, ExileServer_system_bounty_monitorLoopKing, [], true]  call ExileServer_system_thread_addtask;
	};
}
catch
{
	[_sessionID, "toastRequest", ["ErrorTitleOnly", [_exception]]] call ExileServer_system_network_send_to;
	_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
	_playerObject setVariable ["ExileBountyKing", false, true];
	_object setVariable ["ExileBountyKingActivated", false, true];
	_object setVariable ["ExileBountyKingStarted", false, true];
};