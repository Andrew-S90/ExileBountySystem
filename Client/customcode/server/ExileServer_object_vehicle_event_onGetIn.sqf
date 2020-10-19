/**
 * ExileServer_object_vehicle_event_onGetIn
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_vehicleObject"];
_vehicleObject = _this select 0;
if (getNumber(missionConfigFile >> "CfgSimulation" >> "enableDynamicSimulation") isEqualTo 1) then 
{
	if !(dynamicSimulationEnabled _vehicleObject) then 
	{
		_vehicleObject enableDynamicSimulation true;
	};
}
else
{
	if !(simulationEnabled _vehicleObject) then 
	{
		_vehicleObject enableSimulationGlobal true;
	};
};

//ExileBountySystem Start
private _player = _this select 2;
private _vehicleClass = typeOf _vehicleObject;
if (_player getVariable ["ExileBountyKing", false]) then
{
	if (_vehicleClass in (getArray(configFile >> "BountySettings" >> "king" >> "blacklist"))) then
	{
		{
			moveOut _x;
			unassignVehicle _x;
			_x action ['eject', _vehicleObject];
		} forEach (crew _vehicleObject);
	
		private _sessionID = _player getVariable ["ExileSessionID", ""];
	
		[_sessionID, "toastRequest", ["ErrorTitleAndText", ["BountyKing Blacklist!", "That vehicle is too dangerous to use during this mission!"]]] call ExileServer_system_network_send_to;
	};
};
//ExileBountySystem End

true