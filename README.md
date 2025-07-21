# wise
``wise`` is a library implementing an ORM system for Garry's Mod.

## Features
- [x] [prisma](https://prisma.io/)-like
- [x] MySQL/MariaDB (MySQLOO and tmysql4), SQLite support
- [x] Coroutine based (Asynchronus)
- [x] LuaLS support
- [x] Easy to setup
- [x] Lightweight

## Installation
1. [Download latest release](https://github.com/smokingplaya/wise/releases/latest/) ``(just click "Source code (zip)")`` of this addon
2. Unpack it into ``addons`` folder

### Console variables (convars)
* ``wise_log`` - Level of the logging **(info by default)**
  * Values: ``err`` (only errors), ``warn`` errors and warns, ``info`` errs, warns, info, ``debug`` all levels

## Usage
```lua
local database = wise.new("mysqloo", {
  host = "127.0.0.1",
  user = "root"
  pass = "some_password",
  dbname = "gmoddb",
  port = 3306 -- optional, 3306 by default
})

local profiles = database:registerTable("PlayerProfiles")

---@type player Player
function GM:LoadPlayer(player)
  local steamid = player:SteamID64()

  local co = coroutine.create(function()
    local profile = profiles:findFirst({
      where = {
        steamid = steamid
      }
    })

    if (istable(profile) && IsValid(player)) then
      player:SetProfile(profile)
    end
  end)

  coroutine.resume(co)
end
```

## To Do
- [ ] PostgreSQL provider/support
- [ ] Returns queries in all ``table`` methods (create, update, delete)
- [ ] Table structure for query results validator
- [ ] Make library more flexible and fresh