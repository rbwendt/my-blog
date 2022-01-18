---
title: A timer class
author: ben-wendt
layout: post
date: 2013-09-09
url: /2013/09/09/a-timer-class/
template: article.pug
categories:
  - PHP
tags:
  - helpful classes
---
It&#8217;s often useful to time aspects of your applications. In environments without access to profiling tools like xdebug, it is necessary to roll your own. Here&#8217;s one that relies heavily on calls to `microtime`. Unfortunately making many thousands of calls to `microtime` takes a significant amount of time on its own.

<span class="more"></span>

But a manual timing class like this can still be quite useful in identifying problem blocks of code:

```php
class Timer {

	private $starts = array();
	private $calls = array();
	
	private $times = array();
	
	public function start($identifier) {
		if (!isset($this-&gt;calls[$identifier])) {
			$this-&gt;calls[$identifier] = 0;
		}
		$this-&gt;calls[$identifier]++;
		$this-&gt;starts[$identifier] = microtime(true);
	}
	
	public function stop($identifier) {
		$end = microtime(true);
		if (!isset($this-&gt;times[$identifier])) {
			$this-&gt;times[$identifier] = 0;
		}
		$this-&gt;times[$identifier] += ($end - $this-&gt;starts[$identifier]);
	}
	
	public function getTimes() {
		return $this-&gt;times;
	}
	
	public function getCallCounts() {
		return $this-&gt;calls;
	}

}
```
