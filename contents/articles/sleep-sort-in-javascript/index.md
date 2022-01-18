---
title: Sleep Sort in Javascript
author: ben-wendt
layout: post
date: 2013-07-08
template: article.pug
url: /2013/07/08/sleep-sort-in-javascript/
categories:
  - Javascript
tags:
  - sorting
---
[Sleep Sort][1] is a humourous algorithm for sorting. The idea is to output the numeric array elements after a time interval proportional to the value of the array element. So if you had an array [3, 2, 1], 3 could be output three seconds after the sort, 2 two seconds after and 1 one second after. The result is that you&#8217;d see 1, 2, 3 three seconds later.

Of course this is a terrible idea, but it&#8217;s also a heck of a lot of fun!

Here&#8217;s an implementation of the idea in javascript:

<pre class="brush: jscript; title: ; notranslate" title="">function opnode(a) {
	el = document.createElement('div');
	el.innerHTML = a;
	document.body.appendChild(el);
}

var temporalSort = function(ar) {
	for (i = 0; i &lt; ar.length; i++) {
		(
			function(a){
				window.setTimeout(
					function() {
						opnode(a);
					},
				100 * a);
			}
		)(ar[i]);
	}
};

var i, array = [6, 14, 1, 12, 8, 3, 9, 2, 10, 15, 4, 11, 7, 13, 5];

temporalSort(array);
</pre>

 [1]: http://archives.cazzaserver.com/SleepSortWiki/SleepSort.html
