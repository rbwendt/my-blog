---
title: A key-value store that forgets
author: ben-wendt
layout: post
date: 2014-02-27
template: article.pug
url: /2014/02/27/a-key-value-store-that-forgets/
categories:
  - Javascript
tags:
  - biology
  - data structures
  - memory
  - temporal data structures
---
Humans, like computers, have long term and short term memory. An interesting feature of human memory is that if you don&#8217;t use a memory for a while, you will eventually forget it.

So, for example, assume that 20 years ago you read _War and Peace_. Rather than keep the details of all 1000 pages in your memory, your brain sees that the memory hasn&#8217;t been used in a while, and eventually it forgets the details of the book.

<span class="more"></span>

This memory feature could be useful for AI in a video game, or for clearing out old memory that hasn&#8217;t been used in a while. In the latter case, you&#8217;d want to have some re-lookup functionality added to your code. In our analogy this would be akin to re-reading the book after having forgotten the details.

We can model this behaviour in javascript using an interval that clears out old unused memories.

<pre class="brush: jscript; title: ; notranslate" title="">var Forgettable = function(duration) {
    var forgettable = {
        "duration" : duration,
		"values" : {},
		"timeouts" : {}
	};
	forgettable.set = function (k, v) {
		if (!v) {
			return;
		}
		this.values[k] = v;
		this.timeouts[k] = this.duration;
	};
	forgettable.check = function() {
		var i;
		for (i in this.timeouts) if (this.timeouts.hasOwnProperty(i)) {
			if (this.timeouts[i] == 0) {
				delete this.timeouts[i];
				delete this.values[i];
			} else {
				this.timeouts[i] --;
			}
		}
	};
	forgettable.get = function(k) {
		var value = this.values[k];
		this.set(k, value);
		return value;
	};
	(function(f) {
		setInterval(function() {
			f.check();
		}, 1000);
	})(forgettable);
    return forgettable;
};
</pre>

The data structure above works by having a duration of time that it will retain a memory. When a certain memory hasn&#8217;t been looked up in a certain amount of time, it will be deleted.

Rather than using the interval, the same code could be implemented by moving the contents of the check function in before the contents of the get function, or using timeouts.
