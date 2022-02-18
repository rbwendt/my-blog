---
title: '"Infinite Word Ladder"'
author: ben-wendt
layout: post
date: 2022-02-17
template: article.pug
---

One of the paper handouts my child used to do at school was the
"word ladder." The exercise is a starting word and a series of
instructions, with a hint/definition of the word that will be
created.

<span class="more"></span>

For example, given the starting word "jump", a sequence like this could be 
created:

* Replace first letter: get rid of
* Replace last letter: bereft of speech.
* Replace first vowel, add er at end: wetter.

And then the obvious answer is "damper".

Given the ongoing waves of home / remote schooling we have as a result of
the covid pandemic, parents will often find themselves looking for work-
sheets for their ids to do. So I decided to write some code that could
make these word ladders.

Firstly, I needed to decide what words would be valid for the puzzles.
Clearly we don't want words that are above grade level that the kid 
wouldn't have heard before. So I won't be giving "clonality" as an answer
in the excercise. My first though was to use word frequencies, under the
assumption that kids would know the most common words. Unfortunately this
assumption did not bear out. There are a lot of commonly used words that
I wouldn't expect children to know.

Thankfully some kind folks already realized this and released a dataset
of words kids should know. It's called the [Dale-Chall Word List](https://www.readabilityformulas.com/articles/dale-chall-readability-word-list.php).

> The Dale-Chall Word List contains approximately three thousand familiar words 
> that are known in reading by at least 80 percent of the children in Grade 5.
> It gives a significant correlation with reading difficulty. It is not intended
> as a list of the most important words for children or adults. It includes words
> that are relatively unimportant and excludes some important ones. 

So with this dictionary I just needed to write a few lines of code to enact the
logic of the word puzzle.

First, start with a data class to hold the "rungs" on the ladder:

```python
from collections import namedtuple
Rung = namedtuple("Rung", "word description instructions")
```

I needed definitions of the words. This is the worst part of the result, as
the definitions are very dictionary-like.

```python
from PyDictionary import PyDictionary
dictionary=PyDictionary()
def dictionary_meaning(word):
    defn = dictionary.meaning(word)
    if defn is None:
        print(f'no definition for {word}')
        return ''
    items = list(defn.items())
    if len(items) == 0:
        print(f'no definition for {word}')
        return ''
    return items[0][1][0]
    return ' '.join(items)
```

A method of deciding which words are valid:

```python
def okay_word(word, used_words={}):
    return (word in dale_chall) and (word not in used_words) and ("'" not in word)
```

And now the fun part, the method with the list of available edits that finds
new rungs to put in the ladder:

```python
def edit_word(word, used_words={}):
    edits = []
    for letter in string.ascii_lowercase:
        if okay_word(letter + word, used_words):
            edits.append((letter + word, 'add letter at start'))
        # don't want to just pluralize.
        if letter != "s" and okay_word(word + letter, used_words):
            edits.append((word + letter, 'add letter at end'))
        if okay_word(letter + word[1:], used_words):
            edits.append((letter + word[1:], 'change first letter'))
        if okay_word(word[:-1] + letter, used_words):
            edits.append((word[:-1] + letter, 'change last letter'))
    for letter1 in string.ascii_lowercase:
        if letter1 == word[0]:
            continue
        for letter2 in string.ascii_lowercase:
            if letter2 == word[-1]:
                continue
            new_word = letter1 + word[1:-1] + letter2
            if okay_word(new_word):
                edits.append((new_word, 'change first and last letter'))
            
    for pair in first_twos:
        if pair[0] == word[0] and pair[1] == word[1]:
            continue
        if pair[0] == word[0] and pair[1] != word[1] and okay_word(pair + word[2:]):
            edits.append((pair + word[2:], 'change second letter'))
        elif pair[0] != word[0] and pair[1] == word[1]:
            # already checked first letter change above.
            continue
        elif okay_word(pair + word[2:], used_words):
            edits.append((pair + word[2:], 'change first two letters'))
    for vowel_source in ['a', 'e', 'i', 'o', 'u']:
        for vowel_dest in ['a', 'e', 'i', 'o', 'u']:
            vowel_replaced = word.replace(vowel_source, vowel_dest, 1)
            if okay_word(vowel_replaced, used_words):
                edits.append((vowel_replaced, 'change first vowel'))
        
    edits = [(w,d) for (w,d) in edits if w != word]
    return edits
```

I like this and I think it might be fun to try to add new edits.

Then just a couple methods to glue this crap together and make a ladder:

```python
def find_next_rung(rung, used_words={}):
    edits = edit_word(rung.word, used_words)
    if len(edits) == 0:
        print(f"failed to find a suitable word based on {rung.word}. :(")
        return None
    found_word, found_instruction = random.choice(edits)

    return Rung(found_word, dictionary_meaning(found_word), found_instruction)

def get_ladder(word):
    ladder = [Rung(word, '', '')]
    used_words = {ladder[0].word}

    for i in range(100):
        next_rung = find_next_rung(ladder[len(ladder) - 1], used_words)
        if next_rung is None:
            print('breaking')
            break
        used_words.add(next_rung.word)
        ladder.append(next_rung)
    return ladder
```

And here's an example output:

```python
[Rung(word='shoe', description='', instructions=''),
 Rung(word='shop', description='a mercantile establishment for the retail sale of goods or services', instructions='change last letter'),
 Rung(word='show', description='the act of publicly exhibiting or entertaining', instructions='change last letter'),
 Rung(word='meow', description='the sound made by a cat (or any sound resembling this', instructions='change first two letters'),
 Rung(word='glow', description='an alert and refreshed state', instructions='change first two letters'),
 Rung(word='know', description='the fact of being aware of information that is known to few people', instructions='change first two letters'),
 Rung(word='grow', description='pass into a condition gradually, take on a specific property or attribute; become', instructions='change first two letters'),
 Rung(word='flow', description='the motion characteristic of fluids (liquids or gases', instructions='change first two letters'),
 Rung(word='snow', description='precipitation falling from clouds in the form of ice crystals', instructions='change first two letters'),
 Rung(word='plow', description='a farm tool having one or more heavy blades to break the soil and cut a furrow prior to sowing', instructions='change first two letters'),
 Rung(word='crow', description='black birds having a raucous call', instructions='change first two letters'),
 Rung(word='crown', description='the Crown (or the reigning monarch', instructions='add letter at end'),
 Rung(word='frown', description='a facial expression of dislike or displeasure', instructions='change first letter'),
 Rung(word='brown', description='an orange of low brightness and saturation', instructions='change first letter'),
 Rung(word='clown', description='a rude or vulgar fool', instructions='change first two letters'),
 Rung(word='drown', description='cover completely or make imperceptible', instructions='change first two letters'),
 Rung(word='known', description='be cognizant or aware of a fact or a specific piece of information; possess knowledge or information about', instructions='change first two letters')]
 ```
