---
title: Longest Common Substring in PHP
author: ben-wendt
layout: post
date: 2013-06-11
template: article.jade
url: /2013/06/11/longest-common-substring-in-php/
categories:
  - PHP
tags:
  - algorithms
  - strings
---
Longest common substring is a function that can be useful once in a while. Here&#8217;s a PHP implementation. Be forewarned, this runs in `O(mn)` time.

<pre class="brush: php; title: ; notranslate" title="">function longest_common_substring($string1, $string2) {
	$L = array();
	$length = 0;
	$pos = 0;
	$array1 =str_split($string1);
	$array2 =str_split($string2);
	foreach ($array1 as $i =&gt; $c1) { 
		$L[$i] = array();
		foreach ($array2 as $j =&gt; $c2) { 
			$L[$i][$j] = 0;
			if ($c1 == $c2) {
				if ($i == 0 || $j == 0) {
					// initialize that this character position exists.
					$L[$i][$j] = 1;
				} else {
					// increment previous or reset.
					if (isset($L[$i-1][$j-1])) {
						$L[$i][$j] = $L[$i-1][$j-1] + 1;
					} else {
						$L[$i][$j] = 0;
					}
				}
				if ($L[$i][$j] &gt; $length) {
					$length = $L[$i][$j];
				}
				if ((isset($L[$i][$j]))&&($L[$i][$j] == $length)) {
					$pos = $i;
				}
			}
		}
	}
	if ($length &gt; 0) {
		return substr($string1, $pos - $length + 1, $length);
	} else {
		return '';
	}
}

</pre>

Usage:

<pre class="brush: php; title: ; notranslate" title="">$string1 = 'sadjjasdf this is the string  sdlkjhaskl';
$string2 = 'eriuhysdfnbasi this is the stringbhdjubsdi';

echo longest_common_substring($string1, $string2);
</pre>
