/*
 * Bounty Server ExileServer_system_bounty_createBounty
 *
 * Selects a random town and then spawns a nearby Bounty
 *
 * Made by Andrew_S90
 */

private ["_found", "_count", "_center", "_towns", "_town", "_townPos", "_radius", "_townBuildings", "_building", "_buildingConfig", "_localPositions", "_randomPosition", "_spawnPosition", "_markerName", "_object"];

try 
{
	_found = false;
	_count = 0;
	
	while {!_found || _count > 200} do
	{
		try 
		{
			_center = getArray(configfile >> "BountySettings" >> worldName);
			if(count _center < 1) then
			{
				_center = [[worldSize/2,worldSize/2,0],5000];
			};
			_towns = nearestLocations [(_center select 0), ["NameVillage","NameCity","NameCityCapital"], ((_center select 1)+4000)];
			
			_town = selectRandom _towns;
			_townPos = locationPosition _town;
			_townPos set[2,0];
			_radius = 150;
			
			_spawnPosition = [_townPos, 1, _radius, 3, 0, 20, 0,[],_townPos] call BIS_fnc_findSafePos;
			
			if (_spawnPosition select 2 < 0.05) then
			{
				_spawnPosition set [2, 0.05];
			};
			_found = true;
			diag_log format["BountySystem Bounty Created at %1 pos %2",name _town,_spawnPosition];
			_markerName = createMarker [format["markername%1",_spawnPosition], _spawnPosition];
			_markerName setMarkerType "b_inf";
			_markerName setMarkerText "Bounty Mission";
			_object = createVehicle ["Land_PortableWeatherStation_01_white_F", _spawnPosition, [], 0, "CAN_COLLIDE"]; //PortableHelipadLight_01_blue_F
			_object setVariable ["ExileBountyMarker",_markerName,true];
			ExileBountyBounties pushBack [_object,""];
			
			if (getNumber(configFile >> "BountySettings" >> "Bounty" >> "broadcastNewMission") isEqualTo 1) then
			{
				["bountyBaguetteRequest", ["New Bounty Mission Spotted!","Bounty",false]] call ExileServer_system_network_send_broadcast;
			};
		}
		catch 
		{
			_count = _count + 1;
		};
	};
	
}
catch
{
	format ["ExileServer_system_bounty_createBounty: %1", _exception] call ExileServer_util_log;
};