
private ["_kingTime"];

_kingTime = _this select 0;

["SuccessTitleAndText", ["BountyKing", format["Let the hunt begin! Survive for %1 minutes.", _kingTime]]] call ExileClient_gui_toaster_addTemplateToast;

_kingTime spawn
{
	private _kingTime = _this;
	disableSerialization;
	(["BountyTimerLayerArea"] call BIS_fnc_rscLayer) cutRsc ["BountyTimer","PLAIN", 0, false];
	private _Display = uiNamespace getVariable [ "BountyTimer", controlNull ];
	private _timerText = _display displayCtrl 4304;
	private _timer = _kingTime * 60;
	private _count = 0;
	private _flip = true;
	_timer = _timer - 20;
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
};