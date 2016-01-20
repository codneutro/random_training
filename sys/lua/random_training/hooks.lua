----------------------------------------------------------------------
-- Main Script Project v1.1                                         --
--                                                                  --
-- Author: xNir**                                                   --
-- Last Update: 01.01.2016                                          --
-- File: hooks.lua                                                  --
----------------------------------------------------------------------


----------------------------------------------------------------------
-- Process menu action                                              --
--                                                                  --
-- @param id player's ID                                            --
-- @param action numeric key                                        --
----------------------------------------------------------------------
function onMenuServerAction(id, action)
	if(action == 1) then
		if(playersMenus[id] == nil) then
			changeMenu(id, "main", true);
		else
			if(playersMenus[id].open) then
				infoMessage(id, "Your menu is already opened !");
				if(playersAttempts[id] == nil) then
					playersAttempts[id] = 1;
				else
					playersAttempts[id] = playersAttempts[id] + 1;
					if(playersAttempts[id] > 3) then
						playersMenus[id]:display(id);
						infoMessage(id, "Next time avoid using escape for closing menu !");
						playersAttempts[id] = nil;
					end
				end
			else
				playersMenus[id]:display(id);
			end
		end
	end
end

----------------------------------------------------------------------
-- Handles buttons events                                           --
--                                                                  --
-- @param id player's ID                                            --
-- @param title menu's title                                        --
-- @param button button number (0 - 9)                              --
----------------------------------------------------------------------
function onButtonClick(id, title, button)
	if(button == 0) then
		changeMenu(id, "main");
	elseif(button == 8) then
		playersMenus[id].currentPage = playersMenus[id].currentPage - 1;
		playersMenus[id]:display(id);
	elseif(button == 9) then
		playersMenus[id].currentPage = playersMenus[id].currentPage + 1;
		playersMenus[id]:display(id);
	else
		local index = (playersMenus[id].currentPage - 1) * 6 + button;
		local b = playersMenus[id].buttons[index];
		if(b) then b:pressed(id); end
	end
end

----------------------------------------------------------------------
-- Handles targets hits                                             --
--                                                                  --
-- @param imageID dynamic object id of image with hitzone           --                                     
-- @param playerID id of player who shot                            --
-- @param objectID id of dynamic object that shot                   --
-- @param weapon weapon type ID                                     --
-- @param x impact x position (in pixels)                           --
-- @param y impact y position (in pixels)                           --
-- @param damage damage of the shot that hit the hitzone            --
----------------------------------------------------------------------
function onTargetHit(imageID, playerID, objectID, weapon, x, y, damage)
	parse("sv_sound2 "..playerID.." player/hit2.wav");
	for k, target in pairs(targets) do
		if(target.imageID == imageID) then
			target.hp = target.hp - damage;
			if(target.hp < 0) then
				infoMessage(playerID, "You have killed the target #"..
					target.ID);
				target:hide();
				target.hp = TARGET_DEFAULT_HP;
				if(AUTO_UPDATE) then
					target:spawn();
				end
			end
			break;
		end
	end
	return 0;
end

----------------------------------------------------------------------
-- Spawn Targets on start round                                     --
--                                                                  --
-- @param mode start round mode                                     -- 
----------------------------------------------------------------------
function onStartRoundSpawnTargets(mode)
	loadTargets();
	spawnTargets();
end

----------------------------------------------------------------------
-- Show Target id on mouse hover                                    --
--                                                                  --
-- @param id player who sent this data                              --
-- @param mode which kind of data                                   -- 
-- @param data1: data value 1 (commonly X coordinate)               --
-- @param data2: data value 2 (commonly Y coordinate)               --
----------------------------------------------------------------------
function onMouseHover(id, mode, data1, data2)
	if(mode == 2) then
		local mX = data1;
		local mY = data2;
		local hovering = false;

		for k, t in pairs(targets) do
			if(t.imageID ~= nil) then
				if(isPointInsideRectangle(mX, mY, t.x - t.width / 2, t.y - t.height / 2, t.width, t.height)) then
					hudtxt2(id, 1, WHITE.."Target #"..t.ID, 0, 430, align);
					hovering = true;
					break;
				end
			end
		end

		if(not hovering) then
			clearhudtxt2(id, 1);
		end
	end
end

----------------------------------------------------------------------
-- Set 16k + equip deagle, usp, glock, m4, ak, and kev              --
--                                                                  --
-- @param id player who sent this data                              --
----------------------------------------------------------------------
function onSpawn(id)
	parse("setmoney "..id.." 16000");
	return "1, 2, 3, 30, 32, 58";
end