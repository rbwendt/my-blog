---
title: Getting Started With Espruino
author: ben-wendt
layout: post
date: 2014-02-07
template: article.pug
url: /2014/02/07/getting-started-with-espruino/
categories:
  - Javascript
tags:
  - espruino
---
I was excited yesterday to see that my [Espruino][1], which I backed on Kick Starter, had arrived in the mail. Espruino is micro controller that is controlled via JavaScript. I&#8217;ve long wanted to experiment with micro controllers, having visions of working with arduinos or a raspberry pi, but the JavaScript control combined with the reasonable price tipped the scale in favour of Espruino.

<span class="more"></span>

![my new Espruino][2]

There is an excellent [Quick Start Guide][3] on the Espruino site that got me started in a flash. You can control the LED lights on the board by calling things like `digitalWrite(LED1, 1)`.

There are three LED variables, so I decided to write an interval to loop through them:

<pre class="brush: jscript; title: ; notranslate" title="">var state = 0,
    interval = setInterval(function() {
      state = (state + 1) %3;
      digitalWrite(LED1, 0);
      digitalWrite(LED2, 0);
      digitalWrite(LED3, 0);
      switch (state) {
        case 0:
          digitalWrite(LED1, 1);
          break;
        case 1:
          digitalWrite(LED2, 1);
          break;
        case 2:
          digitalWrite(LED3, 1);
          break;
      }
    }, 50);
</pre>

And here it is in action:

![][4]

And here is code to turn on and off LED1 when BTN1 is pressed:

<pre class="brush: jscript; title: ; notranslate" title="">var on = false;
setWatch(function(e) {
  on = !on;
  
  digitalWrite(LED1, on);
}, A1, { repeat: true, edge: "falling" });

</pre>

 [1]: http://www.espruino.com/
 [2]: http://benwendt.ca/images/IMG_20140207_092616-2.jpg
 [3]: http://www.espruino.com/Quick+Start
 [4]: http://benwendt.ca/images/base2.gif
