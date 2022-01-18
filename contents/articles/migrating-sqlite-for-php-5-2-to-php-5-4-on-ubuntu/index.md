---
title: Migrating SQLite for PHP 5.2 to PHP 5.4 on Ubuntu
author: ben-wendt
layout: post
template: article.pug
date: 2014-06-14
url: /2014/06/14/migrating-sqlite-for-php-5-2-to-php-5-4-on-ubuntu/
categories:
  - PHP
tags:
  - database
---
PHP 5.4 discontinued support for SQLite 2 databases. Updating an old legacy PHP application with a SQLite database to a new server is not very difficult.

<span class="more"></span>

To start off, you will need the SQLite binaries so that you can convert the database between versions:

<pre class="brush: bash; title: ; notranslate" title="">sudo apt-get install sqlite sqlite3
</pre>

Now that you have the binaries installed, you can convert your version 2 SQLite database to version 3:

<pre class="brush: bash; title: ; notranslate" title="">sqlite version2.db .dump | sqlite3 version3.db
</pre>

Now you will need to update your PHP script with the following translations

<div class="clearer">
  <div class="move">
    Old command
  </div>
  
  <div class="move">
    New command
  </div>
</div>

<div class="clearer">
  <div class="move">
    <pre class="brush: php; title: ; notranslate" title="">
sqlite_escape_string()
</pre>
  </div>
  
  <div class="move">
    <pre class="brush: php; title: ; notranslate" title="">
SQLite3::escapeString()
</pre>
  </div>
</div>

<div class="clearer">
  <div class="move">
    <pre class="brush: php; title: ; notranslate" title="">
sqlite_fetch_array($result)
</pre>
  </div>
  
  <div class="move">
    <pre class="brush: php; title: ; notranslate" title="">
$result-&gt;fetchArray()
</pre>
  </div>
</div>

<div class="clearer">
  <div class="move">
    <pre class="brush: php; title: ; notranslate" title="">
sqlite_exec($handle, $query)
</pre>
  </div>
  
  <div class="move">
    <pre class="brush: php; title: ; notranslate" title="">
$handle-&gt;exec($query)
</pre>
  </div>
</div>

<div class="clearer">
  <div class="move">
    <pre class="brush: php; title: ; notranslate" title="">
sqlite_query($handle, $query)
</pre>
  </div>
  
  <div class="move">
    <pre class="brush: php; title: ; notranslate" title="">
$handle-&gt;query($query)
</pre>
  </div>
</div>

<div class="clearer">
  <div class="move">
    <pre class="brush: php; title: ; notranslate" title="">
$handle = sqlite_open($file)
</pre>
  </div>
  
  <div class="move">
    <pre class="brush: php; title: ; notranslate" title="">
$handle = new SQLite3($file)
</pre>
  </div>
</div>
