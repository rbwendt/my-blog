---
title: Getting a sum of durations in rails
author: ben-wendt
date: 2016-02-01
template: article.pug
---

For my "I had trouble finding this on google" series, here's a 
solution I found to getting a total duration from a collection
of objects with durations stored as `Time` objects.

```ruby
total_duration = durations.reduce(Time.gm(2000)) do |total, time|
  total += time.to_i
end
```

There are two little tricks happening here. The first is that 
durations are stored as a time of day on January 1st, 2000, so
we use that as the reduce seed. The second thing is that the 
`Time` class defines addition for integer objects, but not for
other times, so you have to convert your duration to an integer
first.

No rocket science here, but a couple little quirks that made it
a little harder to add two times together than I expected.

