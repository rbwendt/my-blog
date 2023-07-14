---
title: Schemas and SqlTransform in Beam
author: ben-wendt
template: article.pug
date: 2023-7-13
---

Beam has support for working with collections of data that conforms
to a schema, and you can use SQL Transforms to transform this data.
This feels a bit more like working with data in spark, but beam
does not have the same level of optimization.


<span class="more"></span>

Here's some imports. I'll leave these in because beam's docs are not
great and I had to copy these out of a [youtube video](https://www.youtube.com/watch?v=zx4p-UNSmrA)
when I was learning to do this:

```python

import apache_beam as beam
from apache_beam.transforms.sql import SqlTransform

import typing

from faker import Faker
```

Here is my schema class. Beam wants it to be a named tuple.

```python
class Person(typing.NamedTuple):
    person_id: int
    name: str
    fave_color: str
```

And you have to register a coder for the class:

```python
beam.coders.registry.register_coder(Person, beam.coders.RowCoder)
```

And here's an example showing some usage of the schema and a
transformation:

```python
with beam.Pipeline() as p:
    fake = Faker()
    people = (
        p |
        "get ids" >> beam.Create(list(range(10_000)))
        | "to people" >> beam.Map(lambda person_id: Person(
            person_id=person_id,
            name=fake.name(),
            fave_color=fake.color_name()
            )
        ).with_output_types(Person)
        | SqlTransform("""
            select fave_color, count(*) as `COUNT`
            FROM PCOLLECTION
            group by fave_color
        """)
        | "print" >> beam.Map(print)
    )
```
