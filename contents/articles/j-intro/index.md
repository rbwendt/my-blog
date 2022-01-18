---
title: Introduction to J
author: ben-wendt
date: 2018-01-01
template: article.pug
---

I tried using j for some of my [advent of code](http://github.com/rbwendt/advent-of-code-2017/) puzzles. I found it wasn’t totally suitable for a lot of the challenges, but I had fun learning about J nonetheless.

<span class="more"></span>

J is a declarative and functional array programming language. I like this quote from [J’s new user guide](http://code.jsoftware.com/wiki/Guides/GettingStarted):

> J isn’t just another way to declare variables and write loops. J is a way of thinking big: describing an algorithm by looking at it as a whole and breaking it into its natural parts. You’re going to have to spend some time learning what those natural parts are. Your skill as a program designer will help, but it will be fighting against your learned tendency to think small.

But I won’t be giving an example of that. I’ll just show how some of [J’s vocabulary](http://www.jsoftware.com/help/dictionary/vocabul.htm) works.

Here’s how to multiply two numbers in J:
```
       4 * 4
    16
```
But let’s look at a silly way of doing the same multiplication:
```
       NB. note that comments in J start with NB., for nota bene
       1
    1
       NB. commands read right to left.
    
       NB. $ is the reshape operator it will take the input and
       NB. change it into an array with the size on the left.
       4 $ 1
    1 1 1 1
       NB. you can reshape to multiple dimensions
       4 4 $ 1
    1 1 1 1
    1 1 1 1
    1 1 1 1
    1 1 1 1
       NB. now we have 4 * 4 = 16 ones above, we need to add them up.
    
       NB. / is the insert operator. It adds it's left operand between
       NB. everything in the right operand.
       NB. So this shows the sum of all of the columns:
       + / 4 4 $ 1
    4 4 4 4
       NB. So, to get the result of 4 * 4, we need to apply the + insert twice:
       + / + / 4 4 $ 1
    16
```
Now, let’s imagine Guass knew J [when he was in school](https://notesonmathematics.wordpress.com/2013/04/01/the-gauss-triangle-trick/), he could have done this:
```
       +/ 1 + i.100
    5050
```
Which probably isn’t as fun as the original story.

And for day of of 2017 advent of code, the question was very well suited for J. It gives you a 16 x 16 array of numbers, and asks for the sum of the max of each column minus the minus of each column. So in J, that was:
```
    e =: 790 ... NB. tonnes of numbers
    NB. reshape the input.
    f =: 16 16 $ e
    
    NB. insert the minimum into the list
    max =: >./
    NB. insert the maximum into the list
    min =: <./
    
    NB. sum of maxes minus mins. (|: is transpose)
    +/ (max |: f - min |: f) NB. answer
```
And that’s it. I really love J but I doubt I’ll get any chance to use it professionally.