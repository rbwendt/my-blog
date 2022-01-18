---
title: Using the HSL colour space on Android
author: ben-wendt
layout: post
template: article.pug
date: 2014-04-23
url: /2014/04/23/using-the-hsl-colour-space-in-java/
categories:
  - Android
  - Java
tags:
  - Android
  - Color
  - HSL
---
For my fun projects that include color, I like to use the following palette in the HSL space:

<span class="more"></span>

* random hue
* full saturation
* 50% lightness

This is easy in HTML because HSL is in the CSS specification and it has great cross browser support.

It's a tiny bit harder in an Android app.

Java on Android uses the rgb color space by default, but there are some handy methods for using HSL.

```java
float[] colors = {(float)Math.random() * 360,255,127}; 
int rgb = Color.HSVToColor(colors); 
r = Color.red(rgb); 
g = Color.green(rgb); 
b = Color.blue(rgb);
```
