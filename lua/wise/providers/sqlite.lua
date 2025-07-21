local provider = wise.provider.new("sqlite")

function provider:init(_)
  self.isConnected = true
end

function provider:execute(query)
  local result = sql.Query(query)

  if (result == false) then
    return wise.log.err("An error occurred while executing the query: %s", sql.LastError())
  end

  return result
end