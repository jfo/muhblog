---
title: Mapping the Monado
date: 2017-09-15
---

I have recently come into possession of a reasonably sound understanding of
monads. Tradition dictates that I now have an obligation to write a blog
post/tutorial/thing about them, wherein I attempt to gracefully share this
nascent knowledge through the judicious use of carefully chosen metaphors and
examples.  Legend has it that [I will inevitably
fail](https://byorgey.wordpress.com/2009/01/12/abstraction-intuition-and-the-monad-tutorial-fallacy/)
in this, and then be raked over the coals for my sins by both category
theorists and Haskellers alike. This isn't very appealing to me, but who am I
to challenge fate?

<hr>

I would not call this a tutorial, and though it might feel like it, at times,
I assume no real authority. I'm just trying to explain some things I've
just learned a bit about. Monads are particularly prickly both to explain and
understand, for a variety of reasons, but something that came up over and over
again while I was reading about them  was the necessity of "developing an
intuition."

To that end, [I've included a lot of links I found helpful at the end of this
post](#ref). Reading different takes on the subject can help to develop that
intuition in a way that no single tutorial ever could, and though
many posts like this start with something along the lines of "I know the world
doesn't need another monad tutorial," I beg to differ. The only thing so far
that's made any of this click at all for me is the overlapping bits of all
these different posts and tutorials and such. It's a little like [mapping the
potato!](http://www.moishelettvin.com/2015/12/16/lowering-the-bar/)

So here's a little bit of the potato!

<hr>

Monads have a reputation. Why?

1. The term is [imprecise](https://en.wikipedia.org/wiki/Monad) across
   disciplines, and even many professed experts
   [disagree](https://en.wikipedia.org/wiki/Talk:Monad_(functional_programming)/Archive_1)
   on what constitutes a reasonable approach to explaining them in a programming
   context.

2. ...despite this, the term _is_ precise within [category
   theory](https://en.wikipedia.org/wiki/Monad_(category_theory)), which is a
   fascinating but also particularly advanced and abstract branch of mathematics.

3. ...and the term is _also_ precise [within
   Haskell](https://wiki.haskell.org/Monad), which is a _also_ a fascinating
   but particularly advanced and abstract programming language.

Those two precisions seem to not always _quite_ line up, exactly. Certainly,
the Haskell monads are derived from category theory, but the nomenclature is
dense on both sides and is difficult to parse out if you're new to both of
them.

Though I appreciate that a _complete_ comprehension of monads and their
theoretical underpinnings may very well be predicated on becoming intimate with
category theory, I completely reject the assertion that a even a rudimentary and
useful understanding of monads and their applications _must_ be preceded by that
study.

I'm not alone in this. [Philip
Wadler](https://en.wikipedia.org/wiki/Philip_Wadler), in one of the [_very first
papers_](https://page.mi.fu-berlin.de/scravy/realworldhaskell/materialien/the-essence-of-functional-programming.pdf)
ever written describing the practical uses of monads in functional programs,
said as much:

> The concept of a monad comes from category theory, but this paper assumes no
> prior knowledge of such arcana. Rather, it is intended as a gentle introduction,
> with an emphasis on why abstruse theory may be of interest to computing
> scientists.

Here's [Brian Beckman](https://www.linkedin.com/in/brianbeckman/)
fullthroatedly [making a similar
point.](https://www.youtube.com/watch?v=ZhuHCtR3xq8&feature=youtu.be&t=26m20s)

> ...and that's where we go into category theory... but you _don't need_ to know
> category theory, to be fully conversant, to be _fully fluent_ in this language
> of function composition. All you have to remember is the types need to line up.

As I write this post, I know _very little_ real category theory, and _very
little_ Haskell... but I still have a working understanding of monads. This post
is as much a record of that understanding _at this time_ as it is anything,
and that understanding will likely change and grow richer and more nuanced if and
when I _do_ learn more about category theory and/or Haskell (as you might
expect, this process has piqued my interest in learning [more category theory](https://bartoszmilewski.com/2014/10/28/category-theory-for-programmers-the-preface/)
and/or Haskell!)

I'm not making an indictment of either of those in this post, either. I'm just
saying it's not a _prerequisite_ to developing an understanding and intuition
of what monads are and do. Beckman goes on...

> If you're going to nest function calls, the types have to line up. There's
> nothing complicated about this you don't need to know category theory to... I mean
> if you _want_ to learn category theory to understand the full, flowering glory
> of the consequences of this astonishing... you can and by all means, it will
> only increase your richness, but you can now speak French in the world of monoidal
> categories because you understand, that as long as the types line up, then
> **compositionality makes sense**.

<hr>

A monad is _three things_ that, working together, satisfy _three
rules_, and that is what makes them, in aggregate, a monad.

The three things are:

a type of thing
-------------

The structure doesn't matter, only that it satisfies a certain interface I'll
get into below.

`unit()`
--------

`unit` takes a value and returns a _new_ something of a type that incorporates
that initial value.  It's _almost_ just a constructor.

In javascript, I could use the `new` keyword for this. Again, it does not
matter what the structure of the returned thing is. I'll simply return an
object that has a `value` property.

```js
const Thing = function(x) {
    return {
        value: x
    };
}
```

For now, `unit` will simply be a wrapper around this constructor.

```js
const unit = function(x) {
    return new Thing(x);
}
```

I will use only the `unit` function below, and it always means `new Thing()`.

`bind()`
--------

_This is not javascript's bind function._

Vanilla javascript doesn't have any typing to help here. I'm going to use a
little [Typescript](https://www.typescriptlang.org/) instead. You can just think
at it as javascript with type annotations!

Here is a function that takes a number and adds one to it and return a number!

```js
const addOne = function(x: number) : number {
    return x + 1;
}
```

What if I want to add one to a `Thing`?

```js
let mx = unit(1);
addOne(mx);
```

`mx` is a `Thing`, and `addOne` expects and `number`, so I get this compilation
error:

```
../monad.ts (15,12): Argument of type 'Thing' is not assignable to parameter of type 'number'. (2345)
```

> In vanilla javascript, this _does work_. What it returns is much worse than
> useless, though.
>
```
[object Object]1
```
>
> It casts my `Thing` to a string by calling `Thing.prototype.toString()`,
> which returned `"[object Object]"`, then it "added" "1" to it by concatenating the
> string `"1"` onto the end. Typescript catches this error.

What I really wanted is a function `addOneToThing` that can add one to the
`value` of a `Thing`.

```js
const addOneToThing = function(mx: Thing) : Thing {
    return unit(mx.value + 1);
}
```

This function takes a `Thing` and returns a _new_ `Thing`. And it does what I would
expect it to.

```js
let mx = unit(1);
addOneToThing(mx);
```

```
{ value: 2 }
```

`addOneToThing` _knows_ about `Thing`s. It knows how to get a value out of a
thing and it knows how to make a new one.

`bind` is a function that knows how to _apply a function to an underlying type
contained inside of another type._

For this example, the underlying type is a `number`, and the another type is a
`Thing`, which is just an object with a `value` property that is a number!

```js
const bind = function(fn: Function, mx: Thing) {
    return fn(mx.value);
}
```

`bind` knows about `.value`, so `addOne` doesn't have to be `addOneToThing`
anymore. I can just use `bind`!

What do I get, then, if I _bind_ `addOne` to a `Thing`?

```js
bind(addOne, unit(1));
```

I get:

```
2
```

This certainly works, but I am left with a `number` instead of a `Thing`. If I
try to bind another function to the return value, now:

```js
console.log(
    bind(addOne, bind(addOne, unit(1)))
);
```
```
NaN
```

> You might expect to see a type error like
```
Argument of type 'number' is not assignable to parameter of type 'Thing'. (2345)
```
> But `bind` is dynamically applying a function and can't be statically type checked here.

If I wanted to _chain_ these calls, then any function that is bound in this
fashion must accept a _bare_ (underlying) value and _return a new `Thing`_.

> "If you're going to nest function calls, the types have to line up."

You'll see this written a lot as `a -> M b`, where `a` and `b` are, say,
numbers, and `M b` is, say, a number "wrapped" in some other structure or type.

I'll redefine `addOne` then, to do this, and add a `timesTwo` function to help
with the next example. The function signatures below amount to `a -> M b` where
`M b` is a `Thing(number)` and `a` and `b` are `number`s.

```js
const addOne = function(x: number) : Thing {
    return unit(x + 1);
};
const timesTwo = function(x: number) : Thing {
    return unit(x * 2);
};
```

Now, if I

```typescript
bind(addOne, unit(1))
```
I get a `Thing` back...

```
Thing { value: 2 }
```

and if I

```typescript
bind(timesTwo, bind(addOne, unit(1)))
```

I _also_ get a `Thing` back!

```
Thing { value: 4 }
```

Interesting...

So, this is _all_ that is needed to satisfy:

the three laws
==============

Described in terms of the preceding functions `unit` and `bind`, and using
`addOne` and `timesTwo` as arbitrary example functions that _happen_ to have
this `a -> M b` type signature, they are:

left identity
--------------

Binding a function to a monad must result in the same output as calling the
bare function on the value(s) contained "inside" the monad.

so,

```js
bind(addOne, unit(1))
```
must be equivalent to:

```js
addone(1);
```

They are! They both return:

```
{ value: 2 }
```

right identity
--------------

Binding a unit function to a monad must result in the same thing as simply
calling the unit function on a bare value.

So,

```js
bind(unit, unit(1))
```
must be equivalent to:

```js
unit(1);
```

They are! They both return:

```
{ value: 1 }
```

associativity
--------------

Functions should be able to be composed together in any grouping and result in
the same ouput regardless of that grouping, assuming they are applied in the
same order.

`compose` takes 2 functions and returns a _new function_ that composes them
together. `compose(g, f)` then, returns a function that takes an input `mx`,
`bind`s `g` to it, and then `binds` `f` to _that_.

```js
const compose = function(g, f) {
    return function(mx) {
        bind(f, bind(g, mx));
    }
}
```

So,

```js
bind(addOne, compose(timesTwo, addOne)(mx))
```
must be equivalent to:

```js
compose(addOne, addOne)(bind(timesTwo, mx))
```

They are! they both return

```
{ value: 4 }
```


> [I briefly confused associativity with commutativity.](http://lambda-the-ultimate.org/node/2448)

but... _why_
----------

The usefulness of this construct is probably not readily apparent, but in
actual fact this is very powerful and can be used for many things, _especially_
in a purely functional context!

Last year, I wrote a completely pure, 100% pass by value functional lisp called
[Sild](/sild-is-a-lisp-dialect). There is not much to recommend it, really...
there are no types, not even _numbers_, just labels and lists. There is no
mutable state, there are no `let`s or `do`s either.

It's only quote, car, cdr, cons, eq, atom, cond, and lambda, and it has
define, but only at the top level, and it has display for printing to stdout,
and _that's all_.

Can I use monads in sild for anything useful? It turns out that I can!

I'll start by implementing the same thing from above, the `identity` monad.

```scheme
(define unit
 (lambda (x)
  (cons x '() )))
```

I have no way of creating objects other than lists, or types of any kind at
all, in Sild, but let's call a  "`Thing`" simply something that is wrapped in a
list. Remember, it doesn't really matter what the _structure of the type_ is,
only that these particular interfaces are satisfied.

`unit` is a function that will take something and wrap it in a list, then!

```scheme
(unit '(a b c))
```
```
((a b c))
```

Remember that `bind` needs to know how to "get at" that internal value. In this
case, it's as simple as unwrapping that outer list by using `car` and then
applying the given function to it.

```scheme
(define bind
  (lambda (f mx)
    (f (car mx))))
```

This is already _a_ monad! I've got a _type_ of something, in this case denoted by
a doubly wrapped list. I have `unit` which takes a value and makes it into a
thing of that "type", and I have `bind`, which knows how to "unwrap" the value
and apply a function to it!

Remember that the function it applies must have the type signature `a -> M b`.
I don't have a type system to help here! But, any function I pass in needs to
take some value and return it as a "`Thing`", in this case by wrapping it in a
list.

Here are three test functions that do that:

```scheme
(define push_a
  (lambda (x) (unit (cons 'a x))))
(define push_c
  (lambda (x) (unit (cons 'c x))))
(define pop
  (lambda (x) (unit (cdr x))))
```

I'll also need `compose`, of course, to test for associativity. That looks just
like the js version:

```scheme
(define compose (lambda (g f)
  (lambda (m)
    (bind f
      (bind g m)))))
```

Does this already pass the tests? I don't have any list equality functions to
check with, but we can just look at the output!

```scheme
; this is a bare value to start with, it's just a list with a few symbols in it.
(define y '(a b c))
; and here's a monadic version of that, created with `unit`!
(define My (unit y ))

; left identity
(display (bind pop My))  ; ((b c))
(display (pop y))        ; ((b c))

; right identity
(display (bind unit My)) ; ((a b c))
(display My)             ; ((a b c))

; ; associativity
(display (bind push_c ((compose push_a pop) My))) ; ((c a b c))
(display ((compose pop push_c) (bind push_a My))) ; ((c a b c))
```

This is the identity monad!

A digression Monads are _"like"_ functions
-------------------------

Monads, like functions, are an _abstraction_. Functions can be thought of in
metaphorical terms... a black box, a machine with inputs and outputs, these are
intuitively correct but insufficient descriptions of what a function _is_.
Monads can also be thought of in metaphorical terms. A monad is a container, a
monad is a burrito, a bucket, or a package... more abstractly (and accurately,
but not completely) as a sort of composition of functions on types... likewise,
these metaphors can be intuitively correct but insufficient. Consider much of
the language I use above... "get at that internal value" accurately describes
what "bind" is doing for me right now, _but_ it's not at all sufficient to
describe the _general_ case of what makes something monadic, just a _common_
and easy to understand one. This is only part of the potato, is what I'm saying.

Simlarly, monads are _not_ the structure of type `Thing`, and `Thing` alone,
though acting as a container, is _not_ a monad.  `Thing` _plus_ the `unit` and
`bind` procedures made available to work with and around it _together_ make up
the monad.

You might ask, what does this make _possible_, then? Well, what do _functions_
make possible, exactly? Does that question even really make _sense_? Is it
specific enough to have any answer besides "a lot of things"?

It doesn't really matter how you architect these procedures and types, what
matters is the availability of these rudimentary operations and their ability to
pass those three tests: left identity, right identity, and associativity. That is _all_
that matters in terms of defining a monad. To prove this, here's another
Identity monad implemented in a more object oriented way, This time using PHP.

First, I'll define an interface that any monadic class will need to implement.

```php
<?
interface Monad {
    public static function unit($x);
    public function bind(callable $fn);
}
```

Now, I'll make one!

```php
<?

class ID implements Monad {

    private $value;

    private function __construct($n) {
        $this->value = $n;
    }

    public static function unit($x) {
        return new ID($x);
    }

    public function bind(callable $fn) {
        return $fn($this->value);
    }

    public function compose(callable $g, callable $f) {
        return $g($this->value)->bind($f);
    }
}
```

Here are two functions that I can pass to `bind`.

```php
<?

$increment = function($n) { return ID::unit($n + 1); };
$times2    = function($n) { return ID::unit($n * 2); };
```

Does this pass those tests?

```php
<?

# left identity
ID::unit(1)->bind($increment) == $increment(1)

# right identity
ID::unit(1)->bind("ID::unit") == ID::unit(1)

# associativity identity
ID::unit(1)->compose($increment, $times2)->bind($increment) ==
ID::unit(1)->bind($increment)->compose($times2, $increment);

```

All of these are:

```
bool(true)
```

Notice something important, here... those `bind`s are _not returning self_.
There's no mutation happening to the original object, it's a completely new
`ID`, each and every time. I'm not going to say that's the most efficient
pattern in terms of memory use, but languages designed for purely functional
calculations employ techniques to mitigate and [abstract this
away](http://okasaki.blogspot.dk/2008/02/ten-years-of-purely-functional-data.html)


Back to Sild and something actually useful...
-----------

How can I keep track of all the functions I've run on an object? In a stateful
language, this is pretty easy. Here's one way to do so in some Ruby:

```ruby
class Whatever
    attr_reader :history, :value

    def initialize
        @history = []
        @value = 0
    end

    def inc
        @history << 'inc'
        @value += 1
        self
    end

    def dec
        @history << 'dec'
        @value -= 1
        self
    end
end

x = Whatever.new
x.inc.inc.dec.inc.inc.inc.dec.dec.dec

puts x.value # 1
puts x.history.join(", ") # inc, inc, dec, inc, inc, inc, dec, dec, dec
```

I'm sure that could be metaprogrammed and monkeypatched into Object if you
wanted to debug _everything_ run on _everything_.

But, how could I _possibly_ do this in a pure language, with no mutability or
global state, and no side effects? It can be done!

I'm going to implement a [writer
monad](http://adit.io/posts/2013-06-10-three-useful-monads.html#the-writer-monad)
that will let me keep a log of all the functions I've run, in Sild.

First, I'll define some aliases I like to use:

```scheme
(define def define)
(def λ lambda)
```

Sild is not especially smart, but you _can_ use arbitrary unicode like `λ` and
redefine basic language keywords, which is nice.

I'll also define a few old fashioned lisp functions.

```scheme
(def cadr (λ (l) (car (cdr l))))
(def caadr (λ (l) (car (car (cdr l)))))
```

I'll also need a couple of utility functions...

`reverse` will reverse a list.

```scheme
(def revinner
 (λ (l acc)
  (cond l (revinner (cdr l) (cons (car l) acc))
        acc)))
(def reverse (λ (l) (revinner l '())))
```

`unshift` will "push" something on to the _end_ of a list. It's the opposite of
`cons` and `push`.  [Here read this!](http://www.perlmonks.org/?node_id=613124)

```scheme
(def unshift
  (λ (el l)
    (reverse (cons el (reverse l)))))
```

Ok, with these useful extras out of the way, let's get to the meat of things.

Here's the unit function. This monad will have the form:

```
(() ())
```

...that is to say, it must be a list with two lists inside of it.
The first will be the value, the second will be the record (history) of all the
procedures that were bound to the monad. `unit` then will take a value (a
list), and 'wrap' it into a monad with a blank history.

```scheme
(def unit
  (λ (x)
    (cons x '(()))))
```

I'll have a constructor, that simply takes two lists and wraps them up.

```scheme
(def constructor
  (λ (value history)
    (cons value (cons history '()))))
```

And I'll define a few aliases to make it clearer what I'm doing to `Thing`s

```scheme
; some aliases to make usage clearer when applied to `Thing`s.
(def get-val car)
(def get-hist cadr)
(def get-most-recent-hist caadr)
```

Here's a function that writes a new element to a history and returns a new
Thing with that new history, leaving the value unchanged.

```scheme
; takes a symbol `sym` and a monad `Mx` and returns a new monad with the symbol
; appended to its history list
(def write-to-hist
  (λ (sym Mx)
    (constructor (get-val Mx)
                 (unshift sym (get-hist Mx)))))
```

Next, I'll need this function that takes two `Thing`s, an old one and a new one.
It merges the histories, and returns a new `Thing` with the new value and the
merged histories.

```scheme
; takes two monads, an old one and a new one. Combines the new's value with the
; old's history while appending the new's most recent history entry.
(def combine-hist
  (λ (m-old m-new)
; if both histories are equal, it's empty. We don't need to merge anything,
; just return the new one:
    (cond (eq (get-hist m-old) (get-hist m-new)) m-new
; otherwise, write the most recent history entry from the new to the old and
; return a new monad made of the value of the new and the merged histories
              (constructor
                (get-val m-new)
                (get-hist (write-to-hist (get-most-recent-hist m-new)
                                         m-old))))))
```

It's our friend, bind! in this case, we apply the function with signature `a ->
M b` to the extracted value, and combine histories, and we're done!

```scheme
(def bind
  (λ (f Mx)
    (combine-hist Mx
                  (f (get-val Mx)))))
```

It might seem like not much is happening here- to be fair, I've hidden quite
a bit of complexity in that `combine-history` function. But this is truly
"where the magic happens." Because `bind` "knows" so much about the structure
of this monad, and has references available to both the old and new state of
the monads as they are being operated on, I can _do stuff_ here. This writer
monad is a type of "state" monad because it "persists" state throughout these
function calls. `bind` is the place and the mechanism for that persistence. But
this is _only one use_ of monads, and a relatively simple one at that.

A salient take home point: `bind`'s implementation for any particular monad is
where a lot of the complexity is both implemented and hidden away.

Now, I'll also need some functions of the form `a -> M b`.

```scheme
; takes a datum to push into something and a name for the function to be
; recorded into history as and returns a function that pushes into a value and
; returns a monad
(def makepusher
  (λ (datum name)
    (λ (l) (write-to-hist name (unit (cons datum l))))))

(def push-a (makepusher 'a 'push-a))
(def push-b (makepusher 'b 'push-b))
(def push-c (makepusher 'c 'push-c))
; this will break if the monad's value list is empty! caveat lisper
(def pop    (λ (l) (write-to-hist 'pop (unit (cdr l)))))
```

And finally, compose, which looks and acts just like the js example.

```scheme
(def compose
  (λ (g f)
    (λ (m) (bind f (bind g m)))))
```

With all of this out of the way, what do we get? Does this pass those three tests?

```scheme
; an initial value state to play with
(def y '(a b c))
; an initial monad with that initial value state to play with
(def My (unit y))

; left identity
(display (bind pop My))  ; ((b c) (pop))
(display (pop y))        ; ((b c) (pop))

; right identity
(display My)             ; ((a b c) ())
(display (bind unit My)) ; ((a b c) ())

; associativity
(display (bind push-c ((compose push-a pop) My))) ; ((c a b c) (push-a pop push-c))
(display ((compose pop push-c) (bind push-a My))) ; ((c a b c) (push-a pop push-c))
```

Indeed it does. This is a monad! And look here,

```scheme
(display (bind push-c
          (bind pop
           (bind pop
            (bind push-a
             (bind push-b
              (bind push-c
               (bind pop
                (bind pop My)))))))))
; ((c c c) (pop pop push-c push-b push-a pop pop push-c))
```

This monad has a "memory", a history of everything that's been bound to it! That is useful!

Thanks to Gabe Herrera, Adit Bhargava, Vaibhav Sagar, Veit Heller, Julia Evans, and Alan O'Donnell for discussing drafts of this post with me.

<div id="ref">

References
------------

Here are a bunch of things I read or watched to do this post. In no particular
order. I'd recommend reading as many things as you can get your hands on to get
different perspectives and facets presented in as many ways as possible.

- [Typeclassopedia](https://wiki.haskell.org/Typeclassopedia)
- [Monads in JavaScript](https://curiosity-driven.org/monads-in-javascript)
- [Monads, Arrows, and Idioms](http://homepages.inf.ed.ac.uk/wadler/topics/monads.html), a collection of papers by Philip Wadler
- [You Could Have Invented Monads! (And Maybe You Already Have.)](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html) by Dan Piponi
- [Abstraction, intuition, and the “monad tutorial fallacy”](https://byorgey.wordpress.com/2009/01/12/abstraction-intuition-and-the-monad-tutorial-fallacy/) by Brent Yorgey
- [The "What Are Monads?" Fallacy](https://two-wrongs.com/the-what-are-monads-fallacy)
- [Don't fear the Monad](https://www.youtube.com/watch?v=ZhuHCtR3xq8) by Brian Beckman
- [Monad Anti-tutorial](http://vaibhavsagar.com/blog/2016/10/12/monad-anti-tutorial/) by Vaibhav Sagar
- [Monads and Programming](http://goodmath.scientopia.org/2012/08/19/monads-and-programming/) by Mark Chu-Carroll
- [Monad laws for regular developers](https://miklos-martin.github.io/learn/fp/2016/03/10/monad-laws-for-regular-developers.html) by Miklos Martin
- [Question about the Monad associativity laws](http://lambda-the-ultimate.org/node/2448)
- [All About Monads]( https://web.archive.org/web/20050204001716/http://www.nomaware.com/monads/html/index.html )
- [A Schemer's Introduction to Monads](http://www.ccs.neu.edu/home/dherman/browse/shared/notes/monads/monads-for-schemers.txt) by Dave Herman
- [The Functor Typeclass](http://learnyouahaskell.com/making-our-own-types-and-typeclasses#the-functor-typeclass) from LYAHFGG
- [Functors, Applicative Functors and Monoids](http://learnyouahaskell.com/functors-applicative-functors-and-monoids) from LYAHFGG
- [Monad Laws](https://wiki.haskell.org/Monad_laws) from the Haskell wiki
- [Functors, Applicatives, And Monads In Pictures](http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html) by Aditya Bhargava
- [Three Useful Monads](http://adit.io/posts/2013-06-10-three-useful-monads.html) by Aditya Bhargava
- [Explanation of Monad laws](https://stackoverflow.com/questions/3433608/explanation-of-monad-laws) from SO
- [What is a functor?](https://medium.com/@dtinth/what-is-a-functor-dcf510b098b6) by Thai Pangsakulyanont
- [A Fistful of Monads](http://learnyouahaskell.com/a-fistful-of-monads) from LYAHFGG
- [Javascript Functor, Applicative, Monads in pictures](https://medium.com/@tzehsiang/javascript-functor-applicative-monads-in-pictures-b567c6415221) 'by' Tze-Hsiang Lin
- [A monad is just a monoid in the category of endofunctors. what's the problem?](http://slides.com/julientournay/a-monad-is-just-a-monoid-in-the-category-of-endofunctors-what-s-the-problem/#/) by Julien Tournay
- [Monads, part one](https://ericlippert.com/2013/02/21/monads-part-one/#more-461) by Eric Lippert (this whole series is excellent)
- [The Monad Laws](http://etymon.blogspot.dk/2006/09/monad-laws.html) by Andrae Muys
- [Composing Monadic Functions with Kleisli Arrows](http://blog.ssanj.net/posts/2017-06-07-composing-monadic-functions-with-kleisli-arrows.html)
- [The Marvellously Mysterious Javascript Maybe Monad](https://jrsinclair.com/articles/2016/marvellously-mysterious-javascript-maybe-monad/) by James Sinclair
- [Functional programming: Monads made clear - in javascript](http://blog.klipse.tech/javascript/2016/08/31/monads-javascript.html) by Yehonathan Sharvit
- [Translation from Haskell to JavaScript of selected portions of the best introduction to monads I’ve ever read](https://blog.jcoglan.com/2011/03/05/translation-from-haskell-to-javascript-of-selected-portions-of-the-best-introduction-to-monads-ive-ever-read/) by James Coglan
- [Monads and Objects](http://www.lispcast.com/monads-and-objects) on LispCast
- [A grumpy rant that makes some good points](https://karma-engineering.com/lab/wiki/Monads2)
