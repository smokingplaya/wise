---@class Wise.Provider.MySQLOO: Wise.Provider
local provider = wise.provider.new("mysqloo")

---@param credentials Wise.Database.Credentials
function provider:init(credentials)
  ---@diagnostic disable-next-line undefined-global
  if (!mysqloo) then
    if (!util.IsBinaryModuleInstalled("mysqloo")) then
      return wise.log.err("Binary module `mysqloo` is not installed!")
    end

    require("mysqloo")
  end

  ---@diagnostic disable-next-line undefined-field
  self._connection = mysqloo.connect(
    credentials.host,
    credentials.user,
    credentials.pass,
    credentials.dbname,
    credentials.port or 3306
  )

  self._connection.onConnected = function()
    self.isConnected = true
  end

  self._connection.onConnectionFailed = function(_, e)
    self.isConnected = false
    wise.log.err("Connection to database is failed: %s", tostring(e or "no error"))
  end

  self._connection.onDisconnected = function()
    self.isConnected = false
  end

  self._connection:connect()
end

function provider:execute(query)
  if (!self.isConnected) then
    return wise.log.err("Database connection is inactive")
  end

  local result;
  local co = coroutine.running()

  local q = self._connection:query(query)
  q.onSuccess = function(_, data)
    result = data
    coroutine.resume(co)
  end

  q.onError = function(err)
    wise.log.err("An error occurred while executing the query: %s", err)
    coroutine.resume(co)
  end

  q:start()

  coroutine.yield()

  return result
end