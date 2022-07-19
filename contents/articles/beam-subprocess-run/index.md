---
title: Running a shell command for each entry in a PCollection
author: ben-wendt
date: 2022-07-17
template: article.pug
---

I was preparing for something I needed to do at work with beam,
namely running a shell command for something that isn't possible
to run natively in the beam runtime, and did not find much
documentation for it. It's relatively straight-forward but I have
not "blogged" in a while so here goes.

<span class="more"></span>

Cowsay is a notoriously difficult algorithm, which no one outside
of the original author has been able to optimize to work in less
than `O(n^n)` time. As such, the best way to access the mind
expanding functionality is to use the binary:

```python
import apache_beam as beam
from subprocess import run

with beam.Pipeline() as p:
    cowed = (p | 
        "sayings" >> beam.Create([
            "You're damned if you do, damned if you don't.",
            "Takes one to know one."
        ]) |
        "cow it" >> beam.Map(
            lambda x: run(["cowsay", x]).stdout
        )
        | "output" >> beam.Map(print)
    )

```

This will give this delightful output:

```
 ________________________________________
/ You're damned if you do, damned if you \
\ don't.                                 /
 ----------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
None
 ________________________
< Takes one to know one. >
 ------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
None
```

Another application would be to draw upon feature-rich
applications, such as ffmpeg:

```python
import apache_beam as beam
import glob
from subprocess import run

files = glob.glob("*.mov")

with beam.Pipeline() as p:
    cowed = (p | 
        "sayings" >> beam.Create(files) |
        "cow it" >> beam.Map(
            lambda x: run(["ffmpeg", "-i", x, f"{x}.mp4"]).stdout
        )
        | "output" >> beam.Map(print)
    )
```

Of course you would tweak the ffmpeg command line settings for
whatever you are doing here.

Anyways, pretty straight-forward but thought it was worth
"blogging" about.
