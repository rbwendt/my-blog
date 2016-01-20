---
title: Simple Markov Chain in PHP
author: ben-wendt
layout: post
date: 2013-05-30
url: /2013/05/30/simple-markov-chain-in-php/
categories:
  - PHP
tags:
  - algorithms
  - markov
template: article.jade
---
Here&#8217;s a simple Markov chain implementation in PHP, loosely adapted from this excellent write up about [implementing Markov chains in javascript][1]:

<pre class="brush: php; title: ; notranslate" title="">class Link {
	private $nexts = array();
	public function addNextWord($word) {
		if (!is_string($word)) {
			throw new Exception('addNextWord method in Link class is run with an string parameter');
		}
		if (!isset($this-&gt;nexts[$word])) {
			$this-&gt;nexts[$word] = 0;
		}
		$this-&gt;nexts[$word]++;
	}
	public function getNextWord() {
		$total = 0;
		foreach($this-&gt;nexts as $word =&gt; $count) {
			$total += $count;
		}
		$randomIndex = rand(1, $total);
		$total = 0;
		foreach($this-&gt;nexts as $word =&gt; $count) {
			$total += $count;
			if ($total &gt;= $randomIndex) {
				return $word;
			}
		}
	}
}

class Chain {
	private $words = array();
	function __construct($words) {
		if (!is_array($words)) {
			throw new Exception('Chain class is instantiated with an array');
		}
		
		for($i = 0; $i &lt; count($words); $i++) {
			$word = (string) $words[$i];
			if (!isset($this-&gt;words[$word])) {
				$this-&gt;words[$word] = new Link();
			}
			if (isset($words[$i + 1])) {
				$this-&gt;words[$word]-&gt;addNextWord($words[$i + 1]);
			}
		}
	}
	public function getChainOfLength($word, $i) {
		if (!is_string($word)) {
			throw new Exception('getChainOfLength method in Chain class is run with an string parameter');
		}
		if (!is_integer($i)) {
			throw new Exception('getChainOfLength method should be called with an integer');
		}
		if (!isset($this-&gt;words[$word])) {
			return '';
		} else {
			$chain = array($word);
			for ($j = 0; $j &lt; $i; $j++) {
				$word = $this-&gt;words[$word]-&gt;getNextWord();
				$chain[] = $word;
			}
			return implode(' ', $chain);
		}
	}
}
</pre>

And here is an example of usage:

<pre class="brush: php; title: ; notranslate" title="">function get_all_words_in_file($file) {
	return preg_split('/s+/ ', file_get_contents($file));
}

$file = 'testtext2.txt';

$words = get_all_words_in_file($file);
$chain = new Chain($words);
$newSentence = $chain-&gt;getChainOfLength('The', 200);
echo wordwrap($newSentence, 80, "n");
</pre>

Conceptually, a Markov chain captures the idea of likelihood of traversing from state to state. You can populate this data for a block of text by passing through a block of text and counting the number of occurrences of words that follow a given word. You can then use this data to generate new blocks of text.

 [1]: http://blog.javascriptroom.com/2013/01/21/markov-chains/
