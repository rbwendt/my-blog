---
title: Pointless Promises in PHP
author: ben-wendt
layout: post
template: article.jade
date: 2013-06-19
url: /2013/06/19/pointless-promises-in-php/
categories:
  - PHP
tags:
  - design patterns
  - promise
---
A [promise][1] is a way to defer the execution of a given routine until the data it needs to run is ready. This is a very useful pattern in asynchronous languages, so using promises in a language like javascript is a great idea.

Of course PHP is (without forking) totally synchronous so there is really no reason to implement the promise pattern in PHP.

But the motto of every programmer is &#8220;if it&#8217;s a bad idea, I will do it!&#8221; (no, it isn&#8217;t), so here&#8217;s an implementation of promises in PHP:

<pre class="brush: php; title: ; notranslate" title="">class PromiseClass {
	private $callbacks = array();
	private $last_return;
	function promise($promise) {
		if (get_class($promise) == 'Promise') {
			return $promise;
		} else if (is_callable($promise)) {
			$this-&gt;then($promise);
			return $this;
		}
	}
	function then (callable $callback) {
		$this-&gt;callbacks[] = $callback;
		return $this;
	}
	function resolve () {
		$callback = array_shift($this-&gt;callbacks);
		if (is_callable($callback)) {
			$this-&gt;last_return = $callback($this-&gt;last_return);
		}
		if (count($this-&gt;callbacks) &gt; 0) {
			$this-&gt;resolve();
		}
	}
}
</pre>

A few things to note here: 

  1. First you will have to make an instance of the class.
  2. You start by passing a function to the `promise` method. You could use `then` but the code wouldn&#8217;t look as descriptive or read as well.
  3. You can then add any functions that would be run after with successive calls to `then`.
  4. None of the functions that have been set up will be run until you call the `resolve` method on the object.

Here&#8217;s an example of usage of this useless and pointless class:

<pre class="brush: php; title: ; notranslate" title="">$promiser = new PromiseClass();

$promiser-&gt;promise(function() {
		echo "sleepingn";
		sleep(3);
		return 3;
	})
	-&gt;then(function($args) {
		echo "that farn$argsn";
		sleep(1);
	})
	-&gt;then(function() {
		echo "even farthernn";
	});

$promiser-&gt;resolve();	
</pre>

Note: I&#8217;ve added some `sleep` statements here so it almost seems like something asynchronous is happening. Really `sleep` is just blocking. The output will be something like:

<pre>sleeping
that far
3
even farther
</pre>

 [1]: http://en.wikipedia.org/wiki/Futures_and_promises
