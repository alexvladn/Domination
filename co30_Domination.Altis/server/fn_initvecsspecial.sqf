// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_initvecsspecial.sqf"
#include "..\x_setup.sqf"

if (!isServer) exitWith{};

{
	__TRACE_1("","_x")
	private _vec = _x;

	_vec setVariable ["d_OUT_OF_SPACE", -1];

	_vec setVariable ["d_vec_islocked", _vec call d_fnc_isVecLocked];
	
	_vec setVariable ["d_WreckMaxRepair", 10000000, true];
	
	_vec setVariable ["d_isspecialvec", true, true];
	
	[_vec, "d_prebo"] call d_fnc_setekmode;
	
	if (unitIsUAV _vec) then {
		private _uavgrp = createVehicleCrew _vec;
		_vec allowCrewInImmobile true;
		_uavgrp deleteGroupWhenEmpty true;
		[_vec, "d_delcrewk"] call d_fnc_setekmode;
		if (isClass (configFile>>"CfgVehicles">>_vec_type>>"Components">>"TransportPylonsComponent")) then {
			_vec remoteExecCall ["d_fnc_addpylon_action", [0, -2] select isDedicated];
		};
	};
	
	if (_vec isKindOf "Air") then {
		_vec enableCopilot false;
	} else {
		_vec setVariable ["d_liftit", true, true];
	};
	if (!unitIsUAV _vec && {d_with_dynsim == 0}) then {
		_vec spawn {
			scriptName "spawn enable dyn";
			sleep 10;
			if (alive _this) then {
				_this enableDynamicSimulation true;
			};
		};
	};
	if (d_with_ranked) then {
		clearWeaponCargoGlobal _vec;
	};
	
	_vec spawn {
		scriptName "spawn initvecsspecial";
		sleep 10;
		_this allowDamage true;
	};
	
	_vec addEventHandler ["getIn", {_this call d_fnc_sgetinvec}];

	_vec addEventHandler ["getOut", {_this call d_fnc_sgetoutvec}];
	
	if !(_vec isKindOf "Air") then {
		_vec setVariable ["d_liftit", true, true];
	};
} forEach _this;
