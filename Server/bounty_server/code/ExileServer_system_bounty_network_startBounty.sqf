 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_sessionID", "_parameters", "_object", "_playerObject", "_activated", "_index", "_bountyDelay"];

_sessionID = _this select 0;
_parameters = _this select 1;
_object = _parameters select 0;

try
{
	_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
	if (isNull _playerObject) then
	{
		throw "Player object not found!";
	};
	
	_activated = _object getVariable ["ExileBountyActivated", false];
	
	if (_activated) then 
	{
		throw "Bounty Mission already completed!"
	};
	_object setVariable ["ExileBountyActivated", true, true];
	_playerObject setVariable ["ExileBounty", true, true]; // ExileBountyPlayer
	_index = -1;
	
	{
		if((_x select 0) isEqualTo _object) then
		{
			_index = _forEachIndex;
		};
	} forEach ExileBountyBounties;
	ExileBountyBounties set [_index,[_object,(getPlayerUID _playerObject)]];
	
	_bountyDelay = getNumber(configFile >> "BountySettings" >> "Bounty" >> "activateDelay");
	[_sessionID, "toastRequest", ["SuccessTitleAndText", ["Bounty", format["You have a %1 second head start to prepare for your target!", _bountyDelay]]]] call ExileServer_system_network_send_to;
	[_bountyDelay, ExileServer_system_bounty_startBounty, [_sessionID,_object], false] call ExileServer_system_thread_addtask;
}
catch
{
	[_sessionID, "toastRequest", ["ErrorTitleOnly", [_exception]]] call ExileServer_system_network_send_to;
};