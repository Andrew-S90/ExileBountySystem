private ["_progressTick", "_coef"];
_progressTick = _this select 4;
_coef = _progressTick / 24;
playSound3D [((getArray (configfile >> "CfgSounds" >> "Orange_Action_Wheel" >> "sound")) param [0,""]) + ".wss", player, false, getPosASL player, 1, 0.8 + 0.2 * _coef];