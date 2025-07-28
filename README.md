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

## Documentation
All documentation can be found on the [project's GitBook page](https://smokingplaya.gitbook.io/smokingplaya/wise-gmod-orm/whats-wise)

## To Do
- [ ] PostgreSQL provider/support
- [ ] Returns queries in all ``table`` methods (create, update, delete)
- [ ] Table structure for query results validator
- [ ] Make library more flexible and fresh
