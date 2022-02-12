---
title: I Did a Deep Q Learning Course
author: ben-wendt
layout: post
date: 2022-02-11
template: article.pug
---

I had access to udemy courses back when
I was working at Deloitte Digital. One interesting course I did was
the [introduction to deep q learning from Pieran Data](https://www.udemy.com/course/practical-ai-with-python-and-reinforcement-learning/). Deep Q learning
is a way to use neural nets to do reinforcement learning. It was an interesting course
and I learned a lot, so I'll give a recap here.

<span class="more"></span>

Classical Q learning is a reinforcement learning algorithm that revolves
around making a table of all possible states and actions, and gives an
expected reward for each of these combinations. For problems with a
continuous state or action space, the states and choices are discretized
by bucketing (and bucket distribution is a hyperparameter).

The table is made iteratively. At first it's filled with zeroes, as no
rewards are known, and choices are made at random. Expected reward values
are updated using the [Bellman Equation](https://en.wikipedia.org/wiki/Bellman_equation).
As expected reward values are updated, the randomness of action choices is reduced to fine-tune the reward values (this is called the Epsilon Greedy Strategy).

Classic Q learning is great for a certain class of reinforcement learning problems.
Here's an example we did in the course of classic q learning beating the "hill
car challenge.":

<video controls width="250"><source src="hill-car-classic-q.mp4" type="video/mp4">Sorry, your browser doesn't support embedded videos.</video>

This works great but most realistic problems have too large a space of states
and actions, even after bucketing. The key insight of deep Q learning is that
similar states will lead to similar actions, so we can model the states and actions
using neural networks to make it a tractable problem. It's been almost a year since
I covered this materal , and I feel pretty rusty so I won't get too deep into it,
but here's an example we did in the course of getting an AI that can play
Atari games:

<video controls width="250"><source src="breakout.mp4" type="video/mp4">Sorry, your browser doesn't support embedded videos.</video>

Overall it's a very cool technique but I doubt I'll ever get much use out of it.