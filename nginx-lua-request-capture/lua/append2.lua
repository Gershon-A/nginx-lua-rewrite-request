local json = require('cjson')

ngx.req.read_body()  -- explicitly read the req body
local data = ngx.req.get_body_data()

    ngx.say("\n body data type:")
    ngx.print(type(data))
-- Construct data tables
    -- Body/incoming request data
    local tableWithData = json.decode(data) 
    -- Data to be appended to body table
    local tableToAppend = { 
        client_ip = ngx.var.realip_remote_addr
    }

-- Merge 2 tables
    t1 = tableWithData
    t2 = tableToAppend
    function tableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
                ngx.say("key_tableMerge = "..t1[k]..' value_tableMerge = '..t1[v])
                ngx.say("key_tableMerge = "..t2[k]..' value_tableMerge = '..t2[v])
            else
                t1[k] = v
                ngx.say("key_y = "..t1[k]..' value_y = '..v)
            end
        else
            t1[k] = v
            ngx.say("key1 = "..t1[k]..' value1 = '..v)
        -- t2[k] = v2
        -- ngx.say("key2 = "..t2[k]..' value2 = '..v2)
        end
    end

    end
    tableMerge(t1, t2)    

-- To able print results we need to encode
local tableWithData = json.encode (tableWithData)
local tableToAppend = json.encode (tableToAppend)
ngx.say("\n tableToAppend:")
ngx.print(tableToAppend)
ngx.say("\n tableWithData:")

ngx.print(tableWithData)
ngx.say("\n ------------------ \n")
-- Set new body
ngx.req.set_body_data(tableWithData)
local tableWithData = ngx.req.set_body_data(tableWithData)
-- Test if new body set correctly
    -- ngx.req.read_body()  -- explicitly read the req body
    -- local data1 = ngx.req.get_body_data()
    -- ngx.say("\n body1 data :")
    --ngx.print(data1)