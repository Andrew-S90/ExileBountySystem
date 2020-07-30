private ["_object", "_activated", "_numPlayersByEntity"];
_object = _this;
_activated = _object getVariable ["ExileBountyActivated", false];


if (player getVariable ["ExileBounty", false]) exitWith {false};

if (isNull _object) exitWith {false};
if !(typeOf _object isEqualTo "PortableHelipadLight_01_blue_F") exitWith {false};
if (_activated) exitWith {false};

if(ExilePlayerInSafezone) exitWith {false};

if(player distance _object > 5) exitWith {false};


_numPlayersByEntity = {_x distance _object < 8} count allPlayers;
_numPlayersBounty = 0;

if !(ExileClientPartyID isEqualTo -1) then
{
	_numPlayersBounty = {_x getVariable ["ExileBounty", false] isEqualTo true} count (units groupFromNetId ExileClientPartyID);
};

if(_numPlayersBounty >= 1) exitWith {false};

if(_numPlayersByEntity isEqualTo 1) exitWith {true};

false