private ["_object", "_activated", "_numPlayersByEntity"];

_object = _this;
_activated = _object getVariable ["ExileBountyActivated", false];

try 
{
	if(isNull _object) then {throw "Object not found."};

	if !(typeOf _object isEqualTo "PortableHelipadLight_01_blue_F") then {throw "Incorrect Object!"};
	if (_activated) then {throw "Bounty Mission already completed!"};
	if(player distance _object > 5) then {throw "You are too far!"};
	
	_numPlayersByEntity = {_x distance _object < 8} count allPlayers;
	if !(_numPlayersByEntity isEqualTo 1)  then {throw "Another player is too close!"};
	
	["startBounty", [_object]] call ExileClient_system_network_send;
}
catch
{
	["ErrorTitleAndText", ["Bounty",  _exception]] call ExileClient_gui_toaster_addTemplateToast;
};

true