---
title: A Random Password Generator
author: ben-wendt
date: 2015-09-04
template: article.pug
---



I’ve posted a [random password generator](https://github.com/rbwendt/golang-password-gen) I’ve written to github. The impetus for this was me accidentally posting one of my passwords in an open chat channel at work. I decided it was time to change my password. 


<span class="more"></span>


I found a python library that generated xkcd style passwords a while back, which I can no longer find. So, as part of my ongoing quest to have fun and program a lot I decided to whip one up myself.

Two glaring improvements are:

# The dictionary path is currently hard-coded for ubuntu, which probably north of 90% of people are using by now, but it would be great to make it configurable for people stuck on older machines.
# I’d like a “text-munging” option that would randomly replace the occasional x with a %, and the odd s with a $, and so on.

Enjoy!
