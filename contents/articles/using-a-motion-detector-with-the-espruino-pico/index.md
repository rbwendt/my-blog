---
title: Using a motion detector with the espruino pico
author: ben-wendt
layout: post
date: 2015-05-07
template: article.jade
url: /2015/05/06/using-a-motion-detector-with-the-espruino-pico/
categories:
  - Javascript
tags:
  - espruino
---
This is a simple modification of the [espruino motion detector][1] tutorial to work with the espruino pico. The main difference is which pins things are hooked up to, and my not using the LED strips, which I don&#8217;t own (hint hint, Santa).

<span class="more"></span>

First off, using your espruino pico, set it up at the standard left-most position on the bread board.

Then wire up as follows:

| HC-SR501 | Espruino  |
| -------- | --------- |
| VCC      | VBAT (5v) |
| OUT      | A7        |
| GND      | GND       |

The main difference here is that we use `A7` instead of `A1` because on the pico, `A1` doesn&#8217;t come with a pin soldered on, so you can&#8217;t just plug a jumper into the bread board.

The code is basically the same as the tutorial, with the updates of removing the LED strip code and updating `A1` to `A7`

```javascript
var timeout;

function lightsOn() {
  digitalWrite(LED1, 1);
  console.log('light on ' + (new Date().toString()));
}

function lightsOff() {
  digitalWrite(LED1,0);
}

setWatch(function(e) {
  if (timeout!==undefined)
    clearTimeout(timeout);
  else {
    lightsOn();
  }
  timeout = setTimeout(function() {
    timeout = undefined;
    lightsOff();
  }, 1500);
}, A7, { repeat:true, edge: "rising" });
```


This thing is so much fun to toy around with. I had fun putting together the [pico piano][2] project too.

 [1]: http://www.espruino.com/Motion+Sensing+Lights
 [2]: http://www.espruino.com/Pico+Piano
