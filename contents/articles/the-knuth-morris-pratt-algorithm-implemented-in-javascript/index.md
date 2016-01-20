---
title: The Knuth-Morris-Pratt algorithm implemented in JavaScript
author: ben-wendt
layout: post
template: article.jade
date: 2013-09-20
url: /2013/09/20/the-knuth-morris-pratt-algorithm-implemented-in-javascript/
categories:
  - Javascript
tags:
  - algorithms
---
The [Knuth-Morris-Pratt string search algorithm][1] is an algorithm for finding a substring within another string that uses information calculated about the substring to speed up the search process.

<span class="more"></span>

Before looking through the text to be searched, a table of jump lengths is calculated from the search string. Rather than iterating through the whole string, you can determine how many characters to skip over based on the structure of the word being searched for. As you scan through the search text and you find a mismatch, you can start comparing characters again from the last matching substring between the search term and the search text. 

E.g. if you are searching through [T-Bone by Neil Young][2] for the words &#8220;Ain&#8217;t got no T-BonenT-Bone&#8221;, every time you find an instance of &#8220;&#8221;Ain&#8217;t got no T-Bonen&#8221; that isn&#8217;t followed by a line-break, you can skip 20 characters of checking the lyrics and restart from the beginning of your words, because you know that they can&#8217;t occur again within that span because you have already checked those and they don&#8217;t match the begging of the search words. Basically you already know that index is the next occurence of Ain&#8217;t, so you can start again from there.

```javascript
var makeKMPTable = function(word) {
	if(Object.prototype.toString.call(word) == '[object String]' ) {
		word = word.split('');
	}
	var results = [];
	var pos = 2;
	var cnd = 0;
		
	results[0] = -1;
	results[1] = 0;
	while (pos &lt; word.length) {
		if (word[pos - 1] == word[cnd]) {
			cnd++;
			results[pos] = cnd;
			pos++;
		} else if (cnd &gt; 0) {
			cnd = results[cnd];
		} else {
			results[pos] = 0;
			pos++;
		}
	}
	return results;
};

var KMPSearch = function(string, word) {
	if(Object.prototype.toString.call(string) == '[object String]' ) {
		string = string.split('');
	}
	if(Object.prototype.toString.call(word) == '[object String]' ) {
		word = word.split('');
	}
		
	var index = -1;
	var m = 0;
	var i = 0;
	var T = makeKMPTable(word);
		
	while (m + i &lt; string.length) {
		if (word[i] == string[m + i]) {
			if (i == word.length - 1) {
				return m;
			}
			i++;
		} else {
			m = m + i - T[i];
			if (T[i] &gt; -1) {
				i = T[i];
			} else {
				i = 0;
			}
		}
	}
	return index;
};

var test = 'potential';

var string = "This fact implies that the loop can execute at most 2n times. For, in each iteration, it " +
	"executes one of the two branches in the loop. The first branch invariably increases i and does not " +
	"change m, so that the index m + i of the currently scrutinized character of S is increased. The second " +
	"branch adds i - T[i] to m, and as we have seen, this is always a positive number. Thus the location m " +
	"of the beginning of the current potential match is increased. Now, the loop ends if m + i = n; " +
	"therefore each branch of the loop can be reached at most k times, since they respectively increase " +
	"either m + i or m, and m = m + i: if m = n, then certainly m + i = n, so that since it increases by " +
	"unit increments at most, we must have had m + i = n at some point in the past, and therefore either " +
	"way we would be done.";

result = KMPSearch(string, test);
```

 [1]: http://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm
 [2]: http://www.lyricsfreak.com/n/neil+young/t+bone_20536423.html
