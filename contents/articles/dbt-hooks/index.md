---
title: An Intro to Data Build Tool (dbt) Hooks
author: ben-wendt
template: article.pug
date: 2024-03-20
---

[DBT](https://getdbt.com/) supports [hooks](https://docs.getdbt.com/docs/build/hooks-operations), which are a mechanism for
running operations at different points of the execution of your DBT
DAG. This is useful for running operations like adding a record to an
audit table, running specific reports, and more.

<span class="more"></span>

Here I will show an example based on my "enriched movies" example from my
previous blog post. Consider the use case where you want to export a table
to your data lake after populating it using DBT run. You could do 
something like the following:

```jinja
{{ config(
  post_hook = "EXPORT DATA
  OPTIONS (
    uri = 'gs://bq_movie_export/movie_export/*.json',
    format = 'JSON',
    overwrite = true)
AS (
  SELECT *
  FROM dbt_bwendt.enriched_movies
  ORDER BY movie_title
);
"
) }}

with movies as (
    select id as movie_id, title
    from {{ ref('movies') }}
),
actors as (
    select id as actor_id, name
    from {{ ref('actors') }}
),
movie_actor_mapping as (
    select id, movie_id, actor_id
    from {{ ref('stg_actor_movies') }}
)
select movie_actor_mapping.id,
    movies.title as movie_title,
    actors.name as actor_name
from movie_actor_mapping
join movies using (movie_id)
join actors using (actor_id)

```

Note the use of the `config` macro with a post hook specified. The
action performed by the post hook is:

```sql
EXPORT DATA
  OPTIONS (
    uri = 'gs://bq_movie_export/movie_export/*.json',
    format = 'JSON',
    overwrite = true)
AS (
  SELECT *
  FROM dbt_bwendt.enriched_movies
  ORDER BY movie_title
);
```

This is a bigquery specific export option that will write the table
to the specified GCS location. If you were to look in the generated file,
you would see this in JSONL format:

```json
{"id":"3","movie_title":"Avatar","actor_name":"Sigourney Weaver"}
{"id":"5","movie_title":"Paul","actor_name":"Sigourney Weaver"}
{"id":"2","movie_title":"Speed","actor_name":"Keanu Reeves"}
{"id":"1","movie_title":"Speed","actor_name":"Sandra Bullock"}
{"id":"6","movie_title":"Terminator 2","actor_name":"Linda Hamilton"}
{"id":"4","movie_title":"The Matrix","actor_name":"Keanu Reeves"}
```

Bigquery's export automatically writes these out in a way that will be easy to read into another distributed processing engine like dataprow or
dataflow.