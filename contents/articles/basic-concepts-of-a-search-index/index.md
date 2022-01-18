---
title: Basic Concepts of a Search Index
author: ben-wendt
layout: post
date: 2015-01-31
template: article.pug
url: /2015/01/30/basic-concepts-of-a-search-index/
categories:
  - PHP
tags:
  - code
  - search
---
### Introduction

A text index is a way to store information about textual data to improve ease of retrieval. The basic idea is to store the information in such a way that it is possible to retrieve what you are looking for without doing a full scan of the data. A text index will do this by storing information about each indexed word separately. So where in the raw text you might have a text field with the contents &#8220;this is a description&#8221;, a full text index would store information about each individual word separately, so it would store a form of &#8220;this&#8221;, &#8220;is&#8221;, &#8220;a&#8221;, and &#8220;description&#8221;.

<span class="more"></span>

There are two motivations to using an indexing engine: speed and quality of results. Generally speaking, sifting through a massive amount of text is a slow process. (We discussed that earlier on this blog when we looked at the [Knuth-Morris-Pratt algorithm][1]). There are also numerous intricacies of language that can trip up a naive search that a search index can work around.

So let&#8217;s dive in, shall we?

### Tokenizing

The first stage of generating an index is to split the source text up into individual words or phrases. This stage is called &#8220;tokenizing.&#8221; A simple way of tokenizing text is the &#8220;white space tokenizing&#8221; technique, which basically splits text up by whitespace, as I did with &#8220;this is a description&#8221; earlier. But punctuation is a pitfall here. Without considering punctuation, tokenizing a phrase like &#8220;this is a pizza, and the pizza is good&#8221; would create separate and distinct tokens for each &#8220;pizza,&#8221; and &#8220;pizza&#8221;. This is generally not a desired outcome, so most tokenization algorithms will allow for a whitespace tokenizer that also accepts a list of punctuation characters. 

There is a lot more room for nuance in tokenization: for example what if you want to use a whitespace+punctuation tokenizer, but you have IP addresses that you want to be searchable in your data? Then tokenizing something like &#8220;The IP was 127.0.0.1&#8243; would yield separate tokens for &#8220;127&#8221;, &#8220;0&#8221; and &#8220;1&#8221;.

Another possible issue is that you may want multiple terms to be treated like single terms. For example, records that contain the phrase &#8220;magnetic resonance imaging&#8221; should be treated as more relevant in searches when the terms all appear together than when they are apart. There are different ways to approach this problem, but one is &#8220;NGram&#8221; tokenizing (this is a fancy way of saying that a given number N of adjacent terms will each be treated as one token).

The myriad nuances of tokenization are why industry leading search indices allow a developer to define their own tokenizing routine.

### Analysis

Fully featured search indices like ElasticSearch or Solr will allow a software developer to define an analysis chain on their indexed data. The analysis chain is a way of normalizing the language that will be indexed so that related terms will be able to match after the index has been created.

Once a collection of tokens is generated, further processing is generally desired before storing indexed terms. If a user searches for &#8220;skeet shooting&#8221;, records with &#8220;skeet shoot&#8221; should probably match. Generally this issue is tackled by storing &#8220;stemmed&#8221; words in the index, where the &#8220;stem&#8221; of a word is generally a form of the word with any suffixes removed. A popular stemmer is the &#8220;[Lovins Snowball stemmer][2].&#8221; (I recommend reading this link; it&#8217;s well-written and highly fascinating.)

There are two important points to consider here:

  1. Stemming is language specific. Suffixes that denote different meaning vary from language to language. And pictogram based languages are (to my knowledge) practically immune to this approach to stemming.
  2. Simple suffix removal is not a foolproof method of word stemming, for example &#8220;flammable&#8221; and &#8220;inflammable&#8221; have precisely the same meaning, but removing their suffixes leaves different stems. You wouldn&#8217;t want someone using your index to search for whether a product is flammable, and find no results because it is inflammable.

The solution to the first issue is to use different stemming algorithms for different languages. The solution to the second issue is to support synonyms in the search index; if the system is aware that flammable and inflammable represent the same thing, your users will find the safety information they need even if they use the term that isn&#8217;t in your data.

Proper analysis is where an indexing engine will beat out a text search in terms of quality of results.

### Storing

Storing indexed data can be done in any number of ways. The important thing is that lookups should be fast. Index sizes and data concerns will determine which data structure is best. For my demo code below I am using PHP so that basically limits me to using PHP&#8217;s built-in `array` data structure as a hash map.

### An example index

Here is a couple functions that create a simple index:

<pre class="brush: php; title: ; notranslate" title="">file_put_contents('index.dat', serialize(createIndex($records));

/**
* @param $record array collection of records
* @return array record collection combined with indices
*/
function createIndex($record) {
	$output = ['records' =&gt; $records, 'index' =&gt; []];
	foreach($records as $recordKey =&gt; $record) {
		$record = str_replace(array('.', ','), ' ', $record);
		$record = strtolower($record);
		$tokens = whitespaceTokenize($record);
		
		foreach($tokens as $token) {
			if (!isset($output['index'][$token])) {
				$output['index'][$token] = [];
			}
			$output['index'][$token][$recordKey] = 1;
		}
	}
	return $output;
}

/**
* @param $records array|string record or records to be split by white space.
* @return array tokenized collection
*/
function whitespaceTokenize($records) {
	$out = [];
	if (is_string($records)) {
		$records = [$records];
	}
	foreach($records as $record) {
		
		$out = array_merge($out, preg_split('/\s+/', $record));
	}
	return $out;
}
</pre>

Note how the indexer splits out terms then stores them in a hash that maps back to which record the term can be found in. This is the basic idea of a search index.

And here is a quick way to read matches from the index:

<pre class="brush: php; title: ; notranslate" title="">$index = unserialize(file_get_contents('index.dat'));

$keywords = strtolower($argv[1]);

$matches = array_keys($index['index'][$keywords]);
echo count($matches) . ' matches' . "\n";
foreach($matches as $matchKey =&gt; $match) {
	echo "$match =&gt; " . $index['records'][$match] . "\n";
}
</pre>

You will note here that I did not create a configurable punctuation + whitespace tokenizer. And in fact, none of the more advanced features I discussed earlier are implemented. This code is only meant to illustrate how an index works, not be fully featured. The basic concept here could be cleaned up, coded to a [generalized storage interface][3], and then the more advanced features could be added as needed to make a functioning search index written in pure PHP. 

### Conclusion

We have seen a mile-high overview of how a search index works, discussed the tokenization and analysis processes, briefly discussed storage, and seen just about the most basic working example of a search index. Search indices are a fascinating technology that empower users through services like Bing, Million Short, and Duck Duck Go to find information on the internet, but we have also identified some issues in the technology and hinted at some methods of dealing with these problems. We may take a more in-depth look at some of those solutions in a future post.

 [1]: /blog/?p=265
 [2]: http://snowball.tartarus.org/texts/introduction.html
 [3]: https://groups.google.com/forum/#!topic/php-fig/mBP6PmG0TqU
