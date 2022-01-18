---
title: A Ruby Pipe
author: ben-wendt
date: 2018-02-01
template: article.pug
---

Javascript is going to get a [pipeline operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Pipeline_operator) any day now, and I love working with it in elixir, so I thought I’d try to make one in ruby.

<span class="more"></span>

So here’s an implementation

```ruby
    class Object
      def pipe arg
        arg.(self)
      end
    end
```

And it works like this:

```ruby
    plus1 = -> (x) {x+1}
    1.pipe(plus1) # 2
    1.pipe(plus1).pipe(plus1) # 3
```

And you can do things like add a logging aspect:

```ruby
    putit = ->(x) {puts x; x}
    1.pipe(plus1).pipe(putit).pipe(plus1) # outputs 2 and returns 3
```

It’s pretty neat, but it only works with lambdas and procs for now. And it’s obviously not standard ruby so you’d be swimming against the tide if you tried to do anything useful with this.
