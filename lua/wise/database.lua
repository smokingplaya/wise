---@class Wise.Database
---@field credentials? Wise.Database.Credentials
---@field provider? Wise.Provider
---@field tables table<string, Wise.Database.Table>
local db = {}
db.__index = db

RegisterMetaTable("Wise.Database", db)

---@class Wise.Database.Credentials
---@field host string
---@field user string
---@field pass string
---@field dbname string
---@field port? number

---@alias Wise.Database.Params.SafeTypes number | string | boolean

---@class Wise.Database.Where
---@field [string] Wise.Database.Params.SafeTypes

---@class Wise.Database.Select
---@field fields? string[]  -- поля, которые нужно выбрать

---@class Wise.Database.OrderBy
---@field [string] "asc" | "desc"

---@class Wise.Database.FindOneParams
---@field where Wise.Database.Where
---@field select? Wise.Database.Select
---@field orderBy? Wise.Database.OrderBy

---@class Wise.Database.FindManyParams : Wise.Database.FindOneParams
---@field limit? number
---@field offset? number

---@class Wise.Database.InsertParams
---@field data table<string, Wise.Database.Params.SafeTypes>

---@class Wise.Database.UpdateParams
---@field where Wise.Database.Where
---@field data table<string, Wise.Database.Params.SafeTypes>

---@class Wise.Database.DeleteParams
---@field where Wise.Database.Where

---@alias Wise.Database.Params Wise.Database.FindOneParams | Wise.Database.FindManyParams | Wise.Database.InsertParams | Wise.Database.UpdateParams | Wise.Database.DeleteParams

function db:checkRequirements()
  if (!coroutine.running()) then
    error("calling async method not within coroutine!")
  end

  if (!self.provider) then
    error("no database provider provided!")
  end
end

---@param name string
function db:registerTable(name)
  local table = wise.table.new(name, self)

  self.tables[name] = table

  return table
end

--- Executes SQL query on the database
---@async
---@generic T
---@param query string
---@return T
function db:execute(query)
  self:checkRequirements()

  return self.provider:execute(query)
end

wise.database = {}

---@private
---@param provider string
---@param credentials Wise.Database.Credentials
---@return Wise.Database
function wise.database.new(provider, credentials)
  local prov = wise.provider:newInstance(provider)
  prov:init(credentials)

  return setmetatable({
    credentials = credentials,
    provider = prov,
    tables = {}
  }, db)
end