wise = {
  meta = {
    author = "smokingplaya",
    version = "1.0.0",
    git = "https://github.com/smokingplaya/wise"
  }
}

---@non-minified
include("wise/log.lua")
include("wise/provider.lua")
include("wise/database.lua")
include("wise/query.lua")
include("wise/table.lua")
---@type string[]
local providers = file.Find("wise/providers/*.lua", "LUA")
for _, provider in ipairs(providers) do
  wise.log.debug("Add provider `" .. provider:StripExtension() .. "`")
  include("wise/providers/" .. provider)
end

---@param provider string
---@param credentials Wise.Database.Credentials
---@return Wise.Database
function wise.new(provider, credentials)
  return wise.database.new(provider, credentials)
end