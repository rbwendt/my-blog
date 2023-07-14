---
title: Safe Navigation in Python
author: ben-wendt
date: 2022-10-13
template: article.pug
---

In a chain of method calls, what happens when
one of the calls returns a null? The next chained call will throw some kind of reference
error. But what if you don't want to deal with
a reference error? What if you want the null
value to be the answer? That's where a safe
navigation operator is useful.

<span class="more"></span>

Ruby has a safe navigation operator `&.`. This is really useful
in database applications. For example, consider a database model
of a tree, so you might have something like:

```ruby
tree.trunk.branches[2].branches[5].twigs[2].leaves[1]
```

But what if your tree doesn't have that leaf, or that branch, or if
it has no trunk? But also you don't mind "null" being the answer to
your query. Well that's where safe navigation is useful. Observe:

```ruby
tree&.trunk&.branches&.[2]&.branches&.[5]&.twigs&.[2]&.leaves&.[1]
```

This would return null if any of the calls in the chain return
null, without having 9 levels of short-circuiting.

Note: I'm ignoring the law of demeter in this post.

But python does not have a safe navigation operator. One has been
proposed, but currently it doesn't exist.

it is however possible to roll one. Consider an input document like
this:

```html
<!doctype html>
<html>
    <head>
        <title>Something</title>
    </head>
    <body>
        <article>
            <h1>My article</h1>
            <div>
                <p>Some text <b>yelling <i>curiously</i></b>.</p>
            </div>
        </article>
        <article>
            <h1>My article</h1>
            <div>
                <p>Some text <b>yelling <i>curiously</i></b>.</p>
            </div>
        </article>
    </body>
</html>
```

Reading the article with beautiful soup, you can access various html
nodes using a chained dot notaion:

```python
import bs4
from typing import List, Optional


with open("something.html", "r") as f:
    soup = bs4.BeautifulSoup(f.read(), "html.parser")

print(soup.body.article.div.p.b.i)
try:
    print(soup.body.article.div.p.c.i)
except AttributeError:
    print("that did not work.")
```

Here we can read the contents of the b tag, but not the c tag, since the
latter doesn't exist. But if we have the function we talked about:

```python
def safe_navigate(soup: Optional[bs4.BeautifulSoup], tag_list: List[str]):
    if tag_list:
        return safe_navigate(getattr(soup, tag_list[0], None), tag_list[1:])
    else:
        return soup

print(safe_navigate(soup, ["body", "article", "div", "p", "b", "i", "text"]))
print(safe_navigate(soup, ["body", "article", "div", "p", "c", "i", "text"]))
```

Now our document query works in both cases, the query with the `b` gives
the expected result, and the query with `c` returns `None`.
