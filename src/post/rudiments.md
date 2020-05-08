---
title: Noob
draft: true
---

Sometimes people ask me about learning to program. That's great! I am always
happy to talk about it! There are so many resources available these days that I
can point people to, especially for beginners.

But I often find that folks can get stuck on rudimentary concepts that can
slow them down with learning other things. This is usually not that big a deal!
But sometimes it might be enough to derail momentum, and at an early stage,
that can spell the end of things.

Sandboxed environments like Codeacademy mean well, they are just trying to hide
a lot of the complexity of what's running what so you can focus on learning
concepts, but I think there are some rudimentary concepts that are really,
really important, and not really that hard to understand, that can help a lot.

What data _is_
--------------

Everything in a computer is data. Data is `1`'s and `0`'s organized in specific
ways and interpreted in specific ways. Everything a computer touches is data.

Every file on your computer is just data, that's it. Different file formats
encode things in different ways, but they all boil down to `1` and `0` in the
end, at least until we get quantum computers working at a consumer pricepoint.


Interacting with your computer.
--------------------------

The computer is a machine... a "calculator with benefits." But we are so
used to interacting with it graphically that it can seem like that's all there
is. We click, we scroll, we read. When I started, the command line terrified
me, and why wouldn't it? It seemed so alien and dangerous.

Of course, you should never run a command that you don't understand or that
doesn't come from a trusted source, but there really isn't anything to be
afraid of.  The command line, or terminal, is just another way to interact with
the computer.

There's nothing inherently better about this as compared to a graphical user
interface (GUI) like the ones everyone who touches a computer these days is
used to,

How do you interface with computers? We are so used to a gui, and that's fine,
but an understanding of command line work is vital to being able to grok the
system as a whole

what is the file system? a tree, mostly. How do you navigate that system?

Some commands to definitely, definitely know:

man
pwd
ls
cd
cp
mv
cat
mkdir
tree maybe

Understanding that code is text files. That's it! That's all they are! html,
for example, is simply a text file written to a spec that a browser knows how
to read to produce an output.

Similarly, a ruby file is a text file written to a spec that the Ruby
interpreter knows how to read as instructions to do something. A `.py` file is
a text file written to a spec that the python interpreter knows how to
interpret as instructions. There is nothing special about the file itself other
than that it is written in valid python or valid ruby, in fact, some
expressions that the two languages have in common can be run through both
interpreters to obtain a result:

```ruby
# thing.txt
print 2 + 2
```

Is valid Ruby, and it is valid Python.

```
ruby thing.txt
```
and

```
python thing.txt
```

Both print out `4`. The suffix is arbitrary to a mac or linux system. (I think
the suffixes matter more in windows land.)
