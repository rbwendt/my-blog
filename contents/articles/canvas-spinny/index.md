---
title: Canvas Spinny
author: ben-wendt
layout: post
template: article.pug
date: 2014-09-05
url: /2014/09/05/canvas-spinny/
categories:
  - Javascript
---
This will make a nice semi transparent spinner for you.
<span class="more"></span>
```javascript
var spinnyCanvas = function(left, top) {
	var conti = false;
	var self = this;
	this.stop = function() {
		this.conti = false;
	}
	this.start = function() {
		console.log(self.conti)
		if (!self.conti) {
			self.conti = true;
			draw();
		}
	}
	var dim = 48
	var canvas = document.createElement('canvas')
	var context = canvas.getContext('2d')
	document.body.appendChild(canvas)
	canvas.height= dim
	canvas.width = dim
	canvas.theta = 0
	canvas.dtheta = -.09
	canvas.style.position = 'fixed'
	canvas.style.top = top + 'px'
	canvas.style.left= left + 'px'

	var draw = function() {
		canvas.width = canvas.width
		var r = dim / 16
		var x, y
		var i, L = 5
		for (i = 0; i &lt; L; i++) {
			x = dim / 2 + dim * .3 * Math.sin(canvas.theta + i * 1.1 * Math.PI / L)
			y = dim / 2 + dim * .3 * Math.cos(canvas.theta + i * 1.1 * Math.PI / L)
			context.beginPath()
			context.fillStyle = "rgba(128,128,128," + (1 - i / L) + ")"
			context.arc(x, y, r, 0, 2*Math.PI, false)
			context.fill()
			context.closePath()
		}
		canvas.theta += canvas.dtheta
		if (self.conti) {    
			requestAnimationFrame(draw)
		}
	}
	return this
}


```


