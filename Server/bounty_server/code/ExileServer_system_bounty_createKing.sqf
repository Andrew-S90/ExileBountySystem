/*
 * Bounty Server ExileServer_system_bounty_createKing
 *
 * Selects a random town and then spawns a King Bounty in a building.
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
			if((count _spawnPosition) isEqualTo 2) then
			{
				_spawnPosition pushBack 0;
			};

			_found = true;
			diag_log format["BountySystem BountyKing Created at %1 pos %2",name _town,_spawnPosition];
			_markerName = createMarker [format["markername%1",_spawnPosition], _spawnPosition];
			_markerName setMarkerType "n_inf";
			_markerName setMarkerText "Bounty King Mission";
			_object = createVehicle ["PortableHelipadLight_01_red_F", _spawnPosition, [], 0, "CAN_COLLIDE"]; 
			_object setVariable ["ExileKingBountyMarker",_markerName,true];
			ExileBountyKings pushBack [_object,""];
		}
		catch 
		{
			_count = _count + 1;
		};
	};
	
}
catch
{
	format ["ExileServer_system_bounty_createKing: %1", _exception] call ExileServer_util_log;
};