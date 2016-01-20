---
title: 'Adding Arbitrary Code to your <head> in Magento'
author: ben-wendt
layout: post
date: 2014-02-06
template: article.jade
url: /2014/02/06/adding-arbitrary-code-to-your-in-magento/
categories:
  - Uncategorized
---
Magento&#8217;s built in `addJs` method in the `Mage_Page_Block_Html_Head` class assumes that files will be hosted locally. This isn&#8217;t always desirable. E.g. you may want to use Google&#8217;s CDN to host jQuery.

This can be accomplished by adding the following to your layout xml:

<pre>&lt;reference name="head">
            &lt;block type="core/text" name="my_head">&lt;/block>
        &lt;/reference>
</pre>

Now, in your controller you can add anything into this block that you want, like so:

<pre class="brush: php; title: ; notranslate" title="">$google_url = 'http://google.com/jquery.js';
$this-&gt;getLayout()-&gt;getBlock('my_head')-&gt;setText("

            &lt;script src='$google_url'&gt;&lt;/script&gt;

        ");

</pre>
