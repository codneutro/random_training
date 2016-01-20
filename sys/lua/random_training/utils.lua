---------------------------------------------------------------------
-- utils.lua                                                       --
-- Author: xNir                                                    --
-- Version: 1.1                                                    --
-- Last Update: 28.12.2015                                         --
-- Utilitaries Functions                                           --
---------------------------------------------------------------------

-----------------------
--      GLOBALS      --
-----------------------
WHITE = string.char(169).."255255255";
local INFO_COLOR = WHITE;
local DEBUG_COLOR = string.char(169).."205127050";
maps = {};

---------------------------------------------------------------------
-- Displays a message to a specific player                         --
--                                                                 --
-- @param id a player's ID                                         --
-- @param message a message to display                             --
---------------------------------------------------------------------
function infoMessage(id, message)
	msg2(id, INFO_COLOR.."[INFO]: "..message)
end

---------------------------------------------------------------------
-- Prints the message into the default output                      --
--                                                                 --
-- @param message a message to print                               --
---------------------------------------------------------------------
function printDebug(message)
	print(DEBUG_COLOR..message)
end

---------------------------------------------------------------------
-- Displays a debugging message                                    --
--                                                                 --
-- @param message a message to display                             --
---------------------------------------------------------------------
function debugMessage(message)
	msg(DEBUG_COLOR.."[DEBUG]: "..message)
end

---------------------------------------------------------------------
-- Returns n with f decimal places                                 --
--                                                                 --
-- @param n a number                                               --
-- @param f number of decimal places                               --
-- @return the number formatted                                    --
---------------------------------------------------------------------
function tofloat(n, f)
	return string.format("%."..f.."f", tonumber(n));
end

---------------------------------------------------------------------
-- Returns true if a point is inside the specified rectangle       --
--                                                                 --
-- @param pointX point x coordinate in pixels                      --
-- @param pointY point y coordinate in pixels                      --
-- @param rectX rectangle x coordinate in pixels                   --
-- @param rectY rectangle y coordinate in pixels                   --
-- @param rectWidth rectangle width                                --
-- @param rectHeight rectangle height                              --
-- @return true if the specified point is inside the rectangle     --
---------------------------------------------------------------------
function isPointInsideRectangle(pointX, pointY, rectX, rectY, rectWidth, rectHeight)
	return (pointX >= rectX) and (pointX <= rectX + rectWidth) and
		(pointY >= rectY) and (pointY <= rectY + rectHeight)
end

---------------------------------------------------------------------
-- Displays an hudtext2                                            --
--                                                                 --
-- @param player player's ID                                       --
-- @param id internal text id (0-49)                               --
-- @param text the text to be displayed                            --
-- @param x x position in pixels                                   --
-- @param y y position in pixels                                   --
-- @param align text alignment                                     --
-- @return the txt id                                              --
---------------------------------------------------------------------
function hudtxt2(player, id, text, x, y, align)
	if(not align) then align = 0 end
	parse('hudtxt2 '..player..' '..id..' "'..text..'" '..x..' '..y..' '..align)
	return id
end

---------------------------------------------------------------------
-- Hides a hudtext2                                                --
--                                                                 --
-- @param player player's ID                                       --
-- @param id internal text id (0-49)                               --
---------------------------------------------------------------------
function clearhudtxt2(player, id)
	parse('hudtxt2 '..player..' '..id)
end

---------------------------------------------------------------------
-- Parse logs for collecting maps                                  --
--                                                                 --
-- @param txt some logs                                            --
---------------------------------------------------------------------
function grabmaps(txt)
	if(txt ~= "----- Maps -----") then
		table.insert(maps, txt);
	end
end

---------------------------------------------------------------------
-- Load the maps of the server, used for map menu                  --
---------------------------------------------------------------------
function loadMaps()
	maps = {};
	addhook("log","grabmaps");
 	parse("maps");
 	freehook("log","grabmaps");
end