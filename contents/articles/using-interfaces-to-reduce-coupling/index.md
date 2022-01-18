---
title: Using Interfaces to reduce coupling
author: ben-wendt
layout: post
date: 2013-06-28
template: article.pug
url: /2013/06/28/using-interfaces-to-reduce-coupling/
categories:
  - PHP
tags:
  - coupling
  - oop
---
Consider the following three scenarios:

  1. <pre class="brush: php; title: ; notranslate" title="">class Dog {
...
    public function Bark($str) {
        echo $str;
    }
...
}

class AnimalCommunication {
...
    public function DogBark(Dog $dog, $str) {
        $dog-&gt;Bark($str);
    }
...
}</pre>

  2. <pre class="brush: php; title: ; notranslate" title="">class Dog {
...
    public function Bark($str) {
        echo $str;
    }
...
}


class AnimalCommunication {
...
    public function AnimalCommunicate($str) {
        echo $str;
    }
...
}</pre>

  3. <pre class="brush: php; title: ; notranslate" title="">Interface IAnimal {
    public function Speak($str);
}

Class Dog implements IAnimal {
...
    public function Speak($str) {
        $this-&gt;Bark($str);
    }
....
}
class AnimalCommunication {
...
    public function AnimalCommunicate(IAnimal $animal, $str) {
        $animal-&gt;speak($str);
    }
...
}</pre>

Note the following about these examples:

  1. The first is tightly coupled to the dog class, and hence is not very extensible.
  2. The second is coupled to echo. It does not allow different &#8220;animals&#8221; to output their text differently. What if we later added a `TelepathicGecko` class, which didn&#8217;t echo out to speak, but rather published to some ESP API somewhere? Clearly the coupling here is not ideal either.
  3. The third is best. By programming to an interface, we reduce coupling to the minimum necessary amount.
