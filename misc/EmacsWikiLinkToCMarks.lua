--
--
--

local argFile, argReplace = ...

local fs = {}

function fs.readContent( path )
   local f = io.open( path, "r" )
   if f then
      local content = f:read("a")
      f:close()
      return content
   end
   return nil
end

function fs.writeContent(path, content, append)
   if type(content) == "string" and content:len() > 0 then
      local f = io.open( path, append and "a+" or "w")
      if f then
         local valid, errString = f:write(content)
         f:close()
         return valid ~= nil, errString
      end
   end
   return false
end


function fs.replaceMarks(path, isReplace)
   local content = fs.readContent(path)
   if type(content) ~= "string" then
      return
   end

   -- replace (EmailMe)[EmailMe] to (EmailMe)(link)
   content = content:gsub("(%(EmailMe%)%[EmailMe%])", function(mark)
                             return "<a class=\"nonexistent\" href=\"mailto:suchaaa@gmail.com\">EmailMe</a>"
   end)

   -- replace "''''" to ""
   content = content:gsub("''''", "")

   -- replace "*+ title" to "#+ title"
   content = content:gsub("\n(%*+%s+[^%c]+)", function(mark)
                             local s, e = mark:find("%s")
                             if not s then
                                return mark
                             end
                             local title = mark:match("%*+%s+([^%c]+)")
                             return "\n" .. string.rep("#", tonumber(s)) .. " " .. title
   end)

   -- replace "[[link][name]]" to "[name](link)"
   content = content:gsub("(%[%[[^%]]+%]%[[^%]]+%]%])", function( mark )
                             local link, name = mark:match("%[%[([^%]]+)%]%[([^%]]+)%]%]")
                             --print("---", tag, name)
                             return string.format("[%s](%s)", name, link)
   end)

   -- replace "[[link]]" to "![img](link)"
   content = content:gsub("(%[%[[^%]]+%]%])", function( mark )
                             local link = mark:match("%[%[([^%]]+)%]%]")
                             --print("---", name)
                             return string.format("![img](%s)", link)
   end)

   if isReplace then
      fs.writeContent(path, content)
   else
      print(content)
   end
end

if not argFile then
   print("Usage: SourcePath [1:Replace]")
else
   fs.replaceMarks( argFile, argReplace )
end
