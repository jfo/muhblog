---
title: Lichess bot
draft: true
---

Let's make a chess bot.

When I was at Recurse Center (nee hacker school), one of my smaller projects
was creating a chess bot for zulip. It didn't play any moves, it just kept
track of games by channel/topic/players and let those people issue commands to
play new moves, then it printed out the board.

Eventually, I would like to build a chess playing bot, but in this post, my
goal will be simply to play a lichess game _via_ a bot through the api. Only
bot accounts can use the api, and only accounts that have never played a game
can be promoted to bot accounts, so I will make a new one.

https://lichess.org/forum/general-chess-discussion/multiple-accounts-3

8zk7hS1BsEs2WGW2
curl -d '' https://lichess.org/api/bot/account/upgrade -H "Authorization: Bearer 7MolOOKfsAEEZ8i2"

first time I got an error telling me I was missing scope for that action, I
assume I needed more permissions, so i made a new token and tried again, and
this time it worked. I don't really mind giving this api token all access
because this is the whole point ofthis account.
