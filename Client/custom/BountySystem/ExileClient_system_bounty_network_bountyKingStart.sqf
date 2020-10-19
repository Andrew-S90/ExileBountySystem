 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_kingTime", "_bountyMaxHeight"];


_kingTime = _this select 0;
_bountyMaxHeight = _this select 1;

ExileClientBountyFlip = false;

["SuccessTitleAndText", ["BountyKing", format["Let the hunt begin! Survive for %1 minutes.", _kingTime]]] call ExileClient_gui_toaster_addTemplateToast;

if (ExileClientBountyKingWatch isEqualTo -1) then
{
	ExileClientBountyKingWatch = [2, ExileClient_system_bounty_thread_bountyKingWatch, [_bountyMaxHeight], true] call ExileClient_system_thread_addtask;
};

_kingTime spawn
{
	private ["_kingTime", "_Display", "_timerText", "_display", "_timer", "_count", "_flip", "_early", "_result"];
	_kingTime = _this;
	disableSerialization;
	(["BountyTimerLayerArea"] call BIS_fnc_rscLayer) cutRsc ["BountyTimer","PLAIN", 0, false];
	_Display = uiNamespace getVariable [ "BountyTimer", controlNull ];
	_timerText = _display displayCtrl 4304;
	_timer = _kingTime * 60;
	_count = 0;
	_flip = true;
	_early = false;
	while{_timer > 0} do
	{
		if (player getVariable ["ExileBountyKing",false]) then
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
	(["BountyTimerLayerArea"] call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
	
	_result = [ExileClientBountyKingWatch] call ExileClient_system_thread_removeTask;
	if (_result) then
	{
		ExileClientBountyKingWatch = -1;
	};
	if !(_early) then
	{
		["surviveBountyKing", [true]] call ExileClient_system_network_send;
	};
};