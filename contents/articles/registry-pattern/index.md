---
title: Registry Pattern
author: ben-wendt
layout: post
date: 2013-11-18
template: article.pug
url: /2013/11/18/registry-pattern/
categories:
  - PHP
tags:
  - design patterns
---
Here&#8217;s another super-simple design pattern, implemented in PHP.

<pre class="brush: php; title: ; notranslate" title="">class Registry {
	private $values = array();
	
	public function get($key) {
		if (!isset($this-&gt;values-&gt;$key)) {
			throw new OutOfBoundsException("$key not in registry");
		}
		return $this-&gt;values-&gt;$key;
	}
	
	public function set($key, $val) {
		if (!isset($this-&gt;values-&gt;$key)) {
			throw new OverflowException("$key already in registry");
		}
		$this-&gt;values-&gt;$key = $val;
	}
}
</pre>

The registry pattern is used to store information that can be used throughout your application. You could use a registry to store a bunch of application settings, for example.

I&#8217;ve seen this implemented with the magic getters and setters in php, but then you end up with an object that appears to just be setting public properties. It&#8217;s not the most readable solution and it is unintuitive to expect an exception when setting a public property.

It is often implemented as a singleton, but it doesn&#8217;t have to be. In general singletons are bad because they introduce global state into your code and are hard to write test cases for. If you don&#8217;t want to use your registry as a singleton, just do an inversion of control. The downside is having to pass around the registry as a parameter, but trust me: it&#8217;s worth the effort.
