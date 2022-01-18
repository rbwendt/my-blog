---
title: Fun with `fork`
author: ben-wendt
layout: post
date: 2016-02-02
template: article.pug
---

In `irb`,

```ruby
fork
```

Now typing `exit` will not work because your keystrokes might go to either
the parent process or the forked child process. I found it to be impossible
to get the characters `exit` to coherently all go to the same process.
