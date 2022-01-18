---
title: Skip List Implementation in PHP
author: ben-wendt
layout: post
date: 2013-08-13
template: article.pug
url: /2013/08/13/skip-list-implementation-in-php/
categories:
  - PHP
tags:
  - data structures
  - list
---
A skip list is similar to a linked list, but it is always sorted and maintains multiple pointers. The multiple pointers allow fast traversal of the list so that you can quickly look for elements, essentially performing a binary search on the data.

<span class="more"></span>

Here&#8217;s an implementation of skip list in PHP:


```php
<?php 
class SkipList {
	
	// # implement a skip list with a given depth.
	// # this data structure is used to rapidly search
	// # through a multiply-linked (sorted) list,
	// # mimicking the functionality of a binary
	// # sort using references.

	// # The private properties here are the first
	// # node and the depth, which is the number
	// # of levels of references to maintain.
	// # E.g. a depth of 3 will maintain 3 levels of
	// # pointers, so that each subsequent level of
	// # reference will allow for more fine-grained
	// # access than the one before.
	
	private $_first = array();
	private $_depth = 0;

	// # We construct with an array. This is then
	// # sorted (so use a sortable array) and references
	// # are made for the given or predefined depth.

	public function __construct($list, $depth = null) {
		if (!is_array($list)) {
			throw new Exception(
				'SkipList constructor called with invalid list parameter'
			);
		}
		if (!is_numeric($depth)) {
			throw new Exception(
				'SkipList constructor called with invalid depth parameter'
			);
		}
		$this->_depth = $depth;
		sort($list);
		foreach($list as $lkey => $item) {
			$list[$lkey] = new SkipListNode($item);
		}
		for ($i = 0; $i < $depth; $i++) {
			for ($j = 0; $j < count($list) / pow(2, $i); $j++) {
				$index = $j * pow(2, $i);
				$next_index = ($j + 1) * pow(2, $i);
				$next_node = isset($list[$next_index]) ?
					$list[$next_index] : null;
				$list[$index]->setNext($next_node, $i);
			}
		}
		$this->_first = $list[0];
	}

	public function getFirst() {
		return $this->_first;
	}

	public function getDepth() {
		return $this->_depth;
	}

	// # for a perfect skip-list implementation you'd
	// # reweight the references every so often, so
	// # that you don't end up with giant amounts of
	// # data between two references and very little
	// # between others. This implementation does not
	// # do that.

	public function insertValue($value) {
		// inserts the value at the lowest level.
		// ideally you'd shuffle everything around
		// once in a while to ensure it's still efficient.
		$new_node = new SkipListNode($value);
		$node = $this->_first;
		do {
			if (false) {
				 "oops never implemented. lol";
			} else {
				$node = $node->getNext(0);
			}
		} while ($node != null);
	}
	
	// # The whole point of this is to be able to tell quickly
	// # whether or not a list contains a given value.

	public function contains($value) {
		$found = false;
		$node = $this->_first;
		$depth = $this->_depth - 1;
		do {
			if ($node->getValue() == $value) {
				$found = $node;
			} if ($node->getValue() > $value) {
				break;
			} else if ($node->getNext($depth) != null && $node->getNext($depth)->getValue() > $value) {
				$depth--;
				continue;
			} else {
				$node = $node->getNext($depth);
			}
		} while ($depth >= 0 && $node != null);
		
		return $found;
	}

}

class SkipListNode {
	private $_value;
	private $_nexts = array();
	public function setValue($value) {
		$this->_value = $value;
	}
	public function getValue() {
		return $this->_value;
	}
	public function getNext($depth) {
		return $this->_nexts[$depth];
	}
	public function setNext($node, $depth) {
		$this->_nexts[$depth] = $node;
	}
	public function __construct($value) {
		$this->setValue($value);
	}
}
```

Example Usage:

```php
$array = array('this', 'is', 'a', 'way', 'to', 'test');
$depth = 5;
$list = new SkipList($array, $depth);
if ($list->contains('is')) {
        echo "list contains 'is'.n";
}
```
