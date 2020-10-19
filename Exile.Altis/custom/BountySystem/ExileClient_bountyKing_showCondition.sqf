 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_object", "_activated", "_numPlayersByEntity", "_numPlayersBountyKing"];

_object = _this;
_activated = _object getVariable ["ExileBountyKingActivated", false];

if (player getVariable ["ExileBountyKing", false]) exitWith {false};
if (player getVariable ["ExileBounty", false]) exitWith {false};

if (isNull _object) exitWith {false};
if !(typeOf _object isEqualTo "Land_PortableWeatherStation_01_olive_F") exitWith {false};
if (_activated) exitWith {false};

if(ExilePlayerInSafezone) exitWith {false};

if(player distance _object > 5) exitWith {false};

_numPlayersByEntity = {_x distance _object < 8} count allPlayers;
_numPlayersBountyKing = 0;

if !(ExileClientPartyID isEqualTo -1) then
{
	_numPlayersBountyKing = {_x getVariable ["ExileBountyKing", false] isEqualTo true} count (units groupFromNetId ExileClientPartyID);
};

if(_numPlayersBountyKing >= 1) exitWith {false};

if(_numPlayersByEntity isEqualTo 1) exitWith {true};

false