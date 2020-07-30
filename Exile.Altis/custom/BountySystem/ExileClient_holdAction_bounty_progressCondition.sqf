private ["_object", "_modelName", "_validConfig", "_condition", "_scavengedObjects"];
_object = _this;
_activated = _object getVariable ["ExileBountyActivated", false];

try 
{
	if(isNull _object) then {throw "Object not found!"};
	if !(typeOf _object isEqualTo "PortableHelipadLight_01_blue_F") then {throw "Incorrect Object!"};
	if (_activated) then {throw "Bounty Mission already completed!"};

	if(player distance _object > 5) then {throw "You are too far!"};
	
	_numPlayersByEntity = {_x distance _object < 8} count allPlayers;
	if !(_numPlayersByEntity isEqualTo 1)  then {throw "Another player is too close!"};
	_numPlayersBounty = 0;
	if !(ExileClientPartyID isEqualTo -1) then
	{
		_numPlayersBounty = {_x getVariable ["ExileBounty", false] isEqualTo true} count (units groupFromNetId ExileClientPartyID);
	};

	if(_numPlayersBounty >= 1) then {throw "Another party member is already a Bounty Hunter!"};
	
	_condition = true;
}
catch
{
	["ErrorTitleAndText", ["Bounty",  _exception]] call ExileClient_gui_toaster_addTemplateToast;
	_condition = false;
};

_condition