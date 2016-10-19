params ["_loadoutHierarchy"];

_mergedLoadout = [] call CBA_fnc_hashCreate;

{
    _currentLevel = _x;

    {
        if ([_currentLevel, _x] call CBA_fnc_hashHasKey) then {
            _newValue = [_currentLevel, _x] call CBA_fnc_hashGet;
            [_mergedLoadout, _x, _newValue] call CBA_fnc_hashSet;
        };
    } forEach [
        "uniform",
        "vest",
        "backpack",
        "primaryWeapon",
        "primaryWeaponMuzzle",        
        "primaryWeaponOptics",
        "primaryWeaponPointer",
        "primaryWeaponUnderbarrel",
        "secondaryWeapon",
        "handgunWeapon",
        "headgear",
        "goggles",
        "nvgoggles",
        "binoculars",
        "map",
        "gps",
        "compass",
        "watch",
        "radio"
    ];

    // add* values must be appended
    {
        if ([_currentLevel, _x] call CBA_fnc_hashHasKey) then {
            _oldValue = [_mergedLoadout, _x] call CBA_fnc_hashGet;
            if (isNil "_oldValue") then {
                _oldValue = [];
            };
            _addValue = [_currentLevel, _x] call CBA_fnc_hashGet;
            [_mergedLoadout, _x, _oldValue + _addValue] call CBA_fnc_hashSet;
        };
    } forEach [
        "addItemsToUniform",
        "addItemsToVest",
        "addItemsToBackpack"
    ];

} forEach _loadoutHierarchy;

_mergedLoadout