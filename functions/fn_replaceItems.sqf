// Get config entry
_configPath = _this select 0;
_loadoutTarget = _this select 1;

{ _loadoutTarget removeItem _x; } forEach items _loadoutTarget;
{ _loadoutTarget addItem _x; } forEach getArray (_configPath);