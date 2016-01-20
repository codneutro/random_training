----------------------------------------------------------------------
-- Random Script Project v1.1                                       --
--                                                                  --
-- Author: xNir**                                                   --
-- Last Update: 02.01.2016                                          --
-- File: main.lua                                                   --
----------------------------------------------------------------------

--------------
-- INCLUDES --
--------------
dofile("sys/lua/random_training/utils.lua"); -- Misc Methods
dofile("sys/lua/random_training/io/filestream.lua"); -- Input/Output Methods
dofile("sys/lua/random_training/menu.lua"); -- Menu Operations
dofile("sys/lua/random_training/button.lua"); -- Button Class
dofile("sys/lua/random_training/target.lua"); -- Target Class
dofile("sys/lua/random_training/hooks.lua"); -- Hooks Functions

-------------
-- GLOBALS --
-------------
AUTO_UPDATE = true;
BLOCK_SHOT = false;
REQUEST_RATE = 150;

---------------------------------------------------------------------
-- Change the current update state                                 --
--                                                                 --
-- @param mode true/false                                          --
---------------------------------------------------------------------
function processAutoUpdate(mode)
	if(mode) then
		AUTO_UPDATE = true;
		addhook("startround", "onStartRoundSpawnTargets");
		infoMessage(0, "Targets spawn every round");
		infoMessage(0, "Targets insta respawn");
	else
		AUTO_UPDATE = false;
		freehook("startround", "onStartRoundSpawnTargets");
		infoMessage(0, "Targets dont spawn every round");
		infoMessage(0, "Targets dont insta respawn");
	end
end

---------------------------------------------------------------------
-- Change the current block shot state                             --
--                                                                 --
-- @param mode true/false                                          --
---------------------------------------------------------------------
function processBlockShot(mode)
	if(mode) then
		BLOCK_SHOT = true;
		TARGET_HITZONE_MODE = 103;
		infoMessage(0, "Targets block shots");
	else
		BLOCK_SHOT = false;
		TARGET_HITZONE_MODE = 3;
		infoMessage(0, "Targets dont block shot");
	end
	spawnTargets();
end

---------------------------------------------------------------------
-- Timer for mouse position                                        --
---------------------------------------------------------------------
function requestMousePos()
	reqcld(0, 2);
end

function main()
	--// Init
	initMenus();
	loadTargets();
	--// Hooks
	addhook("serveraction", "onMenuServerAction");
	addhook("menu", "onButtonClick");
	addhook("hitzone", "onTargetHit");
	addhook("spawn", "onSpawn");
	addhook("clientdata", "onMouseHover");
	if(AUTO_UPDATE) then
		addhook("startround", "onStartRoundSpawnTargets");
	end
	--// timers
	timer(REQUEST_RATE, "requestMousePos", "", 0)
	--// settings
	parse("mp_infammo 1");
	parse("sv_fow 1");
	parse("mp_startmoney 16000");
	parse("mp_roundtime 100");
	parse("mp_freezetime 0");
end

main();