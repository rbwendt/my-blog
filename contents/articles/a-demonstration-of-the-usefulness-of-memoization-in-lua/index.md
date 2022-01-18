---
title: A demonstration of the usefulness of Memoization in Lua
author: ben-wendt
layout: post
date: 2013-07-24
template: article.pug
url: /2013/07/24/a-demonstration-of-the-usefulness-of-memoization-in-lua/
categories:
  - Lua
tags:
  - memoization
---
[Memoization][1] is a programming technique where you save expensive computations in memory to speed up function execution time. E.g. If you were writing a CMS and you wanted a `getSignedInUserName()` method, you wouldn&#8217;t want to make two database calls to show the user name at the top and bottom of the page, so you&#8217;d save it in memory for use later.

My canonical example of the speed increase you can get from this technique is with a Fibonacci calculator. Here is a non-optimized version:

<pre class="brush: delphi; title: ; notranslate" title="">fib = function(n)
	if n==1 or n==0 then
		return 1
	else
		return fib(n-1)+fib(n-2)
	end
end

print(fib(40))
</pre>

This takes about 22 seconds to run on my development machine. Here&#8217;s a rewritten calculator that uses memoization:

<pre class="brush: delphi; title: ; notranslate" title="">results = {}
fib = function(n)
	if results[n] then
		return results[n]
	else
		if n==1 or n==0 then
			result = 1
		else
			result = fib(n-1)+fib(n-2)
		end
		results[n] = result
		return result
	end
end

print(fib(40))
</pre>

This finishes in well under one second. In fact, calling the memoized function with fib(100) finishes in under a second too. The real benefit here is that you aren&#8217;t clogging up your call stack with hundreds of thousands of calls, each waiting on other calls. By having previous results on hand, the function can easily move on to the next step.

 [1]: http://en.wikipedia.org/wiki/Memoization
