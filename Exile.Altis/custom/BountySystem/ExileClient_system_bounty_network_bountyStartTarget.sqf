 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_player", "_bountyTime", "_bountyMaxHeight"];

_player = _this select 0;
_bountyTime = _this select 1;
_bountyMaxHeight = _this select 2;

ExileClientBountyFlip = false;

["SuccessTitleAndText", ["Bounty", format["You are being hunted! Survive for %1 minutes or kill your hunter for a reward!", _bountyTime]]] call ExileClient_gui_toaster_addTemplateToast;

systemchat format["Territories, Safezones and being above %1m will forfit your reward!",_bountyMaxHeight];

if (ExileClientBountyWatchTarget isEqualTo -1) then
{
	ExileClientBountyWatchTarget = [2, ExileClient_system_bounty_thread_bountyWatchTarget, [_player,_bountyMaxHeight], true] call ExileClient_system_thread_addtask;
};

_bountyTime spawn
{
	private ["_bountyTime", "_Display", "_timerText", "_display", "_timerIcon", "_timerTitle", "_timerTarget", "_timer", "_count", "_flip", "_early", "_result"];
	_bountyTime = _this;
	disableSerialization;
	(["LowerBountyTimerLayerArea"] call BIS_fnc_rscLayer) cutRsc ["LowerBountyTimer","PLAIN", 0, false];
	_Display = uiNamespace getVariable [ "LowerBountyTimer", controlNull ];
	_timerText = _display displayCtrl 5304;
	_timerIcon = _display displayCtrl 5301;
	_timerIcon ctrlsetText "custom\BountySystem\bounty_white.paa";
	_timerTitle = _display displayCtrl 5302;
	_timerTitle ctrlsetText "HUNTED";
	_timerTarget = _display displayCtrl 5303;
	_timerTarget ctrlsetText "You are the target, Survive!";
	_timer = _bountyTime * 60;
	_count = 0;
	_flip = true;
	_early = false;
	while{_timer > 0} do
	{
		if (player getVariable ["ExileBountyTargeted",false]) then
		{
			_timerText ctrlsetText (format["%1",[_timer,"MM:SS.MS",false] call BIS_fnc_secondsToString]);
			if(_timer <= 30.0) then
			{
				switch (_count) do 
				{
					case 0: 
					{
						if (_flip) then
						{
							_timerText ctrlSetTextColor [1, 1, 1, 1];
							_count = _count + 1;
						};
						_flip = !_flip;
					};
					case 1: 
					{ 
						if (_flip) then
						{
							_timerText ctrlSetTextColor [1, 0.52, 0.52, 1];
							_count = _count + 1;
						};
						_flip = !_flip;
					};
					case 2: 
					{ 
						if (_flip) then
						{
							_timerText ctrlSetTextColor [1, 0, 0, 1];
							_count = 0;
						};
						_flip = !_flip;
					};
					default 
					{ 
						if (_flip) then
						{
							_timerText ctrlSetTextColor [1, 0, 0, 1];
							_count = 0;
						};
						_flip = !_flip;
					};
				};
			};
		}
		else
		{
			_timer = 0;
			_early = true;
		};
		_timer = _timer - 0.1;
		uiSleep 0.1;
	};
	(["LowerBountyTimerLayerArea"] call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
	_result = [ExileClientBountyWatchTarget] call ExileClient_system_thread_removeTask;
	if (_result) then
	{
		ExileClientBountyWatchTarget = -1;
	};
};