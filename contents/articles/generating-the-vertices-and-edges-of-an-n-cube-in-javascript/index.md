---
title: Generating the vertices and edges of an n-cube in javascript
author: ben-wendt
layout: post
date: 2013-10-26
template: article.jade
url: /2013/10/26/generating-the-vertices-and-edges-of-an-n-cube-in-javascript/
categories:
  - Javascript
tags:
  - math
---
An [n-cube][1] is a geometric shape analogous to a cube, but in an arbitrary number of dimensions.

The algorithm I&#8217;ve laid out does a recursive routine for finding the vertices and then looks for all edges within one unit of each to define the edges.

<span class="more"></span>

The function becomes non-response with values over 14. This is because the number of points in an n-cube is given by 2<sup>n</sup> and the number of edges is n2<sup>n-1</sup>. So the expected memory usage of this function is O(2<sup>n</sup>), which is going to blow up with any fairly large value.

```javascript
var nCube = function(n) {

    if (n == 1) {
      return {
        "points" :[[0], [1]],
        "edges" : [[0, 1]]
      };
    } else {
      var L, i, j, prev = nCube(n - 1), out = {
        "dimensions" : n,
        "points" : [],
        "edges" : []
      };
        
      for (i = 0; i < prev.points.length; i++) {
        for (j = 0; j < 2; j++) {
          (function() {
            var fit = prev.points[i].slice();
            fit.push(j);
            out.points.push(fit);

          })();
        }
      }
      // surely there is a faster recursive method of defining edges, but...
      for (i = 0; i < out.points.length; i++) {
        for (j = i; j < out.points.length; j++) {
          if (i == j) continue;
          if (distance(out.points[i], out.points[j]) == 1) {
            out.edges.push([i,j]);
          }
        }
      }
        
      return out;
    }
  };


```

 [1]: http://en.wikipedia.org/wiki/Hypercube
