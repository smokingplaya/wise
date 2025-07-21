---@alias Wise.Query.Kind "select" | "insert" | "update" | "delete"

---@class Wise.Query
---@field kind Wise.Query.Kind
---@field tableName string
---@field params Wise.Database.Params
local query = {}
query.__index = query

RegisterMetaTable("Wise.Query", query)

---@type table<string, fun(_: string, _: Wise.Database.Params): string>
wise.query = {}
wise.query.queryKinds = {
  select = function(tableName, params)
    local fields = "*"
    if params.select and params.select.fields then
      fields = table.concat(params.select.fields, ", ")
    end

    local whereClause = ""
    if params.where then
      local whereParts = {}
      for key, val in pairs(params.where) do
        table.insert(whereParts, key .. " = " .. SQLStr(val))
      end
      whereClause = " WHERE " .. table.concat(whereParts, " AND ")
    end

    local orderClause = ""
    if params.orderBy then
      local orders = {}
      for field, dir in pairs(params.orderBy) do
        table.insert(orders, field .. " " .. string.upper(dir))
      end
      orderClause = " ORDER BY " .. table.concat(orders, ", ")
    end

    local limitClause = params.limit and (" LIMIT " .. tonumber(params.limit)) or ""
    local offsetClause = params.offset and (" OFFSET " .. tonumber(params.offset)) or ""

    return string.format("SELECT %s FROM %s%s%s%s%s;", fields, tableName, whereClause, orderClause, limitClause, offsetClause)
  end,

  insert = function(tableName, params)
    local keys, values = {}, {}

    for key, value in pairs(params.data or {}) do
      table.insert(keys, key)
      table.insert(values, SQLStr(tostring(value)))
    end

    return string.format("INSERT INTO %s (%s) VALUES (%s);",
      tableName, table.concat(keys, ", "), table.concat(values, ", "))
  end,

  update = function(tableName, params)
    local sets, where = {}, {}

    for key, value in pairs(params.data or {}) do
      table.insert(sets, key .. " = " .. SQLStr(tostring(value)))
    end

    for key, value in pairs(params.where or {}) do
      table.insert(where, key .. " = " .. SQLStr(value))
    end

    return string.format("UPDATE %s SET %s WHERE %s;",
      tableName, table.concat(sets, ", "), table.concat(where, " AND "))
  end,

  delete = function(tableName, params)
    local where = {}

    for key, value in pairs(params.where or {}) do
      table.insert(where, key .. " = " .. SQLStr(value))
    end

    return string.format("DELETE FROM %s WHERE %s;", tableName, table.concat(where, " AND "))
  end
}

---@param kind Wise.Query.Kind
---@param tableName string
---@param params Wise.Database.Params
---@return Wise.Query
--- please fix this shit!!! down
---@diagnostic disable-next-line redundant-parameter
function wise.query.new(kind, tableName, params)
  return setmetatable({ kind = kind, tableName = tableName, params = params }, query)
end

--- Builds object into SQL query
---@return string
function query:build()
  local kindFn = wise.query.queryKinds[self.kind]

  if not kindFn then
    error("unsupported query kind: " .. tostring(self.kind))
  end

  local sql = kindFn(self.tableName, self.params)

  wise.log.debug(sql)

  return sql
end