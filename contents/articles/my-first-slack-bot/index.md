---
title: My first slack bot
author: ben-wendt
layout: post
date: 2016-09-15
template: article.pug
---

I am still working on picking up some [elixir](http://elixir-lang.org/), so when a coworker mentioned
that writing a [Slack bot](https://api.slack.com/bot-users) is cool, I decided to give that a try.
[Slack](https://slack.com/) is a bit easier to work with than IRC because the communication is done in
JSON so you can skip a step in message parsing.

<span class="more"></span>

The login process for a slack bot is:

1. Authenticate over HTTP using your bot's token.
2. Open a websocket connection using the socket url returned in 1.
3. Communicate using JSON over the socket.

Each of these steps required importing a library (`:httpotion`, `"meh/elixir-socket"`, and `:poison`).
This is a bit of a departure from go where the standard library has HTTP and JSON support, and
there's an [x-package for websockets](https://godoc.org/golang.org/x/net/websocket). But everything
worked well. It's three external dependencies instead of two.

Elixir does have a [package repository](https://hex.pm/), so it's way ahead of go in that regard.

You can take a look at [my slack bot here](https://github.com/rbwendt/elixir-slack-bot).

