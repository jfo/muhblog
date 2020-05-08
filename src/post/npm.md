---
title: Dependency Purgatory
date: 2017-01-02
draft: true
---

Every few months I decide I'm going to "properly learn" ES6. Almost immediately
I somehow end up with a node_modules directory in my project tree, and I
invariably peek inside it, and then I catch myself thinking... why are there
`contributing.md` files in my libraries? Why do I have to have copies of the
same dependencies in every project directory? I just get so mad about it.

I've been trying very hard to unpack why exactly that is aside from a vague and
most likely unfair feeling of distaste for the flavor of dependency management
npm has settled on. The fact is that `create-react-app` doesn't do anything
remarkably different from `gem install rails` other than the that all the deps
are sitting right there, kind of hanging out in my source tree. Why doesn't it
bother me in the same way when it's hidden away in my rvm directories? To be
fair to npm, I fully recognize that package management is a [Hard
Problem](https://medium.com/@sdboyer/so-you-want-to-write-a-package-manager-4ae9c17d9527),
that there are very good reasons for the decisions they've made, and that it's
completely possible to set up npm to install modules globally if I really
wanted to (although probably not without extra headaches), and that a lot of
the state of libraries is up to the individual maintainter and not the
ecosystem, etc...

But, this got me thinking about dependencies _in general_. Whenever I look at all
the source files in a project that I've carefully curated and know every inch
of, I feel very accomplished. It's certainly something to aspire to, really
grokking your source and tools and every little detail, but isn't it a _huge_
lie? Just because I've synthetically cordoned off my source from all the
incredibly complicated dependencies I'm sitting it on top of doesn't mean they
go away. To be clear here, I'm not even talking about packages or libraries,
but rather the language runtimes, the operating systems, the chips
themselves... could it be that my desire to understand everything always is in
point of fact actually a laudable but immature impulse? And I have to
consciously choose my layer of abstraction? And I could consciously choose to
call my `node_modules` directory another black box and focus more intently on
the APIs to the libraries I'm using and my understanding of that?

I then swing back around to where I started, that I have to be less fussy about
this particular thing if I'm going to seriously learn modern JavaScript. The
fact is there are a lot of really interesting new ideas percolating up in the
community, some of which may mature into fundamental precepts of future
programming paradigms, React's "UI as purely functional expression of state"
being a canonical if a bit on the nose example, and if I let my perfect is the
enemy of the good mentality keep me away from this stuff I will miss out on
some very interesting things!

And _then_, where I want to land with this, is just that a _lot_ of the
complexity I perceive in having a JS dev environment is really wrapped up in
the implicit expectation of deployment. I do _not need webpack or babel_ to
make a thing for myself, node runs ES6 now, and so do modern browsers. I don't
need to worry about trans/compilation or minified bundling or polyfills just to
do personal projects. I _do_ need to learn about ES6 modules and libraries, but
    _that's different_.

There is a middle ground between "vanilla" javascript and full on webpacky
babel'd giant dependency heap package.json. And I want to figure out what that
is and how to get to it.

This is a bit scattered at the moment, but I have been ruminating on this for a
while and I'm convinced there's a very salient point about explicitly
acknowledging dependencies and then treating them as such without freaking
out about it somewhere in there, hopefully also a nice little mini tutorial on
setting up a minimal but modern development environment (once I figure that out
for myself, that is).
