---
title: A Tale From Microservice Hell
author: ben-wendt
date: 2022-09-21
template: article.pug
---

Ages ago I was working as a contractor on a data engineering
team, working on a knowledge graph platform that was built on
a service architecture.

<span class="more"></span>

The platform had dozens of services. Each service had its
code in its own repository. We used containers for
deployment, testing, and so on. This meant we had dozens of
containers to migrate over. Several of the containers
were built on top of other containers, for example there was
a base python container, and a base java container. All of
these containers had images hosted on docker hub.

A decision was made to change container registries. This meant
we would have to go in to every repository, update the 
container deployment in the CD code, then once that was merged,
update the container pull code and make a separate pull
request in an infra repo to update the container location there. 
And because we had several base containers, that meant there were
several more containers that we would need to deal with, and
we would need to handle those base containers first.

All told, each repo had two or three PRs needed to update the
container repository, and across the dozens of repositories this
added up to about 40 pull requests. I decided that the 40 subtasks
would overwhelm JIRA so all tracking was done in a big spreadsheet
with rows for each container image and columns for each task state.

I eventually got through the migration, but it was pretty painful.
The process put a large PR overhead on the team for the several
weeks the job took to complete. The mechanical part of updating
everything was manageable, but the hardest part was tracking down
all the different stake holders to determine which images were in
use, and which were not (and did not need to be migrated). Even with
my best efforts there we still missed a couple images that we had
to go back and migrate later.