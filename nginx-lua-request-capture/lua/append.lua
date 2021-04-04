-- Reset the response's content_length, so that Lua can generate a 
-- body with a different length. 
    ngx.header.content_length = nil

ngx.req.read_body()  -- explicitly read the req body
local data = ngx.req.get_body_data()

    ngx.say("body data:")
    ngx.print(type(data))

 ngx.var.query = data.."&ng_real-ip:"..ngx.var.realip_remote_addr
 ngx.print(ngx.var.query)
 unconcatted = {'"', "client_ip", '": "', ngx.var.realip_remote_addr, '"'}

ngx.say("\n unconcatted data:")
ngx.print(unconcatted)

body = [["name":"stringValue]] .. data .. [["]]
ngx.say("\n New body data:")
ngx.print(body) 

-- Test table 
foo = {}
foo[#foo+1]=unconcatted
ngx.say("\n FOO data:")
ngx.print(foo)
-- convert a Json String to a table data structure in Lua
local json = require('cjson')
local tab = json.decode(data)
data = json.encode(tab)
    ngx.say("\n body data:")
    ngx.print(data)
    ngx.say("\n tab data:")
--    table.insert(tab,"&ng_real-ip:"..ngx.var.realip_remote_addr);
    table.foreachi (tab, ngx.say)

    for k, v in pairs(tab) do
        ngx.print(k, json.encode(v))
    end
    t1 = tab
    t2 = foo
    ngx.say("\n t2 data:")
    ngx.print(t2)
    function tableMerge(t1, t2)
        for k,v in pairs(t2) do
            if type(v) == "table" then
                if type(t1[k] or false) == "table" then
                    tableMerge(t1[k] or {}, t2[k] or {})
                else
                    t1[k] = v
                end
            else
                t1[k] = v
            end
        end
        return t1
    end
    --
    a = tab
    b = foo

    function merge(a, b)
        if type(a) == 'table' and type(b) == 'table' then
            for k,v in pairs(b) do if type(v)=='table' and type(a[k] or false)=='table' then merge(a[k],v) else a[k]=v end end
        end
        return a
    end
    -- merge(tab, foo)
    --table.insert(tab,unconcatted)
  -- Print data key value format
        for k, v in ipairs(tab) do
            ngx.log(ngx.ERR,"headerK = "..k..' value = '..v)
            ngx.say("headerK = "..k..' value = '..v)
        end
       
  -- build up the new JSON string
  local newbody = "{"

   for k,v in pairs(tab) do
     -- add all the params we want to keep
        -- log("adding"..k.." as "..v)
        -- ngx.log(ngx.ERR,"adding  "..k.." as "..v)
        newbody = newbody..'"'..k..'":"'..v..'", '
   

   end
  -- Adding custom value 
   -- unconcatted = {'"', "client_ip", '": "', ngx.var.realip_remote_addr, '"'}
   -- newbody = newbody..{'"', "client_ip", '": "', ngx.var.realip_remote_addr, '"'}
   --newbody = newbody .. '..unconcatted'
   ngx.say("\n newbody data:")
   ngx.print(newbody)
   unconcatted2 = '"', "client_ip", '": "', ngx.var.realip_remote_addr, '"'
  --remove the last trailing comma before closing this off
  newbody = string.sub(newbody, 0, #newbody+1)
 -- newbody = string.sub(newbody, 0, #newbody-1)
  newbody = newbody.."}"
  ngx.say("\n unconcatted2 data:")
  ngx.print(unconcatted2)
  ngx.req.set_body_data(newbody)
  ngx.say("\n newbody data:")
  ngx.print(newbody)


-- Convenience Function
t = tab
local function printTable( t )
 
    local printTable_cache = {}
 
    local function sub_printTable( t, indent )
 
        if ( printTable_cache[tostring(t)] ) then
            ngx.print( indent .. "*" .. tostring(t) )
        else
            printTable_cache[tostring(t)] = true
            if ( type( t ) == "table" ) then
                for pos,val in pairs( t ) do
                    if ( type(val) == "table" ) then
                        ngx.print( indent .. "[" .. pos .. "] => " .. tostring( t ).. " {" )
                        sub_printTable( val, indent .. string.rep( " ", string.len(pos)+8 ) )
                        ngx.print( indent .. string.rep( " ", string.len(pos)+6 ) .. "}" )
                    elseif ( type(val) == "string" ) then
                        ngx.print( indent .. "[" .. pos .. '] => "' .. val .. '"' )
                    else
                        ngx.print( indent .. "[" .. pos .. "] => " .. tostring(val) )
                    end
                end
            else
                ngx.print( indent..tostring(t) )
            end
        end
    end
 
    if ( type(t) == "table" ) then
        ngx.print( tostring(t) .. " {" )
        sub_printTable( t, "  " )
        ngx.print( "}" )
    else
        sub_printTable( t, "  " )
    end
end
ngx.say("\n myTable data:")
local myTable = json.decode(data)
printTable( tab )
-- End print table function
t = { "the", "quick", "brown", "fox" }
table.insert (t, 2, "very") -- new element 2
table.insert (t, "jumped")  -- add to end of table
table.foreachi (t, ngx.say)

string = "Lua Tutorial"

-- replacing strings
newstring = string.gsub(string,"Tutorial","Language")
ngx.say("The new string is "..newstring)

local t1 = {1, 2, 3, 4, 5}
local t2 = {6, 7, 8, 9, 10}

local t3 = {unpack(t1)}
for I = 1,#t2 do
    t3[#t1+I] = t2[I]
end
return t3

