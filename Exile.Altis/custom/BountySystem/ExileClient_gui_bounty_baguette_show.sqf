 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_description", "_type", "_red", "_display", "_baguette", "_iconArea", "_icon", "_text", "_textArea", "_textAreaSize"];
disableSerialization;
if !(ExileClientBaguetteAreaVisible) exitWith { false };
_description = _this select 0;
_type = _this select 1;
_red = _this select 2;
waitUntil {!ExileBaguetteIsVisible};
ExileBaguetteIsVisible = true;
_display = uiNamespace getVariable ["RscExileBaguetteArea", displayNull];
_baguette = _display ctrlCreate ["RscExileBaguette", -1];
_iconArea = _baguette controlsGroupCtrl 5000;
_iconArea ctrlSetFade 1;
_iconArea ctrlCommit 0;
if (_type isEqualTo "BountyKing") then 
{
	_icon = _baguette controlsGroupCtrl 5003;
	if(_red) then
	{
		_icon ctrlSetText "custom\BountySystem\bountyking_red.paa";
	}
	else
	{
		_icon ctrlSetText "custom\BountySystem\bountyking_white.paa";
	};
};
if (_type isEqualTo "Bounty") then 
{
	_icon = _baguette controlsGroupCtrl 5003;
	if(_red) then
	{
		_icon ctrlSetText "custom\BountySystem\bounty_red.paa";
	}
	else
	{
		_icon ctrlSetText "custom\BountySystem\bounty_white.paa";
	};
};
_text = _baguette controlsGroupCtrl 5002;
_text ctrlSetText _description;
_textArea = _baguette controlsGroupCtrl 5001;
_textAreaSize = ctrlPosition _textArea;
_textArea ctrlSetPosition [_textAreaSize select 0, _textAreaSize select 1, 0, _textAreaSize select 2];
_textArea ctrlSetFade 1;
_textArea ctrlCommit 0;
_iconArea ctrlSetFade 0;
_iconArea ctrlCommit 0.5;
uiSleep 0.5;
playsound "ZoomIn";
_textArea ctrlSetPosition _textAreaSize;
_textArea ctrlSetFade 0;
_textArea ctrlCommit 0.25;
uiSleep (0.25 + 5);
_textArea ctrlSetPosition [_textAreaSize select 0, _textAreaSize select 1, 0, _textAreaSize select 2];
_textArea ctrlSetFade 1;
_textArea ctrlCommit 0.25;
playsound "ZoomOut";
uiSleep 0.25;
_iconArea ctrlSetFade 1;
_iconArea ctrlCommit 0.5;
uiSleep 0.25;
_textArea ctrlSetPosition _textAreaSize;
_textArea ctrlCommit 0;
ctrlDelete _baguette;
ExileBaguetteIsVisible = false;