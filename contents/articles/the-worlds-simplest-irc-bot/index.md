---
title: The World's Simplest IRC Bot
author: ben-wendt
layout: post
date: 2016-09-01
template: article.jade
---

I saw an article on twitter about [writing an IRC bot in ruby](https://blog.openshift.com/running-irc-bot-ruby-openshift-v3/). It piqued
my interest because of nostalgia and because I'm a slack curmudgeon. I 
believe that IRC has value. I never actually got around to trying the 
[cinch](https://github.com/cinchrb/cinch) gem that the article recommends, although if I ever need
to do anything serious in this realm it wil be the first  tool I turn to.

<span class="more"></span>

Instead I found an article about writing a [really simple ruby class for a
bot](http://kevin.glowacz.info/2009/03/simple-irc-bot-in-ruby.html). It never really
occurred to me how simple the actual connection part of IRC is, so after playing 
around with this code for an hour or two I decided to port it to Go.

[What I came up with](https://github.com/rbwendt/an-irc-bot) is an extremely [simple
connection struct](https://github.com/rbwendt/an-irc-bot/blob/master/irc_connection/irc_connection.go)
that wraps a tcp socket with some metadata, and allows for injection of a message handler, while maintaining
the `PING` / `PONG` keep-alives on its own.

I spent at least twenty minutes trying to figure out why this wasn't working before
realizing `fmt.Println` puts in a line break, while `fmt.Fprintf` does not. Don't trust
your debugging output too much.

```go
func (c *IrcConnection) Say(msg string) {
	fmt.Println(msg)
	fmt.Fprintf(c.conn, fmt.Sprintf("%s\n", msg))
}
```

For an afternoon project, I like how neat and compartmentalized it is, excusing the
natural verbosity of Go. If I ever put more time into this, I'd like to:

1. *Add tests*. I wavered on this because at the end of the day it has to connect to a 
  real IRC server so I did all my development against that. Sorry freenode. But it 
  would be pretty easy to make an IrcConnection interface, craft a dummy version with
  a buffer I can control, and use that to test that things like `PONG` work correctly.
2. *Factor code more*. For example, I could definitely use a separate method for all the handshake
  messages done during connection.
3. *Change `Run` to work in a goroutine*, and make a separate message handler that allows
  user input. That would turn this into a single channel IRC client application, which
  would not be the least cool thing in the world.
  
That's it. Just another fun little side project I thought I would share.


