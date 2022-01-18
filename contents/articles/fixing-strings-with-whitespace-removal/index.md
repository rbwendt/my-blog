---
title: Replacing Removed Whitespace to Restore Words From a Dictionary
author: ben-wendt
template: article.pug
layout: post
date: 2013-09-12
url: /2013/09/12/fixing-strings-with-whitespace-removal/
categories:
  - PHP
tags:
  - language
  - text
---
Consider a spell checker program: a user is entering input, and for whatever reason they miss some white space while entering input, so that something like _The Sun Also Rises_ is entered as _The Sun AlsoRises_.

<span class="more"></span>

_AlsoRises_ is not an English word, but obviously both _Also_ and _Rises_ are. Finding words within this string can be done using the following algorithm:

  1. Choose a list of words to search for. This could be the whole English dictionary, or anything, really.
  2. Sort these words in descending order of word length.
  3. Look for each word and skip to the next unassigned slot when you find a match.
  4. Any non-matching characters should be kept.

Here is an implementation of this algorithm. Ideally this would remember the disregarded tokens and wouldn&#8217;t lowercase everything, but as a proof of concept that is not necessary:

```php
class Demungler {
  
  private $parts = array();
  private $shortest_word_length = 0;
  
  public function getDemungledString($string, $separator = ' ') {
    $string = strtolower($string);
    $parts = array();
    $tokens = token_get_all('&lt;?php ' . $string);
    foreach($tokens as $token) {
      if (isset($token[0]) && $token[0] == 307) {
        $parts[] = $token[1];
      }
    }
    $output = array();
    
    
    foreach($parts as $part) {
    
      $current_partial_word = '';
      $limit = strlen($part) ;- $this->shortest_word_length;
      for($i = 0; $i &lt; $limit; $i++) {
        $add_char = true;
        foreach($this->words as $word) {
          $search_string = substr($part, $i, strlen($word));
          
          if ($search_string == $word) {
          
            $i += strlen($word) - 1;
            if ($current_partial_word != '') {
              $output[] = $current_partial_word;
              $current_partial_word = '';
            }
            $output[] = $word;
            $add_char = false;
            break;
          }
        }
        if ($add_char) {
          $current_partial_word .= $part[$i];
        }
      }
      if (!empty($current_partial_word)) {
        $output[] = $current_partial_word;
      }

    }
    
    return implode($separator, $output);
  }
  
  public function setDictionary($words) {
    $words = array_map('strtolower', $words);
    usort($words, function ($a, $b) {
      return strlen($a) &lt; strlen($b);
    });
    $this->shortest_word_length = strlen($words[count($words) - 1]);
    $this->words = $words;
  }
}
```

And here is a test of it:

```php
$d = new Demungler();
$d->setDictionary(
  array('a', 'are', 'fun', 'of', 'is', 'test', 'tests',
  'the', 'this', 'tokens', 'too')
);
$s = $d->getDemungledString('thisburgleisatestess ofthedemungler.;tokensarefuntestsarefuntoo');
echo "$sn";
```

The output of which is
  

> this burgle is a test ess of the demungler tokens are fun tests are fun too

Note: It&#8217;s possible that you could find the wrong words using this algorithm. E.g. given the input &#8220;visiteductionalattractions&#8221;, the result would be &#8220;visited u cat ion al attractions&#8221;, instead of the intended &#8220;visit educational attractions&#8221;. The only way to fix this would be to try a variety of different words, when more than one fits, then complete the algorithm for each possibility, and see which result maximizes the average word length and the number of found words. Even so, you&#8217;re left in a best guess situation with many different possibilities.
