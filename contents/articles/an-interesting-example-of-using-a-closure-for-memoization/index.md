---
title: An interesting example of using a closure for memoization
author: ben-wendt
layout: post
template: article.jade
date: 2015-05-15
url: /2015/05/14/an-interesting-example-of-using-a-closure-for-memoization/
categories:
  - Go
tags:
  - memoization
---
Long ago I wrote about the [benefits of memoization][1]. It&#8217;s a simple idea: a time vs. space trade off. Trade time in CPU for space in memory. A pretty classic example is the massive speed benefit you can get while calculating the Fibonacci sequence by saving values you have already found. (The naive recursive approach recalculates values an exponential number of times.) It&#8217;s a toy example but it definitely exhibits the power of the technique.
<span class="more"></span>

I have to learn [Go][2] for an upcoming project at work. I&#8217;m excited about it, and I&#8217;ve been starting out by working through the [Go Tour][3] lesson series. I was pretty interested to see [slide 22 in the more types lesson][4], an exercise instructing the reader to write a function that calculates Fibonacci numbers using a closure. The way this is set up gently nudges the reader toward writing an answer that uses memoization through a closure.

Here&#8217;s what I came up with:

```go
package main

import "fmt"

// fibonacci is a function that returns
// a function that returns an int.
func fibonacci() func() int {
	a := [10]int{1, 1}
	b := 0
	f := func() int {
		val := a[b]
		if val == 0 {
			val = a[b - 1] + a[b - 2]
			a[b] = val
		}
		b ++
		return val
	}
	return f
}

func main() {
	f := fibonacci()
	for i := 0; i &lt; 10; i++ {
		fmt.Println(f())
	}
}

```

I really liked the way that the solution uses a built in array and a closure to accomplish memoization. It&#8217;s very clean. Coming from doing a lot of PHP it&#8217;s nice to see because a fairly standard way of implementing this technique in that language is to use the `static` keyword which always felt a bit hacky (on a side note, you could do this in PHP, but you&#8217;d need the `use` feature on the closure, which I am also not a fan of). The same technique would definitely work in javascript as well. It&#8217;s a welcome addition to my toolset.

 [1]: http://benwendt.ca/blog/2013/07/24/a-demonstration-of-the-usefulness-of-memoization-in-lua/
 [2]: http://golang.org/
 [3]: https://tour.golang.org/
 [4]: https://tour.golang.org/moretypes/22
