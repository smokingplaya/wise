---@class Wise.Database.Table<T>
---@field name string
---@field database Wise.Database
local table = {}
table.__index = table

RegisterMetaTable("Wise.Database.Table", table)

wise.table = {}

function wise.table.new(name, database)
	return setmetatable({ name = name, database = database }, table)
end

--- Finds
---@async
---@generic T
---@param params Wise.Database.FindOneParams
---@return T | nil
function table:findFirst(params)
  self.database:checkRequirements()

  local query = wise.query.new("select", self.name, params)
  local sql = query:build()

  local result = self.database:execute(sql)

  if (istable(result)) then
    return result[1]
  end

  return result
end

--- Finds
---@async
---@generic T
---@param params Wise.Database.FindManyParams
---@return T[] | nil
function table:findMany(params)
  self.database:checkRequirements()

  local query = wise.query.new("select", self.name, params)
  local sql = query:build()

  local result = self.database:execute(sql)

  if (!istable(result)) then
    return { result }
  end

  return result
end


--- Creates
---@async
---@generic T
---@param params Wise.Database.InsertParams
function table:create(params)
  self.database:checkRequirements()

  local query = wise.query.new("insert", self.name, params)
  local sql = query:build()

  -- todo: add return of new created query
  self.database:execute(sql)
end


--- Updates
---@async
---@generic T
---@param params Wise.Database.UpdateParams
function table:update(params)
  self.database:checkRequirements()

  local query = wise.query.new("update", self.name, params)
  local sql = query:build()

  -- todo: add return of updated query
  self.database:execute(sql)
end


--- Deletes
---@async
---@generic T
---@param params Wise.Database.DeleteParams
function table:delete(params)
  self.database:checkRequirements()

  local query = wise.query.new("delete", self.name, params)
  local sql = query:build()

  -- todo: add return of deleted query
  self.database:execute(sql)
end