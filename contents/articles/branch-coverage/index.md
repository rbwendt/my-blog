---
title: Branch Coverage, A Cautionary Tale
author: ben-wendt
date: 2025-07-07
template: article.pug
---

Unit testing your code is the ultimate route to developer
sanity. A well written test suite is a patchwork proof of
the correctness of your system. The more complete your
patchwork, the more you can rest easy knowing your code
will do what you intend it to do.

<span class="more"></span>

The typical measure of the completeness of a test suite is
line coverage. A profiler running while the test suite is
run checks every line of code to see whether it has been run
or not. In theory, the closer you get to 100%, the better
tested your code base is, and the more easily you can sleep
at night.

This of course isn't always true. For example, consider the
following code:

```python
def contrived_example(data, a, b):
    encoding = "utf-8"
    if a:
        encoding = "not a real encoding"
    if b:
        encoding = "iso-8859-1"
    return data.decode(encoding)

def test_contrived_example():
    assert contrived_example(b"test", True, True) == "test"


test_contrived_example()
```

Congratulations, you have 100% line coverage! But what happens when you do this:

```python
def test_contrived_example_2():
    assert contrived_example(b"test", True, False) == "test"

test_contrived_example_2()
```

Oh no, an error:

> LookupError: unknown encoding: not a real encoding

This is because the all possible branches weren't checked by
`test_contrived_example`, as shown by `test_contrived_example_2`.

But sometimes branch coverage isn't enough either.  Consider this example:

```python
def my_function(a, b):
    if a >= 3:
        a -= 3
    if b > 0:
        b /= a
    return b

def test_small_a():
    a = 1
    b = 2
    print(f"{a} {b} => {my_function(a, b)}")
    assert my_function(a, b) == 2.0

def test_big_a():
    a = 1
    b = 2
    print(f"{a} {b} => {my_function(a, b)}")
    assert my_function(a, b) == 2.0

def test_small_b():
    a = 1
    b = 0
    print(f"{a} {b} => {my_function(a, b)}")
    assert my_function(a, b) == 0.0


tests = [test_small_a, test_big_a, test_small_b]

for test in tests:
    test()
```

This "test suite" gives 100% branch coverage of our example
function, but there's still special case handling that can
cause an exception:

```python
my_function(3, 2)
```

Yields 

> ZeroDivisionError: division by zero

So even with 100% branch coverage we cannot be sure that our
code is clear of errors. This is where the peer review process
is important. More eyes on a code base will reveal these edge
case issues that aren't caught by code coverage.
