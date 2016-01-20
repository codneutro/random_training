---------------------------------------------------------------------
-- filestream.lua                                                  --
-- Author: xNir                                                    --
-- Version: 1.0                                                    --
-- Last Update: 28.12.2015                                         --
-- Input/Output Functions                                          --
---------------------------------------------------------------------

fileStream = {}
fileStream.buff = {}
fileStream.line = 0

---------------------------------------------------------------------
-- Returns true if the specified file exists    				   --
--                                                                 --
-- @param path the filepath to be tested                           --
-- @return true if the specified file exists                       --
---------------------------------------------------------------------
function fileStream.fileExists(path)
	local f = io.open(path, "r")
	if(f) then
		f:close()
		return true
	end
	return false
end

---------------------------------------------------------------------
-- Erases the whole content of the specified file  		           --
--                                                                 --
-- @param path a filepath                                          --
---------------------------------------------------------------------
function fileStream.eraseFile(path)
	local f = io.open(path, "w+")
	if(f) then
		f:close()
	else
		printDebug("[FileStream]: Can't erase "..path)
	end
end

---------------------------------------------------------------------
-- Reads a specified file and reset the current buffer   		   --
--                                                                 --
-- @param path the filepath to be tested                           --
---------------------------------------------------------------------
function fileStream.readFile(path)
	local f = io.open(path, "r")
	if(f) then
		fileStream.buff = {}
		fileStream.line = 0
		for line in f:lines() do
			--print(line)
			table.insert(fileStream.buff, line)
		end
		f:close()
	else
		printDebug("[FileStream]: Can't read "..path)
	end
end

---------------------------------------------------------------------
-- Returns a line from a loaded buffer   		                   --
--                                                                 --
-- @param path a filepath (optionnal)                              --
-- @return a line or nil on EOF                                    --
---------------------------------------------------------------------
function fileStream.readLine(path)
	if(path) then fileStream.readFile(path) end
	fileStream.line = fileStream.line + 1
	return fileStream.buff[fileStream.line]
end

---------------------------------------------------------------------
-- Writes the specified lines into the specified file   		   --
--                                                                 --
-- @param path the file path                                       --
-- @param lines the lines to be written                            --
---------------------------------------------------------------------
function fileStream.writeLines(path, lines)
	local f = io.open(path, "w+")
	if(f) then
		for _, line in pairs(lines) do
			f:write(line.."\n")
		end
		f:flush()
		f:close()
	else
		printDebug("[FileStream]: Can't write lines "..path)
	end
end

---------------------------------------------------------------------
-- Appends a line into the specified file   		   			   --
--                                                                 --
-- @param path the file path                                       --
-- @param line the line to be appended                             --
---------------------------------------------------------------------
function fileStream.appendLine(path, line)
	local f = io.open(path, "a+")
	if(f) then
		f:write(line.."\n")
		f:flush()
		f:close()
	else
		printDebug("[FileStream]: Can't append line "..path)
	end
end

---------------------------------------------------------------------
-- Appends the lines into the specified file   		   			   --
--                                                                 --
-- @param path the file path                                       --
-- @param lines the lines to be appended                           --
---------------------------------------------------------------------
function fileStream.appendLines(path, lines)
	local f = io.open(path, "a+")
	if(f) then
		for _, line in pairs(lines) do
			f:write(line.."\n")
		end
		f:flush()
		f:close()
	else
		printDebug("[FileStream]: Can't append lines "..path)
	end
end

---------------------------------------------------------------------
-- Remplace an old line by a new one   		   			           --
--                                                                 --
-- @param path the file path                                       --
-- @param index the index of the previous line                     --
-- @param line the new line                                        --
---------------------------------------------------------------------
function fileStream.editLine(path, index, line)
	fileStream.readFile(path)
	fileStream.buff[index] = line
	fileStream.writeLines(path, fileStream.buff)
end

---------------------------------------------------------------------
-- Removes a line from a file 		   			                   --
--                                                                 --
-- @param path the file path                                       --
-- @param index the index of the previous line                     --
---------------------------------------------------------------------
function fileStream.removeLine(path, index)
	fileStream.readFile(path)
	table.remove(fileStream.buff, index)
	fileStream.writeLines(path, fileStream.buff)
end

---------------------------------------------------------------------
-- Inserts a new line at the specified index into the specified    --
-- file		   			                                           --
--                                                                 --
-- @param path the file path                                       --
-- @param index the index of the previous line                     --
-- @param line the new line                                        --
---------------------------------------------------------------------
function fileStream.insertLine(path, index, line)
	fileStream.readFile(path)
	table.insert(fileStream.buff, index, line)
	fileStream.writeLines(path, fileStream.buff)
end