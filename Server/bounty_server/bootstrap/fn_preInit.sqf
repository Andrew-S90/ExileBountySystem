 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ['_code', '_function', '_file'];

{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;

    if (isText (missionConfigFile >> 'CfgExileCustomCode' >> _function)) then
    {
        _file = getText (missionConfigFile >> 'CfgExileCustomCode' >> _function);
    };

    _code = compileFinal (preprocessFileLineNumbers _file);                    

    missionNamespace setVariable [_function, _code];
}
forEach 
[
	['ExileServer_system_bounty_createBounty', 'bounty_server\code\ExileServer_system_bounty_createBounty.sqf'],
	['ExileServer_system_bounty_createKing', 'bounty_server\code\ExileServer_system_bounty_createKing.sqf'],
	['ExileServer_system_bounty_hunterDied', 'bounty_server\code\ExileServer_system_bounty_hunterDied.sqf'],
	['ExileServer_system_bounty_hunterFailed', 'bounty_server\code\ExileServer_system_bounty_hunterFailed.sqf'],
	['ExileServer_system_bounty_hunterKilled', 'bounty_server\code\ExileServer_system_bounty_hunterKilled.sqf'],
	['ExileServer_system_bounty_loop', 'bounty_server\code\ExileServer_system_bounty_loop.sqf'],
	['ExileServer_system_bounty_monitorLoop', 'bounty_server\code\ExileServer_system_bounty_monitorLoop.sqf'],
	['ExileServer_system_bounty_monitorLoopKing', 'bounty_server\code\ExileServer_system_bounty_monitorLoopKing.sqf'],
	['ExileServer_system_bounty_network_failBounty', 'bounty_server\code\ExileServer_system_bounty_network_failBounty.sqf'],
	['ExileServer_system_bounty_network_failBountyKing', 'bounty_server\code\ExileServer_system_bounty_network_failBountyKing.sqf'],
	['ExileServer_system_bounty_network_startBounty', 'bounty_server\code\ExileServer_system_bounty_network_startBounty.sqf'],
	['ExileServer_system_bounty_network_startBountyKing', 'bounty_server\code\ExileServer_system_bounty_network_startBountyKing.sqf'],
	['ExileServer_system_bounty_network_surviveBountyKing', 'bounty_server\code\ExileServer_system_bounty_network_surviveBountyKing.sqf'],
	['ExileServer_system_bounty_network_targetFailBounty', 'bounty_server\code\ExileServer_system_bounty_network_targetFailBounty.sqf'],
	['ExileServer_system_bounty_process_postInit', 'bounty_server\code\ExileServer_system_bounty_process_postInit.sqf'],
	['ExileServer_system_bounty_startBounty', 'bounty_server\code\ExileServer_system_bounty_startBounty.sqf'],
	['ExileServer_system_bounty_startBountyKing', 'bounty_server\code\ExileServer_system_bounty_startBountyKing.sqf'],
	['ExileServer_system_bounty_targetDied', 'bounty_server\code\ExileServer_system_bounty_targetDied.sqf'],
	['ExileServer_system_bounty_targetFailed', 'bounty_server\code\ExileServer_system_bounty_targetFailed.sqf'],
	['ExileServer_system_bounty_targetKilled', 'bounty_server\code\ExileServer_system_bounty_targetKilled.sqf']
];


true