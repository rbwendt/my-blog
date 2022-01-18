---
title: Relevance Graphing
author: ben-wendt
layout: post
date: 2016-03-27
template: article.pug
---

Last month a workmate and I flew down to San Francisco to go to elasticon.


I attended an interesting talk given two employees of [Giant Oak](http://giantoak.com).
Giant Oak does contracting for government agencies to try to solve social problems. I
am not sure if this is their motto but one of the speakers say that they "see the people
behind the data," which sounds really cool.

<span class="more"></span>

Their work involves things like trying to answer questions about war insurgency, or 
terrorism. They don't work on computer science questions, but social science
questions. Some of their analytical tools for social scientists are built on ElasticSearch.

One of the tools used to reveal data poaching data was a graph
representation of their data.

The graph databases I've used, like neo4j, allow a user to define
entities and create a graph by defining relationships between those
entities. But elasticsearch has a new feature coming out in version 5 for
auto generating edges based on relevance. A user will not have to manually
set up these relations when creating data. One of the developers
Giant Oak made an elasticsearch reporting tool, similar to kibana,
called [unicorn](https://github.com/giantoak/unicorn).
It is built for revealing relationships between records in the database, and
uses existing elasticsearch technology.

As opposed to standard graph databases
where the relationships on the edges of graphs are explicitly
defined, this tool generates entity relationships based on relevance. So
when different documents share attributes, they are linked.

This work has led to over 100 arrests of human
traffickers and poachers. Revealing the stories hidden the data,
can be fun or informative, or even save people's lives and make the
world a better place.

