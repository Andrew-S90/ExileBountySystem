
//ExileBountySystem Start

ExileClientBountyWatch = -1;
ExileClientBountyWatchTarget = -1;
ExileClientBountyKingWatch = -1;

{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;

    _code = compileFinal (preprocessFileLineNumbers _file);

    missionNamespace setVariable [_function, _code];
}
forEach
[
	['ExileClient_bounty_showCondition', 'custom\BountySystem\ExileClient_bounty_showCondition.sqf'],
	['ExileClient_bounty_startMission', 'custom\BountySystem\ExileClient_bounty_startMission.sqf'],
	['ExileClient_bountyKing_showCondition', 'custom\BountySystem\ExileClient_bountyKing_showCondition.sqf'],
	['ExileClient_bountyKing_startMission', 'custom\BountySystem\ExileClient_bountyKing_startMission.sqf'],
	['ExileClient_gui_bounty_baguette_show', 'custom\BountySystem\ExileClient_gui_bounty_baguette_show.sqf'],
	['ExileClient_gui_network_bountyBaguetteRequest', 'custom\BountySystem\ExileClient_gui_network_bountyBaguetteRequest.sqf'],
	['ExileClient_system_bounty_network_bountyKingKilled', 'custom\BountySystem\ExileClient_system_bounty_network_bountyKingKilled.sqf'],
	['ExileClient_system_bounty_network_bountyKingStart', 'custom\BountySystem\ExileClient_system_bounty_network_bountyKingStart.sqf'],
	['ExileClient_system_bounty_network_bountyKingSurvived', 'custom\BountySystem\ExileClient_system_bounty_network_bountyKingSurvived.sqf'],
	['ExileClient_system_bounty_network_bountyStart', 'custom\BountySystem\ExileClient_system_bounty_network_bountyStart.sqf'],
	['ExileClient_system_bounty_network_bountyStartTarget', 'custom\BountySystem\ExileClient_system_bounty_network_bountyStartTarget.sqf'],
	['ExileClient_system_bounty_thread_bountyKingWatch', 'custom\BountySystem\ExileClient_system_bounty_thread_bountyKingWatch.sqf'],
	['ExileClient_system_bounty_thread_bountyWatch', 'custom\BountySystem\ExileClient_system_bounty_thread_bountyWatch.sqf'],
	['ExileClient_system_bounty_thread_bountyWatchTarget', 'custom\BountySystem\ExileClient_system_bounty_thread_bountyWatchTarget.sqf'],
	['ExileClient_util_addCommas', 'custom\BountySystem\ExileClient_util_addCommas.sqf']
];

//ExileBountySystem End
