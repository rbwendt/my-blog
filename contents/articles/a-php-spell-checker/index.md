---
title: A PHP spell checker
author: ben-wendt
layout: post
date: 2013-10-21
template: article.jade
url: /2013/10/21/a-php-spell-checker/
categories:
  - PHP
tags:
  - algorithms
  - language
---
[How to Write a Spelling Corrector][1], by Peter Norvig, is a popular resource for instructions on how to produce spell check functionality. That page does some statistical Analysis of how this algorithm works and is definitely worth reading.

I&#8217;ve rewritten this alghorithm in PHP. It&#8217;s not as eloquent as the python code in the original, but I suspect it gains a tiny bit of readability in the trade-off for terseness.

<span class="more"></span>
A basic outline of the routine is as follows:

  1. Train the spell checker in what words it should know. Any large block of text in the desired language that contains all the words you want to be spell-checkable, and no others, will do. This introduces a chicken-egg issue as you may have misspellings in your training text. Ideally, you would use a previously verified dictionary for this step. But you could use anything, like a bunch of crawled text from wikipedia, or this blog, or the complete works of Charles Dickens, or whatever reference you choose.
  2. Generate a list of candidate words within a given [Levenshtein distance][2] of the word you are attempting to correct. 
      * All candidate words will be found within a predefined number of character deletions, character transpositions, and character insertions on the original word.
      * Candidates will be in the trained text.
      * A given candidate can be reached in more than one way depending on which deletions, transpositions, and insertions are performed. We will exploit this fact.
    
    The list of suggestions will be ranked by which suggestions arise most frequently.</li> 
    
      * Choose one or more suggestions from your list as required</ol> 
    
    Here&#8217;s the PHP class:
    
    <pre class="brush: php; title: ; notranslate" title="">&lt;?php

class checker {
	private $nwords = array();
	private function words($text) {
		return preg_split('/s+/', $text);
	}
	public function train($words) {
		$this-&gt;nwords = array_flip($this-&gt;words($words));
	}
	private function edits1($word) {
		$word = strtolower($word);
		$alphabet = range('a', 'z');
		
		$splits = array();
		for ($i = 1; $i &lt; strlen($word); $i++) {
			$splits[] = array(substr($word, 0, $i), substr($word, $i));
		}
		$deletes = array();
		foreach($splits as $split) {
			$deletes[] = $split[0] . substr($split[1], 1);
		}
		$transposes = array();
		foreach($splits as $split) {
			if (isset($split[1][1])) {
				$transposes[] = $split[0] . $split[1][1] . $split[1][0] . substr($split[1], 2);
			}
		}
		$replaces = array();
		foreach($alphabet as $letter) {
			foreach($splits as $split) {
				$replaces[] = $split[0] . $letter . substr($split[1], 1);
			}
		}
		$inserts = array();
		foreach($alphabet as $letter) {
			foreach($splits as $split) {
				$inserts[] = $split[0] . $letter . $split[1];
			}
		}
		return array_merge($deletes, $transposes, $replaces, $inserts);
	}
	private function edits2($word) {
		$edits2 = array();
		foreach($this-&gt;edits1($word) as $e1) {
			foreach($this-&gt;edits1($e1) as $e2) {
				if (isset($this-&gt;nwords[$e2])) {
					$edits2[] = $e2;
				}
			}
		}
		return $edits2;
	}
	private function known($word) {
		$known = array();
		if (isset($this-&gt;nwords[$word])) {
			$known[] = $word;
		}
		return $known;
	}
	public function correct($word) {
		$candidates = array();
		if ($this-&gt;known($word)) {
			$candidates[] = $word;
		}
		foreach($this-&gt;edits1($word) as $possible) {
			if ($this-&gt;known($possible)) {
				$candidates[] = $possible;
			}
		}
		foreach($this-&gt;edits2($word) as $possible) {
			if ($this-&gt;known($possible)) {
				$candidates[] = $possible;
			}
		}
		$counts = array();
		foreach($candidates as $candidate) {
			if (!isset($counts[$candidate])) {
				$counts[$candidate] = 0;
			} else {
				$counts[$candidate]++;
			}
		}
		$most = 0;
		$word = '';
		foreach($counts as $candidate =&gt; $count) {
			if ($count &gt; $most) {
				$most = $count;
				$word = $candidate;
			}
		}
		return $word;
	}
}
</pre>
    
    Usage:
    
    <pre class="brush: php; title: ; notranslate" title="">$spell = new checker();

$spell-&gt;train(file_get_contents('dictionary.txt'));

$corrections = $spell-&gt;correct('speling');

echo "$correctionsn";
</pre>

 [1]: http://norvig.com/spell-correct.html
 [2]: http://en.wikipedia.org/wiki/Levenshtein_distance
