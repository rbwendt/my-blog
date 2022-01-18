---
title: A Lattice class
author: ben-wendt
layout: post
template: article.pug
date: 2013-10-09
url: /2013/10/09/a-lattice-class/
categories:
  - PHP
tags:
  - data structures
---
Consider if you need a 7-dimensional lattice data structure. An array is great for one-dimensional data but once you add dimensions things quickly get difficult to manage. Here&#8217;s a data structure that takes away some of that headache:
<span class="more"></span>
<pre class="brush: php; title: ; notranslate" title="">&lt;?php

class Lattice {
	
	private $lattice = null;
	private $dimensions = 0;
	private $boundaries = null;

	public function setDimensions($d) {
		if (is_integer($d)) {
			$this-&gt;dimensions = $d;
		} else {
			throw new Exception('setDimensions expects an integer. given: ' . $d);
		}
	}
	public function getDimensions() {
		return $this-&gt;dimensions;
	}
	public function setBoundaries(array $boundaries) {
		$iteration = count($boundaries);
		if ($this-&gt;dimensions &gt; 0 && $this-&gt;dimensions == count($boundaries)) {
			$this-&gt;boundaries = $boundaries;
			$array = null;
			while ($iteration &gt; 0) {
				$iteration --;
				$array = array_fill(0, $boundaries[$iteration], $array);
			}
			$this-&gt;lattice = $array;
		} else {
			throw new Exception("Boundary count should match dimension count");
		}
	}
	public function setNode(array $coordinates, $value) {
		if (count($coordinates) != $this-&gt;dimensions) {
			throw new Exception("Passed coordinates have dimension mismatch");
		}
		$iteration = 0;
		$array = &$this-&gt;lattice;
		while ($iteration &lt; count($coordinates) - 1) {
			$coordinate = $coordinates[$iteration];
			
			if ($coordinate &gt; $this-&gt;boundaries[$iteration] - 1) {
				throw new Exception("coordinate $iteration is out of bounds");
			}
			$array = &$array[$coordinate];
			$iteration++;
		}
		$coordinate = $coordinates[$iteration];
		if ($coordinate &gt; $this-&gt;boundaries[$iteration] - 1) {
			throw new Exception("coordinate $iteration is out of bounds");
		}
		$array[$coordinate] = $value;
	}
	public function getNode(array $coordinates) {
		if (count($coordinates) != $this-&gt;dimensions) {
			throw new Exception("Passed coordinates have dimension mismatch");
		}
		$iteration = 0;
		$array = &$this-&gt;lattice;
		while ($iteration &lt; count($coordinates) - 1) {
			$coordinate = $coordinates[$iteration];
			
			if ($coordinate &gt; $this-&gt;boundaries[$iteration] - 1) {
				throw new Exception("coordinate $iteration is out of bounds");
			}
			$array = &$array[$coordinate];
			$iteration++;
		}
		$coordinate = $coordinates[$iteration];
		if ($coordinate &gt; $this-&gt;boundaries[$iteration] - 1) {
			throw new Exception("coordinate $iteration is out of bounds");
		}
		return $array[$coordinate];
	}
	public function toArray() {
		return $this-&gt;lattice;
	}
}

</pre>
