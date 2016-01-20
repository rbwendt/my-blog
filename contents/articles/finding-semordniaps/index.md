---
title: Finding Semordnilaps
author: ben-wendt
layout: post
date: 2015-04-18
url: /2015/04/18/finding-semordniaps/
template: article.jade
categories:
  - ruby
tags:
  - language
---
My wife recently developed an interest in semordnilaps, so I thought I would take a stab at writing a script that will find some. What I came up with finds a subset of all two word to two word semordnilaps. Generally you don&#8217;t consider whitespace and punctuation in palindromes and semordnilaps, so this code doesn&#8217;t either.

<span class="more"></span>


It turns out that filtering out proper names vastly reduces the number of semordnilaps found, and I didn&#8217;t really appreciate the ones which contained proper names anyway, so I took those out.

<pre class="brush: ruby; title: ; notranslate" title="">words = {}
File.open("/usr/share/dict/words") do |file|
  file.each do |line|
    if line.length &gt; 4 # don't accept one or two letter words.
      word = line.strip
      next if word.downcase != word # proper names have capitals, exclude those.
      words[word.downcase.gsub(/[^a-z]/, '')] = true
    end
  end
end

words.each do |word1, k|  
  p_words = {}
  word_finds = 0
  
  word1 = word1.reverse
  first_words = []
  # skip words that when reversed don't match the ending of another word.
  (1 .. (word1.length - 1)).each do |i|
    if words[word1[0..i]]
      first_words &lt;&lt; word1[0..i]
    end
  end
  if first_words.count == 0
    next
  end

  words.each do |word2, k|  
    two_words = word1 + word2.reverse    
    (2 .. two_words.length).each do |i|
   	if words[two_words[0..(i - 1)]] && words[two_words[i..(two_words.length-1)]]
   	  p_words[two_words[0..(i - 1)] + ' ' + two_words[i..(two_words.length-1)]] = word2 + ' ' + word1.reverse
   	  word_finds += 1
   	end
    end
  end
  if word_finds &gt; 0
    puts p_words
  end
end

</pre>

And this gives you some great semordnilaps like:

  * &#8220;cite catnip&#8221;=>&#8221;pint acetic&#8221;
  * &#8220;stub aloof&#8221;=>&#8221;fool abuts&#8221;
  * &#8220;tubas gals&#8221;=>&#8221;slags abut&#8221;
  * &#8220;sane railed&#8221;=>&#8221;deli arenas&#8221;
  * &#8220;reis trailed&#8221;=>&#8221;deli artsier&#8221;
  * &#8220;diva lived&#8221;=>&#8221;devil avid&#8221;
  * &#8220;stabs faced&#8221;=>&#8221;decafs bats&#8221;

All told, I got a 2.7MB text file. I am sure that there are better ones in there.
