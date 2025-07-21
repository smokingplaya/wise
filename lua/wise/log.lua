---@alias Wise.LogLevel "debug" | "info" | "warn" | "err"

wise.log = wise.log or {
  _convar = CreateConVar("wise_log", "info", {FCVAR_PROTECTED, FCVAR_ARCHIVE})
}

local levels = {
  err = 1,
  warn = 2,
  info = 3,
  debug = 4
}

local logColors = {
  err = Color(255, 0, 0),
  warn = Color(255, 165, 0),
  info = Color(0, 128, 255),
  debug = Color(128, 128, 128)
}

local levelNames = {
  [1] = "err",
  [2] = "warn",
  [3] = "info",
  [4] = "debug"
}

local couldDoLog = {
  err = false,
  warn = false,
  info = false,
  debug = false
}

cvars.AddChangeCallback("wise_log", function(_, old, new)
  local levelStr = new:lower()
  local levelNum = levels[levelStr]

  if (!levelNum) then
    return RunConsoleCommand("wise_log", old)
  end

  for name, num in pairs(levels) do
    couldDoLog[levelNames[num]] = num <= levelNum
  end
end, "wise_internal")

do
  local currentLevelStr = wise.log._convar:GetString():lower()
  local currentLevelNum = levels[currentLevelStr] or levels["info"]

  for name, num in pairs(levels) do
    couldDoLog[levelNames[num]] = num <= currentLevelNum
  end
end

---@param level Wise.LogLevel
---@param message string
function wise.log.log(level, message, ...)
  if (!couldDoLog[level]) then
    return
  end

  local msg = string.format(message, ...)

  MsgC(color_white, "[wise]", " ", "[", os.date("%H:%M:%S"), " ", logColors[level] or color_white, level:upper(), color_white, "]", " ", msg)
  MsgN()
end

function wise.log.err(message, ...)
  wise.log.log("err", message, ...)
end

function wise.log.warn(message, ...)
  wise.log.log("warn", message, ...)
end

function wise.log.info(message, ...)
  wise.log.log("info", message, ...)
end

function wise.log.debug(message, ...)
  wise.log.log("debug", message, ...)
end