---@class Wise.Provider.TMysql4: Wise.Provider
local provider = wise.provider.new("tmysql4")

---@param credentials Wise.Database.Credentials
function provider:init(credentials)
  ---@diagnostic disable-next-line undefined-global
  if (!tmysql) then
    if (!util.IsBinaryModuleInstalled("tmysql4")) then
      return wise.log.err("Binary module `tmysql4` is not installed!")
    end

    require("tmysql4")
  end

  ---@diagnostic disable-next-line undefined-global
  local db, err = tmysql.Connect(
    credentials.host,
    credentials.user,
    credentials.pass,
    credentials.dbname,
    credentials.port or 3306,
    0
  )

  if (err) then
    return wise.log.err("Connection to database is failed: %s", tostring(err or "no error"))
  end

  self._connection = db
  self.isConnected = true
end

function provider:execute(query)
  if (!self.isConnected) then
    return wise.log.err("Database connection is inactive")
  end

  local result;
  local co = coroutine.running()

  self._connection:Query(query, function(results)
    local data;
    local hasErr = false
    for _, res in ipairs(results) do
      if (res.error) then
        wise.log.err("An error occurred while executing the query: %s", res.error)
        hasErr = true
        break
      end

      data = res.data
    end

    if (!hasErr) then
      result = data
    end

    coroutine.resume(co)
  end)

  coroutine.yield()

  return result
end