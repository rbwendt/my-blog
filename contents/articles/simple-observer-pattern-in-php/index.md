---
title: Simple Observer Pattern in PHP
author: ben-wendt
layout: post
date: 2013-07-03
template: article.pug
url: /2013/07/03/simple-observer-pattern-in-php/
categories:
  - PHP
tags:
  - design patterns
  - observer
---
The observer pattern is a nifty way to decouple objects from one another. Rather than having methods explicitly rely on, create, and access other objects, the other objects can subscribe to an object and enact their own changes as necessary.

Our implementation will have two general groups of objects, subscribers and observers. A subscriber class will hook in to an observer class and make actions when the observer publishes certain messages. The observer class will give objects methods to subscribe and unsubscribe from its messages.

We'll begin by setting up an interface for our subscribers. Our subscribers could really be anything, so we want to specify some general behaviour that they will have. We don't want to be restrictive and have an abstract class that they will inherit from because that would restrict functionality of all subscribers and limit the usefulness of this pattern.

```php
interface Subscriber {
	public function EventCall($str);
}
```

Now we&#8217;ll set up an abstract class for Observables. This may be more useful as a trait but we actually do have to implement some functionality here.

```php
abstract class Observable {
	private $_subscribers = array();
	public function Subscribe($o) {
		// give objects an ability to add themselves to the subscribers list.
		if (!in_array($o, $this->_subscribers)) {
			$this->_subscribers[] = $o;
		}
	}
	public function Unsubscribe($o) {
		// give objects an ability to remove themselves from the subscribers list.
		if (in_array($o, $this->_subscribers)) {
			foreach($this->_subscribers as $key => $value) {
				if ($o == $value) {
					unset($this->_subscribers[$key]);
				}
			}
		}	
	}
	public function Event($event) {
		// when the event occurs, call the corresponding method on the clients.
		foreach($this->_subscribers as $subscriber) {
			$subscriber->EventCall($event);
		}
	}
}
```

Now that the abstract class and interface are ready, we can make some concrete classes based on these.

```php
class Observer extends Observable {
	public function Talk() {
		echo "I am an observern";
	}
}

class Subscriber1 implements Subscriber{
	public function EventCall($str) {
		echo "Subscriber1 event occured $strn";
	}
}

class Subscriber2 implements Subscriber {
	private $data;
	public function __construct($data) {
		$this->data = $data;
	}
	public function EventCall($str) {
		echo "Subscriber2 event occured $str data is " . $this->data . "n";
	}
}

class Subscriber3 implements Subscriber {
	public function EventCall($str) {
		echo "Subscriber3 event occured $strn";
	}
}
```

And now let's make some instances of these:

```php
$observer = new Observer();
$subscriber1 = new Subscriber1();
$subscriber2 = new Subscriber2('one');
$subscriber2too = new Subscriber2('two');
$subscriber3 = new Subscriber3();

$observer->Subscribe($subscriber1);
$observer->Subscribe($subscriber2);
$observer->Subscribe($subscriber2);
$observer->Subscribe($subscriber2too);
$observer->Subscribe($subscriber3);

$observer->Event('wow check out this awesome message that is being passed, bro.');
$observer->Talk();

$observer->Unsubscribe($subscriber2);

$observer->Event('what unheard of madness will happen next?');
```

And of course the output is:

> Subscriber1 event occured wow check out this awesome message that is being passed, bro.
  
> Subscriber2 event occured wow check out this awesome message that is being passed, bro. data is one
  
> Subscriber2 event occured wow check out this awesome message that is being passed, bro. data is two
  
> Subscriber3 event occured wow check out this awesome message that is being passed, bro.
  
> I am an observer
  
> Subscriber1 event occured what unheard of madness will happen next?
  
> Subscriber2 event occured what unheard of madness will happen next? data is two
  
> Subscriber3 event occured what unheard of madness will happen next?
