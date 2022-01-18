---
title: Finding the main content element on a page in javascript
author: ben-wendt
layout: post
template: article.pug
date: 2013-06-10
url: /2013/06/10/finding-the-main-content-element-on-a-page-in-javascript/
categories:
  - Javascript
tags:
  - content
---
Short of going to something more complex like measuring information or doing some natural language processing, you can estimate which element on a page contains the content by determining which element has the highest ratio of contained content to contained markup. Here&#8217;s a javascript snippet that does just that:

<pre class="brush: jscript; title: ; notranslate" title="">// not perfect obviously. Not terrible neither.

var id, tag;
var all = document.querySelectorAll('body *'), max = 0, el, i, L;

// list some commons ids that denote the outermost element on a page.
var badIds = {
    "wrapper" : 1,
    "container" : 1,
    "wrapper-content" : 1
};

// we don't want to include content from certain tags.
var badTags = {
	"SCRIPT" : 1,
	"STYLE" : 1,
	"HEADER" : 1
}

// the goal rate of markup per content
var contentPercent = 0.45;

var contentRatio = function(el) {
	var i, L, totalScript = 0, scripts = el.getElementsByTagName("script");
	for (i =0, L= scripts.length; i &lt; L; i++) {
		totalScript += scripts[i].length;
	}
	totalScript = 0;
	return (el.textContent.length - totalScript) / el.innerHTML.length;
};

for (i = 0, L =all.length; i &lt; L; i++) {
    id = all[i].getAttribute('id');
    tag = all[i].tagName;
    if (all[i].textContent && all[i].textContent.length &gt; max && (contentRatio(all[i]) &gt; contentPercent) && !badIds[id] && !badTags[tag]) {
        max = all[i].textContent.length;
        el = all[i];
    }
}

// show the results.
console.log(el)
console.log(el.textContent.length / el.innerHTML.length)

</pre>
