---
title: Non-functional Sleep Sort Implemented in PHP using pthreads
author: ben-wendt
template: article.jade
date: 2013-07-08
url: /2013/07/08/non-functional-sleep-sort-implemented-in-php-using-pthreads/
categories:
  - PHP
tags:
  - pthreads
  - sorting
---
I&#8217;ve looked at [Sleep Sorting][1] before. The basic idea is that each scalar in your collection to be sorted will be used as it&#8217;s own weight, which is then used as the delay before outputting it as output.

In a perfect world, all elements are sent to this time-based output buffer at the same instant, in which case the results will be accurate.

When I did this before in javascript, the results were accurate because javascript is an asynchronous language. When you call `setInterval`, other things can happen before that interval is complete.

PHP is not asynchronous. You could imagine looping through a collection and calling `sleep` before each `echo` and that this would be a basic sleep sort implementation. This doesn&#8217;t work because in PHP sleep is blocking. The result will be a script that waits the sum of the array seconds in total, and outputs the order unchanged.

<pre class="brush: php; title: ; notranslate" title="">function sleepcount($sleepnum) {
	sleep($sleepnum);
	echo "$sleepnumn";
}
foreach($nums as $num){
	sleepcount($num);
}
</pre>

There are several methods of implementing threading in PHP. A beta PHP extension called [pthreads][2] is one way to do this. Here&#8217;s an implementation based on the [pthreads Async example][3]:

<pre class="brush: php; title: ; notranslate" title="">function sleepcount($sleepnum) {
	sleep($sleepnum);
	echo "$sleepnumn";
}

class Async extends Thread {

	public function __construct($method, $params){
		$this-&gt;method = $method;
		$this-&gt;params = $params;
		$this-&gt;result = null;
		$this-&gt;joined = false;
	}

	public function run(){
		if (($this-&gt;result=call_user_func_array($this-&gt;method, $this-&gt;params))) {
			return true;
		} else return false;
	}

	public static function call($method, $params){
		$thread = new Async($method, $params);
		if($thread-&gt;start()){
			return $thread;
		}
	}

}


$nums = array( 6, 2, 4, 1);

foreach($nums as $num){
	$future = Async::call("sleepcount", array($num));
}
</pre>

On my development machine this does not product the correct results. It only sorts elements pairwise, so my result is

> 2, 6, 1, 4

This is likely because my development machine has a dual core processor. That&#8217;s just part of the fun of concurrent programming I suppose. 

There may be a better way of implementing this in pthreads. I wouldn&#8217;t know. I&#8217;m only currently getting my feet wet with it.

 [1]: http://benwendt.ca/blog/?p=124
 [2]: https://github.com/krakjoe/pthreads
 [3]: https://github.com/krakjoe/pthreads/blob/master/examples/CallAnyFunction.php
