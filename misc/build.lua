#!/usr/bin/env lua

-- generate html
os.execute([[lua MarkdownProjectCompositor.lua config.lua ..]])

do
    local build_ti_path = "../publish/pagefind/last_build_time.txt"
    local fp = io.open(build_ti_path, "rb")
    if fp then
        local content = fp:read("*a")
        fp:close()
        if content and content:len() > 0 then
            local ti, td = content:match("(%d+)|(.+)")
            print("-- Check build date")
            print("> time: " .. ti)
            print("> date: " .. td)
            ti = tonumber(ti)
            -- if less than tow month
            local ti_span = os.time() - ti
            if ti_span < 3600 * 24 * 60 then
                print("> only pass " .. tostring(ti_span / (3600 * 24)) .. " days")
                print("> no more than 60 days, exit !")
                os.exit()
            else
                print("> more than 60 days")
            end
        end
    end
    --
    print("-- Update build date")
    fp = io.open(build_ti_path, "wb")
    if not fp then
        print("> failed to write build date, exit !")
        os.exit()
    end
    fp:write(tostring(os.time()) .. "|" .. os.date("%Y-%m-%d_%H:%M:%S"))
    fp:close()
    print("> write success, done.")
    print("> write success, done.")
end

--generate pagefind source
os.execute([[pagefind_extended --bundle-dir ../publish/pagefind --source ../publish --force-language zh --verbose]])
