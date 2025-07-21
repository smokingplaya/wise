---@class Wise.Provider
---@field name string
---@field isConnected boolean
---@field init fun(self, _: Wise.Database.Credentials)
---@field execute fun(self, query): any[] | any | nil
local provider = {}
provider.__index = provider

RegisterMetaTable("Wise.Provider", provider)

wise.provider = {
  ---@private
  ---@type table<string, Wise.Provider>
  storage = {},

  ---@param name string
  ---@param subclass Wise.Provider
  add = function(self, name, subclass)
    RegisterMetaTable("Wise.Provider." .. name, subclass)
    self.storage[name] = subclass
  end,

  ---@param name string
  ---@return Wise.Provider | nil
  get = function(self, name)
    return self.storage[name]
  end,

  newInstance = function(self, name)
    local provider = self:get(name)

    if (!provider) then
      error("no provider `" .. tostring(name) .. "` found!")
    end

    return setmetatable({ name = name, isConnected = false }, provider)
  end,

  ---@param name string
  ---@return Wise.Provider
  new = function(name)
    local existing = wise.provider:get(name)

    if existing then
      return existing
    end

    local subclass = setmetatable({}, { __index = provider })
    subclass.__index = subclass

    wise.provider:add(name, subclass)

    return subclass
  end,
}