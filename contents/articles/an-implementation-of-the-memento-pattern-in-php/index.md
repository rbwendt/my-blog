---
title: An implementation of the memento pattern in PHP
author: ben-wendt
layout: post
date: 2013-12-09
template: article.jade
url: /2013/12/09/an-implementation-of-the-memento-pattern-in-php/
categories:
  - PHP
tags:
  - design patterns
  - helpful classes
---
The memento pattern is a design pattern used to store and revert states for objects which support this capacity. It is accomplished by having a `Caretaker` object which manages a set of states, encoded in `Memento` objects. The `Memento` objects handle the storage of state; the implementation of this can vary, but it necessitates some level of deep-copying the object. A shallow copy will not suffice in general because it will not always capture the whole state of an object, due to the fact that most languages implement memory access for objects as references. Because of this, I use `serialize` and `unserialize` in my example below. Of course you could use other methods, like `clone` or just copying what you know you will need if memory is a concern.

<span class="more"></span>

Let&#8217;s take a look at how it works&#8230;

<pre class="brush: php; title: ; notranslate" title="">/**
* The memento class is very simple; it simply serializes and
* unserializes incoming data.
*/

class Memento {
	private $state = null;
	public function __construct($state) {
		$this-&gt;state = serialize($state);
	}
	public function revertState() {
		return unserialize($this-&gt;state);
	}
}

/**
* The Caretaker class manages a group of Memento objects.
*/

class Caretaker {
	
	private $states = array();
	
	public function set($state) {
		$this-&gt;states[] = new Memento($state);
	}
	
	public function get() {
		$memento = array_pop($this-&gt;states);
		return $memento-&gt;revertState();
	}
	
}
</pre>

And here is a sample of usage:

<pre class="brush: php; title: ; notranslate" title="">$ct = new Caretaker();

$ct-&gt;set('3');
$ct-&gt;set('2');
$ct-&gt;set('1');
$ct-&gt;set(new stdClass);

var_dump($ct-&gt;get());
echo $ct-&gt;get() . "n";
echo $ct-&gt;get() . "n";
echo $ct-&gt;get() . "n";
</pre>
