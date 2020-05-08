---
title: s3, Hugo, and static asset hosting
date: 2017-09-29T00:00:00Z
---

I've been writing this blog for a while now, and put it through several different
blogging engines and style changes.  [Wordpress](https://wordpress.org/),
[Middleman](https://middlemanapp.com/), [Jekyll](https://jekyllrb.com/)...  and
finally to [Hugo](https://gohugo.io/), which I'm using currently. I feel it
should be _really easy_ to switch platforms (where "really easy" means like, a
week or two of fiddly work), and I fully expect to do so again when it becomes
worth the trouble to do it, whenever and whyever that may be.

I was hosting my Middleman version on [github
pages](https://pages.github.com/), but Jekyll was attractive with the built in
[build
support](https://help.github.com/articles/about-github-pages-and-jekyll/), so I
switched to that when Middleman made some breaking changes.  It was great in
every way except that it was simply _way_ too slow! I have around
80 posts so far, and I'm only going to write more, but it took about 5 or 6
seconds for every build, even with incremental builds on! Most of this was
likely due to the syntax highlighting, and usually it wouldn't be that big a
deal, but when I was writing interactive javascript snippets like for ["The
Mandelwat Set"](/the-mandelwat-set/) it _really_ slowed me down. I decided to
switch to something faster.

The spectre of "write your own" is always looming, but I also truly want to
simply have a tool that makes things easy, stays out of my way, and "just
works." Hugo has everything I need!  It's _super fast_.  After the initial
build every incremental change triggers a new build that takes about 150
milliseconds. It also includes a development server that auto reloads on every
build.

This is all great! But there is something I've been thinking about for quite a
while that I need, and that is photo hosting! I want to to be able to spice up
my posts with custom images, but I don't want to commit images to my git
repo - both to avoid bloat and because, properly speaking, image files are
data, not source code. I know this is fairly arbitrary, but I feel oddly
strongly about maintaining that separation.

For The Mandelwat set, I uploaded small photos to [imgur](https://imgur.com/).
This works great, but it's very time consuming, and results in ugly URL's like
https://i.imgur.com/Yq0SFWn.jpg. Not to mention, and most importantly for
posterity's sake, it's all dependant on their naming scheme and continued
existence. I want this site to be as self contained as possible and where not,
relatively reproducible. If Hugo disappeared tomorrow, I know that I could
switch to another static site generator (albeit with some effort). If they all
disappeared, I know that I could write my own static site generator (albeit
with much more effort). If html is disappeared and some new weird markup format
comes out, I know I could get _this_ markdown into that format _somehow_ (probably with [pandoc](http://pandoc.org/)).

The point is not that I expect this site to necessarily last for that long, the
point is that I'd like to operate with the assumption that it _could_.  Bitrot
is real! Great swaths of the foundational internet has withered into the ether!
Remember [Geocities](https://news.ycombinator.com/item?id=4136682)?

Anyway, I want a place to host images that's not in my source tree and is easy
to manage.

I went to an [AWS conference last
week](https://aws.amazon.com/events/awsomeday-nordics-2017/), and guess what
will solve my problem? [S3](https://aws.amazon.com/s3/)!

Here's how I set it up.
----------------------

I started with a `.gitignore`d folder in the root of my blog's directory: `s3`.

I installed and authenticated the [command line interface
`awscli`](https://aws.amazon.com/cli/) with homebrew:

```
$ brew install awscli
```

... and
[configured](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-quick-configuration)
it with

```
$ aws configure
```

I created a bucket on `s3` just for this purpose called `blog.jfo.click`, and I
added some `make` targets that sync both to the bucket:

```make
syncs3:
	aws s3 sync ./s3 s3://blog.jfo.click/
```

and from the bucket:

```make
syncfroms3:
	aws s3 sync s3://blog.jfo.click/ ./s3
```

Since I am in there, I also took care of a `TODO` I've been meaning to do to
make it easier to deploy my whole site with a single command.

```make
push: build
	cd ./public && git add -A && git commit -m "`date`" && git push

build:
	hugo
```

`build` simply issues the `hugo` command to build the site. `push` now `cd`'s
into the built directory, adds and commits everything indiscriminantly, and
pushes it to _its_ remote, which is a [git
subtree](https://gohugo.io/hosting-and-deployment/hosting-on-github://gohugo.io/hosting-and-deployment/hosting-on-github/)

Finally,

```make
deploy: syncs3 push
```

Now, with a single `make deploy`, I can sync my images, build the site, and
push it all up to the hosted environment. This is a lot better than the multi
step process I was doing before, _and_ adds the images!

Ok, last thing. Hosting static content on s3 has a lot of benefits... it's
easy, scriptable via the command line interface, cheap, and automagically
CDN'd. But it also results in ugly URLs like this:

```
https://s3-us-west-2.amazonaws.com/blog.jfo.click/images/redefine.jpg
```

This is not good for two reasons. I don't want to be typing that into every
place I post a photo, certainly, but more importantly I want to be able to
replicate my full image folder in an arbitrary place and switch every reference
across my site to it without editing every file. Let's say that tomorrow,
Amazon goes out of business. I know, lol right? But [who knows what will happen
in the future](https://www.theatlantic.com/business/archive/2017/09/sears-predicts-amazon/540888/).
Perhaps more realistically in the short term, they could render s3 unusable
because of price or breaking API changes... or they could deprecate it. Who
knows! I would like to know that if I have to or want to for any reason, I
could host my photos and other static assets anywhere else at a moment's
notice.

Hugo has a great feature I can use for this,
[shortcodes](https://gohugo.io/content-management/shortcodes/)!

I make a template for my simple little shortcode here:

```
/themes/jfo/shortcodes/img.html
```

That consists of a single, simple line:

```html
<img src="https://s3-us-west-2.amazonaws.com/blog.jfo.click/images/{{ .Get 0 }}" />
```

You'll notice an interpolated variable here, or at least a method that looks
like it is accessing same:

```go
{{ .Get 0 }}
```

This is how I access things I pass in!

I can now put a shortcode tag anywhere in my markdown passing in a filename as
a string of something I've stored in that I've stored in the synced `s3` folder:

<pre>{&#8205;{< img "redefine.jpg" >}}</pre>

> Hey also fun fact, I had to use a hidden [zero width
> joiner](https://en.wikipedia.org/wiki/Zero-width_joiner) in my markup to
> actually type that and not have it be preprocessed. Looks like:
> ```
> {&#8205;{< img "redefine.jpg" >}}
> ```
> !

That, by the way, is the new version of the [very first post I made](/v-i) on
my OG site that was Wordpress.

So! Expect to see more media on here in the future!
