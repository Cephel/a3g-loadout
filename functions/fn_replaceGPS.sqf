// Get config entry
_configPath = _this select 0;
_loadoutTarget = _this select 1;

if(getText _configPath == "") then {
	_loadoutTarget unlinkItem "ItemGPS";
} else {
	_loadoutTarget linkItem getText (_configPath);
};