--
-- by lalawue, 2019/06/02
--

local envReadAll = (_VERSION:sub(5) < "5.3") and "*a" or "a"

local type = type
local print = print
local assert = assert
local tonumber = tonumber
local pairs = pairs
local ipairs = ipairs
local ioOpen = io.open
local strFormat = string.format
local tableSort = table.sort
local tableRemove = table.remove
local tableConcat = table.concat
local mathMin = math.min

--
-- user defined function
--
local user = {
   projNames = nil,              -- table [projName][FileName]
   blogYearMonthFiles = nil,     -- blog sorted YYYY-MM files
   blogArchiveLinkContent = nil, -- blog archive links content
   blogTempContent = {},         -- category dynamic file content
}

function user.filename(f)
   if f:find("%.md") then
      return f:sub(1, f:len() - 3)
   else
      return f
   end
end

function user.writeFile( path, content )
   local f = ioOpen(path, "wb")
   if f then
      f:write( content )
      f:close()
   end
end

function user.readFile( path )
   local f = ioOpen(path, "rb")
   if f then
      local content = f:read( envReadAll )
      f:close(f)
      return content
   else
      return ""
   end
end

function user.findDivClass( content, className, index )
   assert(type(content) == "string")
   assert(type(className) == "string")
   if content:len() > 0 and className:len() > 0 then
      local match = strFormat("<div%%s+class=\"%s\".-div>", className)
      return content:find(match, index)
   end
end

function user.mdGetTitle( config, proj, filename )
   -- '#title title', for <title> or <h1> tag
   local path = config.source .. "/" .. proj.dir .. "/" .. filename .. ".md"
   local content = config.user.readFile( path )
   content = content:len() > 1 and content or config.user.blogTempContent[filename]
   if content then
      local name = content:match("#title%s+([^\n]+)")
      if name then
         return name
      end
   end
   return filename
end

function user.mdGenContentDesc( config, proj, content )
   -- '#contents depth-number'
   local s, e = content:find("\n#contents%s*")
   if not s then
      return content
   end
   local depth = content:match("\n#contents%s*(%d*)")
   if not depth then
      return content
   end
   local pre = content:sub(1, s - 1)
   local sub = content:sub(e + 1 + depth:len(), content:len())
   local lastStack = {}
   local lastNum = 0
   local firstNum = 0
   local index = 1
   local desc = ""
   sub = sub:gsub("\n(#+%s+[^%c]+)", function( mark )
                     local num = mark:find("%s")
                     if lastNum > 0 and num > depth then
                        return mark
                     end
                     if lastNum <= 0 then
                        depth = num + tonumber(depth) - 1
                        lastNum = num
                        desc = "<dl class=\"contents\">"
                        lastStack[#lastStack + 1] = "</dl>"
                     elseif num > lastNum then
                        lastNum = num
                        desc = desc .. "<dd><dl class=\"contents\">"
                        lastStack[#lastStack + 1] = "</dl></dd>"
                     elseif num < lastNum then
                        while lastNum > num and #lastStack > 0 do
                           lastNum = lastNum - 1
                           desc = desc .. lastStack[#lastStack]
                           tableRemove(lastStack)
                        end
                     end
                     local title = mark:match("#+%s+([^%c]+)")
                     desc = desc .. strFormat("<dt class=\"contents\"><a href=\"#sec-%d\">%s</a></dt>",
                                                  index, title)
                     local ret = strFormat("<a id=\"sec-%d\"></a>\n%s", index, mark)
                     index = index + 1
                     return ret
   end)
   while #lastStack > 0 do
      desc = desc .. lastStack[#lastStack]
      tableRemove(lastStack)
   end
   return pre .. desc .. "\n" .. sub
end

function user.mdReplaceTag( config, proj, content )
   -- replace [Desc](#footnote) to html tag
   local tags = {}
   content = content:gsub("(%[[^%]]-%]%(#[^%)]-%))", function( mark )
                             local name, fntag = mark:match("%[(.-)%]%(%#([^%)]-)%)")
                             if fntag and not tags[fntag] then
                                tags[fntag] = fntag
                                return strFormat("<sup><a href=\"#%s\">%s</a></sup>", fntag, name)
                             else
                                return strFormat("<sup>&lsqb;<a id=\"%s\">%s</a>&rsqb;</sup>", fntag, name)
                             end
   end)
   local projNames = config.user.projNames
   --
   -- replace [Desc](WikiTag) as really links, WikiTag may contain
   -- '#' as project/source/anchor seperator, for example:
   --
   -- 1. [Desc](ProjectSourceName)
   -- 2. [Desc](OtherProject#SourceName)
   -- 3. [Desc](OtherProject#SourceName#Anchor)
   return content:gsub("(%[[^%]]+%]%([^%)]+%))", function( mark )
                          local name, tag = mark:match("%[([^%]]+)%]%(([^%)]+)%)")
                          local ptag, ftag, atag = tag:match("([^#]+)#([^#]+)#([^%c]+)")
                          if ptag and ftag and atag then
                             return strFormat("[%s](../%s/%s.html#%s)", name, ptag, ftag, atag)
                          end
                          local ptag, ftag = tag:match("([^#]+)#([^%c#]+)")
                          if ptag and ftag then
                             if projNames[ptag] and projNames[ptag][ftag] then
                                ftag = projNames[ptag][ftag]
                                return strFormat("[%s](../%s/%s)", name, ptag, ftag)
                             end
                          end
                          local projFile = projNames[proj.dir][tag]
                          if projFile then
                             return strFormat("[%s](%s)", name, projFile)
                          end
                          return strFormat("[%s](%s)", name, tag)
   end)
end

function user.mdGenAnchor( config, proj, content )
   return content:gsub("\n#([^#%s%c]+)", function(mark)
                             return strFormat("<a id=\"%s\"></a>\n", mark)
   end)
end

function user.blogGenDateTime( config, proj, content )
   local s, e = content:find("\n#date%s*")
   if not s then
      return content
   end
   content = content:gsub("\n(#date%s*[^%c]*)", function(mark)
                             local date = mark:match("#date%s*([^%c]*)")
                             return strFormat("\n<div class=\"date\">%s</div>", date)
   end)
   return content
end

function user.blogGenCategory( config, proj, filename, content )
   local s, e = content:find("\n#category%s*")
   if not s then
      return content
   end
      -- '#p[0-9]+' is fixed title anchor for every entry
      local anchorName = content:gmatch("\n#(p%d+)")
      local categoryLink = function(mark)
      local name = mark:match("#category%s*(%a*)")
      local clink = strFormat("<a href=\"Category%s.html\">Category%s</a>", name, name)
      local plink = strFormat("<a href=\"%s.html#%s\">Permalink</a>", filename, anchorName())
      local dlink = '<a href="https://github.com/lalawue/homepage/discussions/categories/blog" target="_blank">Discussion</a>'
      return strFormat("\n<div class=\"category\">%s / %s / %s</div>\n", clink, plink, dlink)
   end
   content = content:gsub("\n(#category%s*[^%c]*)", categoryLink)
   return content
end

function user.blogSortFiles( config, proj )
   if config.user.blogYearMonthFiles then
      return
   end
   local fileList = {}
   local orgFileList = {}
   for _, filename in ipairs(proj.files) do
      if filename:match("(%d+)%-(%d+)") then
         local f = user.filename(filename)
         orgFileList[f] = filename
         fileList[#fileList + 1] = f
      end
   end
   tableSort(fileList, function(s1, s2)
                  local y1, m1 = s1:match("(%d+)%-(%d+)")
                  local y2, m2 = s2:match("(%d+)%-(%d+)")
                  if tonumber(y1) == tonumber(y2) then
                     return tonumber(m1) > tonumber(m2)
                  else
                     return tonumber(y1) > tonumber(y2)
                  end
   end)
   for i=1, #fileList, 1 do
      proj.files[i] = orgFileList[fileList[i]]
   end
   config.user.blogYearMonthFiles = fileList
end

function user.blogGenSideBarJS( config, proj )
   local nameList = {
      [1]="January", [2]="February", [3]="March", [4]="April",
      [5]="May", [6]="June", [7]="July", [8]="August",
      [9]="September", [10]="October", [11]="November", [12]="December"
   }
   local tbl = {}
   for _, filename in ipairs(config.user.blogYearMonthFiles) do
      local year, month = filename:match("(%d+)%-(%d+)")
      if year and month then
         tbl[#tbl+1] = strFormat("<li><a href=\"%s.html\">%s %s</a></li>",
                                     filename, nameList[tonumber(month)],
                                     year)
      end
   end
   local part_archives = '<div class="archive_links"><ul>' .. tableConcat(tbl) .. '</ul></div>'
   -- generate sidebar
   local part_top = [[<p class="header">Navi</p>
   <ul>
     <li><a href="../index.html">Home</a></li>
     <li><a href="index.html">Front</a></li>
     <li><a href="../scratch/ThisSite.html">This Site</a></li>
     <li><a href="../live/AboutMe.html">About Me</a></li>
   </ul>
   <p class="header">Search</p><!-- Bing Search -->
   <form>
      <input id="searchtext" type="text" />
      <input type="text" class="form-control" style="display:none" />
      <a style="text-decoration: none;" href="javascript:"onclick="onPageSearch();">🔍</a>
   </form>
   <p class="header">Categories</p>
   <ul>
     <li><a href="CategoryLinux.html">GNU/Linux</a></li>
     <li><a href="CategoryProgramming.html">Programming</a></li>
     <li><a href="CategoryLife.html">Life &#38; essay</a></li>
     <li><a href="CategoryStatistics.html">Statistics</a></li>
     <li><a href="CategoryReading.html">Reading</a></li>
     <li><a href="CategoryThisSite.html">This Site</a></li>
     <li><a href="CategoryMisc.html">Misc</a></li>
   </ul>
   <p class="header">Links</p>
   <ul>
     <li><a href="http://blog.csdn.net/g9yuayon/">G9</a></li>
     <li><a href="http://www.ruanyifeng.com/blog/">阮一峰的网络日志</a></li>
     <li><a href="http://blog.codingnow.com/">CloudWu</a></li>
     <li><a href="https://github.com/lalawue/">My GitHub</a></li>
     <li><a href="https://map.baidu.com/search/%E7%8E%89%E6%9E%97%E5%B8%82/@12263703.582905954,2572316.510483823,13.94z/maptype%3DB_EARTH_MAP">Yulin City</a></li>
   </ul>
   <p class="header">Archives</p>]]
   config.user.writeFile(config.publish .. "/js/blog_sidebar.js",
      [[var onPageSearch = function() {
         var value = document.getElementById("searchtext").value
         window.open('https://cn.bing.com/search?q=site:suchang.net+'+value,'_blank');
      }
      ]] ..
      'document.getElementById("sidebar").innerHTML = `' ..
      part_top ..
      part_archives ..
      '`')
end

function user.blogCollectCategory( config, proj, filename, content )
   local s = filename:find("%d*%-%d*")
   if not s then
      return
   end
   local categoryTable = {}
   local anchorName = content:gmatch("\n#(p%d+)")
   local dateName = content:gmatch("\n#date%s+([^%c]+)")
   local titleName = content:gmatch("\n##%s+([^%c]+)")
   local categoryName = content:gmatch("\n#category%s*(%a*)")

   while true do
      local aname = anchorName()
      local dname = dateName()
      local tname = titleName()
      local cname = categoryName()
      if cname and tname and dname and aname then
         local tbl = categoryTable[cname]
         if not tbl then
            tbl = {}
            categoryTable[cname] = tbl
            local year, month = filename:match("(%d+)%-(%d+)")
            tbl[#tbl + 1] = strFormat("\n## %s.%s", year, month)
         end
         tbl[#tbl + 1] = strFormat("- %s [%s](%s%s#%s)",
                                       dname, tname, filename, ".html", aname)
      else
         break
      end
   end

   for cname, tbl in pairs(categoryTable) do
      local name = "Category" .. cname
      local content = config.user.blogTempContent[name]
      if not content then
         content = strFormat("\n#title Category %s\n", cname)
         proj.files[#proj.files + 1] = name
      end
      content = content .. tableConcat(tbl, "\n")
      config.user.blogTempContent[name] = content
   end
end

function user.blogGenWelcomePage( config, proj )
   local blogYearMonthFiles = config.user.blogYearMonthFiles
   local count = mathMin(#blogYearMonthFiles, 11)
   if count <= 0 then
      return
   end
   local entries = {}
   local publishPath = config.publish .. "/" .. proj.dir .. "/"
   -- generate welcome page
   for i=1, count, 1 do
      local content = config.user.readFile( publishPath .. blogYearMonthFiles[i] .. ".html" )

      local as, ae, cs, ce = 0, 0, 0, 0
      repeat
         local ds, de = config.user.findDivClass( content, "date", ce + 1 )
         cs, ce = config.user.findDivClass( content, "category", ce + 1 )
         if as and ae and cs and ce then
            entries[#entries + 1] = content:sub(ds, ce + 1)
         else
            break
         end
      until #entries >= count

      if #entries >= count then
         break
      end
   end
   if #entries > 0 then
      local header = config.user.blogHeader( config, proj, "Welcome" )
      local title = "<h1>Sucha's Blog ~ Welcome</h1>"
      local body = tableConcat(entries, "\n")
      local footer = config.user.blogFooter( config, proj, "" )
      local indexPath = publishPath ..  "index.html"
      config.user.writeFile( indexPath, header .. title .. body .. footer )
      print(strFormat("output: %s", indexPath))
   end
end

function user.sitePrepare( config, proj )
   -- generage projNames[ProjDir][SourceName] = [Resouce | Source.html]
   local projNames = config.user.projNames
   if not projNames then
      projNames = {}
      for _, proj in ipairs(config.projs) do
         projNames[proj.dir] = {}
         for _, f in ipairs(proj.files) do
            if proj.res then
               projNames[proj.dir][f] = f
            else
               f = user.filename(f)
               projNames[proj.dir][f] = f .. ".html"
            end
         end
      end
   end
   config.user.projNames = projNames
end

function user.siteBody( config, proj, filename, content )
   if content then
      content = content:gsub("#title ", "# Sucha's Homepage ~ ")
      content = config.user.mdGenContentDesc( config, proj, content )
      content = config.user.mdReplaceTag( config, proj, content )
      content = config.user.mdGenAnchor( config, proj, content )
      return content
   end
end

function user.siteHeader( config, proj, filename )
   filename = user.filename(filename)
   local part1 = [[<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>Sucha's Homepage - ]]
   local part2 = config.user.mdGetTitle( config, proj, filename )
   local part3 = [[</title>
    <meta name="author" content="Sucha" />
    <meta name="keywords" content="suchang, programming, Linux, Lua" />
    <meta name="description" content="Sucha's homepage and blog" />
    <link rel="shortcut icon" href="../images/ico.png" />
    <link rel="stylesheet" type="text/css" href="../styles/site.css" />
    <link rel="stylesheet" type="text/css" href="../styles/prism.min.css" />
  </head>
  <body>
    <div id="body">
      <div id="text">
	<!-- Page published by cmark-gfm begins here -->]]
      return part1 .. part2 .. part3
end

function user.siteFooter( config, proj, filename )
   return [[<!-- Page published by cmark-gfm ends here -->
      <div id="foot">
	2004-<script type="text/javascript">var d = new
	Date();document.write(d.getFullYear())</script> &copy;
	Sucha. Powered by MarkdownProjectCompositor.
      </div><!-- foot -->
      </div><!-- text -->
      <div id="sidebar">
      </div><!-- sidebar -->
      <script type="text/javascript" src="../js/site_sidebar.js" async="async"></script>
      <script type="text/javascript" src="../js/prism.min.js" async="async"></script>
    </div><!-- body -->
  </body>
</html>]]
end

function user.blogPrepare( config, proj )
   config.user.sitePrepare( config, proj )
   config.user.blogSortFiles( config, proj )
   config.user.blogGenSideBarJS( config, proj )
end

function user.blogBody( config, proj, filename, content )
   filename = user.filename(filename)
   content = content or config.user.blogTempContent[filename]
   if content then
      config.user.blogCollectCategory( config, proj, filename, content )
      content = content:gsub("#title ", "# Sucha's Blog ~ ")
      content = config.user.blogGenDateTime( config, proj, content )
      content = config.user.blogGenCategory( config, proj, filename, content )
      content = config.user.mdReplaceTag( config, proj, content )
      content = config.user.mdGenAnchor( config, proj, content )
      return content
   end
end

function user.blogHeader( config, proj, filename )
   filename = user.filename(filename)
   local part1 = [[<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>Sucha's Blog - ]]
   local part2 = config.user.mdGetTitle( config, proj, filename )
   local part3 = [[</title>
    <meta name="generator" content="MarkdownProjectCompositor.lua" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="author" content="Sucha" />
    <meta name="keywords" content="suchang, programming, Linux, Lua" />
    <meta name="description" content="Sucha's blog" />
    <link rev="made" href="mailto:suchaaa@gmail.com" />
    <link rel="shortcut icon" href="../images/ico.png" />
    <link rel="stylesheet" type="text/css" href="../styles/blog.css" />
    <link rel="stylesheet" type="text/css" href="../styles/prism.min.css" />
  </head>
  <body>
    <div id="body">
      <div id="text">
	   <!-- Page published by cmark-gfm begins here -->]]
   return part1 .. part2 .. part3
end

function user.blogFooter( config, proj, filename )
   local content = [[<!-- Page published by cmark-gfm ends here -->
  <div id="foot">2004-<script type="text/javascript">var d = new
	Date();document.write(d.getFullYear())</script> &copy;
	Sucha. Powered by MarkdownProjectCompositor.
  </div>
  </div><!-- text -->
  <div id="sidebar">
  </div><!-- sidebar -->
  <script type="text/javascript" src="../js/blog_sidebar.js" async="async"></script>
  <script type="text/javascript" src="../js/prism.min.js" async="async"></script>
  </div> <!-- body -->
</body>
</html>]]
   return content
end

function user.blogAfter( config, proj )
   config.user.blogGenWelcomePage( config, proj )
end

--
-- config for MarkdownProjectCompositor
--
local config = {
   source = "sources",
   publish = "publish",
   program = "cmark-gfm",
   params = " -t html --unsafe --github-pre-lang ",
   tmpfile = nil,
   dos2unix = true,
   destname = function(f)
      return user.filename(f) .. ".html"
   end,
   projs = {},
   user = user,
}

-- define projects
config.projs = {
   {
      res = true,               -- resouces dir, no build
      dir = "images",           -- dir under publish path
   },
   {
      res = true,
      dir = "doc",
      files = {},              -- proj source filled by compositor
   },
   {
      res = true,
      dir = "code",
      files = {},
   },
   {
      dir = "scratch",
      files = {},
      prepare = user.sitePrepare,
      body = user.siteBody,
      header = user.siteHeader,
      footer = user.siteFooter,
   },
   {
      dir = "muse",
      files = {},
      prepare = user.sitePrepare,
      body = user.siteBody,
      header = user.siteHeader,
      footer = user.siteFooter,
   },
   {
      dir = "live",
      files = {},
      prepare = user.sitePrepare,
      body = user.siteBody,
      header = user.siteHeader,
      footer = user.siteFooter,
   },
   {
      dir = "slack",
      files = {},
      prepare = user.sitePrepare,
      body = user.siteBody,
      header = user.siteHeader,
      footer = user.siteFooter,
   },
   {
      dir = "cs",
      files = {},
      prepare = user.sitePrepare,
      body = user.siteBody,
      header = user.siteHeader,
      footer = user.siteFooter,
   },
   {
      dir = "blog",
      files = {},
      prepare = user.blogPrepare,
      body = user.blogBody,
      header = user.blogHeader,
      footer = user.blogFooter,
      after = user.blogAfter,
   }
}

-- return this table as config
return config
