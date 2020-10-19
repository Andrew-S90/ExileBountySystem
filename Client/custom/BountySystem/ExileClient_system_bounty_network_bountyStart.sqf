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

["SuccessTitleAndText", ["Bounty", format["Let the hunt begin! You have %1 minutes to take down %2", _bountyTime,  name _player]]] call ExileClient_gui_toaster_addTemplateToast;

ExileClientBountyMarker = createMarkerLocal [format["markername%1",_player], getPosATL _player];
ExileClientBountyMarker setMarkerTypeLocal "select";
ExileClientBountyMarker setMarkerColorLocal "ColorRed";

if (ExileClientBountyWatch isEqualTo -1) then
{
	ExileClientBountyWatch = [2, ExileClient_system_bounty_thread_bountyWatch, [_player,_bountyMaxHeight], true] call ExileClient_system_thread_addtask;
};

[_bountyTime,_player] spawn
{
	private ["_bountyTime", "_player", "_Display", "_timerText", "_display", "_timerIcon", "_timerTitle", "_timerTarget", "_timer", "_count", "_flip", "_early", "_result"];
	_bountyTime = _this select 0;
	_player = _this select 1;
	disableSerialization;
	(["BountyTimerLayerArea"] call BIS_fnc_rscLayer) cutRsc ["BountyTimer","PLAIN", 0, false];
	_Display = uiNamespace getVariable [ "BountyTimer", controlNull ];
	_timerText = _display displayCtrl 4304;
	_timerIcon = _display displayCtrl 4301;
	_timerIcon ctrlsetText "custom\BountySystem\bounty_white.paa";
	_timerTitle = _display displayCtrl 4302;
	_timerTitle ctrlSetStructuredText parseText "<t color='#ffffff'>BOUNTY</t>";
	_timerTarget = _display displayCtrl 4303;
	_timerTarget ctrlSetStructuredText parseText format["Eliminate <t color='#ff0000'>%1</t>",name _player];
	_timer = _bountyTime * 60;
	_count = 0;
	_flip = true;
	_early = false;
	while{_timer > 0} do
	{
		if (player getVariable ["ExileBounty",false]) then
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
	deleteMarkerLocal ExileClientBountyMarker;
	(["BountyTimerLayerArea"] call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
	_result = [ExileClientBountyWatch] call ExileClient_system_thread_removeTask;
	if (_result) then
	{
		ExileClientBountyWatch = -1;
	};
	if !(_early) then
	{
		["failBounty", [3]] call ExileClient_system_network_send;
	};
};