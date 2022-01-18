---
title: Popping errors out from ruby threads using a Queue
author: ben-wendt
date: 2018-05-10
template: article.pug
---

I had an issue at work where some database writes were throwing errors within a thread, and the error was being silently eaten when the thread died.

<span class="more"></span>

The solution is to use a queue for inter-thread communication, like this:

```ruby
q = Queue.new

Thread.new do
    i = 1
    loop do
    begin
        sleep i
        i += 1
        raise 'whatever'

    rescue StandardError => e
        q << e
    end
    end
end

loop do
    puts q.size
end
```
