----------------------------------------------------------------------
-- Main Script Project v1.1                                         --
--                                                                  --
-- Author: xNir**                                                   --
-- Last Update: 01.01.2016                                          --
-- File: Button.lua                                                 --
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Button class                                                     --
--                                                                  --
-- @field content button's content                                  --
-- @field func button's function                                    --
-- @field args button's function additional arguments               --
----------------------------------------------------------------------
Button = {};
Button.meta = {__index = Button};
Button.content = "";
Button.func = nil;
Button.args = {};

----------------------------------------------------------------------
-- Button default constructor                                       --
--                                                                  --
-- @param content button's content                                  --
-- @param func button's function                                    --
-- @param args button's function additional arguments               --
----------------------------------------------------------------------
function Button.new(content, func, args)
	local b = {};
	setmetatable(b, Button.meta);
	b.content = content;
	b.func = func;
	b.args = args;
	return b;
end

----------------------------------------------------------------------
-- Button's action event                                            --
--                                                                  --
-- @param id player's ID                                            --
----------------------------------------------------------------------
function Button:pressed(id)
	self.func(id, self.args);
end