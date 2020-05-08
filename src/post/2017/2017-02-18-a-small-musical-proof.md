---
date: 2017-02-18T00:00:00Z
title: A Small Musical Proof
---

Yesterday, [Miles Okazaki](http://www.milesokazaki.com/) tweeted a thing on the twitter.

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">Was just noticing some things about 3-note diatonic fragments - any thoughts? Also, a cat with hearts and roses: <a href="https://t.co/IBL2uIXWMd">pic.twitter.com/IBL2uIXWMd</a></p>&mdash; Miles Okazaki (@milesokazaki) <a href="https://twitter.com/milesokazaki/status/832736147394658305">17 February 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

It's a sketch thinking about groups of notes and how many keys they can exist
in. This is a thing we can know.

# Nerdsniped

I banged out a little script to answer the question posed on the bottom left of the page:

> There are no groups of three notes that can be in 6 different keys (Is this true?)

I used ruby because I still heart it and that's what I always use to bang out
little scripts. My coworker Jacob always uses perl for the same types of
things, which makes me think that in ten years Ruby will be like Perl is now,
which is an unrelated observation that I'm going to trail off on.

Anyway, it turns out that it is, true, that is.. Let's see why.

First, we need a way to represent notes. Of course, there are a [bunch of libs
and gems and
stuff](https://www.google.com/search?q=ruby+music+theory+library&oq=ruby+music+theory+library&aqs=chrome..69i57j69i64l3.3277j0j1&sourceid=chrome&ie=UTF-8#q=ruby+music+theory+library+gem)
that make it easy(er) to work with musical concepts and sound generation and
midi and stuff in ruby land, but I don't need any of that really. I just need a way to
represent notes. I don't really care about the note names, and enharmonics gum
everything up. I'll just use the numbers `0` through `11` to represent the 12
chromatic notes.

```ruby
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
```

I am thinking of `0` as a C natural, but it's really pretty arbitrary. If it
were `C`, the corresponding tones (using just flats) would be:

```ruby
# C,  Db, D,  Eb, E,  F,  Gb, G,  Ab, A,  Bb, B
[ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11 ]
```

I can get the same numbers by describing them as a `range`, which is more
compact and logical in this case.

```ruby
(0..11)
```

Next, I need to have a way to represent keys. I'm only concerned with 12 major
scales. To begin, I'll look at what would be "C major" in these numbers.

```ruby
# C, D, E, F, G, A, B
[ 0, 2, 4, 5, 7, 9, 11 ]
```

Notice I don't repeat the 12- that would be another C. These numbers represent
C major. What if I want D major? In music land, I would just transpose this up
a major 2nd. With numbers, this is easy! Since each integer is a semitone (half
step), adding 2 to each number will transpose each of them up a whole step:

```ruby
# D,  E,  F#, G,  A,  B   C#
[ 2,  4,  6,  7,  9,  11, 13 ]
```

A wrinkle here, of course, is that 13 is too high for this system since I'm
only concerned with notes within an octave. An easy fix is to mod 12 all the
numbers though!

```ruby
# D,  E,  F#, G,  A,  B   C#
[ 2,  4,  6,  7,  9,  11, 1 ]
```

What if I wanted to get to Ab major? That is 8 steps up. I'll start with the C
major array and map an addition of 8 mod 12 over it to get this new key:

```ruby
[ 0, 2, 4, 5, 7, 9, 11 ].map {|note| note + 8 % 12 }
```

Which yields:

```ruby
[8, 10, 0, 1, 3, 5, 7]
```

If you cross reference this with the note map above, you'll see that these
numbers do indeed match the notes of Ab major. Great job everyone.

So, I can put these together to get myself an array of arrays that represent
one of each of 12 keys!

I start with the canonical C major scale and that range of all twelve notes
from before:

```ruby
cmajor = [0,2,4,5,7,9,11]
roots = (0..11)
```

Now, for each root, I'll add its distance from C (which happens to be its
chromatic note value!) to the C major scale, and mod 12 it just like before.

```ruby
roots.map do |root|
    cmajor.map do |note|
        (note + root) % 12
    end
end
```

Which yields all of those keys:

```ruby
[
    [0, 2, 4, 5, 7, 9, 11],
    [1, 3, 5, 6, 8, 10, 0],
    [2, 4, 6, 7, 9, 11, 1],
    [3, 5, 7, 8, 10, 0, 2],
    [4, 6, 8, 9, 11, 1, 3],
    [5, 7, 9, 10, 0, 2, 4],
    [6, 8, 10, 11, 1, 3, 5],
    [7, 9, 11, 0, 2, 4, 6],
    [8, 10, 0, 1, 3, 5, 7],
    [9, 11, 1, 2, 4, 6, 8],
    [10, 0, 2, 3, 5, 7, 9],
    [11, 1, 3, 4, 6, 8, 10]
]
```

# Note groups

Next, the question is: are there groups of any 3 notes that exist in 6 keys at
once?

For this, we need a way to generate all the possible three note sets. In other
words, we want all possible combinations of 3 notes made out of the range of
notes numbered `(0..11)`

This is shockingly easy to do in Ruby land. Yay ruby! First we make an array
out of that range:

```
(0..11).to_a
# [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
```

Next we call
[Array#combination](https://ruby-doc.org/core-2.2.0/Array.html#method-i-combination)
with argument `3` and turn the resulting [Enumerator](http://ruby-doc.org/core-2.2.0/Enumerator.html) back into an Array.

```ruby
(0..11).to_a.combination(3).to_a
```

Which yields :

```ruby
[[0, 1, 2], [0, 1, 3], [0, 1, 4], [0, 1, 5], [0, 1, 6], [0, 1, 7], [0, 1, 8], [0, 1, 9], [0, 1, 10], [0, 1, 11], [0, 2, 3], [0, 2, 4], [0, 2, 5], [0, 2, 6], [0, 2, 7], [0, 2, 8], [0, 2, 9], [0, 2, 10], [0, 2, 11], [0, 3, 4], [0, 3, 5], [0, 3, 6], [0, 3, 7], [0, 3, 8], [0, 3, 9], [0, 3, 10], [0, 3, 11], [0, 4, 5], [0, 4, 6], [0, 4, 7], [0, 4, 8], [0, 4, 9], [0, 4, 10], [0, 4, 11], [0, 5, 6], [0, 5, 7], [0, 5, 8], [0, 5, 9], [0, 5, 10], [0, 5, 11], [0, 6, 7], [0, 6, 8], [0, 6, 9], [0, 6, 10], [0, 6, 11], [0, 7, 8], [0, 7, 9], [0, 7, 10], [0, 7, 11], [0, 8, 9], [0, 8, 10], [0, 8, 11], [0, 9, 10], [0, 9, 11], [0, 10, 11], [1, 2, 3], [1, 2, 4], [1, 2, 5], [1, 2, 6], [1, 2, 7], [1, 2, 8], [1, 2, 9], [1, 2, 10], [1, 2, 11], [1, 3, 4], [1, 3, 5], [1, 3, 6], [1, 3, 7], [1, 3, 8], [1, 3, 9], [1, 3, 10], [1, 3, 11], [1, 4, 5], [1, 4, 6], [1, 4, 7], [1, 4, 8], [1, 4, 9], [1, 4, 10], [1, 4, 11], [1, 5, 6], [1, 5, 7], [1, 5, 8], [1, 5, 9], [1, 5, 10], [1, 5, 11], [1, 6, 7], [1, 6, 8], [1, 6, 9], [1, 6, 10], [1, 6, 11], [1, 7, 8], [1, 7, 9], [1, 7, 10], [1, 7, 11], [1, 8, 9], [1, 8, 10], [1, 8, 11], [1, 9, 10], [1, 9, 11], [1, 10, 11], [2, 3, 4], [2, 3, 5], [2, 3, 6], [2, 3, 7], [2, 3, 8], [2, 3, 9], [2, 3, 10], [2, 3, 11], [2, 4, 5], [2, 4, 6], [2, 4, 7], [2, 4, 8], [2, 4, 9], [2, 4, 10], [2, 4, 11], [2, 5, 6], [2, 5, 7], [2, 5, 8], [2, 5, 9], [2, 5, 10], [2, 5, 11], [2, 6, 7], [2, 6, 8], [2, 6, 9], [2, 6, 10], [2, 6, 11], [2, 7, 8], [2, 7, 9], [2, 7, 10], [2, 7, 11], [2, 8, 9], [2, 8, 10], [2, 8, 11], [2, 9, 10], [2, 9, 11], [2, 10, 11], [3, 4, 5], [3, 4, 6], [3, 4, 7], [3, 4, 8], [3, 4, 9], [3, 4, 10], [3, 4, 11], [3, 5, 6], [3, 5, 7], [3, 5, 8], [3, 5, 9], [3, 5, 10], [3, 5, 11], [3, 6, 7], [3, 6, 8], [3, 6, 9], [3, 6, 10], [3, 6, 11], [3, 7, 8], [3, 7, 9], [3, 7, 10], [3, 7, 11], [3, 8, 9], [3, 8, 10], [3, 8, 11], [3, 9, 10], [3, 9, 11], [3, 10, 11], [4, 5, 6], [4, 5, 7], [4, 5, 8], [4, 5, 9], [4, 5, 10], [4, 5, 11], [4, 6, 7], [4, 6, 8], [4, 6, 9], [4, 6, 10], [4, 6, 11], [4, 7, 8], [4, 7, 9], [4, 7, 10], [4, 7, 11], [4, 8, 9], [4, 8, 10], [4, 8, 11], [4, 9, 10], [4, 9, 11], [4, 10, 11], [5, 6, 7], [5, 6, 8], [5, 6, 9], [5, 6, 10], [5, 6, 11], [5, 7, 8], [5, 7, 9], [5, 7, 10], [5, 7, 11], [5, 8, 9], [5, 8, 10], [5, 8, 11], [5, 9, 10], [5, 9, 11], [5, 10, 11], [6, 7, 8], [6, 7, 9], [6, 7, 10], [6, 7, 11], [6, 8, 9], [6, 8, 10], [6, 8, 11], [6, 9, 10], [6, 9, 11], [6, 10, 11], [7, 8, 9], [7, 8, 10], [7, 8, 11], [7, 9, 10], [7, 9, 11], [7, 10, 11], [8, 9, 10], [8, 9, 11], [8, 10, 11], [9, 10, 11]]
```

Note that this behaves differently than
[Array#permutation](https://ruby-doc.org/core-2.2.0/Array.html#method-i-permutation),
which will return arrays that for our purposes would be redundant (`[0,1,2]`
and `[2,0,1]` would be considered different, for example. `Array#combination`
does not include these redundancies).

# [The Dirty Work](https://www.youtube.com/watch?v=ghcsrblhn7A)

Now that we have both a representation of all twelve major keys and a
collection of all the pitch sets we'd like to know something about, we are in a
position to ask and answer some questions.

So a reminder: `keys` looks like this:

```ruby
cmajor = [0,2,4,5,7,9,11]
keys = roots.map do |root|
    cmajor.map do |note|
        (note + root) % 12
    end
end
```
and `groups` looks like this:

```ruby
groups =  (0..11).to_a.combination(3).to_a
```


And the question we want answered is "Are there any groups of three notes that
exist in 6 keys."

A natural deconstruction of this question would be "for each group, how many keys is it in?" and further, "for a given group and a given key, is the group in the key or not?"

Let's take these 1 by 1 backwards.

How about this... is the note group `[0,4,7]` in the key of F? F looks like

```ruby
[5, 7, 9, 10, 0, 2, 4]
```

This turns out to be a very easy thing to check, using the `&` operator.

```ruby
[0,4,7] & [5, 7, 9, 10, 0, 2, 4] == [0,4,7]
```

Well hot damn.

```ruby
true
```

The `&` operator is borrowed from the [bitwise
operations](https://en.wikipedia.org/wiki/Bitwise_operation#AND), but does here
what you'd expect. It returns a new array that has only the elements that are
in both arrays. So,

```ruby
[1,2,3] & [1,2]
```
is

```ruby
[1, 2]
```

This is the same as the [intersection of two
sets](https://en.wikipedia.org/wiki/Intersection_(set_theory)), and
interestingly, ruby treats these arrays as sets in this case, discarding
elements that are the same.

```ruby
[1,1,1] & [1,1]
```
```ruby
[1]
```

How about... is [4,9,11] in the key of Db major?

```ruby
[4,9,11] & [1, 3, 5, 6, 8, 10, 0] == [4,9,11]
```

So this says, "take the intersection of the given note group and the given key.
Is the result the same as the given note group? If yes, all the notes in that
group were in the key.

This one's not though.

```ruby
false
```

Alright we know how to check if a single group is in a single key. Let's do the
next thing, which is to see _how many_ keys a given group is in. This is also
easy!

Let's take group [3,5,9]. This would be Eb/D#, F, and A if you're keeping score at home.

Next we'll map over the `keys` and replace each element with the answer to the
question "is this group in this key?"

```ruby
keys.map do |key|
    [3,5,9] & key == [3,5,9]
end
```

This give us this result:

```ruby
[false, false, false, false, false, false, false, false, false, false, true, false]
```

This group is only in one key, which you can figure from it's position is: Bb.

We're not super interested in the actual keys though, we only care about the
number of keys.

```ruby
keys.map do |key|
    [3,5,9] & key == [3,5,9]
end.count(true)
```

Now we get back a single number. `1`.

Penultimate question. "For _each group of three notes_, how many keys is it in."

We wrap that above block in _another_ map, this time over the groups themselves.

```ruby
groups.map do |group|
    keys.map do |key|
        group & key == group
    end.count(true)
end
```

This replaces each group of notes with the number of keys it appears in. Again,
we're discarding which keys, we don't really care about that.

```ruby
[0, 2, 0, 2, 1, 1, 2, 0, 2, 0, 2, 3, 4, 1, 5, 1, 4, 3, 2, 0, 4, 1, 3, 3, 1, 4, 0, 2, 1, 3, 0, 3, 1, 2, 1, 5, 3, 3, 5, 1, 1, 1, 1, 1, 1, 2, 4, 4, 2, 0, 3, 0, 2, 2, 0, 0, 2, 0, 2, 1, 1, 2, 0, 2, 2, 3, 4, 1, 5, 1, 4, 3, 0, 4, 1, 3, 3, 1, 4, 2, 1, 3, 0, 3, 1, 1, 5, 3, 3, 5, 1, 1, 1, 1, 2, 4, 4, 0, 3, 2, 0, 2, 0, 2, 1, 1, 2, 0, 2, 3, 4, 1, 5, 1, 4, 0, 4, 1, 3, 3, 1, 2, 1, 3, 0, 3, 1, 5, 3, 3, 1, 1, 1, 2, 4, 0, 0, 2, 0, 2, 1, 1, 2, 2, 3, 4, 1, 5, 1, 0, 4, 1, 3, 3, 2, 1, 3, 0, 1, 5, 3, 1, 1, 2, 0, 2, 0, 2, 1, 1, 2, 3, 4, 1, 5, 0, 4, 1, 3, 2, 1, 3, 1, 5, 1, 0, 2, 0, 2, 1, 2, 3, 4, 1, 0, 4, 1, 2, 1, 1, 0, 2, 0, 2, 2, 3, 4, 0, 4, 2, 0, 2, 0, 2, 3, 0, 0, 2, 2, 0]
```

Finally, all we have to do now is ask: "Does this array contain the number 6?"
(let's pretend I assigned the above array to `counts`)

```ruby
arr.contain? 6
# false
```

And that's our answer. The whole thing could look like this:

```ruby
cmajor = [0,2,4,5,7,9,11]
roots = (0..11)
keys = roots.map do |root|
    cmajor.map do |note|
        (note + root) % 12
    end
end

groups =  (0..11).to_a.combination(3).to_a

counts = groups.map do |group|
    keys.map do |key|
        group & key == group
    end.count(true)
end

p counts.include? 6
# false
```

# Compactify.

Look at all those long variable names and multi-line blocks.. What an
abomination. What kind of functional programmer would I be if I let myself by
without making this into an inexplicable one liner. Not much of one, that's
what kind! Lol jk but Imma do it anyway.

```ruby
(0..11).to_a.combination(3).to_a.map{|g|(0..11).map{|i|[0,2,4,5,7,9,11].map{|e|(e+i)%12}}.map{|k|(g&k)==g}.count(true)}.to_a.include?(6)
```

As expected, `false`. Go team.

# Coda

Ok, so, this is all a little contrived and I realize that. But it's a great
example of something! There was a question that had an answer, and that answer
was definitively worked out through every conceivable combination of some
things. It wasn't the smartest way to figure this out, there are easier and
more [logical ways to do
so](https://twitter.com/themadwort/status/832738527209103360). It was a brute
force method, but it took me only a couple of minutes to produce initially, and it
answered the question just fine, relying on first principles and knowledge of
only how many notes there are and what the structure of a major scale is.

Thanks to Miles Okazaki for the nerd snipe, and also for being a really kick
ass [musician](https://www.youtube.com/watch?v=MFNldzReNq8) and
[pedagogue](http://fundamentalsofguitar.com/).

This has been a short post. I'm trying to get better maybe at writing short
fast posts. I'm working on a long one though that has a bunch of math and stuff
in it, so see you next time I guess, dear reader.
