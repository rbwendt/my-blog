---
title: Diabolical Answers In Wordle
author: ben-wendt
date: 2022-04-12
template: article.pug
---

I've blogged several times about wordle before. It's a great
game for someone like me who loves words. I don't think I'm a
great wordle player, but I love thinking about the intricacies
of the game. One bugaboo in wordle, which I'll call "diabolical
answers" is when you reach a point where you have four letters
correct and there are many possible answers. The worst of these
would have more than six possible words, meaning you aren't
guaranteed a win even though you're almost done.

<span class="more"></span>

I'll start with an example. The word "soare", which I blogged
about earlier as being a great first guess, is also a diabolical
answer, and this happened to me the other day. Assuming all but
the second letter are correct, other possible answers include:

* scare
* share
* slare
* snare
* spare
* stare
* sware

Admittedly some of these are rare and don't occur in wordle's
dictionary.

I am still working on learning more [Apache Beam](https://beam.apache.org/), so I thought I would try to find these diabolical words using that tool. Here is the algorithm:

```python
import apache_beam as beam
from wordfreq import word_frequency

# should probably use the actual wordle dictionary.
dictionary = "/usr/share/dict/words"

def is_lower(x):
    return x.lower() == x

def is_fives(text):
    return len(text) == 5

def to_missings(word):
    retval = []
    for i in range(len(word)):
        s = word + ""
        s = s[:i] + "_" + s[i + 1:]
        retval.append((s, word))
    return retval

def remove_rares(x):
    return word_frequency(x, 'en') > 1.0e-06

with beam.Pipeline() as p:
    fives = ( p |
        beam.io.ReadFromText(dictionary) |
        "is lower" >> beam.Filter(is_lower) |
        "is fives" >> beam.Filter(is_fives) |
        "is common" >> beam.Filter(remove_rares)
    )

    various_lists = (fives |
        "create keyed missings" >> beam.FlatMap(to_missings)
        | "unique those" >> beam.Distinct()
    )

    groups = (various_lists |
        "group by missing chars" >> beam.GroupByKey()
    )

    filtered_groups = (groups |
        "only baddies" >> beam.Filter(lambda x: len(x[1])> 5)
    )

    output = (filtered_groups |
        "hopefully found something" >> beam.Map(print)
    )
```

Note the use of the `wordfreq` library, one of my faves, to
remove rare words, based on the heuristic threshold I decided
on of `1.0e-06`. This gives a really pleassing (to me at least)
list of diabolical answers 😈:

* _arry: barry, carry, harry, larry, marry, parry
* _atch: batch, catch, hatch, latch, match, patch, watch
* _erry: berry, derry, ferry, jerry, kerry, merry, perry, terry
* _illy: billy, filly, hilly, milly, silly, willy
* _itch: bitch, ditch, fitch, hitch, mitch, pitch, witch
* _ound: bound, found, hound, mound, pound, round, sound, wound
* _ater: cater, eater, hater, later, mater, water
* _over: cover, dover, hover, lover, mover, rover
* _olly: dolly, folly, holly, jolly, molly, polly
* _ight: eight, fight, light, might, night, right, sight, tight, wight
* gra_e: grace, grade, grape, grate, grave, graze
* sha_e: shade, shake, shale, shame, shane, shape, share, shave
* sta_e: stage, stake, stale, stare, state, stave

Some of these have 6 or more entries, which would make them very frustrating.
