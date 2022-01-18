---
title: Reactive Programming in PHP
author: ben-wendt
layout: post
date: 2013-05-23
template: article.pug
url: /2013/05/23/reactive-programming-in-php/
categories:
  - PHP
tags:
  - data structures
  - paradigms
---
Wikipedia has this to say about [reactive programming][1]:

> In [computing][2], **[reactive programming][1]** is a [programming paradigm][3] oriented around [data flows][4] and the propagation of change. This means that it should be possible to express static or dynamic data flows with ease in the programming languages used, and that the underlying execution model will automatically propagate changes through the data flow.

Inspired by projects like [knockout.js][5] and [reactor.js][6], I thought I&#8217;d give it a shot in PHP. Here is an example implementation:

<pre class="brush: php; title: ; notranslate" title="">&lt;?php

$Signal = function($v) {
	if (is_callable($v)) {
		return function() use ($v) {
			return $v();
		};
	} else {
		return function($a = null) use ($v) {
			static $return;
			if (is_null($return)) {
				$return = $v;
			}
			if (!is_null($a)) {
				$return = $a;
			}
			return $return;
		};
	}
};

</pre>

And here is an example of usage:

<pre class="brush: php; title: ; notranslate" title="">&lt;?php

include 'Reactor.php';

$foo = $Signal(1);

$bar = $Signal(function() use ($foo) {
	return $foo() + 1;
});
$bar2 = $Signal(function() use ($foo, $bar) {
	$val = $foo();
	return $val * $val + $bar();
});

echo $foo() . "n";
echo $bar() . "n";
echo $bar2() . "nn";

$foo(2);

echo $foo() . "n";
echo $bar() . "n";
echo $bar2() . "nn";

$foo(0);

echo $foo() . "n";
echo $bar2() . "nn";

</pre>

 [1]: http://en.wikipedia.org/wiki/Reactive_programming
 [2]: http://en.wikipedia.org/wiki/Computing "Computing"
 [3]: http://en.wikipedia.org/wiki/Programming_paradigm "Programming paradigm"
 [4]: http://en.wikipedia.org/wiki/Dataflow_programming "Dataflow programming"
 [5]: http://knockoutjs.com/
 [6]: https://github.com/fynyky/reactor.js
