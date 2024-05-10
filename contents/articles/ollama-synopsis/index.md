---
title: Using ollama to make an epub synopsis
author: ben-wendt
template: article.pug
date: 2024-05-09
---

Like everyone else, I do my best to read many books, and like
many, I find it to be a challenge, not just in finding the time,
but also I found after you've read enough books, especially
non-fiction, a lot of the book seems like filler. Different
books on the same subject will cover the same material, or the
author will be needlessly verbose in covering a topic. I thought
'if I just want to read this book for the content, not the style,
could I shorten it with an ai tool to ease some of the pain
points?'

<span class="more"></span>

Now, synopsisizing has a long history, and has met with it's
share of detractors. For those wanting the sense of accomplishment
of finishing a book, this isn't for you. On the other hand, Coles
Notes was once a staple of classrooms and campuses, and certainly
helped many students achieve their goals. A manager I had a couple
years ago was a proponent of using a synopsis site, I forget the
name, but it served a similar purpose.

Anyways, I thought I would try making a tool to generate a
shortened version of a text. The idea is to turn a chapter
into something more like a page of text. My target genre
is lighter non-fiction books and books about management,
which I would like to read some of to help me with work.

[llama3](https://github.com/meta-llama/llama3) is a gpt model.
It's pretty good, and you can download the full model and
weights. A few weeks ago I was trying to install it, but ran 
into the usual cuda issues on my macbook, and had some annoying
dependency issues derail me on my old linux machine that has a
1060 6GB that I use for AI stuff. So my momentum was gone. Then
the other day, someone posted on the #random channel at work
about [ollama](https://github.com/ollama/ollama/), which comes
with a mac installer. I've always been a huge proponent of 
avoiding dependency hell. I've been pulled down into that morass
regularly for decades. I've spent more time manually copying
around specific versions of dll files than I can remember; that's
just how it was in the .net 1.0 days.

So, I ran the ollama installer. Once it is running you can do
`ollama run llama3` and chat with llama, as if you were in the
instagram app. This can be useful, but running on my macbook, it's
actually much faster to run the inference on facebooks servers
that I'm sure have hefty GPUs. But for my purpose I had another
idea.

I can open an ebook in python. These contain a collection of 
xml documents, one per chapter. I can create batches of paragraphs
and get a synopsis of each by prompting the ollama ai.

Here's some code.

```python
from itertools import islice
import ebooklib
import requests
from bs4 import BeautifulSoup
import json

# I found this code on stack overflow for making
# batches from a collection:

def batched(iterable, n):
    "Batch data into lists of length n. The last batch may be shorter."
    it = iter(iterable)
    while True:
        batch = list(islice(it, n))
        if not batch:
            return
        yield batch

def gen_prompt(author, title, all_text):
    """this is under the assumption that llama3 may already
    know something about the book, so it's a hint to add
    the title and author. I did not validate this assumption."""

    return f"generate a synopsis of this excerpt from '{title}'" "by {author} with no preamble and without referencing the " "author or the excerpt: {all_text}"

to_shorten = 'my_book.epub'
book = ebooklib.epub.read_epub(to_shorten)

# larger means less to read, but you'll hit a limit of what
# llama can handle if this is too big.
text_batch_size = 10

author = book.get_metadata('DC', 'creator')[0][0]
title = book.get_metadata('DC', 'title')[0][0]
print(f"author: {author} title: {title}")

for item in book.get_items():
    if item.get_type() == ebooklib.ITEM_DOCUMENT:
        print('==================================')
        print('NAME : ', item.get_name())
        content = item.get_content()

        # probably not the best choice.
        y = BeautifulSoup(content)

        # pretty sure this title logic will depend on which ebook
        # you are reading.
        title = y.findAll('h3')
        if title:
            print(f"{title[1].text}")
            print(''.join(['=' for l in title[1].text]))

        # I don't know enough about epubs to say whether they
        # all use the p tag.
        ps = y.findAll('p')

        batches = batched(ps, text_batch_size)
        for batch in batches:
            all_text = " ".join([p.text for p in ps])
            prompt = gen_prompt(author, title, all_text)
            
            # thanks ollama
            url = "http://localhost:11434/api/generate"
            body = {
                "model": "llama3",
                "prompt": prompt
            }
            
            x = requests.post(url, json = body)
            generated = ""

            # the response contains JSONL essentially.
            # One word per response object line.
            # Convert it back to readable.
            for dat in x.text.split("\n"):
                if not dat:
                    continue
                js = json.loads(dat)
                generated += js["response"]
                
            print(generated)
```

Overall the result is pretty good. I'm still trying to find a
prompt that won't start half of the outputs with things like
`"Here's a synopsis of the excerpt:"`, so it will read better,
but overall I'm quite happy with the results. Whether I'm happy
enough to get this running on my 1060, or if I'll ever use it
again remains to be seen. But I did use it to get the "super gist"
of a book I had already read half of, and it worked quite well. I
mentioned in my intro how I find many of these kinds of books to
be quite repetitive and low-density for information. This leads
me to doing skimming. I think for me, if I pay close attention to
a synopsis rather than skimming, the result is about the same.
This post must be leading by far in justifications and
rationalizations per whatever, but that's the nature of AI.
