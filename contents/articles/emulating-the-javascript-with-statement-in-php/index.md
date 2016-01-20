---
title: Emulating the Javascript With Statement in PHP
author: ben-wendt
layout: post
date: 2014-07-02
template: article.jade
url: /2014/07/02/emulating-the-javascript-with-statement-in-php/
categories:
  - Javascript
  - PHP
tags:
  - language design
---
[Javascript has a `with` statement][1] that you probably shouldn&#8217;t use. I&#8217;ve never seen it used non-jokingly in JavaScript in the past decade or so, other than the occasional [clever hack][2]. [Visual Basic also has a `with` statement][3], and I did see it used a fair bit in that realm, back in the day. In my experience it&#8217;s not something that developers are clamoring for.

<span class="more"></span>

The main advantage of using `with` is not having to retype the name of the object you are working with repeatedly in a block of code. The drawback is that this harms readability; an assortment of new variables are presented in the block, and the scope has metaphorically changed gears. A big part of writing readable code is maintaining a good flow and preventing [context switches][4]. Because of this, `with` use is rare.

However, suppose you did want to implement some PHP code where you didn&#8217;t want repeated array or object references and you didn&#8217;t want to pollute your scope with a call to `extract`. You could use the following abomination:

<pre class="brush: php; title: ; notranslate" title="">call_user_func(function () use ($withVariable) {
	if (is_object($withVariable)) {
		$withVariable= get_object_vars($withVariable);
	}
	extract($withVariable);
	// do stuff.
});
</pre>

The cumbersome `use` keyword and its white-list approach to close scope make this a difficult and cumbersome block of code. PHP doesn&#8217;t allow immediate execution of anonymous functions directly, so we have to pass the function to `call_user_func`. In other languages, `with` will bring variables from the outer scope into the `with` scope, but that will not happen here unless you add the desired variables into to `use` arguments.

In conclusion, `with` is a misfeature and attempting to implement it in PHP is neither very fruitful or elegant.

 [1]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/with
 [2]: http://jsfiddle.net/ondras/hYfN3/ "Tiny Excel-like app in vanilla JS"
 [3]: http://msdn.microsoft.com/en-ca/library/wc500chb.aspx
 [4]: http://en.wikipedia.org/wiki/Human_multitasking
