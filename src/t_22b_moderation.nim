import dotenv
import os
import dimscord
import dimscmd
import asyncdispatch
import times
import options
import print

import json
import std/[httpclient, strutils, strformat]

load()

const
  eateryApi = "https://api.eatery.se/wp-json/eatery/v1/load"
  eateryPdf = "https://api.eatery.se/skriv-ut/?id="

let
  token =  os.getEnv("TOKEN")
  discord = newDiscordClient(token)
  http = newHttpClient()

var cmd = discord.newHandler()

proc fetchJson(url: string): JsonNode =
  let response = http.getContent(url)
  return parseJson(response)

# Handle event for on_ready.
proc onReady(s: Shard, r: Ready) {.event(discord).} =
  await cmd.registerCommands()
  echo "Ready as " & $r.user
  
proc interactionCreate (s: Shard, i: Interaction) {.event(discord).} =
  discard await cmd.handleInteraction(s, i)

cmd.addSlash("ping") do ():
  ## Check if the bot is online
  await discord.api.interactionResponseMessage(i.id, i.token, 
    irtChannelMessageWithSource,
    InteractionCallbackDataMessage(content: "Pong! :ping_pong:")
  )

cmd.addSlash("eatery") do ():
  ## View the current eatery menu at kista-nod
  let
    eatery = fetchJson(eateryApi)

    kistaNod = eatery{"eateries"}{"/kista-nod"}
    menuId = kistaNod{"menues"}{"lunchmeny"}.getInt()
    title = kistaNod{"title"}.getStr()

    menu = eatery{"menues"}{$menuId}
    menuTitle = menu{"content"}{"title"}.getStr()
    content = menu{"content"}{"content"}.getStr()

    contentMd = (content.replace("<h2>", "").replace("</h2>", "")
                        .replace("<p>", "").replace("</p>", "")
                        .replace("<br />", "")

                        .replace("<em>", "*").replace("</em>", "*")
                        .replace("<strong>", "**").replace("</strong>", "**"))
    titleMd = &"# {title}\n## {menuTitle}"

    pdf = eateryPdf & $menuId


  await discord.api.interactionResponseMessage(i.id, i.token,
  irtChannelMessageWithSource,
  InteractionCallbackDataMessage(
    content: &"{titleMd}\n{contentMd}\n\npdf: {pdf}"
  ))


# SUPER SECRET
cmd.addSlash("s") do ():
  ## s
  let username = i.member.get().user.username
  if username == "minus420iq":
    await discord.api.interactionResponseMessage(i.id, i.token,
    irtChannelMessageWithSource,
    InteractionCallbackDataMessage(
      content: "t"
    ))
  elif username == "dou2ble":
    await discord.api.interactionResponseMessage(i.id, i.token,
    irtChannelMessageWithSource,
    InteractionCallbackDataMessage(
      content: "double"
    ))
  else:
    await discord.api.interactionResponseMessage(i.id, i.token,
    irtChannelMessageWithSource,
    InteractionCallbackDataMessage(
      content: "te"
    ))

# Connect to Discord and run the bot.
waitFor discord.startSession()