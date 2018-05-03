// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_checkmthardtarget.sqf"
#include "..\..\x_setup.sqf"

params ["_vec"];
_vec addEventHandler ["killed", {
	d_mt_spotted = false;
	if (d_IS_HC_CLIENT) then {
		[missionNamespace, ["d_mt_spotted", false]] remoteExecCall ["setVariable", 2];
	};
	d_mt_radio_down = true;
	[missionNamespace, ["d_mt_radio_down", true]] remoteExecCall ["setVariable", 2];
	"d_main_target_radiotower" remoteExecCall ["deleteMarker", 2];
#ifndef __TT__
	[37] remoteExecCall ["d_fnc_DoKBMsg", 2];
#else
	[38] remoteExecCall ["d_fnc_DoKBMsg", 2];
	private _killer = param [2];
	if (d_with_ace && {isNull _killer}) then {
		_killer = (param [0]) getVariable ["ace_medical_lastDamageSource", _killer];
	};
	if (!isNull _killer) then {
		[d_tt_points # 2, _killer] remoteExecCall ["d_fnc_AddPoints", 2];
		switch (side (group _killer)) do {
			case blufor: {[39, "WEST"] remoteExecCall ["d_fnc_DoKBMsg", 2]};
			case opfor: {[39, "EAST"] remoteExecCall ["d_fnc_DoKBMsg", 2]};
		};
	};
#endif
	(param [0]) spawn {
		sleep (60 + random 60);
		_this setDamage 0;
		deleteVehicle _this;
	};
	if (d_database_found) then {
#ifndef __TT__
		private _killer = param [2];
		if (d_with_ace && {isNull _killer}) then {
			_killer = (param [0]) getVariable ["ace_medical_lastDamageSource", _killer];
		};
#endif
		if (!isNil "_killer" && {!isNull _killer && {_killer call d_fnc_isplayer}}) then {
			[_killer, 1] remoteExecCall ["d_fnc_addppoints", 2];
		};
	};
	(param [0]) removeAllEventHandlers "killed";
}];
_vec addEventHandler ["handleDamage", {_this call d_fnc_CheckMTShotHD}];