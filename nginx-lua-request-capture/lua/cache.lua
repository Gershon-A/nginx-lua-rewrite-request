if ngx.req.get_method() == "POST" then
    -- check if request method is POST 
    -- implement your logic 
    ngx.req.read_body()
  -- log the original body so we can compare to the new one later
  local oldbody = ngx.req.get_body_data()
  log(oldbody)
  -- grab the POST parameters as a table
  local params = ngx.req.get_post_args()

  -- build up the new JSON string
  local newbody = "{"

   for k,v in pairs(params) do
     -- add all the params we want to keep
     if k ~= "user_key" then
        log("adding"..k.." as "..v)
        newbody = newbody..'"'..k..'":"'..v..'",'
     else 
        log("not adding user_key")
     end
   end
  --remove the last trailing comma before closing this off
  newbody = string.sub(newbody, 0, #newbody-1)
  newbody = newbody.."}"

  ngx.req.set_body_data(newbody)
  log(newbody)
end
    return