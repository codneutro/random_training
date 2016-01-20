----------------------------------------------------------------------
-- Main Script Project v1.1                                         --
--                                                                  --
-- Author: xNir**                                                   --
-- Last Update: 01.01.2016                                          --
-- File: target.lua                                                 --
----------------------------------------------------------------------

-------------
-- GLOBALS --
-------------
TARGET_SAVE_FOLDER = "sys/lua/random_training/data/";
TARGET_IMAGE_PATH = "gfx/target.png";
TARGET_DEFAULT_HP = 100;
TARGET_HITZONE_MODE = 3;
TARGET_REGEX_DATA = "(%d+)%s+(%d+\.%d+)%s+(%d+\.%d+)"; -- X(team) X.X (x) X.X(y)
TARGET_REGEX_ROT = "%d+%s+%d+\.%d+%s+%d+\.%d+%s+(%d+\.%d+)";
TARGET_REGEX_NROT = "%d+%s+%d+\.%d+%s+%d+\.%d+%s+(-%d+\.%d+)";

targets = {};

----------------------------------------------------------------------
-- Target class                                                     --
--                                                                  --
-- @field x target x coordinate in pixels                           --
-- @field y target y coordinate in pixels                           --
-- @field rot target rotation                                       --
-- @field path target image's path                                  --
-- @field width target image's width                                --
-- @field height target image's height                              --
-- @field imageID target image's ID                                 --
-- @field ID target's ID                                            --
-- @field hp target's hp                                            --
-- @field target target's team                                      --
----------------------------------------------------------------------
Target = {};
Target.meta = {__index = Target};
Target.x = 0;
Target.y = 0;
Target.rot = 0;
Target.path = TARGET_IMAGE_PATH;
Target.width = 32;
Target.height = 32;
Target.imageID = nil;
Target.ID = nil;
Target.hp = TARGET_DEFAULT_HP;
Target.team = 0;

----------------------------------------------------------------------
-- Loads the previous target file                                   --
----------------------------------------------------------------------
function loadTargets()
	local path = TARGET_SAVE_FOLDER..map("name")..".txt";

	if(fileStream.fileExists(path)) then
		local line;
		local t;
		targets = {};

		line = fileStream.readLine(path);
		while(line ~= nil) do
			t = Target.new(0, 0, 0, 0);
			if(line:match(TARGET_REGEX_DATA)) then
				t.team, t.x, t.y = line:match(TARGET_REGEX_DATA);
				t.team = tonumber(t.team);
				t.x = tofloat(tonumber(t.x), 2);
				t.y = tofloat(tonumber(t.y), 2);
				if(line:match(TARGET_REGEX_ROT)) then
					t.rot = tonumber(line:match(TARGET_REGEX_ROT));
				else
					if(line:match(TARGET_REGEX_NROT)) then
						t.rot = tonumber(line:match(TARGET_REGEX_NROT));
					else
						printDebug(path.." is corrupted !");
						return;
					end
				end
			table.insert(targets, t);
			t.ID = #targets;
			t:print();
			else
				printDebug(path.." is corrupted !");
				return;
			end
			line = fileStream.readLine();
		end
	else
		printDebug(path.." is missing creating a new one");
		fileStream.eraseFile(path);
	end
end

----------------------------------------------------------------------
-- Saves the targets                                                --
----------------------------------------------------------------------
function saveTargets()
	local path = TARGET_SAVE_FOLDER..map("name")..".txt";
	fileStream.eraseFile(path);
	for k, target in pairs(targets) do
		target:save();
	end
end

----------------------------------------------------------------------
-- Spawns the targets of the specified team (nil for all)           --
--                                                                  --
-- @param team target's team (optionnal)                            --
----------------------------------------------------------------------
function spawnTargets(team)
	for _, target in pairs(targets) do
		if(team) then
			if(target.team == team) then
				target:spawn();
			end
		else
			target:spawn();
		end
	end
end

----------------------------------------------------------------------
-- Hides the targets of the specified team (nil for all)            --
--                                                                  --
-- @param team target's team (optionnal)                            --
----------------------------------------------------------------------
function hideTargets(team)
	for _, target in pairs(targets) do
		if(team) then
			if(target.team == team) then
				target:hide();
			end
		else
			target:hide();
		end
	end
end

----------------------------------------------------------------------
-- Removes the targets of the specified team (nil for all)          --
--                                                                  --
-- @param team target's team (optionnal)                            --
----------------------------------------------------------------------
function removeTargets(team)
	local found = true;
	repeat
		found = false;
		for k, target in pairs(targets) do
			if(team) then
				if(target.team == team) then
					removeTarget(k);
					found = true;
				end
			else
				removeTarget(k);
				found = true;
			end
		end
	until not found;
end

----------------------------------------------------------------------
-- Adds a new target into the targets table                         --
--                                                                  --
-- @param x target x coordinate                                     --
-- @param y target y coordinate                                     --
----------------------------------------------------------------------
function addTarget(team, x, y, rot)
	for _, target in pairs(targets) do
		if(tofloat(target.x, 2) == tofloat(x, 2) and 
			tofloat(target.y, 2) == tofloat(y, 2)) then
			return;
		end
	end

	local t = Target.new(x, y, rot, team);
	t:save();
	table.insert(targets, t);
	t.ID = #targets;
	if(AUTO_UPDATE) then
		t:spawn();
	end
end

----------------------------------------------------------------------
-- Removes a target from the target table                           --
--                                                                  --
-- @param index target's index                                      --
----------------------------------------------------------------------
function removeTarget(index)
	for k, t in pairs(targets) do
		if(k == index) then
			t:remove();
			table.remove(targets, k);
			break;
		end
	end
end

----------------------------------------------------------------------
-- Target default constructor                                       --
--                                                                  --
-- @param x target x coordinate in pixels                           --
-- @param y target y coordinate in pixels                           --
-- @param rot target rotation in pixels                             --
-- @param team target's team                                        --
-- @return a target instance                                        --
----------------------------------------------------------------------
function Target.new(x, y, rot, team)
	local t = {};
	setmetatable(t, Target.meta);
	t.x = x;
	t.y = y;
	t.rot = rot;
	t.team = team;
	return t;
end

----------------------------------------------------------------------
-- Spawns a target                                                  --
----------------------------------------------------------------------
function Target:spawn()
	if(self.imageID ~= nil) then
		self:hide();
	end
	self.imageID = image(self.path, self.x, self.y, 1);
	imagepos(self.imageID, self.x, self.y, self.rot);
	imagehitzone(self.imageID, TARGET_HITZONE_MODE,
		-self.width / 2, -self.height / 2, self.width, self.height);
end

----------------------------------------------------------------------
-- Removes a target                                                 --
----------------------------------------------------------------------
function Target:remove()
	local path = TARGET_SAVE_FOLDER..map("name")..".txt";
	local k = 1;
	local line;
	local team, pX, pY = 0, 0, 0;

	self:hide();
	
	if(fileStream.fileExists(path)) then
		line = fileStream.readLine(path);
		while(line ~= nil) do
			if(line:match(TARGET_REGEX_DATA)) then
				team, pX, pY = line:match(TARGET_REGEX_DATA);
				if(self.team == tonumber(team) and 
					tofloat(self.x, 2) == tofloat(pX, 2) and 
						tofloat(self.y, 2) == tofloat(pY, 2)) then
					fileStream.removeLine(path, k);
					printDebug("A target has been removed !");
					return;
				end
			else
				printDebug(path.." is corrupted ! Can't remove target");
				return;
			end

			k = k + 1;
			line = fileStream.readLine();
		end
	else
		printDebug(path.." is missing creating a new one");
		fileStream.eraseFile(path);
	end
end

----------------------------------------------------------------------
-- Hides a target                                                   --
----------------------------------------------------------------------
function Target:hide()
	if(self.imageID ~= nil) then
		freeimage(self.imageID);
		self.imageID = nil;
	end
end

----------------------------------------------------------------------
-- Saves the target                                                 --
----------------------------------------------------------------------
function Target:save()
	local path = TARGET_SAVE_FOLDER..map("name")..".txt";
	if(fileStream.fileExists(path)) then
		local line = fileStream.readLine(path);
		local team, pX, pY = 0, 0, 0; 

		while(line ~= nil) do
			if(line:match(TARGET_REGEX_DATA)) then
				team, pX, pY = line:match(TARGET_REGEX_DATA);
				if(self.team == tonumber(team) and 
					tofloat(self.x, 2) == tofloat(tonumber(pX), 2) and
						tofloat(self.y, 2) == tofloat(tonumber(pY), 2)) then
					return;
				end
			else
				printDebug(path.." is corrupted ! Can't save target");
				return;
			end
			line = fileStream.readLine();
		end

		fileStream.appendLine(path, 
			self.team.." "..tofloat(self.x, 2).." "..
			tofloat(self.y, 2).." "..tofloat(self.rot, 2));
		printDebug("Target saved !");
	else
		printDebug(path.." is missing creating a new one");
		fileStream.eraseFile(path);
	end
end

----------------------------------------------------------------------
-- Prints a target (debugging)                                      --
----------------------------------------------------------------------
function Target:print()
	printDebug("**** TARGET: "..self.ID.." ****");
	printDebug("Team: "..self.team);
	printDebug("X: "..self.x.." Y:"..self.y.." Rot: "..self.rot);
end





