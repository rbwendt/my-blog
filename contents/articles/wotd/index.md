---
title: Automatic Word of the Day
author: ben-wendt
date: 2022-03-03
template: article.pug
---

Since 2007 I've been keeping up my own personal word of the day
blog. I started it back in the heyday of google reader. In those
days I was subscribed to several word of the day blogs and
wanted to do one of my own. I've gone through phases of posting more
and less. Some years I posted every day, and toward the late teens
I had single digits of posts for several years running.

<span class="more"></span>

It's fun. My favorite words to add are ones that I come across while
reading something, and I either really like the word or have to look
it up. Words that arise organically have a personal touch that is
appropriate for blogging.

But in the years where I posted every day, I mixed and matched between
organic words and wikipedia crawling. I forget the exact criteria, but
I had a userscript that I would run in a browser that would look for
interesting words, those being wikipedia articles that matched several
criteria:

- Single word title, with optional parentheses.
- No proper nouns
- Probably some kind of length limit.
- There were probably other criteria.

It would be interesting to share what I was doing with javascript in 
those days, but alas, whatever that user script did, it's lost to the
sands of time. Being totally honest I think it was on a work computer,
and this was back in the days when a work computer was a big box that
sat in an office, not a laptop in your own home.

My enthusiasm for the project waned over the years, but never left. So
last year I was looking to revive the blog. I thought an interesting
way to automate it would be picking random words from the dictionary
with in a given word frequency range.

```python
from wordfreq import word_frequency
from PyDictionary import PyDictionary
from english_words import english_words_set
from random import choice
from wiktionaryparser import WiktionaryParser
import wikipedia
from datetime import datetime

dictionary=PyDictionary()
english_words = list(english_words_set)
parser = WiktionaryParser()

def find_interesting_word(max_freq=5e-07, min_freq=7e-10):
    freq = 2 * max_freq
    while freq < min_freq or freq > max_freq:
        word = choice(english_words)
        freq = word_frequency(word, 'en')
    return word, freq
```

Here you see that an interesting word is one whose frequency
lies in the range `7e-10` to `5e-07`. I found these bounds
by trial-and-error, and even so most of the output words
aren't great, so pick a bunch of them:

```python
def find_interesting_words(num=7):
    return [find_interesting_word() for i in range(num)]
```

Example:

```
[('incubate', 2.88e-07),
 ('rattail', 3.24e-08),
 ('recondite', 5.37e-08),
 ('okra', 4.27e-07),
 ('headdress', 4.57e-07),
 ('Grosset', 8.13e-08),
 ('hyperbola', 1.07e-07)]
```

Aside from the proper noun "Grosset," these are basically all
suitable for "words of the day." But a word of the day isn't
just a word, you also need a definition, and I liked to include
a picture. I found a function that grabs images for a given
query from wikipedia, and use `PyDictionary` and `WiktionaryParser`
to give definitions:

```python
def li(x):
  return f"<li><i>{x['partOfSpeech']}</i>: {' '.join(x['text'])}</li>"

def html_of(word):
    out_code = f'<p><b>' \
      '<a href="https://en.wiktionary.org/wiki/{word}">{word}</a>' \
      '</b></p>'
    meaning = dictionary.meaning(word)
    if meaning:
        for (typ, defs) in meaning.items():
            out_code += f'<p><i>{typ}</i>'
            lis = ''.join(['<li>' + x + '</li>' for x in defs])
            out_code += '<ul>' + lis + '</ul>'
            out_code += '</p>'
    else:
        meaning = parser.fetch(word)
        out_code += '<ul>'
        for defs in meaning:
            lis = [li(x) for x in defs['definitions']]
            out_code += ''.join(lis) + '</ul>'
        out_code += '</ul>'
    wikiimage = get_wiki_image(word)
    if wikiimage:
        out_code += f'<p><img width=720 rel="{word}" src="{wikiimage}" /></p>'
    return out_code
```

I see a few issues here, but this was meant as a proof-of-concept, so that's
fine. After running a few tests, I found I was getting results like this:

> europium
> 
> Noun
>    a bivalent and trivalent metallic element of the rare earth group

This is fine, but I feel it's a bit soul-less. Had this worked out I would
have liked to add blogger API access, including scheduling and tagging, but
I wasn't happy enough with the results. After reflecting on
what I wanted the blog to be, I decided to just make a better effort
of manually posting things, and I've been doing a much better job
since last year.
