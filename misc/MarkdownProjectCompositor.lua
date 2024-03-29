--
--
-- Markdown Project Compositor
--
-- base on cmark-gfm, lfs, by lalawue, 2019/06/02

local envReadAll = (_VERSION:sub(5) < "5.3") and "*a" or "a"
local envIsJit = (type(jit) == 'table')

local function _require(libname)
   local ret, lib = pcall(require, libname)
   if ret then
      return lib
   end
end

local lfs = envIsJit and _require("lfs") or _require("lfs_ffi")
assert(lfs)

local kCMarkProgram = "cmark-gfm"
local kCMarkParams = " -t html --unsafe "
local kTmpFilePath = (os.getenv("TMP") or "/tmp") .. "/MarkdownSiteGeneratorTempFile"

local argConfigFile, argBasePath = ...

local fs = {}                   -- fs interface
local dbg = {}                  -- debug interface
local md = {}                   -- markdown parser interface
local site = {}                 -- site inteface

-- config file example
-- local config = {
--    source = "/Markdown/Source/Path", -- will be modified by compositor
--    publish = "/Html/Output/Path",    -- will be modified by compositor
--    program = "cmark-gfm",            -- program used
--    params = " -t html --unsafe --github-pre-lang ",    -- params
--    tmpfile = "/tmp/MarkdownProjectCompositorTempFile", -- temp file
--    dos2unix = true,                  -- convert CRLF to LF, remove CR
--    destname = function(filename)     -- from '2020-05.md' to '2020-05.html'
--       return dest_filename
--    end
--    projs = {
--       {
--          res = true,      -- resouces dir, when true do not build output
--          dir = "SourceSubPath",
--          files = {
--             -- file names filled by compositor
--          },
--          prepare = function( config, proj )
--             -- prepare proj, sort/insert/delete proj files to be processed by cmark
--          end,
--          body = function( config, proj, filename, content )
--             -- return modified source content before cmark process
--          end,
--          post = function( config, proj, filename, content)
--             -- return adjusted HTML after cmark process
--          end,
--          header = function( config, porj, filename )
--             -- return content append in dest head
--          end,
--          footer = function( config, proj, filename )
--             -- return content append in dest tail
--          end,
--          after = function( config, proj )
--             -- after all files generated
--          end,
--       },
--    },
--    -- user defines below
--    user = {
--       readFile = function( path )
--       end,
--       writeFile = function( path, content )
--       end,
--       siteHeader = function( config, proj, filename )
--       end,
--       siteFooter = function( config, proj, filename )
--       end,
--    },
-- }
--return config

--
-- debug function
--
function dbg.print( value, key, level, onlyipairs )

   if type(value) == "table" then
      if level then
         print(string.rep(".", level) .. key .. " <table>")
      end

      if onlyipairs then
         for k, v in ipairs(value) do
            dbg.print( v, k, level and (level + 1) or 0 )
         end
      else
         for k, v in pairs(value) do
            dbg.print( v, k, level and (level + 1) or 0 )
         end
      end
   else
      if level then
         io.write(string.rep(".", level))
      end

      if key then
         print( key .. " " .. tostring(value))
      else
         print( tostring(value) )
      end
   end
end

--
-- fs function
--

local _isWinOS = nil
function fs.isWinOS()
   if _isWinOS == nil then
      local path = os.getenv("PATH")
      _isWinOS = path:find("C:\\") or path:find("c:\\")
   end
   return _isWinOS
end

function fs.isDir( path )
   local attr = lfs.attributes(path)
   return (type(attr) == "table") and (attr.mode == "directory")
end

function fs.makeDir( path )
   if type(path) == "string" and not fs.isDir(path) then
      local cmd = nil
      if fs.isWinOS() then
         cmd = "mkdir " .. path:gsub("/", "\\")
      else
         cmd = "mkdir -p " .. path
      end
      dbg.print(cmd)
      os.execute(cmd)
   end
end

function fs.readContent( path )
   if not fs.isDir( path ) then
      local f = io.open( path, "rb" )
      if f then
         local content = f:read(envReadAll)
         f:close()
         return content
      end
   end
   return nil
end

function fs.writeContent(path, content, append)
   if not fs.isDir( path ) and type(content) == "string" then
      local f = io.open( path, append and "ab" or "wb")
      if f then
         local valid, errString = f:write(content)
         f:close()
         return valid ~= nil, errString
      end
   end
   return false
end

function fs.copyFile(pathFrom, pathTo)
   if fs.isDir(pathFrom) or fs.isDir(pathTo) then
      return
   end
   fs.writeContent(pathTo, fs.readContent(pathFrom))
end

function fs.listFiles(path, inputTable)
   if not path then
      return nil
   end

   local tbl = inputTable
   if type(tbl) ~= "table" then
      tbl = {}
   end

   for file in lfs.dir(path) do
      if file ~= "." and file ~= ".." then
         local f = path..'/'..file
         local attr = lfs.attributes (f)
         assert (type(attr) == "table")
         if attr.mode == "directory" then
            fs.listFiles( f )
         else
            tbl[#tbl + 1] = file -- no path
         end
      end
   end

   return tbl
end

--
-- cmark function
--

function md.prepareTempSource( config, proj, filename, sourceFile, tempFile )
   local content = fs.readContent( sourceFile )
   if proj.body then
      content = proj.body( config, proj, filename, content )
   end
   fs.writeContent( tempFile, content )
end

function md.compositeHeader( config, proj, filename, destFile )
   if proj.header then
      local content = proj.header( config, proj, filename )
      if type(content) == "string" then
         assert( fs.writeContent( destFile, content ) )
      end
   end
end

function md.compositeBody( config, proj, filename, tempFile, destFile )
   dbg.print("output: " .. destFile )
   os.execute( kCMarkProgram .. kCMarkParams .. tempFile .. " >> " .. destFile )
   if proj.post then
      local content =  fs.readContent( destFile )
      content = proj.post( config, proj, filename, content)
      if type(content) == "string" and content then
         assert( fs.writeContent( destFile, content) )
      end
   end
end

function md.compositeFooter( config, proj, filename, destFile )
   if proj.footer then
      local content = proj.footer( config, proj, filename )
      if type(content) == "string" then
         assert( fs.writeContent( destFile, content, true ) )
      end
   end
end

function md.convertDos2unix( config, destFile )
   if config.dos2unix and destFile then
      local content = fs.readContent( destFile )
      if content then
         content = content:gsub("(\r\n)", '\n')
         content = content:gsub("(\r)", '')
         fs.writeContent(destFile, content)
      end
   end
end

--
-- site function
--

function site.isArgsValid( config )
   if not config then
      print("Usage: CONFIG_FILE [PROJ_DIR]")
      os.exit(0)
   end
   return true
end

function site.fillProjFiles( config )
   local validProjs = 0
   if config then
      local i = 0
      for _, proj in ipairs(config.projs) do
         if proj.res then
            proj.files = fs.listFiles(config.publish .. '/' .. proj.dir)
         else
            proj.files = fs.listFiles(config.source .. '/' .. proj.dir)
            validProjs = validProjs + #proj.files
         end
      end
   end
   return validProjs > 0
end

function site.loadConfig( path )
   if fs.isDir( path ) then
      dbg.print("invalid config path")
      return nil
   end

   local function _err_handler(msg)
      print("\nPANIC : " .. tostring(msg) .. "\n")
      print(debug.traceback())
   end
   local status, config = xpcall(dofile, _err_handler, path)
   assert(status)
   assert(config)

   assert(type(config) == "table")
   assert(type(config.source) == "string")
   assert(type(config.publish) == "string")
   assert(type(config.projs) == "table")
   assert(#config.projs > 0)
   for _, proj in ipairs(config.projs) do
      assert(type(proj) == "table")
      assert(type(proj.dir) == "string")
      if not proj.res then
         assert((not proj.prepare) or (type(proj.prepare) == "function"))
         assert((not proj.body) or (type(proj.body) == "function"))
         assert((not proj.post) or (type(proj.post) == "function"))
         assert((not proj.header) or (type(proj.header) == "function"))
         assert((not proj.footer) or (type(proj.footer) == "function"))
         assert((not proj.after) or (type(proj.after) == "function"))
      end
   end
   return config
end

function site.processProjects( config )
   if not site.fillProjFiles( config ) then
      return
   end

   -- dbg.print("----- using config -----")
   -- dbg.print( config )
   -- dbg.print("----- ----- ----- -----")

   local to_destname = config.destname or function(f) return f end

   for _, proj in ipairs(config.projs) do

      if not proj.res then

         local inPath = config.source .. "/" .. proj.dir .. "/"
         local outPath = config.publish .. "/" .. proj.dir .. "/"

         dbg.print(string.format("\nproj: %s", proj.dir))
         fs.makeDir( outPath )

         if proj.prepare then
            proj.prepare( config, proj )
         end

         local i = 0
         while true do
            i = i + 1

            if i > #proj.files then
               break
            end

            local filename = proj.files[i]
            local sourceFile = inPath .. filename -- origin source
            local tempFile = config.tmpfile or kTmpFilePath -- modified source
            local destFile = outPath .. to_destname(filename) -- formated output

            md.prepareTempSource( config, proj, filename, sourceFile, tempFile )
            md.compositeHeader( config, proj, filename, destFile )
            md.compositeBody( config, proj, filename, tempFile, destFile )
            md.compositeFooter( config, proj, filename, destFile )
            md.convertDos2unix( config, destFile )
         end -- while

         if proj.after then
            proj.after( config, proj )
         end
      end -- proj.res
   end -- for _, proj
   os.remove(config.tmpfile or kTmpFilePath)
end

function site.main( configFile, basePath )
   if site.isArgsValid( configFile ) then
      local config = site.loadConfig( configFile )
      assert(config)
      if basePath then
         config.source = basePath .. "/" .. config.source
         config.publish = basePath .. "/" .. config.publish
      end
      site.processProjects( config )
   end
end

--
-- Main
--
site.main( argConfigFile, argBasePath )
