---
title: Using Shared Strings to Reduce Memory Usage
author: ben-wendt
layout: post
template: article.jade
date: 2013-09-27
url: /2013/09/27/using-shared-strings-to-reduce-memory-usage/
categories:
  - PHP
tags:
  - data structures
  - helpful classes
---
As of Excel 2007, files are saved in the Open XML format. This format is comprised of a grouping of XML files and assets, which are then zipped up and given the `.xlsx` extension. It&#8217;s a lot more readable from other programs than an old fashioned `.xls` file.

One means that was used to reduce the file size was setting up a [shared strings table][1]. Strings stored in a spreadsheet are given a numeric index and this numeric index is then stored in the xml file. In general, if a string is reused frequently the overhead of the shared string map will be payed off by the saving of only storing string indices. 

<span class="more"></span>

For example, consider the following spreadsheet:

<table>
  <tr>
    <td>
      reused string
    </td>
    
    <td>
      reused string
    </td>
    
    <td>
      reused string
    </td>
    
    <td>
      <td>
        reused string
      </td></tr> 
      
      <tr>
        <td>
          other string
        </td>
        
        <td>
        </td>
        
        <td>
          reused string
        </td>
        
        <td>
          reused string
        </td>
        
        <td>
          other string
        </td>
      </tr>
      
      <tr>
        <td>
          reused string
        </td>
        
        <td>
          reused string
        </td>
        
        <td>
          reused string
        </td>
        
        <td>
          reused string
        </td>
        
        <td>
        </td>
      </tr>
      
      <tr>
        <td>
          reused string
        </td>
        
        <td>
          reused string
        </td>
        
        <td>
          reused string
        </td>
        
        <td>
          reused string
        </td>
        
        <td>
          other string
        </td>
      </tr>
      
      <tr>
        <td>
          other string
        </td>
        
        <td>
        </td>
        
        <td>
        </td>
        
        <td>
          reused string
        </td>
        
        <td>
        </td>
      </tr></table> 
      

This could be shortened to:
      
```
1 => reused string
2 => other string
```
      
<table>
<tr>
<td>
1
</td>

<td>
1
</td>

<td>
1
</td>

<td>
<td>
1
</td></tr> 

<tr>
<td>
2
</td>

<td>
</td>

<td>
1
</td>

<td>
1
</td>

<td>
2
</td>
</tr>

<tr>
<td>
1
</td>

<td>
1
</td>

<td>
1
</td>

<td>
1
</td>

<td>
</td>
</tr>

<tr>
<td>
1
</td>

<td>
1
</td>

<td>
1
</td>

<td>
1
</td>

<td>
2
</td>
</tr>

<tr>
<td>
2
</td>

<td>
</td>

<td>
</td>

<td>
1
</td>

<td>
</td>
</tr></table> 
            

The Open XML format has other space savings, like not storing empty cells, but that is not relevant here.

Even with the clunky HTML table structure above, using shared strings has reduced the number of characters used to store this data from 547 down to 362.

The same idea can be applied when you have a program that is saving thousands of reused strings. Saving integers is much more efficient. The size of a PHP integer is platform dependent, but generally 32-bits, while a string will use 1 or more bytes per character. If you know you are dealing with something with a lot of string reuse, something like this can be useful.

Here&#8217;s an implementation in PHP. You can start by throwing strings into the collection by calling <code>getIndex</code>. Then, when you are ready to pull the strings back out, call <code>getString</code>. Note that the class has an insertion mode and an extraction mode, and that when it changes mode a call to <code>array_flip</code> is made on the internal listing of entries. This is done to speed up the process (by using hashing on both operations rather than doing array searches); the down side is that if you are frequently changing back and forth between reading and writing, it will be slow. It&#8217;s meant to be written to all at once, then read off later.
            
```php
class SharedString {
	private $map = array();
	private $extraction_mode = false;
	public function count() {
		return count($this-&gt;map);
	}
	public function getIndex($string) {
		if ($this-&gt;extraction_mode) {
			$this-&gt;map = array_flip($this-&gt;map);
			$this-&gt;extraction_mode = false;
		}
		$string =  preg_replace('/s/', ' ', $string);
		$position = isset($this-&gt;map[$string]) ? $this-&gt;map[$string] : false;
		if ($position === false) {
			$position = count($this-&gt;map);
			$this-&gt;map[$string] = $position;
		} 
		return $position;
		
	}
	public function getString($index) {
		if (!$this-&gt;extraction_mode) {
			$this-&gt;map = array_flip($this-&gt;map);
			$this-&gt;extraction_mode = true;
		}
		return $this-&gt;map[$index];
	}
	static function mapArray(SharedString $string, $array) {
		foreach($array as $key =&gt; $value) {
			$array[$key] = $string-&gt;getIndex($value);
		}
		return $array;
	}
}
```
            
PHP doesn&#8217;t have great control over types, but you can make further memory reductions, as Open XML does, but not saving numerics as strings. These use less memory when stored as their appropriate type. E.g. in Ascii <code>12345</code> takes 5 bytes, but stored in a signed integer it only takes 16 bits.

 [1]: http://msdn.microsoft.com/en-us/library/office/gg278314.aspx
