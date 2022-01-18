---
title: A Mandelbrot Set Viewer via Javascript and Canvas
author: ben-wendt
layout: post
template: article.pug
date: 2013-05-24
url: /2013/05/24/a-mandelbrot-set-viewer-via-javascript-and-canvas/
categories:
  - Javascript
tags:
  - canvas
  - fractal
  - math
---
In mathematics, a [fixed point][1] is an input  `x` for a function `f` such that

```
f(x) = x
```

The Mandelbrot Set is a visualization of which points near `0` in the complex plane are fixed points for the function <img src="http://benwendt.ca/blog/wp-content/ql-cache/quicklatex.com-fbbf2a4c724249d1ef2f4dc756849d05_l3.png" class="ql-img-inline-formula quicklatex-auto-format" alt="&#102;&#40;&#122;&#41;&#32;&#61;&#32;&#122;&#94;&#123;&#50;&#125;&#32;&#45;&#32;&#49;" title="Rendered by QuickLaTeX.com" height="19" width="103" style="vertical-align: -4px;" />, where <img src="http://benwendt.ca/blog/wp-content/ql-cache/quicklatex.com-b85edc5050d852426cfbfae352fd2550_l3.png" class="ql-img-inline-formula quicklatex-auto-format" alt="&#122;&#105;&#110;&#109;&#97;&#116;&#104;&#98;&#98;&#123;&#67;&#125;" title="Rendered by QuickLaTeX.com" height="13" width="97" style="vertical-align: 0px;" />. Points that are fixed are rendered in black, while all other points are colour-coded based on how quickly repeated application of the function to a point diverges.

Images of the Mandelbrot set should be familiar to most everyone. It&#8217;s an infinitely detailed, self-similar set of rainbows surrounding bubbles.

 <img src="http://benwendt.ca/blog/wp-content/uploads/2013/05/canvas6-300x171.png" alt="canvas6" width="300" height="171" class="alignnone size-medium wp-image-30" /><img src="http://benwendt.ca/blog/wp-content/uploads/2013/05/canvas-300x171.png" alt="canvas" width="300" height="171" class="alignnone size-medium wp-image-31" />
  
 <img src="http://benwendt.ca/blog/wp-content/uploads/2013/05/canvas2-300x171.png" alt="canvas2" width="300" height="171" class="alignnone size-medium wp-image-32" /><img src="http://benwendt.ca/blog/wp-content/uploads/2013/05/canvas3-300x171.png" alt="canvas3" width="300" height="171" class="alignnone size-medium wp-image-33" />
  
 <img src="http://benwendt.ca/blog/wp-content/uploads/2013/05/canvas4-300x171.png" alt="canvas4" width="300" height="171" class="alignnone size-medium wp-image-34" /><img src="http://benwendt.ca/blog/wp-content/uploads/2013/05/canvas5-300x171.png" alt="canvas5" width="300" height="171" class="alignnone size-medium wp-image-35" />

So here&#8217;s my javascript and canvas based Mandlebrot viewer:

<pre class="brush: jscript; title: ; notranslate" title="">var xScale, xOffext, yScale, yOffset, xVal, yVal;
var canvas, h, w;
updateScalesAndOffsets = function() {
	xScale = parseFloat(document.getElementById('xScale').value);
	xOffset = parseFloat(document.getElementById('xOffset').value);
	yScale = parseFloat(document.getElementById('yScale').value);
	yOffset = parseFloat(document.getElementById('yOffset').value);
};
updateCanvasAndDimensions = function() {
	canvas = document.getElementById('m');
	h = canvas.getAttribute('height');
	w = canvas.getAttribute('width');
};
doMandelbrot = function() {
	var iteration, max_iteration = 1000, l, x, y, x0, y0, xtemp;
	updateCanvasAndDimensions();
	var ctx = canvas.getContext('2d');
	updateScalesAndOffsets();
	
	for (var i=0; i &lt; w; i++) {
		for (var j=0;j &lt; h; j++) {
			// for each point in the image, generate the color value.
			x0 = xScale * (i / w) + xOffset;
			y0 = yScale * (j / h) + yOffset;
			
			x = 0;
			y = 0;
			
			iteration = 0;
			
			while (x*x + y*y &lt; 4 && iteration &lt; max_iteration) {
				// this is parametrically performing the complex function f(z) = z^2 -1.
				xtemp = x*x - y*y + x0;
				y = 2*x*y + y0;
				x = xtemp;
				iteration++;
			}
			
			if (x*x + y*y &lt; 4) {
				ctx.fillStyle='rgb(0,0,0)';
			} else {
				l = iteration &lt; 50? iteration : 50;
				// set colors using hsl so that the number of iterations to diverge maps to the hue.
				ctx.fillStyle='hsl('+Math.floor((iteration/max_iteration)*256)+',100%,' + l + '%)';
			}
			
			ctx.fillRect(i,j,i+1,j+1);
		}
	}
};
mouseMove = function(e) {
	
	
	xVal = xScale * (e.clientX / w) + xOffset;
	yVal = yScale * (e.clientY / h) + yOffset;
	var xCoordinateElement = document.getElementById('xCoordinate'), yCoordinateElement = document.getElementById('yCoordinate');
	xCoordinateElement.innerHTML = xVal;
	yCoordinateElement.innerHTML = yVal;
};

zoomIn = function() {
	document.getElementById('xScale').value = parseFloat(document.getElementById('xScale').value) / 2;
	document.getElementById('xOffset').value = xVal - parseFloat(document.getElementById('xScale').value) / 2;
	document.getElementById('yScale').value = parseFloat(document.getElementById('yScale').value) / 2;
	document.getElementById('yOffset').value = yVal - parseFloat(document.getElementById('yScale').value) / 2;
	doMandelbrot();
	
}
zoomOut = function() {
	document.getElementById('xScale').value = parseFloat(document.getElementById('xScale').value) * 2;
	document.getElementById('yScale').value = parseFloat(document.getElementById('yScale').value) * 2;
	doMandelbrot();
	
}
moveDir = function(dir) {
	switch (dir) {
		case 'up' : document.getElementById('yOffset').value = yOffset - yScale / 10; break;
		case 'down' : document.getElementById('yOffset').value = yOffset + yScale / 10; break;
		case 'right' : document.getElementById('xOffset').value = xOffset + xScale / 10; break;
		case 'left' : document.getElementById('xOffset').value = xOffset - xScale / 10; break;
	}
	updateScalesAndOffsets();
	doMandelbrot();
}


</pre>

 [1]: http://en.wikipedia.org/wiki/Fixed_Point
