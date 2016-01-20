---
title: Using Angular-UI and Restangular To Interact With WordPress API
author: ben-wendt
layout: post
date: 2015-04-25
url: /2015/04/25/using-angular-ui-and-restangular-to-interact-with-wordpress-api/
template: article.jade
categories:
  - Javascript
tags:
  - angular
---
At my new job I&#8217;ve been working a fair bit with [ui router][1]. It&#8217;s a fun library and I thought I would brush up a bit and have some fun practice interfacing it with the [wordpress api plugin][2] through [restangular][3].

<span class="more"></span>


So let&#8217;s take a quick look at how this very simple process works.

First, I installed all the dependencies using bower.

Next, set up a simple index.html file:

<pre class="brush: xml; title: ; notranslate" title="">&lt;!doctype html&gt;
&lt;html ng-app="blog"&gt;
&lt;head&gt;
    &lt;script src="bower_components/angular/angular.js"&gt;&lt;/script&gt;
    &lt;script src="bower_components/angular-ui-router/release/angular-ui-router.js"&gt;&lt;/script&gt;
    &lt;script src="bower_components/lodash/lodash.min.js"&gt;&lt;/script&gt;
    &lt;script src="bower_components/restangular/dist/restangular.js"&gt;&lt;/script&gt;
    &lt;script src="app.js"&gt;&lt;/script&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div&gt;
&lt;div ui-view&gt;&lt;/div&gt;
&lt;/div&gt;
&lt;/body&gt;
&lt;/html&gt;
</pre>

And here&#8217;s app.js:

<pre class="brush: jscript; title: ; notranslate" title="">var myApp = angular.module('blog', ['ui.router', 'restangular']);
myApp.config(function($stateProvider, $urlRouterProvider, RestangularProvider) {

RestangularProvider.setBaseUrl('http://benwendt.ca/blog/wp-json/')

$urlRouterProvider.otherwise('/');
$stateProvider
.state('home', {
  url: '/',
  templateUrl: 'posts.html',
  resolve: {
    posts:function(Restangular) {
      return Restangular.all('posts').getList()
     }
  },
  controller($scope, $sce, $filter, posts) {
    $scope.posts = posts
  }
})
}).filter('unsafe', function($sce) { return $sce.trustAsHtml })


</pre>

The two main takeaways here are:

  1. Set up the base api url using `RestangularProvider.setBaseUrl()`.
  2. Use ui-router&#8217;s `$stateProvider` to set up which template, api requests, and controller to use.
Also I&#8217;m using a nifty filter I found for running `<A href="http://stackoverflow.com/a/19705096/973810">$sce.trustAsHtml</a>`.

And the template is super simple, but here it is:

<pre class="brush: xml; title: ; notranslate" title="">&lt;div ng-repeat="post in posts"&gt;
  &lt;div class="post"&gt;
    &lt;h1 ng-bind-html="post.title | unsafe"&gt;&lt;/h1&gt;
    &lt;div ng-bind-html="post.content | unsafe"&gt;&lt;/div&gt;
  &lt;/div&gt;
&lt;/div&gt;
</pre>

So, in conclusion, these technologies make it really easy to pull data off a json api and throw it into the browser. It&#8217;s wonderful.

 [1]: https://github.com/angular-ui/ui-router
 [2]: https://wordpress.org/plugins/json-rest-api/
 [3]: https://github.com/mgonto/restangular
