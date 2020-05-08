---
title: Shell Primer
draft: true
---


A filesystem is a tree
----------------------

A computer that has storage stores data in what you can think of as one long
continuous block of ones and zeros.

https://blog.jfo.click/c-and-simple-types/

This data needs to be organized _somehow_.  Imagine a huge library whose books
are in no particular order.  Not very useful, right? Or how about a good chunk
of those books' pages are split up and spread out among all the shelves and
crammed in between each other. Even less useful! They need to be organized
according to some sort of system. A filing system.

This is what a filesystem does on a computer. [Here's a longer
article](https://arstechnica.com/gadgets/2008/03/past-present-future-file-systems/)
that goes into some more technical details about that!


Those details are very interesting! But for now, all you need to know is that
the filesystem organizes your data into a _tree_ consisting of a series of
_nodes_ each of which can be one of either:

1- a file of any type
2- a directory that can contain files and other directories

This maps pretty well to the common understanding of files and folders that you
will likely be used to, just from navigating the graphical user interface of
your computer.

tilde sweet tilde
---------------------
![img](http://tilde.club/~ford/tildepoint.jpg)

Open up `terminal`. You'll be greeted with something that looks a little like
this:

<style>
  @keyframes blinker {
    70% { opacity: 0; }
  }
</style>
<pre>
  <code>
    <div>Last login: Wed Mar 21 11:55:32 on ttys013 </div>
    <div>~ $<span style="animation: blinker 1s linear infinite;"> ▓</span></div>
  </code>
</pre>

This is the command line, and you're looking at the command prompt. The tilde
`~` is the directory you're in right now, it defaults to your home directory,
[which tilde is a shorthand
for](https://medium.com/message/tilde-club-i-had-a-couple-drinks-and-woke-up-with-1-000-nerds-a8904f0a2ebf<Paste>).

Let's learn us a couple of commands! For each command, just type it in and then
press `enter`.

```
pwd
```

This stands for "print working directory," and does what it says on the tin.
The "working directory" is the directory that you're currently _in_, and this
command prints the _full path_ of that directory. Mine looks like this:

```
~ $ pwd
/Users/jfo
```

Yep, that's where I am, that's my home directory, it's the _full path_ of what
`~` is short for.

Remember how I said that the filesystem is structured as a tree? the _root_ of
that tree has a full path as well, and it looks like this:

```
/
```

Every file and every folder on your computer has a full path that starts right
there, at the root directory. We'll visit it in a minute! Let's learn a couple
more commands first.

```
ls
```


Applications
Desktop
Documents
Downloads
Library
Movies
Music
Pictures
Public
Sites
VirtualBox VMs
bird.png
code
development
dotfiles
github
go
local
notes
sandbox


Every command is a program
--------------------------
$PATH

You have an identity
--------------------


how do you move around the file system?

cd for change directory.

cd . and cd .. and cd ~ are special. cd by itself is like cd ~

how about cd - that's a special trick!

ls

touch maybe

what a file _is_

editor - subl nano vim emacs
mac osx 'open' will launch whatever the default handler is

man

running a program.
ruby python node php
