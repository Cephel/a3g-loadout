// Make sure only clients run this script
if (isDedicated) exitWith {};

// Find out if player class is represented in CfgLoadouts, if not we can exit the script right here, as there's no loadout to be applied
if (!isClass (missionConfigFile >> "CfgLoadouts" >> (typeof player))) exitWith {};

// At this point, there definitely is a loadout for player class, let's apply it

// ======================================== Containers ============================================
// Uniform
if (isText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "uniform")) then {
	// Backup items and magazines
	_backUpItems = uniformItems player;
	_backUpMagazines = uniformMagazines player;
	
	player forceAddUniform getText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "uniform");
	
	// Reapply items and magazines
	{ player addItemToUniform _x; } forEach _backUpItems;
	{ player addItemToUniform _x; } forEach _backUpMagazines;
};

// Vest
if (isText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "vest")) then {
	// Backup items and magazines
	_backUpItems = vestItems player;
	_backUpMagazines = vestMagazines player;
	
	player addVest getText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "vest");
	
	// Reapply items and magazines
	{ player addItemToVest _x; } forEach _backUpItems;
	{ player addItemToVest _x; } forEach _backUpMagazines;
};

// Backpack
if (isText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "backpack")) then {
	// Backup items and magazines
	_backUpItems = backpackItems player;
	_backUpMagazines = backpackMagazines player;

	// We need to explicibly remove the backpack here, because otherwise it gets dropped on the floor
	removeBackpack player;
	player addBackpack getText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "backpack");
	
	// Newly spawned backpacks are auto filled with their config loadouts. We don't want this, so we clear them out at this point
	{ player removeItemFromBackpack _x; } forEach backpackItems player;
	
	// Reapply items and magazines
	{ player addItemToBackpack _x; } forEach _backUpItems;
	{ player addItemToBackpack _x; } forEach _backUpMagazines;
};

// ==================================== Items & Magazines =========================================
// Magazines
if (isArray (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "magazines")) then {
	{ player removeMagazine _x; } forEach magazines player;
	{ player addMagazine _x; } forEach getArray (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "magazines");
};

// Items
if (isArray (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "items")) then {
	{ player removeItem _x; } forEach items player;
	{ player addItem _x; } forEach getArray (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "items");
};

// ================================= Added Items & Magazines ======================================
// Magazines
if (isArray (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "addMagazines")) then {
	{ player addMagazine _x; } forEach getArray (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "addMagazines");
};

// Items
if (isArray (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "addItems")) then {
	{ player addItem _x; } forEach getArray (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "addItems");
};

// ======================================== Equipment =============================================
// Headgear
if (isText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "headgear")) then {
	player addHeadgear getText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "headgear");
};

// Goggles ( No, this is NOT Night Vision Goggles )
if (isText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "goggles")) then {
	player addGoggles getText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "goggles");
};

// ========================================= Weapons ==============================================
// Workaround to prevent weapon switching when replacing the primary weapon, remove pistol first, add it later after the primary weapon was changed
// Second workaround because for some reason some handguns ( ie. "hgun_P07_F" cannot be removed via removeWeapon )
// Instead add a placeholder handgun that can immediately be removed again now ( somehow this works )
_handgunBackup = handgunWeapon player;
_handgunMagazineBackup = handgunMagazine player;
if (handgunWeapon player == "hgun_P07_F") then {
	player addWeapon "hgun_Pistol_heavy_01_F";
	player removeWeapon "hgun_Pistol_heavy_01_F";
	player removeItem "16Rnd_9x21_Mag";
	player removeItem "16Rnd_9x21_Mag";
} else {
	player removeWeapon (handgunWeapon player);
};

// Primary weapon
if (isText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "primaryWeapon")) then {
	player addWeapon getText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "primaryWeapon");
};

// Launcher
if (isText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "secondaryWeapon")) then {
	player addWeapon getText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "secondaryWeapon");
};

// Sidearm
if (isText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "handgunWeapon")) then {	
	player addWeapon getText (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "handgunWeapon");
} else {
	// Add handgun back to complete the workaround above
	// Complete retard shit here, but basically it is required to replace the default handgun with something else, as neither adding nor removing it works
	// That's why you get 3 mags and a different pistol here
	if(_handgunBackup == "hgun_P07_F") then {
		player addItem "11Rnd_45ACP_Mag";
		player addItem "11Rnd_45ACP_Mag";
		player addItem "11Rnd_45ACP_Mag";
		player addWeapon "hgun_Pistol_heavy_01_F";
	} else {
		player addItem (_handgunMagazineBackup select 0);
		player addWeapon _handgunBackup;
	};
};

// ======================================= Attachments ============================================
// Primary weapon attachments
if (isArray (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "primaryWeaponAttachments")) then {
	removeAllPrimaryWeaponItems player;
	{ player addPrimaryWeaponItem _x; } forEach getArray (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "primaryWeaponAttachments");
};

// Handgun weapon attachments
if (isArray (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "handgunWeaponAttachments")) then {
	removeAllHandgunItems player;
	{ player addHandgunItem _x; } forEach getArray (missionConfigFile >> "CfgLoadouts" >> (typeof player) >> "handgunWeaponAttachments");
};