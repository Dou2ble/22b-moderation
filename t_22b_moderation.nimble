# Package

version       = "0.1.0"
author        = "Dou2ble"
description   = "A new awesome nimble package"
license       = "0BSD"
srcDir        = "src"
bin           = @["t_22b_moderation"]
backend       = "c"


# Dependencies

requires "nim >= 2.0.0"
requires "dotenv >= 2.0.0"
requires "dimscord == 1.6.0"
requires "dimscmd == 1.4.0"
requires "print"
# requires "httpbeast"
