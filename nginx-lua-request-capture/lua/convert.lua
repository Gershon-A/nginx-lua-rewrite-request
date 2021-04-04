--package.path = package.path .. ";json.lua"

-- Reset the response's content_length, so that Lua can generate a 
-- body with a different length. 
ngx.header.content_length = nil
 --print table lua
 function print_table(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    ngx.print(output_str)
end
-- end function
ngx.req.read_body()  -- explicitly read the req body
local data = ngx.req.get_body_data()

    ngx.say("\n body data type:")
    ngx.print(type(data))

-- Convert JSON String to Lua Table
ngx.say("\n Convert JSON String to Lua Table? \n")
local json = require('cjson')

local t = { 
    ["name1"] = "value1",
    ["name2"] = { 1, false, true, 23.54, "a \021 string" },
    name3 = json.null
}

local encode = json.encode (t)
ngx.print (encode)  --> {"name1":"value1","name3":null,"name2":[1,false,true,23.54,"a \u0015 string"]}

local decode = json.decode( encode )

ngx.say("\n --------------------- \n")
body = [[{"name":"stringValue]] .. encode .. [["}]]
ngx.print(body)
--

-- Test table 
unconcatted = {'"', "client_ip", '": "', ngx.var.realip_remote_addr, '"'}
foo = {}
foo[#foo+1]=unconcatted
ngx.say("\n FOO data:")
ngx.print(foo)
ngx.say("\n FOO data type:")
ngx.print(type(foo))

-- body =  encode ..unconcatted
ngx.say("\n New body data:")
ngx.print(body) 
ngx.say("\n --------------------- \n")
unconcatted2 = {"client_ip = ",  ngx.var.realip_remote_addr}
ngx.say("\n unconcatted2:\n")
ngx.print(unconcatted2)
ngx.say("\n --------------------- \n")



ngx.req.read_body()  -- explicitly read the req body
local data = ngx.req.get_body_data()
ngx.say("\n body data:")
ngx.print(data)
-- convert a Json String to a table data structure in Lua
local json = require('cjson')
local tab = json.encode(data)
local tab_decode = json.decode(data)

--ngx.print (tab)  --> "{\r\n   \"level\":\"INFO\",\r\n   \"source\":\"Gershon\",\r\n   \"message\":\"Received response 404\",\r\n   \"email\":\"vitaly@testproject.io\",\r\n   \"client_secret\":\"secret\",\r\n   \"user_key\":\"my_key\"\r\n}"
ngx.say("\n -------serializedJSON-------------- \n")
local serializedJSON = json.encode( data )
ngx.print( serializedJSON )
ngx.say("\n ---------newHeroes------------ \n")
local newHeroes = json.decode( serializedJSON )
ngx.print( newHeroes )
ngx.say("\n ---------json_as_string------------ \n")
local json_as_string = json.encode(data)
ngx.print( json_as_string )

local tab_decode = json.decode(data)
local request_data = ""
for k, v in pairs(tab_decode) do
    local rowtext = ""
    rowtext = string.format("[%s:%s]\n", k, v)
    request_headers_all = data .. rowtext

  end
  ngx.say("\n ---------request_headers_all------------ \n")
  ngx.print( request_headers_all )
--local decode = json.decode( table )
-- t2 = {foo = "bar", [123] = 456, unconcatted2}
-- t2 = {foo = "bar", unconcatted2}
-- for key,value in pairs(t2) do ngx.print(key,value) end
--table.insert(tab_decode, "test")
-- newHeroes[#newHeroes+1] = 123
-- unconcatted2 = {"client_ip = ",  ngx.var.realip_remote_addr}
tab_decode[#tab_decode+1] = 123
table.insert(tab_decode, string.format("\"%s\":%s", "client_ip", ngx.var.realip_remote_addr))
-- Differnet format table
table.insert(tab_decode, string.format("\"%s\":%s", "key", ngx.var.realip_remote_addr))
-- get simple json string
tab_decode = "{" .. table.concat(tab_decode, ",") .. "}"
--print(string.format("%q", str)) --> "f\"o\"o"
local encode = json.encode (tab_decode)
ngx.say("\n -----Print encode---------------- \n")
--ngx.print (encode)  --> {"name1":"value1","name3":null,"name2":[1,false,true,23.54,"a \u0015 string"]}
ngx.print (encode)
ngx.say("\n -----Test key value---------------- \n")


ngx.print (data)
local tableWithData = json.decode(data)
ngx.say("\n --------tableWithData---------- \n")
print_table(tableWithData)
ngx.say("\n --------End tableWithData---------- \n")
--result = unconcatted2
local result
-- Constrauct new table

local json = require('cjson')

local table_2 = { 
    client_ip = "12.12.34.34"
}

local table_2 = json.encode (table_2)

--table_2 = "{" .. table.concat(table_2, "") .. "}"
--table.insert(table_2 , string.format("\"%s\":%s", "key", ngx.var.realip_remote_addr))
--table_2[#table_2+1]=unconcatted
ngx.say("\n table_2 data:")
ngx.print(table_2)
ngx.say("\n ------------------ \n")
--result = {client_ip="172.21.0.1"}
--local result = json.decode(result)
local table_2 = json.decode(table_2)
ngx.say("\n --------table_2---------- \n")
print_table(table_2)
ngx.say("\n --------End table_2---------- \n")
-- New table
t1 = tableWithData
t2 = table_2
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
ngx.say(tableMerge(t1, t2))
-- End table
for key, value in pairs(tableWithData) do
    -- prepare json key-value pairs and save them in separate table
    --table.insert(table_2, string.format("\"%s\":%s", key, value))
    --table.insert(table_2, string.format("\"%s\":%s", tableWithData[key], value))
    -- ngx.say("key = "..key..' value = '..value)
    ngx.say("tableWithDatakey = "..tableWithData[key]..' value = '..value)
end

for key, value in pairs(table_2) do
    -- prepare json key-value pairs and save them in separate table
    --table.insert(result, string.format("\"%s\":%s", key, value))
    ngx.say("table_2_key = "..table_2[key]..' value = '..value)
end
--table.insert(tableWithData, string.format("\"%s\":%s", "key", ngx.var.realip_remote_addr))
-- get simple json string
--tableWithData = "{" .. table.concat(table_2, ",") .. "}"
local tableWithData = json.encode (tableWithData)
local table_2 = json.encode (table_2)
ngx.say("\n table_2:")
ngx.print(table_2)
ngx.say("\n tableWithData:")

ngx.print(tableWithData)
ngx.say("\n ------------------ \n")

-- Merge test results
t1 = tableWithData
t2 = table_2
local t1 = json.decode (t1)
local t2 = json.decode (t2)
ngx.say("\n -------Merge test----------- \n")
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
    local t1 = json.encode (t1)
    ngx.print(t1)
    --return t1
end
--local t1 = json.encode (t1)
--tableMerge(t1)

--ngx.print(merge(tableWithData, table_2))


ngx.say("\n ---------Convenience Function------------ \n")
-- Convenience Function
t = tab
local function printTable1( t )
 
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
printTable1( tab )
printTable1( table_2 )
local table_2 = json.decode (table_2)
print_table(table_2)
--ngx.print ( "tab = " .. printTable( myTable ) )
-- End print table function

-- Recursive get table element
local x = {tableWithData, table_2}
ngx.say("\n x data:")
local x = json.encode(x)
--ngx.print(x)

local function dump (  value , call_indent)

    if not call_indent then 
      call_indent = ""
    end
  
    local indent = call_indent .. "  "
  
    local output = ""
  
    if type(value) == "table" then
        output = output .. "{"
        local first = true
        for inner_key, inner_value in pairs ( value ) do
          if not first then 
            output = output .. ", "
          else
            first = false
          end
          output = output .. "\n" .. indent
          output = output  .. inner_key .. " = " .. dump ( inner_value, indent ) 
        end
        output = output ..  "\n" .. call_indent .. "}"
  
    elseif type (value) == "userdata" then
      output = "userdata"
    else 
      output =  value
    end
    return output 
  end
  
  ngx.print ( "x = " .. dump(x) )
  ngx.print ( "table_2 = " .. dump(table_2) )

  

 --ngx.print(#people)


ngx.say("\n ---------myTable------------ \n")
print_table(myTable)
--local table_2 = json.encode(table_2)
--print_table(table_2)
--ngx.print ( "people2 = " .. print_table(people) )

