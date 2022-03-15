---
title: Messing Around In Beam, π Day, And More Wordle
author: ben-wendt
date: 2022-03-14
template: article.pug
---

[Apache Beam](https://beam.apache.org/) is a distributed programming
framework, mostly designed as a counterpart to the DataFlow service in
Google Cloud Platform. In the past I've done a fair bit of work on
pipelines in Spark and with a service architecture, but I'll be needing
Beam for my new job, so Ive been playing around a bit with that.

<span class="more"></span>

I've may have written a bit about it before, but I think of calculating π
using the Monte Carlo Method to be kind of like the "hello world" of data
pipelines. A quick review of the algorithm:

- Select a large number of random `x, y ∊ [0, 1]²` from the uniform
    distibution.
- Take the sum of squares of each couple.
- The proportion of sums of squares that are less than one will (very slowly
    converge to π/4).

This works because finding random points withing this quarter arc is analagous
to finding the area of the unit circle. Here's the code in beam:

```python
import apache_beam as beam
import numpy as np

def in_circle(pair):
    if (pair[0]**2 + pair[1]**2) < 1:
        return 1
    else:
        return 0

with beam.Pipeline() as pipeline:
    n_samp = 100_000
    X = np.random.uniform(0,1,2 * n_samp).reshape(n_samp, 2)

    x = pipeline | "create xs" >> beam.Create(X)

    number = x | "calculate it" >> beam.Map(in_circle) \
        | "sum up" >> beam.CombineGlobally(sum)

    number | "writing pi value" >> beam.io.WriteToText("number.txt")
```

This gave me a value of pi of `π is 3.14136`, which any piphile
would tell you is way off. The Monte Carlo Method is great for a
close enough answer, but it's a terrible way to calculate digits
of π.

I've also written recently about wordle. I've been playing every
day for months, and I often get the urge to write a program to cheat
for me. I have thus far resisted the urge to cheat, (unless you count
writing a program to give a good first guess cheating), but I have
gone back several times to re-think word choices.

The other day I had a clue of `_o_us` and I discounted several letters
to get there. Off the top of my head I thought of "bolus"
and "focus" as options. It ended up being "bonus," but it took me a few
minutes to remember this common word.

Here's a beam that calculates some of the words that may match in this
scenario.

```python
import apache_beam as beam

# my favorite unix file
dictionary = "/usr/share/dict/words"

def to_lower(x):
    return x.lower()

def is_fives(text):
    return len(text) == 5

def match_greens(pattern):
    return lambda x: all([x[idx] == letter for idx, letter in pattern])

def non_matches(excludes):
    return lambda x: all([ex not in x for ex in excludes])

with open("beam-output.txt", "w") as f:
    with beam.Pipeline() as p:
        words = ( p |
            "read in words" >> beam.io.ReadFromText(dictionary) |
            "to lower" >> beam.Map(to_lower)
        )

        fives = (words |
            "filter to five letter words" >> beam.Filter(is_fives)
        )

        # sample of letters I had tried and discounted.
        excludes = ['t', 'r']

        without_exclusions = (fives |
            "remove exclusions" >> beam.Filter(non_matches(excludes))
        )

        # sample "green letter" pattern _o_us
        pattern = [(1, 'o'), (3, 'u'), (4, 's')]

        matches = (without_exclusions |
            "get green matches" >> beam.Filter(match_greens(pattern))
        )

        (matches 
            |"do output" >> beam.Map(print)
        )
```

And I get these output words with my dictionary:

```
bogus
bolus
bonus
cobus
comus
conus
copus
focus
fogus
hocus
kobus
locus
momus
mopus
nodus
```

As I mentioned before, wordle does use common words, so it would make
sense to either filter or sort these based on word frequency. But as a
quick learning exercise for beam it was decent. One aspect I am really
enjoying about beam so far is that it basically forces you to document
every step of your pipeline, because you can't use the same operator
twice without doing the `"explanation" >> step` thing, which is really
nice.
