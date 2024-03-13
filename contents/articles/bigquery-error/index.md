---
title: An uninformative error in bigquery
author: ben-wendt
layout: post
date: 2023-10-25
template: article.pug
---

Just a quick note about an uninformative error I saw in bigquery the other day
and was having trouble finding on google. If you see the error:

```
MaterializedView is required for DerivationSpec
```

When trying to create a materialized view in bigquery on google cloud platform (GCP),
it means you didn't specify the query, or including an empty query. It's an easy
mistake to make. Maybe this will help someone some day.
