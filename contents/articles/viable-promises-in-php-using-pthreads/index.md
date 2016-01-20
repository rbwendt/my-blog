---
title: Viable promises in PHP using pthreads
author: ben-wendt
layout: post
date: 2013-07-10
template: article.jade
url: /2013/07/10/viable-promises-in-php-using-pthreads/
categories:
  - PHP
tags:
  - design patterns
  - promise
  - pthreads
  - threads
---
I&#8217;ve looked at making promises in PHP before, [but it was a bit pointless due to PHP&#8217;s synchronous nature][1].

But PHP isn&#8217;t necessarily synchronous. You can add threading capabilities by installing [pthreads][2]. Using this library it is possible to set up functioning promises (with a few limitations) in PHP.

Pthreads supports stacking threads, which is essentially a promise. As such, this blog post is essentially a rehash of any of the [pthreads examples of `Stackable`][3]. The basic idea is to set up a class that inherits from `Worker`, initialize an instance, start it going, then stack on an instance of a class inheriting from `Stackable`.

My implementation of this pattern will allow the passing of arbitrary functions to these classes, which is what the promise pattern is all about. It works, but there is a limitation. You can pass function names in (e.g. `count_to_a_million`), but not closures (e.g `function() {echo "foo";}`). [Aside: for some reason PHP calls anonymous functions closures even though they are only related concepts.] It appears that pthreads has some hidden serialization of parameters going on under the hood, and PHP does not support serialization of closures. Because of this, my implementation only supports the passing of function names (although it could be modified to accept parameters as well, as those could be serializable).

Here are the classes:

<pre class="brush: php; title: ; notranslate" title="">&lt;?php

class PromiseClass extends Worker {
	private $_promise = null;
	public function run() {
		$func = $this-&gt;_promise;
		$func();
	}
	public function __construct($promise) {
		$this-&gt;_promise = $promise;
	}
}

class ThenClass extends Stackable {
	private $_promise = null;
	public function __construct($promise) {
		$this-&gt;_promise = $promise;
	}
	public function run() {
		$func = $this-&gt;_promise;
		$func();
	}
	
}
</pre>

As you can see `PromiseClass` and `ThenClass` have the same extended properties and methods, but are based on different classes.

Here is how to use these classes to implement Promises in PHP:

<pre class="brush: php; title: ; notranslate" title="">function then_function() {
	echo "and then...n";
}

function promise_function() {
	echo "promise function called...n";
}

$promiser = new PromiseClass('promise_function');

$then = new ThenClass('then_function');
	
$promiser-&gt;start();
$promiser-&gt;stack($then);

for ($i = 0; $i &lt; 20; $i++) {
	echo "testn";
}
</pre>

The output for the above example should be something like the following (the outputs of &#8220;test&#8221; are there to show that this work is asynchronous):

<pre>promise function called...
test
test
...
test
and then...
test
test
...
</pre>

Promises are most useful as a means of waiting for data before performing an action with it. In that regard this is not an ideal solution as it would require some form of kludge. If PHP had proper closures it would be reasonable but in this form it would likely need to require use of the `global` operator which is never nice.

 [1]: http://benwendt.ca/blog/?p=85
 [2]: https://github.com/krakjoe/pthreads/
 [3]: https://github.com/krakjoe/pthreads/blob/master/examples/Stacking.php
