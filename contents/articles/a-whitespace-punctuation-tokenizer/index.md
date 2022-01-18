---
title: A Whitespace + Punctuation Tokenizer
author: ben-wendt
template: article.pug
layout: post
date: 2015-02-14
url: /2015/02/13/a-whitespace-punctuation-tokenizer/
categories:
  - python
tags:
  - search
---
In my previous post, I discussed some tokenization techniques and mentioned that a whitespace-only tokenizer will make tokens that are sub-optimal for indexing. I also mentioned that a simple solution to this is created a whitespace + punctuation tokenizer.

<span class="more"></span>

So let&#8217;s take a look at how that might work.

```python
import re

def whitespace_punctuation_tokenize(str, punctuation = "[\.,\"']"):
	tokens = re.split(punctuation + "*\s+" + punctuation + "*", str)
	if (tokens[0]):
		tokens[0] = re.sub("^" + punctuation + "+", "", tokens[0])
	if (tokens[-1]):
		tokens[-1] = re.sub(punctuation + "+$", "", tokens[-1])
	return tokens
```

You would run that code with something like this:

```python
str = """'abc-123' is a cool one. It's far and away the
	ring-tossingest toy this year."""

print whitespace_punctuation_tokenize(str)
print whitespace_punctuation_tokenize(str, "[\.,\"]")
```

From this, you would see output like the following:

> [&#8216;abc-123&#8242;, &#8216;is&#8217;, &#8216;a&#8217;, &#8216;cool&#8217;, &#8216;one&#8217;, &#8220;It&#8217;s&#8221;, &#8216;far&#8217;, &#8216;and&#8217;, &#8216;away&#8217;, &#8216;the&#8217;, &#8216;ring-tossingest&#8217;, &#8216;toy&#8217;, &#8216;this&#8217;, &#8216;year&#8217;]
  
> [&#8220;&#8216;abc-123&#8242;&#8221;, &#8216;is&#8217;, &#8216;a&#8217;, &#8216;cool&#8217;, &#8216;one&#8217;, &#8220;It&#8217;s&#8221;, &#8216;far&#8217;, &#8216;and&#8217;, &#8216;away&#8217;, &#8216;the&#8217;, &#8216;ring-tossingest&#8217;, &#8216;toy&#8217;, &#8216;this&#8217;, &#8216;year&#8217;] 

Here we see a function that does a regular expression split on an input string and accepts a configurable parameter of which characters to consider as punctuation. In this way, we can specify how want tokens to be delimited with a bit more granular control.

The function makes this split, then corrects and leading punctuation on the first element and any trailing punctuation on the last element. At this point you would have higher quality tokens to pass into your analysis chain.
