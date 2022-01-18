---
title: Weighted merging of multiple Markov Chains
author: ben-wendt
layout: post
date: 2013-12-04
template: article.pug
url: /2013/12/04/weighted-merging-of-multiple-markov-chains/
categories:
  - PHP
tags:
  - helpful classes
  - math
---
Suppose you have ten text sources, and you generate a new block of text trained from each, and you want to give each its own weighting. You have to weave multiple markov chains together.
<span class="more"></span>
Here is a class that does just that.

```php
class MultiMarkov {
	private $files;
	private $chains = array();
	private $weights = array();
	private $total_weight = 0;
	public function __construct($init) {
		$total_weight = 0;
		foreach($init as $label => $file_settings) {
			$file = $file_settings['file'];
			$weight = $file_settings['weight'];
			if (!is_integer($weight) || $weight &lt;= 0) {
				throw new Exception (
					"Weight $weight is not a positive integer.");
			}
			$total_weight += $weight;
			$this->weights[$label] = $weight;
			$words = get_all_words_in_file($file);
			$chain = new Chain($words);
			$this->chains[$label] = $chain;
		}
		$this->total_weight = $total_weight;
	}
	public function setWeights($weights) {
		foreach($weights as $label => $weight) {
			$this->weights[$label] = $weight;
		}
	}
	public function getWeightedRandomChain() {
		$rand = rand(0, $this->total_weight);
		$running_total = 0;
		foreach($this->weights as $label => $weight) {
			$running_total += $weight;
			if ($running_total > $rand) {
				break;
			}
		}
		// echo "$labeln";
		return $this->chains[$label];
	}
	public function getRandomWord() {
		$from_chain = $this->getWeightedRandomChain();
		return $from_chain->getRandomWord();
	}
	public function getChainOfLength($in_word, $length) {
		
		while (!isset($word) || $word == false) {
			$from_chain = $this->getWeightedRandomChain();
			$word = $from_chain->getNextWord($in_word);
			
		} 
		if ($length > 1) {
			return $word . $this->getChainOfLength($word, $length - 1);
		} else {
			return $word;
		}
	}
}
```

To use this class you could do something like so:

```php

<?php 

include 'markov.php';
include 'multi-markov.php';

$files = array(
	'joyce' => array(
		'file' => 'text/joyce.txt',
		'weight' => 10
	),
	'weitz' => array(
		'file' => 'text/weitz.txt',
		'weight' => 20
	),
	'sontag' => array(
		'file' => 'text/sontag.txt',
		'weight' => 15
	),
	'berger' => array(
		'file' => 'text/berger.txt',
		'weight' => 10
	),
	'tolstoy' => array(
		'file' => 'text/tolstoy.txt',
		'weight' => 19
	),
	
);

$builder = new MultiMarkov($files);
$starting_word = $builder->getRandomWord();

$newSentence = $builder->getChainOfLength($starting_word, 160);
echo wordwrap($newSentence, 70, "n");
```

This text is trained from a variety of great writers writing about aesthetics and the nature of art. Here&#8217;s a sample of the output:

> praise worthy on the conditions
> under which has drawn it seemed to
> me that of reassembling what we would call these conditions ù a novel,
> painting, to its subject, remains the concept shows, has hardly broken
> into the standard of all other world, have painted the result of color
> that &#8220;This is often experienced as to himself; so, thanks
> to fate or love to see in the faculty of a common properties of the
> world that supreme quality
> of true painting or theory again. Of course,&#8221;Art is very perception of
> art. Whatis central as a fading coal. The destiny of the word has
> experienced, and everything else&#8230; For myself, I am speaking now
> that basket from everything else. Each claims that are made by
> accident when he experiences the oar or that its claim to be answered
> yes or even seem to be maintained is definable as works of application
> of movements, lines, colors, shapes, volumes &#8211; and sufficient
> conditions.
