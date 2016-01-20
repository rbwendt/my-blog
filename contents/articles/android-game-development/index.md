---
title: Android Game Development
author: benwendt
layout: post
template: article.jade
date: 2015-02-14
url: /2015/02/14/android-game-development/
categories:
  - Java
---


Wanting to expand my horizons a little, I decided to give android game development a try. I quickly prototyped a game in canvas + js called [protect your thing][2] to give myself an idea of how it would work on the android platform. This was a natural prototyping choice for me because I&#8217;ve been working with JS code daily for at least a decade now, and I love playing with canvas. (I frequently will whip up a [little graphic][3] in canvas reminiscent of my early QBasic coding days, but flavoured by the years of studying mathematics that followed).

<span class="more"></span>

[<img src="http://benwendt.ca/blog/wp-content/uploads/2015/02/Screenshot_2015-02-13-22-22-57-576x1024.png" alt="Screenshot_2015-02-13-22-22-57" width="576" height="1024" class="alignnone size-large wp-image-450" />][1]


[<img src="http://benwendt.ca/blog/wp-content/uploads/2015/02/Screenshot_2015-02-13-22-23-56-576x1024.png" alt="Screenshot_2015-02-13-22-23-56" width="576" height="1024" class="alignnone size-large wp-image-451" />][4]

With a prototype of a <span title="I'm not a gamer">slightly enjoyable</span> game complete, I set out on the path of android game development. Sereptitiously, the android graphics library has a [canvas][5] class that enabled all the stuff I&#8217;m used to being able to do in js. Beyond that, I looked up how to make an event loop and started hacking. The result is half-decent. It&#8217;s not a AAA game, and it has a few warts, but it was an excellent learning experience and I&#8217;m happy and proud to have made it. Check it out:

**<a style="font-size:24px" href="https://play.google.com/store/apps/details?id=ca.benwendt.protectyourthing&#038;hl=en">Protect Your Thing!</a>**

 [1]: http://benwendt.ca/blog/wp-content/uploads/2015/02/Screenshot_2015-02-13-22-22-57.png
 [2]: /protet.html
 [3]: /flashy32.html
 [4]: http://benwendt.ca/blog/wp-content/uploads/2015/02/Screenshot_2015-02-13-22-23-56.png
 [5]: http://developer.android.com/reference/android/graphics/Canvas.html
