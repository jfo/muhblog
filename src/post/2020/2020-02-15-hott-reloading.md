---
title: Hott reloading
date: 2020-02-15
syndicate: true
---

I'm writing a custom static site generator to use for this site. The initial
attempt is pretty messy, but I was honestly surprised how quickly I was
able to get it to parity with the (relatively slim) subset of Hugo features that I
use, and how performant even my naive implementation is. I'll likely blog more
about that in the future, but for the moment, and in the interest of warming up
my fingers, I'd like to write a little about a simple implementation of a nice
to have static site generator development feature, hot reloading.

'Hot reloading' allows you to make changes to source code and see those changes
immediately reflected in the browser window in which you are running the
application. I say "application" because usually this feature is built into
framework tooling to allow for faster iteration building SPAs (single page
applications), but of course it's even more straightforward to implement this
pattern from whole cloth if all we are dealing with is a static page.

Normally, a client will simply make a request to a server for a resource
defined by a [URL or URI](https://stackoverflow.com/a/1984225) and, assuming
the request is accepted and successful, will do something with the response. In
the most common case, that means rendering some text or html to the viewport.
Let's start with that. I'll be using [express](https://expressjs.com/).

As always, I'm starting from nothing, just assuming you have
[node](https://nodejs.org) installed.

Make a folder...

```bash
mkdir hott
cd hott
```

initialize a package...

```bash
npm init
```

This will ask you a bunch of questions that you can answer however your heart
desires, because we're about to go in and delete most of it for reasons I will
elaborate on in a moment.

This will create a `package.json` file that looks something like this.

```json
{
  "name": "hott",
  "version": "0.0.0",
  "description": "whatevs idc",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "Ur boi",
  "license": "ISC"
}

```

Usually, `npm` is assuming we're initializing a package in order to publish it
on the
[registry](https://docs.npmjs.com/packages-and-modules/contributing-packages-to-the-registry).
This is all well and good, but I don't care about most of these fields until I
actually decide I want to do that, or publish or distribute it somewhere else
through some other means. So, let's delete them!

```json
{}
```

Now your `package.json` is empty. Why do you need an empty package.json file?
Because the next command needs it.

Install express:

```bash
npm install --save-dev express
```

Now, `cat package.json` and you will find something like this:

```json
{
  "devDependencies": {
    "express": "^4.17.1"
  }
}
```

Where `4.17.1` is whatever the most recent version of express is.

If you have no `package.json` file, it would not have created it for you. This
is why we needed the empty one.

Why `devDependencies`? Well, we're playing around with a development tool set.
I don't have any interest in publishing this for consumption yet, so why put
it in `dependencies`? Similar to omitting all the identifying information in
the package file including the license. Until necessary, that information is
extraneous.

But oh, we have a stowaway! `package-lock.json` has been created in the
directly, and is a record of the _resolved dependencies_ of that install of
whatever set of packages you have invoked. In this case, as express is quite
hefty a package itself, with many dependencies, and rightly so I might add, as
it is a beefy full featured multiplexing web server, the lockfile comes in at
somewhere around 500 lines.

Now, we're also going to ignore that. In fact, just delete everything and start
over.

```bash
cd ..
rm -r hott
mkdir hott
cd hott
```

But instead of `npm init`, this time simply

```bash
echo '{}' > package.json
```

and now

```bash
npm i --save-dev --no-package-lock express
```

This gives us the minimalist version of what we want. a `package.json` file that
reflects just what we need and nothing else, and no lockfile cluttering up the place.

A digression: lockfiles are _super useful_ and _super important_ for creating
packages that reliably build identically over time. If a lockfile exists in a
package you are playing with locally, you'll want to defer to it and install
your dependencies with `npm ci` instead of `npm install`, as it guarantees
you'll get the same versions of the packages that were resolved the last time
`npm i` was run by the committer. But again, this is not a published and
distributed package (yet, if ever). I don't need that consistency (yet, if
ever), and I want my package file to declaratively, simply reflect what I
actually need right now, while I'm just playing around.

So! Getting somewhere, I suppose.

One more thing. We don't really want to write `--no-lock-file` every time we
install a dependency, so let's put that in an rc file too.

```bash
echo 'package-lock=false' > .npmrc
```

Let us now define a simple server using express. In `index.js`:

```bash
const express = require('express');

const app = express();

app.get('/', (req, res) => {
  res.send('<h1>Hello World!</h1>');
})

const port = 8765;
app.listen(port, () => console.log(`Listening on port ${port}.`));
```

Now, running

```bash
node index.js
```

Will echo the log line. The server is now listening. Navigate to:

```
localhost:8765
```

In a browser. You should see `Hello World!` there. Great job.

We can also add a script to `package.json` to run this using, for example, `npm
run start`. That looks like:

```json
{
  "scripts": {
    "start": "node index.js"
  },
  "devDependencies": {
    "express": "^4.17.1"
  }
}
```

I'm probably interested in letting this little server return some information
from a file somewhere else on my computer, right? Let's put the text somewhere
else then.

```js
const express = require('express');
const fs = require('fs');

const app = express();

const content = fs.readFileSync('./hello.html', 'utf-8');
app.get('/', (req, res) => {
  res.send(content);
})

const port = 8765;
app.listen(port, () => console.log(`Listening on port ${port}.`));
```

And of course, `hello.html` in the same directory:

```html
<h1>Hello World! From another file this time!</h1>
```

This now reads the file into memory (as a `utf-8` string) and the server sends
it along.


If you write this and navigate to it, you'll notice that the browser tries to
let you download an octet stream. This is not what we want, we need to set the
[`Content-Type` header on the
response](https://stackoverflow.com/questions/23714383/what-are-all-the-possible-values-for-http-content-type-header)
so that the browser knows what I am sending to it.

```js
app.get('/', (req, res) => {
  res.set('Content-Type', 'text/html');
  res.send(content);
})
```

Express can do both the reading of the file and the content type in one pass
with `sendFile`:

```js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/hello.html');
})

const port = 8765;
app.listen(port, () => console.log(`Listening on port ${port}.`));
```

This will do what you think!

Now we're getting close to the fun bits. I want changes I make locally to
`hello.html` to immediately propagate to the running browser window, but I have
a problem. The client _knows_ where to find the server (it's at it's childhood
home, `localhost:8765`!) But the client has no way of knowing when the
`hello.html` file changes, because it's on the "server." First of all, how does
the _server_ know, even? And second of all, how does the server _tell_ the
client that the file has changed? The client already got what they came there
for, they're long gone.

Well, first bit. [File watchers](https://thisdavej.com/how-to-watch-for-files-changes-in-node-js/).

In a vacuum, this is _also_ relatively straightforward. `fs.watch` takes a file
path, and it takes a callback to run every time something happens to the file.
Try this for example, just in another scratch file `scratch.js`:

```js
const fs = require('fs');
fs.watch('./hello.html', console.log);
```

Remember that a callback is just a function, and console.log is just a
function, so you can just straight pass console.log up in there just like that.

That's it. Now run `node scratch.js`. Open `hello.html`, and make some changes
to it. Save it. In the other window, where the script is running, observe:

```
change hello.html
```

So we've answered the question of how the server can know when the file is
changed.

But again, how does that propagate to the client?

Websockets
---------

Http is not the only protocol game in town! The [websocket
protocol](https://duckduckgo.com/?q=websocket+protocaol&t=ffab&ia=web) defines
a system of two-way communication between entities. This is exactly what we
need!

Express does not support this protocol out of the box. But there is a very
robust package that does, [here](https://www.npmjs.com/package/ws).

It is possible to use this package
[directly](https://dzone.com/articles/static-content-rest-endpoints-and-websockets-with).
It is also possible to use this [smol wrapper
package](https://www.npmjs.com/package/express-ws) that let's us simply add
websocket support to the express app itself. That's what I'm going to do, but with a caveat!

Evaluating when to use packages and which ones to use is a really hard and
subtle skill. When you add a dependency to your project, the word doesn't mean
nothing. This project is _dependent_ on the code in that dependency. Is it
robust and well written? Is it easy to understand, if you had to reimplement it
yourself or dive into the source to debug an issue, could you? [Is it incredibly
teensy?](https://www.reddit.com/r/programming/comments/886zji/why_has_there_been_nearly_3_million_installs_of/).
Is it [malicious](https://iamakulov.com/notes/npm-malicious-packages/)

There are some _really good situations_ in which to use packages. You can build
your own server with node's standard libraries, but express is easier to use, battle
tested, ergonomic, and trusted. `ws` is very obviously one too... it's under
active development, and [provably
implements](http://websockets.github.io/ws/autobahn/servers/) a _really
complicated protocol_ to spec.

`ws-express`, on the other hand, is mightily on the fence. What does it give
me? I can more easily use websockets in a pattern I'm used to in express at the
expense of a bit of hackishness. This is a positive. The package has a lot of
open issues and hasn't been touched in over a year. This is a negative. It can
be a tough call though! You have to decide in each case. In this case, I'm
going to use it. It is, after all, depending on `ws` itself, so most of the
heavy lifting is likely happening in a package I have already decided is worth
using. If I were going to deploy this somewhere, I would probably reconsider.

Anyway... websockets.

Here's a working example of a websocket, let's pick it apart a bit.

```js
const express = require('express');
const expressWs = require('express-ws');
const fs = require('fs');

const port = 8765;
const app = express();
expressWs(app);

const filename = './hello.html'
const content = fs.readFileSync(filename, 'utf-8');

app.get('/', (req, res) => {
  res.set('Content-Type', 'text/html');
  res.send(content + `<script>
    var socket = new WebSocket('ws://localhost:${port}');
    socket.onmessage = m => console.log(m.data);
  </script>`);
})

let i = 0;
app.ws('/', async (ws, req) => {
  setInterval(() => {
    ws.send(i += 1);
  }, 1000)
})

app.listen(port, () => console.log(`Listening on port ${port}.`));
```

Most of this is the same. What is new? Well, first of all, the server is
appending a script tag with some _client side_ javascript to the file we're
returning. When the client loads the response, it will also be running this
code. _On the client_. I've gone back to using `res.send` because I am
appending that string there. It opens a websocket _back_ to the server and sets
up a callback to run whenever it receives a message on that websocket. This is
fairly hacky, but not that different from what "real" hot reloaders do in
development builds.

On the server side, a new websocket endpoint has been defined which has a
handler that sends back an incrementing number to the client. This is _really
rad_! A couple of important points:

The state of the incrementing number lives _on the server_. So the logged
values in the client side are coming from the server, not from the client.

Multiple clients can connect to the same websocket endpoint and _observe the
same state_. This is also really cool! As written, this example will start to
do weird stuff when multiple clients are connected to it, because the
incrementing happens inside an interval callback inside of a handler, which is
invoked for every connection. So... each client will have instigated its own
interval counter, and none of them will see the same number at the same time.
This is grade A enterprise software right here. As an exercise for the reader,
how would you make the state report consistently to n websocket clients?

Finally, an implementation
--------

We have all the ingredients, let's put them together.

```js
const express = require('express');
const expressWs = require('express-ws');
const fs = require('fs');

const port = 8765;
const app = express();
expressWs(app);

const filename = './hello.html'

app.get('/', (req, res) => {
  const content = fs.readFileSync(filename, 'utf-8');
  res.set('Content-Type', 'text/html');
  res.send(content + `<script>
    var socket = new WebSocket('ws://localhost:${port}');
    socket.onmessage = m => location.reload()
  </script>`);
})

app.ws('/', async (ws, req) => {
  fs.watch(filename, async () => {
    ws.send('go')
  })
})

app.listen(port, () => console.log(`Listening on port ${port}.`));
```

This is a _live_ reloading server now. A couple of important things have
changed! The websocket endpoint now has a file watcher inside of it, which
sends the `go` message to the client. There is nothing special about that since
the client has been instructed to simply reload the whole page on _any_ message
received. Similarly, the content from the file is loaded from disk on each
request. It must be, since the file has changed, and in order to get it to the
client, we have to load the changed version.

This is almost what I want, but I can do one better.

```js
const express = require('express');
const expressWs = require('express-ws');
const fs = require('fs');

const port = 8765;
const app = express();
expressWs(app);

const filename = './hello.html'

app.get('/', (req, res) => {
  res.set('Content-Type', 'text/html');
  const content = fs.readFileSync(filename, 'utf-8');

  res.send(content + `<script>
    var socket = new WebSocket('ws://localhost:${port}');
    socket.onmessage = m => document.body.innerHTML = m.data;
  </script>`);
})

app.ws('/', async (ws, req) => {
  fs.watch(filename, () => {
    const content = fs.readFileSync(filename, 'utf-8');
    ws.send(content)
  })
})

app.listen(port, () => console.log(`Listening on port ${port}.`));
```

What's new? Well, now, the file is being read in the callback to the
file watcher, immediately before being sent back to the client as a string. The
client, instead of simply reloading the whole page, is just dumping the thing
it got back into the dom in the simplest way possible. Now running this server
and going to page, you can see live updates without reloading the whole page
when you make changes to `hello.html` on disk.

And that's that! This is really simple and there are lots of issues with it,
but for a small development tool it does exactly what I wanted. You can imagine
a world where this gets very fancy, where the client and server do some type of
book keeping, mapping partsof the dom to specific files or components on the
server, so that when a file is updated the client knows exactly where to put
the changed code into the dom without reloading everything, or without (as I've
done here) just dumping it all in the body tag directly, which is little better
than reloading the whole page, if we're being honest. I can imagine a lot of
ways this could be better, but I'm reasonably sure that anything that
implements hot reloading is going to look fundamentally the same.

[Here's](https://github.com/jfo/hott) a repo with the final running code if you
want to play with it.

A note, websockets are a pretty standard way to enable _two way_ communication,
which is potentially overkill for this use case in its current form. You could
also implement the same pattern using a long running HTTP connection using an
[EventSource](https://developer.mozilla.org/en-US/docs/Web/API/EventSource) on
the client to receive messages sent unilaterally by the server.

Thanks to Andreas Lind and Kamal Marhubi for reading drafts of this.
