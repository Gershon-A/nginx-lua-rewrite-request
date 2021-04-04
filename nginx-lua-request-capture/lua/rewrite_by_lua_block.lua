local json = require('cjson')
ngx.req.read_body()  -- explicitly read the req body
local data = ngx.req.get_body_data()

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
             else
                 t1[k] = v
             end
         else
             t1[k] = v
         end
     end
     end
     tableMerge(t1, t2) 
 -- End merge
-- To able print results we need to encode
local tableWithData = json.encode (tableWithData)
local tableToAppend = json.encode (tableToAppend)
-- Set new body
ngx.req.set_body_data(tableWithData)
