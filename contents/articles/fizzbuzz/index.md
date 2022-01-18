---
title: Fizzbuzz in Different Paradigms / Techniques
author: ben-wendt
date: 2019-01-01
template: article.pug
---

I was reading an [article on Fizzbuzz](http://iolivia.me/posts/fizzbuzz-in-10-languages/). Across the various languages used, the article has two recurring techniques. For each technique listed here, I will give it a rating on a scale of my choosing. The two techniques listed in the article are:

<span class="more"></span>

1\. conditional logic
---------------------

This is the standard technique that everyone, regardless of experience, would probably think of first. The following example will run in every c inspired language known to humankind (actually, unless otherwise noted, all code is js).

```js
    for (i = 0 ; i < 33 ; i++) {
      if (i % 15 == 0) {
        console.log('fizzbuzz')
      } else if (i % 5 == 0) {
        console.log('fizz')
      } else if (i % 3 == 0) {
        console.log('buzz')
      } else {
        console.log(i)
      } 
    }
```

understandableness factor: ⭐⭐⭐

The cool-ness here is entirely due to being immediately understandable by anyone who has had an intro to programming.

2\. pattern match
-----------------

Fancy (i.e. “functional”) languages do a fancy thing called pattern matching, which is a lot like coding a conditional, but you let the compiler / runtime / interpreter determine when a variable matches a certain pattern rather than checking whether a certain condition is true. So instead if saying, if x is like this, do that, you would say when x matches this, do that.

Here’s an example in elixir because I am not smart enough for haskell:

```elixir
    defmodule FizzBuzz do
        def run(x) when rem(x, 15) == 0 do
            IO.puts("fizzbuzz")
        end
        def run(x) when rem(x, 5) == 0 do
            IO.puts("fizz")
        end
        def run(x) when rem(x, 3) == 0 do
            IO.puts("buzz")
        end
        def run(x) do
            IO.puts(x)
        end
    end
    Enum.each(0..31, fn(x)-> 
        FizzBuzz.run(x)
    end)
```

cool factor: ⭐⭐⭐⭐

This is a built in language feature, but pattern matches are definitely more interesting than condtionals.

Feeling a little let down.
--------------------------

Given that there are ten languages in the article and only two techniques, I was disappointed. I’ve done a lot of _“write x-in-y”_ posts before, but I feel like there isn’t much point in writing the same code in ten different syntaxes. I thought it would be cool to see what other techniques could be devised.

0\. array programming
---------------------

I googled how someone would do this in an array programming language, and found a [terrific article explaining all about how to do so in j](https://wycd.net/posts/2017-01-19-fizz-buzz-and-triangles-in-j.html). The idea is to filter the list by which numbers match which modulus, and then do a lookup into an array to get the correct answer.

cool factor: ⭐⭐⭐⭐

Anything in j is super cool.

1\. exception handling
----------------------

They tell you not to use exception handling for control flow. But everyone keeps doing it, so it must be good. There’s one `if` statement in there that I would love to get rid of, but it would be difficult without jumping through more hoops than this jokey article deserves.

```js
    fbs = [[15, 'fizzbuzz'], [5, 'fizz'], [3, 'buzz']]
    for (i = 0 ; i < 16; i++) {
        fails = 0
      try {
        for (e of fbs) {
    
          x = e[0]
          msg = e[1]
          a = [() => console.log(msg)]
          try {
            a[i % x]()
            break
          } catch (e) {
            fails++
            if (fails > 2) {
              throw e
            }
          }
        }
      } catch (e) {
        console.log(i);
      }
    }
```

kludge factor: 🦃🦃🦃🦃🦃

I give this one five kludge turkeys. Two for using the exception control flow thing, and three for calling the function in an array accessed by modulus that will raise and error when the modulus isn’t zero. I wanted to just divide by zero, but javascript is wrong and thinks that division by zero returns infinity, so I had to kludge it up a notch.

2\. boolean operators (`if`s in disguise)
-----------------------------------------

This takes advantage of the short circuiting nature of `&&` and `||` to simulate the conditional logic.

```js
     for (i = 0 ; i < 17 ; i++) {
        ((i % 15 == 0) &&
          (console.log('fizzbuzz') || true))
        || ((i % 5 == 0) &&
          (console.log('fizz') || true))
        || ((i % 3 == 0) &&
          (console.log('buzz') || true))
        || console.log(i)
      }
```

hack factor: 💽💽💽💽

I give this one four cd-roms. You will honestly see code that uses the short circuiting of boolean operators for control flow, and in fact some languages like php and ruby have special low-priority `and` and `or` operators to supplement `&&` and `||` that are specifically meant for control flow. So you’re definitely a hacker if you use this.

3\. multiplication (`if`s in a better disguise)
-----------------------------------------------

Some languages let you multiply strings by integers to make repeated strings, e.g. `2 * 'oy' == 'oyoy'`. Ruby does this.

We can exploit this to make fizz buzz by doing slightly convoluted things to multiply fizz, buzz, and fizzbuzz by either 1 or 0 times to make the desired strings. This effectively is re-implementing the if conditional by doing something 0 or 1 times:

```ruby
    def fizzbuzz_mult(n)
      s = ('fizzbuzz'*(1- [1,n% 15].min)) 
      s << 'fizz    ' * (1 - s.length / 8) * (1- [1,n% 5].min)
      s << 'buzz    ' * (1 - s.length / 8) * (1- [1,n% 3].min)
      s << n.to_s * (1 - s.length / 8)
      s.strip
    end
    
    1.upto(16).each {|n| puts fizzbuzz_mult(n)}
```

hack factor: 💽💽💽💽💽

This is essentially a hack on top of the boolean method, so it gets one extra hacker cd-rom.

4\. done declaratively in sql
-----------------------------

I’m so happy about this one. Every line has a little treat:

```sql
    select distinct on (range.num)
      coalesce(msg, cast(range.num as text))
    from (select * from generate_series(1, 16) num) as range
      left join (
        values ('fizzbuzz', 15),
          ('fizz', 5),
          ('buzz', 3)
      ) as lookup (msg, num)
      on range.num % lookup.num = 0;
```

awesome factor: 🎆🎆🎆🎆🎆

This one gets full awesome-ness score. With my undying infatuation with SQL, I can’t help but fawn over joining the series generation to a `SELECT VALUES`, then using `DISTINCT ON` to only return the first joined value, and coalescing in the default case from the nulls. It’s really lovely. Rock on SQL!

5\. list reduction
------------------

This is in ruby again. The idea is to evaluate all of the if options until one is found to pass, then short circuit out of the rest of the loop. I really like the `1` modulus, `n` message part of this that keeps the special default case in the same reduction. The fizzbuzz problem is basic, but in it’s spirit it is really about handling a list of preferred possibilties. In that lens, this is the best solution.

```ruby
    def fizzbuzz(n)
      [[15, :fizzbuzz], [5, :fizz], [3, :buzz], [1, n]].reduce(true) do |a, (m, msg)|
        a && if n % m == 0
          puts msg
          false
        else
          true
        end
      end
    end
    
    0.upto(16) do |i|
      fizzbuzz(i)
    end
```

Loveability: 💞💞💞💞

I really like how this hides the conditional logic behind a list reduction. This is actually a really useful technique when you have to evaluate an arbitary number of booleans.

6\. oop
-------

This is, of course, a bunch of java boilerplate wrapped around the original conditional technique. I prefer this in a way though. We’re only ever doing the conditional check once in any of these implementations, but in the real world this technique is better because we isolate that logic in the factory, and the let our polymorphism handle any future differences in behaviour.

```java
    interface FizzBuzzable {
      void say();
    }
    
    abstract class FizzBuzzer implements FizzBuzzable {
    }
    
    class FizzBuzz extends FizzBuzzer {
      void say() {
        println("fizzbuzz"); 
      }
    }
    
    class Fizz extends FizzBuzzer {
      void say() {
        println("fizz"); 
      }
    }
    
    class Buzz extends FizzBuzzer {
      void say() {
        println("buzz");
      }
    }
    
    class Other extends FizzBuzzer {
      int n;
      Other(int m) {
       n = m; 
      }
      void say() {
        println(n);
      }
    } 
    
    class FizzBuzzFactory {
      FizzBuzzer getFizzBuzzer(int n) {
        if (n % 15 == 0) {
          return new FizzBuzz(); 
        } else if (n % 5 == 0) {
          return new Fizz(); 
        } else if (n % 3 == 0) {
          return new Buzz(); 
        } 
        return new Other(n);
      }
    }
    
    FizzBuzzFactory factory = new FizzBuzzFactory();
    for (int i = 0; i < 17; i++) {
      (factory.getFizzBuzzer(i)).say();
    }
```

Enterprisey-ness score: 🏦🏦🏦

This is enterprisey, but not that enterprisey. It needs more lines of code.

Usefulness score: 🛠🛠🛠🛠

If you were actually coding something with more complex logic than writing out a string given a certain condtion, polymorphism would be a useful tool to reach for.

7\. functions
-------------

This one makes use of functions and currying. The checks will only happen if the previous failed.

```js
    modder = (m) => (x) => x % m == 0
    mod15 = modder(15)
    mod5 = modder(5)
    mod3 = modder(3)
    
    fizzbuzzCurry = (fn, msg) => (n, a) => fn(n)? console.log(msg) : a[0](n, a.slice(1))
    
    sayFizzbuzz = fizzbuzzCurry(mod15, 'fizzbuzz')
    sayFizz = fizzbuzzCurry(mod5, 'fizz')
    sayBuzz = fizzbuzzCurry(mod3, 'buzz')
    sayDefault = n => console.log(n) // so it does not also output empty array
    
    fizzbuzz = (n) => sayFizzbuzz(n, [sayFizz, sayBuzz, sayDefault])
    
    for (i = 0; i < 17; i++) {
      fizzbuzz(i)
    }
```

functional score: λλλλ

I really enjoy how this one uses some functional programming concepts to achieve the desired result.

8\. code generation
-------------------

This one is mostly done to be silly. No one would ever do this, but I suppose that if you did it would make sense to only generate this ridiculous code once, to a file, then use that from then on.

```php
    <?php
    
    define('BIGGEST_NUMBER', 32767);
    
    $str = 'function fizzbuzz($n) {' . "\n";
    
    for ($i = 0; $i < BIGGEST_NUMBER; $i++) {
      $msg = '';
      if ($i % 15 == 0) {
        $msg = 'fizzbuzz';
      } else if ($i % 5 == 0) {
        $msg = 'fizz';
      } else if ($i % 3 == 0) {
        $msg = 'buzz';
      } else {
        $msg = $i;
      }
      $str .= 'if($n == ' . $i . '){echo "' . $msg  . "\\n\"; return;}\n";
    }
    $str .= 'echo("error: this function only works with positive 16 bit signed integers.\n");';
    $str .= "}\n";
    
    eval($str);
    
    for ($i = 0; $i < 17; $i++) {
      fizzbuzz($i);
    }
 ```   

The code that this generates is 32000 lines of:

```php
    function fizzbuzz($n) {
    if($n == 0){echo "fizzbuzz\n"; return;}
    if($n == 1){echo "1\n"; return;}
    if($n == 2){echo "2\n"; return;}
    if($n == 3){echo "buzz\n"; return;}
    if($n == 4){echo "4\n"; return;}
    if($n == 5){echo "fizz\n"; return;}
    if($n == 6){echo "buzz\n"; return;}
    if($n == 7){echo "7\n"; return;}
    if($n == 8){echo "8\n"; return;}
    if($n == 9){echo "buzz\n"; return;}
    if($n == 10){echo "fizz\n"; return;}
    if($n == 11){echo "11\n"; return;}
    if($n == 12){echo "buzz\n"; return;}
    if($n == 13){echo "13\n"; return;}
    if($n == 14){echo "14\n"; return;}
    if($n == 15){echo "fizzbuzz\n"; return;}
    ...
```

kludgey-ness score: 💩💩💩💩💩

I only filled this in because it’s another unconventional technique that would solve this question.

9\. declaratively in css
------------------------

This one uses css’s nth-child formulae, and `content` to fill in the values. I kind of hate this one, because I don’t think you can refer to which child is matched in the `content` attribute, so you have to set up a separate css rule for each default case, making them totally not default and going against the spirit of the.

```html
    <style>
    .fizzbuzz :nth-child(15n+1):after {
     content: '1'
    }
    .fizzbuzz :nth-child(15n+2):after {
     content: '2'
    }
    .fizzbuzz :nth-child(15n+3):after {
     content: 'buzz'WSh-child(15n+9):after {
     content: '9'
    }
    .fizzbuzz :nth-child(15n+10):after {
     content: '10'
    }
    .fizzbuzz :nth-child(15n+11):after {
     content: '11'
    }
    .fizzbuzz :nth-child(15n+12):after {
     content: '12'
    }
    .fizzbuzz :nth-child(15n+13):after {
     content: '13'
    }
    .fizzbuzz :nth-child(15n+14):after {
     content: '14'
    }
    body .fizzbuzz :nth-child(15n+0):after {
     content: 'fizzbuzz'
    }
    </style>
    <div class='fizzbuzz'>
      <div></div>
      <div></div>
      <div></div>
      <div></div>
      <div></div>
      <div></div>
      <div></div>
      <div></div>
      <div></div>
      as many of these as desired.
    </div>
```

kludge score: 💩💩

I give this one two poops of kludge.

Conclusion
----------

I set out to solve this issue in ten different ways, instead of in ten different languages. I ended up stealing one of the techniques, but ended up using 7 languages in this article. It has been a really fun exercise. In the 1992 Remix of _Scenario_ from _A Tribe Called Quest_ Cut Monitor Milo asks “What does it take to check a technique?”, the answer: “Many styles, many styles!” I have enjoying checking my technique and working on my many styles while making this. If I ever have to apply for a job again, and they ask me about this chestnut, I may surprise them with 32000 lines of PHP.