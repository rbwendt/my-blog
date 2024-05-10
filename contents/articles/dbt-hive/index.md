---
title: An Intro to Data Build Tool (dbt) With Hive
author: ben-wendt
template: article.pug
date: 2024-03-26
---

DBT has support for a wide variety of databases. So far, I've been using
Google's bigquery as the database for all of my DBT blog posts, so let's
try something different. For this demo I'll use [Apache Hive](https://hive.apache.org/)

<span class="more"></span>

## Development Environment Setup

Apache hive has a [quickstart guide](https://hive.apache.org/developement/quickstart/)
that doesn't quite work, so I will provide the steps I took to get it going
in `podman`.

First, a very important step (I could imagine people wearing shirts with
this):

```bash
alias docker=podman
```

Next, pull the image:

```bash
docker pull apache/hive:4.0.0-alpha-2
```

Next, run the image:

```bash
export HIVE_VERSION=4.0.0-alpha-2
docker exec -it hive4 beeline -u 'jdbc:hive2://localhost:10000/'
```

This will put you into a beeline shell (a hive CLI). Keep this open.

## Setting up DBT.

This is based on the [dbt hive setup](https://docs.getdbt.com/docs/core/connect-data-platform/hive-setup). First, edit `~/.dbt/profiles.yml`. Add
something like this:

```yml
hive:
  target: dev
  outputs:
    dev:
      type: hive
      host: localhost
      port: 10000 # match your docker run from before.
      schema: my_schema
```

Now do `pip install dbt-hive`, then `dbt init ${your_project}` and choose
hive for the adapter. Edit your new `dbt_project.yml` and make sure your
profile name matches what is in the profiles file.

Now you should be able to do whatever you want in dbt. For my example, I 
set up a quick seed called `randoms.csv`:

```csv
id,random_value
1,2
```

This is a personal in-joke with myself. I had a professor in university
[Dr Marco Polannen], who, when teaching us about randomness said "is 2
random?" (The point was that a single number can't really be random,
randomness is a property of a sequence where it is the shortest definition
of itself). So after naming my model "random" I thought 2 would be a good
seed value. Anyways... now you can run `dbt seed`. If all goes well, you
can return to your beeline shell and run:

```sql
select * from my_schema.randoms;
```

And see something like:

```
+-------------+-----------------------+
| randoms.id  | randoms.random_value  |
+-------------+-----------------------+
| 1           | 2                     |
+-------------+-----------------------+
```

And that's it. You could extend this starting point to add tests, models
and so on. Have a nice day.
