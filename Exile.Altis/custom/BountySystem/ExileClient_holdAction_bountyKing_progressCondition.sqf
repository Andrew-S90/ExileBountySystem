private ["_object", "_modelName", "_validConfig", "_condition", "_scavengedObjects"];
_object = _this;
_activated = _object getVariable ["ExileBountyKingActivated", false];

try 
{
	if(isNull _object) then {throw "Object not found!"};
	if !(typeOf _object isEqualTo "PortableHelipadLight_01_red_F") then {throw "Incorrect Object!"};
	if (_activated) then {throw "BountyKing Mission already completed!"};

	if(player distance _object > 5) then {throw "You are too far!"};
	
	_numPlayersByEntity = {_x distance _object < 8} count allPlayers;
	if !(_numPlayersByEntity isEqualTo 1)  then {throw "Another player is too close!"};
	if !(ExileClientPartyID isEqualTo -1) then
	{
		_numPlayersBountyKing = {_x getVariable ["ExileBountyKing", false] isEqualTo true} count (units groupFromNetId ExileClientPartyID);
	};

	if(_numPlayersBountyKing >= 1) then {throw "Another party member is already a Bounty King!"};
	
	_condition = true;
}
catch
{
	["ErrorTitleAndText", ["BountyKing",  _exception]] call ExileClient_gui_toaster_addTemplateToast;
	_condition = false;
};

_condition