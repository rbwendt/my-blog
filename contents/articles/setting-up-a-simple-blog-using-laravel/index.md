---
title: Setting up a simple blog using laravel
author: ben-wendt
layout: post
date: 2014-04-09
url: /2014/04/09/setting-up-a-simple-blog-using-laravel/
template: article.jade
categories:
  - PHP
tags:
  - frameworks
  - laravel
---
Setting up a very simple blog with laravel is quite easy.

<span class="more"></span>

#### Installing Laravel

The easiest install method is to use [composer][1]. 

#### Setting up routing

Edit your `/app/routes.php` and add the following routes:

<pre class="brush: php; title: ; notranslate" title="">Route::get('/', function()
{
	$posts = Post::orderBy('id', 'DESC')-&gt;get();
	return View::make('blog')-&gt;with('posts', $posts);
});


Route::get('post/{id}', function($id) {
	$post = Post::find($id);
	return View::make('post')-&gt;with('post', $post);
})-&gt;where('id', '[0-9]+');
</pre>

What this is saying is that the root request should use the &#8220;blog&#8221; view, using the collection of all blog posts, ordered by descending id.

It also sets up an option to load individual posts at `/post/{id}`, and the id is validated to be only integers.

#### Setting up views

In `/app/views` create a file called `layout.blade.php` which contains the following:

<pre class="brush: php; title: ; notranslate" title="">&lt;!doctype html&gt;
&lt;html&gt;
    &lt;head&gt;
		&lt;title&gt;@yield('title')&lt;/title&gt;
	&lt;/head&gt;
	&lt;body&gt;
        &lt;h1&gt;@yield('title')&lt;/h1&gt;

        @yield('content')
    &lt;/body&gt;
&lt;/html&gt;
</pre>

This is just a wrapper template where the title and yield values can be swapped in from other templates.

Next, in `/app/views` create a file called `blog.blade.php`, which contains the following:

<pre class="brush: php; title: ; notranslate" title="">@extends('layout')
@section('title')
	The Blog @stop
@section('content')
    @foreach($posts as $post) 
		&lth2&gt;
			&lt;a href="/laravel-blog/post/{{ $post-&gt;id }}"&gt;
				{{ $post-&gt;title }}
			&lt;/a&gt;
		&lt;/h2&gt;
		&lt;div class="post"&gt;{{ $post-&gt;content }}&lt;/div&gt;
	@endforeach
@stop
</pre>

And make another view called `post.blade.php` containing the following:

<pre class="brush: php; title: ; notranslate" title="">@extends('layout')
@section('title')
	{{ $post-&gt;title }} @stop
@section('content')
    {{ $post-&gt;content }}
@stop
</pre>

These view set up values for title and content. In the blog view, we show all the posts, and in the post view, we only show one. This mirrors what we set up in the routes.

#### Setting up the database

First, configure your MySQL database in `app/config/database.php`. Now you have to set up a _migration_. The migration that you set up will create the tables. When you installed laravel, you will have had the `artisan` command line app set up for you. Run the following command:

<pre>php artisan migrate:make create_posts_table</pre>

This will have made a file in the `/app/database/migrations` folder with a name like `{datetime}_create_posts_table.php`. In this file, there will be a class `CreatePostsTable` which will have an `up` and a `down` method. Replace these methods with the following:

<pre class="brush: php; title: ; notranslate" title="">public function up()
	{
		Schema::create('posts', function($table)
		{
			$table-&gt;increments('id');
			$table-&gt;string('title');
			$table-&gt;string('content');
			$table-&gt;timestamps();
		});
	}

	public function down()
	{
		Schema::drop('posts');
	}
</pre>

Save the file, then from your command line, run:

<pre>php artisan migrate
</pre>

This will create the table in your database (as configured in `app/config/database.php`) as configured in the `up` method of your migration class.

#### Conclusion

You have now set up a very simple, non-user friendly, and extremely plain-looking blog. You could add posts by making inserts directly to the table, or by setting up a new route that creates a `Post` then calls the `save()` method on it.

 [1]: https://getcomposer.org/download/
