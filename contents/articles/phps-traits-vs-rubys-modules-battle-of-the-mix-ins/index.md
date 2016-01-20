---
title: 'PHP’s traits vs. ruby’s modules: Battle of the mix-ins'
author: ben-wendt
layout: post
date: 2015-04-10
template: article.jade
url: /2015/04/09/phps-traits-vs-rubys-modules-battle-of-the-mix-ins/
categories:
  - PHP
  - ruby
---


A mixin is a class-like language construct meant to add functionality to another class. They are not meant to stand on their own, and generally speaking they cannot. Mixins can be used to give different classes the same interface. Mixins can be compared to multiple inheritence in what they let you accomplish, but they don&#8217;t work the same way. Rather than inheriting from multiple classes, you mix them in. (Hence the obvious name.)

<span class="more"></span>


PHP, always a late-comer feature-wise in terms of object oriented goodness, got traits in version 5.4.0. Traits allow the developer to add methods to a class with the `use` statement, like this:

<pre class="brush: php; title: ; notranslate" title="">interface Vehicle {
    public function move();
}

trait Wheel {
    public function move() {
        // roll.
    }
}

class Bicycle implements Vehicle {
    use Wheel;
}

$bicycle = new Bicycle;

$bicycle-&gt;move();

</pre>

At this point, Bicycle will implement Vehicle. Even though you a `move` method is not explicitly specified in the class, the call on the object will work. Traits can only be assigned to a class in the class definition.

Ruby supports mixins using modules. That can be done like this:

<pre class="brush: ruby; title: ; notranslate" title="">module Wheel
  def move
    # roll.
  end
end

class Bicycle
  include Wheel
end

bicycle = Bicycle.new

bicycle.move
</pre>

At this point, an instance of `Bicycle` will have a `roll` method, but the class `Bicycle` will not. This is because mixins get attached to the instance, not the class. This is the opposite of what happens in PHP.

In this way, PHP&#8217;s trait design differs fairly substantially from ruby&#8217;s mixin. In my mind, this is most likely because in PHP ideally all of your classes implement an interface. This is a nice feature because it helps a lot with static analysis. Ruby, on the other hand, doesn&#8217;t have interfaces as a language construct; classes do, of course, have interfaces but no part of the interpreter is enforcing signatures like the `implements` keyword makes PHP enforce method signatures. The standard argument against enforcing interfaces is that two unrelated classes can share a signature, so the signature doesn&#8217;t really tell you anything about the class.

In the end, neither approach is the ideal case for adding functionality to classes. I can&#8217;t think of an object oriented language that doesn&#8217;t support dependency injection. As long as you can set properties on an object and call methods, you should be able to do dependency injection. Developers should prefer composition over inheritance. It prevents code coupling: better to couple to a class in one decision than have coupled classes throughout your code base. Inheritance should be a fall-back, but you should always try to implement composition first.
