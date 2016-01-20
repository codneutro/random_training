----------------------------------------------------------------------
-- Main Script Project v1.1                                         --
--                                                                  --
-- Author: xNir**                                                   --
-- Last Update: 01.01.2016                                          --
-- File: menu.lua                                                   --
----------------------------------------------------------------------

-------------
-- GLOBALS --
-------------
menus = {};
playersMenus = {};
playersAttempts = {};


----------------------------------------------------------------------
-- Initialize the menus                                             --
----------------------------------------------------------------------
function initMenus()
	--// main
	menus["main"] = Menu.new("Target Menu");
	menus["main"].buttons[1] = Button.new("Add", addTargetEvent);
	menus["main"].buttons[2] = Button.new("Spawn", onSpawnTargetEvent);
	menus["main"].buttons[3] = Button.new("Hide", onHideTargetEvent);
	menus["main"].buttons[4] = Button.new("Remove", onRemoveTargetEvent);
	menus["main"].buttons[5] = Button.new("HP", onHpTargetEvent);
	menus["main"].buttons[6] = Button.new("Settings", onSettingsEvent);
	menus["main"].buttons[7] = Button.new("Maps", onMapEvent);

	--// spawn
	menus["spawn"] = Menu.new("Spawn Menu");
	menus["spawn"].buttons[1] = Button.new("TT", onSpawnTargetEvent, {team = 1});
	menus["spawn"].buttons[2] = Button.new("CT", onSpawnTargetEvent, {team = 2});
	menus["spawn"].buttons[3] = Button.new("ALL", onSpawnTargetEvent, {team = 0});
	menus["spawn"].buttons[4] = Button.new("Specific", onSpawnTargetEvent, {index = true});

	--// hide
	menus["hide"] = Menu.new("Hide Menu");
	menus["hide"].buttons[1] = Button.new("TT", onHideTargetEvent, {team = 1});
	menus["hide"].buttons[2] = Button.new("CT", onHideTargetEvent, {team = 2});
	menus["hide"].buttons[3] = Button.new("ALL", onHideTargetEvent, {team = 0});
	menus["hide"].buttons[4] = Button.new("Specific", onHideTargetEvent, {index = true});

	--// remove
	menus["remove"] = Menu.new("Remove Menu");
	menus["remove"].buttons[1] = Button.new("TT", onRemoveTargetEvent, {team = 1});
	menus["remove"].buttons[2] = Button.new("CT", onRemoveTargetEvent, {team = 2});
	menus["remove"].buttons[3] = Button.new("ALL", onRemoveTargetEvent, {team = 0});
	menus["remove"].buttons[4] = Button.new("Specific", onRemoveTargetEvent, {index = true});
	
	--// hp
	menus["hp"] = Menu.new("Target HP");
	menus["hp"].buttons[1] = Button.new("100 HP", onHpTargetEvent, {hp = 100});
	menus["hp"].buttons[2] = Button.new("500 HP", onHpTargetEvent, {hp = 500});
	menus["hp"].buttons[3] = Button.new("1000 HP", onHpTargetEvent, {hp = 1000});
	menus["hp"].buttons[4] = Button.new("2000 HP", onHpTargetEvent, {hp = 2000});
	menus["hp"].buttons[5] = Button.new("5000 HP", onHpTargetEvent, {hp = 5000});
	menus["hp"].buttons[6] = Button.new("10000 HP", onHpTargetEvent, {hp = 10000});
	
	--// maps
	loadMaps();
	menus["maps"] = Menu.new("Maps");
	for k, v in pairs(maps) do
		menus["maps"].buttons[k] = Button.new(v, onMapEvent, {map = v});
	end
end

----------------------------------------------------------------------
-- Change the menu of a player                                      --
--                                                                  --
-- @param id player's ID                                            --
-- @param key menu's key                                            --
-- @param display should the menu be displayed ?                    --
----------------------------------------------------------------------
function changeMenu(id, key, display)
	playersMenus[id] = menus[key];
	playersMenus[id].pages = 1;
	playersMenus[id].currentPage = 1;
	playersMenus[id].open = false;
	if(display) then
		playersMenus[id]:display(id);
	end
end

----------------------------------------------------------------------
-- Process the Add Button Event                                     --
--                                                                  --
-- @param id player's ID                                            --
-- @param args additional button arguments                          --
----------------------------------------------------------------------
function addTargetEvent(id, args)
	addTarget(player(id, "team"), player(id, "x"), player(id, "y"),
		player(id, "rot"));
	playersMenus[id].open = false;
end

----------------------------------------------------------------------
-- Process the Hide Button Event                                     --
--                                                                  --
-- @param id player's ID                                            --
-- @param args additional button arguments                          --
----------------------------------------------------------------------
function onHideTargetEvent(id, args)
	if(args.team) then
		if(args.team) then
			hideTargets(team);
		else
			hideTargets();
		end
		changeMenu(id, "main");
	elseif(args.index) then
		local i = 1;
		menus["hideIndex"] = Menu.new("Hide Specific Target");

		for k, t in pairs(targets) do
			if(t.imageID ~= nil) then
				menus["hideIndex"].buttons[i] = Button.new("Target #"..t.ID, 
					onHideTargetEvent, {specific = k});
				i = i + 1;
			end
		end

		changeMenu(id, "hideIndex", true);
	elseif(args.specific) then
		targets[args.specific]:hide();
		changeMenu(id, "main");
	else
		changeMenu(id, "hide", true);
	end
end

----------------------------------------------------------------------
-- Process the Remove Button Event                                  --
--                                                                  --
-- @param id player's ID                                            --
-- @param args additional button arguments                          --
----------------------------------------------------------------------
function onRemoveTargetEvent(id, args)
	if(args.team) then
		if(args.team) then
			removeTargets(team);
		else
			removeTargets();
		end
		changeMenu(id, "main");
	elseif(args.index) then
		local i = 1;
		menus["removeIndex"] = Menu.new("Remove Specific Target");

		for k, t in pairs(targets) do
			if(t.imageID ~= nil) then
				menus["removeIndex"].buttons[i] = Button.new("Target #"..t.ID, 
					onRemoveTargetEvent, {specific = k});
			i = i + 1;
			end
		end

		changeMenu(id, "removeIndex", true);
	elseif(args.specific) then
		removeTarget(args.specific);
		changeMenu(id, "main");
	else
		changeMenu(id, "remove", true);
	end
end

----------------------------------------------------------------------
-- Process the Map Button Event                                     --
--                                                                  --
-- @param id player's ID                                            --
-- @param args additional button arguments                          --
----------------------------------------------------------------------
function onMapEvent(id, args)
	if(args.map) then
		parse("sv_map "..args.map);
	else
		changeMenu(id, "maps", true);
	end
end

----------------------------------------------------------------------
-- Process the Settings Button Event                                --
--                                                                  --
-- @param id player's ID                                            --
-- @param args additional button arguments                          --
----------------------------------------------------------------------
function onSettingsEvent(id, args)
	if(args.update ~= nil) then
		processAutoUpdate(args.update);
		changeMenu(id, "main");
	elseif(args.block ~= nil) then
		processBlockShot(args.block);
		changeMenu(id, "main");
	else
		menus["settings"] = Menu.new("Settings Menu");
		if(AUTO_UPDATE) then
			menus["settings"].buttons[1] = 
				Button.new("AUTO_UPDATE OFF", onSettingsEvent, 
					{update = false});
		else
			menus["settings"].buttons[1] = 
				Button.new("AUTO_UPDATE ON", onSettingsEvent, 
					{update = true});
		end

		if(BLOCK_SHOT) then
			menus["settings"].buttons[2] = 
				Button.new("BLOCK_SHOT OFF", onSettingsEvent, 
					{block = false});
		else
			menus["settings"].buttons[2] = 
				Button.new("BLOCK_SHOT ON", onSettingsEvent, 
					{block = true});
		end

		changeMenu(id, "settings", true);
	end
end

----------------------------------------------------------------------
-- Process the Spawn Button Event                                   --
--                                                                  --
-- @param id player's ID                                            --
-- @param args additional button arguments                          --
----------------------------------------------------------------------
function onSpawnTargetEvent(id, args)
	if(args.team) then
		if(args.team) then
			spawnTargets(team);
		else
			spawnTargets();
		end
		changeMenu(id, "main");
	elseif(args.index) then
		menus["spawnIndex"] = Menu.new("Spawn Specific Target");

		for k, t in pairs(targets) do
			menus["spawnIndex"].buttons[k] = Button.new("Target #"..k, 
				onSpawnTargetEvent, {specific = k});
		end

		changeMenu(id, "spawnIndex", true);
	elseif(args.specific) then
		targets[args.specific]:spawn();
		changeMenu(id, "main");
	else
		changeMenu(id, "spawn", true);
	end
end

----------------------------------------------------------------------
-- Process the HP Button Event                                      --
--                                                                  --
-- @param id player's ID                                            --
-- @param args additional button arguments                          --
----------------------------------------------------------------------
function onHpTargetEvent(id, args)
	if(args.hp) then
		TARGET_DEFAULT_HP = args.hp;
		for k, target in pairs(targets) do
			target.hp = args.hp;
		end
		changeMenu(id, "main");
		infoMessage(id, "Targets HP have been changed to "..args.hp.." HP");
	else
		changeMenu(id, "hp", true);
	end
end


----------------------------------------------------------------------
-- Menu class                                                       --
--                                                                  --
-- @field title menu's title                                        --
-- @field currentPage menu's currentPage                            --
-- @field pages menu's total pages                                  --
-- @field open menu is opened                                       --
-- @field buttons menu's buttons                                    --
----------------------------------------------------------------------
Menu = {};
Menu.meta = {__index = Menu};
Menu.title = "";
Menu.currentPage = 1;
Menu.pages = 1;
Menu.open = false;
Menu.buttons = {};

----------------------------------------------------------------------
-- Menu default constructor                                         --
--                                                                  --
-- @param title menu's title                                        --
-- @param buttons menu's buttons                                    --
-- @return menu's instances                                         --
----------------------------------------------------------------------
function Menu.new(title, buttons)
	local m = {};
	setmetatable(m, Menu.meta);
	m.title = title or "Menu";
	m.buttons = buttons or {};
	return m;
end

----------------------------------------------------------------------
-- Displays a menu to a player                                      --
--                                                                  --
-- @param id player's ID                                            --
----------------------------------------------------------------------
function Menu:display(id)
	--// Local Variables
	local menuStr = self.title;
	local button;
	self.pages = math.ceil(#self.buttons / 6);
	self.open = true;

	--// Fixing Index
	if(self.currentPage < 1) then self.currentPage = 1; end
	if(self.currentPage > self.pages) then self.currentPage = self.pages; end

	--// Collecting Button Content
	for i = self.currentPage * 6 - 5, self.currentPage * 6 do
		button = self.buttons[i];
		if(button) then
			menuStr = menuStr..", "..button.content;
		else
			menuStr = menuStr..",";
		end
	end

	--// Link Buttons
	if(self.currentPage > 1) then
		menuStr = menuStr..",,Previous";
	else
		menuStr = menuStr..",,";
	end

	if(self.currentPage < self.pages) then
		menuStr = menuStr..",Next";
	end

	menu(id, menuStr);
end

----------------------------------------------------------------------
-- Close a menu (changing field states ONLY !!!)                    --
----------------------------------------------------------------------
function Menu:close()
	self.currentPage = 1;
	self.open = false;
end