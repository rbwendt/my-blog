---
title: A NavigableMap inspired class for PHP
author: ben-wendt
layout: post
date: 2013-08-26
template: article.pug
url: /2013/08/26/a-navigablemap-inspired-class-for-php/
categories:
  - PHP
tags:
  - data structures
  - helpful classes
---
Java has a nifty class named [`NavigableMap`][1]. It abstracts away some of the logic for mapping ranges to values. Java is reknowned for it's ridiculously large library of collections.

<span class="more"></span>


Here&#8217;s a PHP implementation of some of its functionality.

```php
class NavigableMap {
  private $data = array();
  private function checkKeyNumeric($key) {
    if (!is_numeric($key)) {
      throw new Exception("keys must be numeric. Given $key");
    }
  }
  public function put($key, $value) {
    $this-&gt;checkKeyNumeric($key);
    $this-&gt;data[$key] = $value;
    ksort($this-&gt;data);
  }
  public function firstEntry() {
    return key($this-&gt;data);
  }
  public function lastEntry() {
    $end = key($this-&gt;data);
    reset($this-&gt;data);
    return $end;
  }
  public function floorEntry($point) {
    return $this-&gt;data[$this-&gt;floorKey($point)];
  }
  public function floorKey($point) {
    $this-&gt;checkKeyNumeric($point);
    $lowest = $this-&gt;firstEntry();
    if ($lowest &gt; $point) {
      throw new OutOfBoundsException("no point exists " .
            "below $point. Lowest map entry is $lowest");
    }
    foreach($this-&gt;data as $key =&gt; $value) {
      if ($key &gt; $point) {
        return $previous_key;
      }
      $previous_key = $key;
    }
    return $previous_key;
  }
  public function ceilingEntry($point) {
    return $this-&gt;data[$this-&gt;ceilingKey($point)];
  }
  public function ceilingKey($point) {
    $this-&gt;checkKeyNumeric($point);
    $highest = $this-&gt;lastEntry();
    if ($highest &lt; $point) {
      throw new OutOfBoundsException("no point exists " .
            "above $point. Highest map entry is $highest");
    }
    $keys = array_reverse(array_keys($this-&gt;data));
    foreach($keys as $key) {
      if ($key &lt; $point) {
        return $previous_key;
      }
      $previous_key = $key;
    }
    return $previous_key;
  }
}
```

 [1]: http://docs.oracle.com/javase/6/docs/api/java/util/NavigableMap.html
