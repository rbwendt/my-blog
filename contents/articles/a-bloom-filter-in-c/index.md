---
title: 'A Bloom Filter in c#'
author: ben-wendt
layout: post
date: 2013-08-16
template: article.pug
url: /2013/08/16/a-bloom-filter-in-c/
categories:
  - 'c#'
tags:
  - data structures
  - probabilistic data structures
---
A [bloom filter][1] is a probabilistic data structure meant for checking whether a given entry does not occur in a list. It is meant to be quite fast, and is used as a way of not doing costly queries when it can be determined that no results will be returned. E.g., if you could turn this:

```
costly_lookup(key)
```

Into this:

```
if (!cheap_check_that_key_isnt_there()) {
    costly_lookup()
}
```

Then that&#8217;s a win.
<span class="more"></span>
The way that a bloom filter goes about this is by performing a series of `k` hashes that return a value between 0 and  `n` (in my example code below I use  `k=2` and `m=32`). When you add a value to your heavy data store, you will also run each of these hashes and store the return values in the bloom filters master list of returned values. Then when you want to see if something is in there, you run it through all of your hashes; if a value is returned that isn&#8217;t in your list of previous hash results you know that the new entry isn&#8217;t in your set. If only previously hashed values are returned the new item _may_ be in there.

For a discussion of the rate of false positives, optimizing  `k` and `m`, and a more in-depth discussion of this issue, I recommend [Bloom Filters by Example][2] by Bill Mill.

As is usual on my blog, below I will outline the general concept of this data structure. You should note that the values of  `m` and  `k` are hard-coded here, and that the hashing functions `rotate` and `rotateMore` aren&#8217;t proper hashing functions, they just illustrate the idea.

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace Bloom
{
    class Bloom
    {
        private BitArray bits = new BitArray(32);

        // two toy hashing functions,
        private Int16 rotateMore(String AddString)
        {
            Int16 ReturnValue = 0;
            for (int i = 0; i &lt; AddString.Length; i++)
            {
                ReturnValue += (Int16)((int)AddString[i] * i);
                ReturnValue = (Int16)(ReturnValue % 32);
            }
            return ReturnValue;
        }

        private Int16 rotate(String AddString)
        {
            Int16 ReturnValue = 0;
            for (int i = 0; i &lt; AddString.Length; i++)
            {
                ReturnValue += (Int16) ((int)AddString[i]);
                ReturnValue = (Int16) (ReturnValue % 32);
            }
            return ReturnValue;
        }
        public void add(String AddString)
        {
            Console.WriteLine("adding " + AddString);

            Int16 Point1 = this.rotate(AddString);
            Int16 Point2 = this.rotateMore(AddString);
            this.bits[Point1] = true;
            this.bits[Point2] = true;

        }
        public bool contains(String CheckString)
        {
            Int16 Point1 = this.rotate(CheckString);
            Int16 Point2 = this.rotateMore(CheckString);
            if (this.bits[Point1] && this.bits[Point2])
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        public void checkFor(String key)
        {
            if (this.contains(key))
            {
                Console.WriteLine(key + " may be in there");
            }
            else
            {
                Console.WriteLine(key + " is not there");
            }
        }
    }
    
    class Program
    {
        static void Main(string[] args)
        {
            Bloom bloom = new Bloom();
            bloom.add("string");
            bloom.add("fresh");
            bloom.add("basketball");
            bloom.checkFor("basketball");
            bloom.checkFor("soccer");
            Console.ReadLine();
        }
    }
}
```

The output of this will be:

<pre>adding string
adding fresh
adding basketball
basketball may be in there
soccer is not there
</pre>

 [1]: http://en.wikipedia.org/wiki/Bloom_filter
 [2]: http://billmill.org/bloomfilter-tutorial/
