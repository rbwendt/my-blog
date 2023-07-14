---
title: Using Underscore.PHP and Newton's Method to approximate pi
author: ben-wendt
template: article.pug
layout: post
date: 2014-04-16
url: /2014/04/16/using-underscore-php-and-newtons-method-to-approximate-pi/
categories:
  - PHP
tags:
  - math
  - Newton
  - underscore
---
[Underscore.js][1] has been ported to [Underscore.PHP][2].

For a simple example, let's using Newton's method to approximate pi.

<span class="more"></span>

```php
$iterations = 20;
$x = 3;

$_ = new __();

$f = function($x) {return 1 + cos($x);};
$g = function($x) {return -sin($x);};
$h = function() {
	global $x;
	global $f;
	global $g;
	$x = $x - $f($x)/$g($x);
};

$j = [];

for ($i = 0; $i &lt; $iterations; $i++) {
	$j[] = $h;
}

$_->each($j, function($k) {$k();});

echo $x;
```

 [1]: http://underscorejs.org/
 [2]: https://github.com/brianhaveri/Underscore.php
