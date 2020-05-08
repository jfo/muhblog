---
date: 2017-03-05T00:00:00Z
title: The Mandelwat Set
---

<script>
    var randColor = function() {
        return '#'+Math.floor(Math.random()*16777215).toString(16).toUpperCase();
    }
</script>

{{#img}}mb/mb01.jpg{{/img}}

If you've never seen the Mandelbrot set, do me and also yourself a favor and
[watch some amount of time of one or two of these
videos](https://www.youtube.com/results?search_query=mandelbrot+zoom) real
quick.

I know, right? _What is that thing._

<hr>

I wanted to learn about the Mandelbrot set. I thought, that's a neat thing!
I wonder how I could make one. Turns out it's not that hard, really, but you
have to understand the math and also what it _is_, and those things are pretty
hard, at least for me, because I am not great at math even though I love it
and also the Mandlebrot set is a fractal and fractals are _bonkers_.

I thought, "Hey, I'm a Web Developer<sup>TM</sup> I should use JavaScript for
this because JavaScript is the best lol!" And so here we are.

I'm going to jump right in and try to explain it practically, but if you feel a
little lost or want something reinforced, jump down to the
[references](#references) at the bottom for some good resources and videos to
watch!

{{#img}}mb/mb02.jpg{{/img}}

So before I can draw a Mandlebrot set, I have to have something to draw on! In
html5 land, that thing is a `<canvas>`

That looks like this:

<canvas></canvas>

```html
<canvas></canvas>
```


Here, let me put a border on it so you can see where it is:

<canvas style="border: 1px solid black;"></canvas>

```html
<canvas style="border: 1px solid black;"></canvas>
```

By default, the dimensions of a canvas element will be 150 pixels tall by 300
pixels wide. This is a funny size, and I'm not sure why it's the default, but
in any case you're almost always going to want to set the width and height
yourself. You can do this with either with CSS, programatically in JS land, or as
attributes directly on the canvas element. Since there are [issues with using
CSS for
this](https://en.wikipedia.org/wiki/Canvas_element#Canvas_element_size_versus_drawing_surface_size),
and because I don't intend to resize the canvas dynamically in the JS code,
I'll just set the attributes directly.

<canvas style="border: 1px solid black;" width="200px" height="200px"></canvas>

```html
<canvas style="border: 1px solid black;" width="200px" height="200px"></canvas>
```

Now we just need to slap an `id` in there and we can grab it from the JavaScriptville.

```html
<canvas id="ex0" style="border: 1px solid black;" width="200px" height="200px"></canvas>
```

That's it from the HTML side. All the rest of the canvases will look the same
except with incrementing ids!

{{#img}}mb/mb03.jpg{{/img}}

You can do many wonderful things on a canvas! First you need to grab a
reference to the thing:

```js
var canvas = document.getElementById("ex1");
```

And then instantiate a _context_ for drawing on it. For now, we're just going
to stick with a basic `CanvasRenderingContext2D`, which can be fetched with a
call like this:

```js
var context = canvas.getContext("2d");
```

From there, there are a [lot of methods you can call on the
context](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D)
to affect the canvas itself. In the following example, notice that we access
the canvas's `width` and `height` attributes to know how big a rectangle to
draw! This is a common pattern, and it will be important later on. Right now
I'm just drawing a rectangle to fill the whole canvas though. [Also I'm using a
random color
function](https://www.paulirish.com/2009/random-hex-color-code-snippets/) I found for [another post](/how-react-do).
To run this example, press this button labeled "Run", right here: <span><button id="ex1button1">Run</button></span>.

<canvas id="ex1" style="border: 1px solid black;" width="200px" height="200px"></canvas>


```js
context.beginPath();
context.rect(0, 0, canvas.width, canvas.height);
context.fillStyle = randColor();
context.fill();
```

<script>
    (function() {
        var canvasId = "ex1"
        var canvas = document.getElementById(canvasId);
        var context = canvas.getContext("2d");
        var render1 = function() {
            context.beginPath();
            context.rect(0, 0, canvas.width, canvas.height);
            context.fillStyle = randColor();
            context.fill();
        }
        document.getElementById(canvasId + "button1").onclick = render1;
    })()
</script>

You can also do other things! Like drawing lines: <span><button id="ex2button">Randinavian</button></span>

<canvas id="ex2" style="border: 1px solid black;" width="200px" height="200px"></canvas>


```js
context.lineWidth = 35;
context.strokeStyle = randColor();

context.beginPath();
context.moveTo(canvas.width/2, 0);
context.lineTo(canvas.width/2, canvas.height);
context.stroke();

context.beginPath();
context.moveTo(0, canvas.height/2);
context.lineTo(canvas.width, canvas.height/2);
context.stroke();
```

<script>
    (function() {
        var canvasId = "ex2"
        var canvas = document.getElementById(canvasId);
        var context = canvas.getContext("2d");
        var render = function() {
            context.beginPath();
            context.rect(0, 0, canvas.width, canvas.height);
            context.fillStyle = randColor();
            context.fill();

            var cross = function(size) {
                context.lineWidth = size;
                context.strokeStyle = randColor();
                context.beginPath();
                context.moveTo(canvas.width/2, 0);
                context.lineTo(canvas.width/2, canvas.height);
                context.stroke();

                context.beginPath();
                context.moveTo(0, canvas.height/2);
                context.lineTo(canvas.width, canvas.height/2);
                context.stroke();
            }
            cross(35);
            if (Math.random() > 0.5) {
                cross(20);
            }
        }
        document.getElementById(canvasId + "button").onclick = render;
    })()
</script>

So, let's look a little closer at those lines.

<canvas id="ex3" style="border: 1px solid black;" width="200px" height="200px"></canvas>

```js
context.lineWidth = 5;
context.strokeStyle = randColor();

context.beginPath();
context.moveTo(50, 20);
context.lineTo(120, 150);
context.stroke();
```

<script>
    (function() {
        var canvasId = "ex3"
        var canvas = document.getElementById(canvasId);
        var context = canvas.getContext("2d");
        context.lineWidth = 5;
        context.strokeStyle = randColor();

        context.beginPath();
        context.moveTo(50, 20);
        context.lineTo(120, 150);
        context.stroke();
    })()
</script>

Those numbers that I'm passing to `moveTo` and `lineTo` are x and y values,
sort of, but they're indexed _from the upper left corner_. if they exceed the
width or height of the canvas, they'll just go straight off the side!

<canvas id="ex4" style="border: 1px solid black;" width="200px" height="200px"></canvas>

```js
context.lineWidth = 5;
context.strokeStyle = randColor();

context.beginPath();
context.moveTo(50, 100);
context.lineTo(1200, 1000);
context.stroke();
```

<script>
    (function() {
        var canvasId = "ex4"
        var canvas = document.getElementById(canvasId);
        var context = canvas.getContext("2d");
        context.lineWidth = 5;
        context.strokeStyle = randColor();

        context.beginPath();
        context.moveTo(50, 100);
        context.lineTo(1200, 1000);
        context.stroke();
    })()
</script>

So, clearly, I have to account for the size of the canvas myself- it's not
really designed to do that for me. Just keep that in mind!

{{#img}}mb/mb12.jpg{{/img}}

It seems like this is really how you're supposed to interact with the canvas...
it's definitely hinted at by the name, you draw strokes and shapes on it to
achieve a final result.

I am interested in a lower lever api than these drawn lines and
shapes, though. How can I achieve granular control over each pixel? We can
interact directly with the pixels in a canvas by using a representation called
[`ImageData`](https://developer.mozilla.org/en-US/docs/Web/API/ImageData).

Calling `createImageData(height, width)` on a `CanvasRenderingContext2d` will
return an ImageData object that contains three things:

```js
context.createImageData(10, 10)
// ImageData { data: Uint8ClampedArray[400], width: 10, height: 10 }
```

There is the `width` and `height` that I expected to see. What is the other
thing? It's just a 1-dimensional array of bytes! 10 x 10 = 100, it seems like a
10 x 10 ImageData should contain 100 items since it represents 100 pixels, but
it contains 400, because each pixel is represented by 4 bytes, one each for
red, green, blue, and alpha (transparency) channels.
[`Uint8ClampedArray`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint8ClampedArray)
ensures that any value inside of itself is an integer between 0 and 255,
simulating the hard type of a single byte. This is important because javascript
doesn't otherwise have any sense of integer types, and internally represents
[all numerical values as 64 bit floats.](http://www.2ality.com/2012/04/number-encoding.html)

You might expect a 2d array here, like this:

```js
[
    [p, p, p, p, p, p, p, p, p, p],
    [p, p, p, p, p, p, p, p, p, p],
    [p, p, p, p, p, p, p, p, p, p],
    [p, p, p, p, p, p, p, p, p, p],
    [p, p, p, p, p, p, p, p, p, p],
    [p, p, p, p, p, p, p, p, p, p],
    [p, p, p, p, p, p, p, p, p, p],
    [p, p, p, p, p, p, p, p, p, p],
    [p, p, p, p, p, p, p, p, p, p],
    [p, p, p, p, p, p, p, p, p, p]
]
```

Where `p` is a some sort of pixel object that can be address by attribute like:

```js
p.r = 255;
p.g = 0;
p.b = 0;
p.a = 0;
```

But this is lower level than that. It is literally just a one dimensional
array! Let's play with it though. This example simply fills all the channels
for all the pixels with a random value.  You'll notice that it looks a little
pastel, since on average there will be some transparency applied to each
pixel. <span><button id="ex5button">RGB Noise</button></span>

<canvas id="ex5" style="border: 1px solid black;" width="200px" height="200px"></canvas>

```js
var imageData = context.createImageData(canvas.width, canvas.height);
for (var i = 0; i < imageData.data.length; i += 1) {
    imageData.data[i] = Math.random() * 255;
}
context.putImageData(imageData, 0, 0); //  0, 0 is the offset to start putting the imageDate into the actual canvas. I won't use any other values for that in this article..
```

<script>
    (function() {
        var canvasId = "ex5"
        var canvas = document.getElementById(canvasId);
        var context = canvas.getContext("2d");
        var render = function() {

            var imageData = context.createImageData(canvas.width, canvas.height);
            for (var i = 0; i < imageData.data.length; i += 1) {
                imageData.data[i] = Math.random() * 255;
            }
            context.putImageData(imageData, 0, 0);

        }
        document.getElementById(canvasId + "button").onclick = render;
    })()
</script>


Of course, to be useful we need to look at each pixel's 4 values as a chunk and
change them accordingly. Here's a simple little for loop that will do that!
This example simply turns every pixel blue with no transparency.
<span>
    <button id="ex6button">blue</button>
    <button id="ex6clear">clear</button>
</span>

<canvas id="ex6" style="border: 1px solid black;" width="200px" height="200px"></canvas>


```js
var imageData = context.createImageData(canvas.width, canvas.height);
for (var i = 0; i < canvas.width * canvas.height * 4; i += 4) {
    imageData.data[i]     = 255;  // red channel
    imageData.data[i + 1] = 0;    // blue channel
    imageData.data[i + 2] = 0;    // green channel
    imageData.data[i + 3] = 255;  // alpha channel
}
context.putImageData(imageData, 0, 0);
```

<script>
    (function() {
        var canvasId = "ex6"
        var canvas = document.getElementById(canvasId);
        var context = canvas.getContext("2d");
        var render = function() {

            var imageData = context.createImageData(canvas.width, canvas.height);
            for (var i = 0; i < canvas.width * canvas.height * 4; i += 4) {
                imageData.data[i]     = 0;
                imageData.data[i + 1] = 0;
                imageData.data[i + 2] = 255;
                imageData.data[i + 3] = 255;
            }
            context.putImageData(imageData, 0, 0);

        }
        document.getElementById(canvasId + "button").onclick = render;
        document.getElementById(canvasId + "clear").onclick = function(){context.clearRect(0,0,canvas.width,canvas.height)};
    })()
</script>

> Here's a small exercise I just thought of. How would one make a widget that uses the
> ImageData technique above to create a randomly colored background? How about
> one that allows user input for the RGBA values? A canvas that maps mouse
> position to the color of the canvas and changes it as you move it around?
> These are just some ideas. You wouldn't have to use ImageData exclusively,
> of course, there are easier ways to simply change the background color.

{{#img}}mb/mb04.jpg{{/img}}

It is a minor inconvenience to have to address the pixel values linearly like
this, what I'd really like to be able to do is address coordinates inside the
canvas. I can remedy this problem with a little bit of math and a helper function!

`indexToCoord` takes an index value and then computes the x and y pixel offsets
for that index in that imageData object. Note that `canvas` must be in scope
    and a valid canvas for this to work! I will address that more thoroughly
    later.

```js
var indexToCoord = function(index) {
    // first, we'll divide by 4 to get an absolute pixel. This number
    // represents the pixel location where 0 is the upper left and the highest
    // index is in the lower right.
    index = Math.floor(index / 4);

    // now we'll make a little coordinate object that has two attributes: x and y
    coord =  {
        // x is the modulo of the index and the width of the canvas.
        x: index % canvas.width,
        // y is the floored index divided by the canvas width.
        y: Math.floor(index / canvas.width)
    }
    // returning that coordinate will let us use it later on
    return coord;
}
```

So now, let's say I have a 10x10 canvas. (That's a very small canvas, but lol I
guess) and I want to address the pixel marked below with an `@`.

```
. . . . . . . . . .
. . . . . . . . . .
. . . . . . . . . .
. . . @ . . . . . .
. . . . . . . . . .
. . . . . . . . . .
. . . . . . . . . .
. . . . . . . . . .
. . . . . . . . . .
. . . . . . . . . .
```

An ImageData object for this size of 10x10 would contain 400 byte values, and
the 4 bytes associated with that pixel would be at indices 132-136. This is
pretty straight forward, but if I put it through the `indexToCoord()` function,
I get something a little more palatable!

```
{ x: 3, y: 3 }
```

This tells me a lot more about that pixel's location.

We're almost there. I want to be able to use coordinates on a coordinate plane,
this is still 0 indexed from the top and left. Also, I want to decouple the
coordinate from the pixels themselves and simply be able to scale it to
whatever range I want. That scaling value is going to be an "r" value.

Let's say that I want the coordinate plane to go from -2 to 2 on both axes.
(Just, you know, for example.)

```js
var indexToCoord = function(index) {
    index = Math.floor(index / 4);
    var r = 4;

    coord =  {
        x: index % 10,
        y: Math.floor(index / 10)
    }

    // coord * 4 (which is the distance from -2 to 2) divided by the axis in pixels.
    // this gives us a value between 0 and 4 that is equal to the coordinate
    // pixel from earlier.
    coord.x = ((coord.x * r / canvas.height) - r/2);

    // the y value needs its sign flipped since the positive side is above the origin.
    coord.y = ((coord.y * r / canvas.width) - r/2) * -1 ;

    return coord;
}
```

Let's also assume we have a much larger canvas! 10 x 10 is not very
interesting. 200 x 200, as before, gives us an ImageData object that has
160,000 bytes in it! Again, that's 200 * 200 = 40,000 * 4 = 160,000. Quite a
lot.

So we have a way to turn an index into a coordinate that can be scaled
according to what you're trying to see! Given a canvas of 200 x 200, and a
scale of -2 to 2, then, yields something very close to what you'd expect:

```js
indexToCoord(0);      // { x: -2,    y: 2 }
indexToCoord(159999); // { x: 1.98,  y: -1.98 }
indexToCoord(132987); // { x: -1.08, y: -1.3199999999999998 }
indexToCoord(54));    // { x: -1.74, y: 2 }
```

This is just begging to be abstracted, so that's what I'm going to do.

First, the constructor will take one thing, a string that represents the canvas
id in the dom! It will assign both `canvas` and `context` as private variables.
We're also going to go ahead and allocate an `ImageData` object for this graph
that we can reuse.

```js
function Graph(canvasId) {
    var canvas = document.getElementById(canvasId);
    var ctx = canvas.getContext("2d");
    var imageData = ctx.createImageData(canvas.width, canvas.height);
}
```

Next we'll add that `indexToCoord` method. I've put the `r` value and the
`center` value as attributes on the object so that I can manipulate them from
outside, and I've added an aspect ratio to scale the coordinates correctly in
case the canvas is not 1:1.


> If I were writing a real graphing library or something, I would want that to
> be settable as well, but this is a stepping stone to the Mandelbrot
> rendering, which will always be 1:1.

```js
function Graph(canvasId) {
    var canvas = document.getElementById(canvasId);
    var ctx = canvas.getContext("2d");
    var imageData = ctx.createImageData(canvas.width, canvas.height);
    var aspectRatio = canvas.height / canvas.width

    this.r = 4
    this.center = {
        x: 0,
        y: 0
    };

    var indexToCoord = function(index) {
        index /= 4;
        coord =  {
            x: index % canvas.width,
            y: Math.floor(index / canvas.width)
        }
        coord.x = (((coord.x * this.r / canvas.width) - this.r / 2) + (this.center.x * aspectRatio)) / aspectRatio;
        coord.y = ((((coord.y * this.r / canvas.height) - this.r / 2) * -1) + this.center.y);
        return coord;
    }.bind(this)

    this.render = function() {
        var imageData = context.createImageData(canvas.width, canvas.height);
        for (var i = 0; i < imageData.data.length; i += 1) {
            imageData.data[i] = Math.random() * 255;
        }
        context.putImageData(imageData, 0, 0);
    }
}
```

I've also added the rgb noise example as the render function for this object.

Now we can interact with a canvas something like this: <span><button id="ex7button">Run</button></span>

```
var graph = new Graph("canvas-id")
graph.render()
```

<canvas id="ex7" style="border: 1px solid black;" width="200px" height="200px"></canvas>


<script>
    (function() {
        function Graph(canvasId) {
            var canvas = document.getElementById(canvasId);
            var context = canvas.getContext("2d");
            var imageData = context.createImageData(canvas.width, canvas.height);
            var aspectRatio = canvas.height / canvas.width

            this.r = 4
            this.center = {
                x: 0,
                y: 0
            };

            var indexToCoord = function(index) {
                index /= 4;
                coord =  {
                    x: index % canvas.width,
                    y: Math.floor(index / canvas.width)
                }
                coord.x = (((coord.x * this.r / canvas.width) - this.r / 2) + (this.center.x * aspectRatio)) / aspectRatio;
                coord.y = ((((coord.y * this.r / canvas.height) - this.r / 2) * -1) + this.center.y);
                return coord;
            }.bind(this)

            this.render = function() {
                var imageData = context.createImageData(canvas.width, canvas.height);
                for (var i = 0; i < imageData.data.length; i += 1) {
                    imageData.data[i] = Math.random() * 255;
                }
                context.putImageData(imageData, 0, 0);
            }
        }

        var canvasId = "ex7"
        var graph = new Graph(canvasId)
        document.getElementById(canvasId + "button").onclick = function() {graph.render()};
    })()
</script>

Each pixel, now, can be viewed as a single discrete coordinate on a plane that
can be centered anywhere in the two dimensional plane and scaled up or down
depending on what you want to see!

{{#img}}mb/mb05.jpg{{/img}}

Before packing away this abstraction and explaining sets, I want to add one
more thing. This render function above just randomly sets all the pixel values,
but of course I want more control than that. I will change the `render()`
method to accept a predicate function, instead:

```js
    this.render = function(predicate) {
        for (var i = 0; i < canvas.width * canvas.height * 4; i += 4) {
            set = predicate(indexToCoord(i)) ? 255 : 0;
            imageData.data[i]     = 0;
            imageData.data[i + 1] = 0;
            imageData.data[i + 2] = 0;
            imageData.data[i + 3] = set;
        }
        context.putImageData(imageData, 0, 0);
    }
```

Now, for every pixel on a given Graph, the predicate is called on it's
coordinate and returns whether or not it should be filled in with black or not.
The first three values per pixel are RGB values, and the last one is the
`alpha` channel, which sets the transparency of the pixel. The higher it is,
the more opaque, so by setting it to its maximum value of `255`, we make the
pixel black.

From now on we're going to interact with a Graph object for each canvas in the
next section, like this!

```js
var graph = new Graph("canvasid")

// the below is the default so we don't need to do it.
// graph.center = { x: 0, y: 0 }

graph.r = 500; // just for starters, sure.

graph.render(function(coord) {
    // stuff stuff stuff
    // return true or return false
})
```

Ok let's play with it!


<script>
    function Graph(canvasId) {
        var canvas = document.getElementById(canvasId);
        var context = canvas.getContext("2d");
        var imageData = context.createImageData(canvas.width, canvas.height);
        var aspectRatio = canvas.height / canvas.width

        this.r = 4
        this.center = {
            x: 0,
            y: 0
        };

        var indexToCoord = function(index) {
            index /= 4;
            coord =  {
                x: index % canvas.width,
                y: Math.floor(index / canvas.width)
            }
            coord.x = (((coord.x * this.r / canvas.width) - this.r / 2) + (this.center.x * aspectRatio)) / aspectRatio;
            coord.y = ((((coord.y * this.r / canvas.height) - this.r / 2) * -1) + this.center.y);
            return coord;
        }.bind(this)

        this.render = function(predicate) {
            for (var i = 0; i < canvas.width * canvas.height * 4; i += 4) {
                set = predicate(indexToCoord(i)) ? 255 : 0;
                imageData.data[i]     = 0;
                imageData.data[i + 1] = 0;
                imageData.data[i + 2] = 0;
                imageData.data[i + 3] = set;
            }
            context.putImageData(imageData, 0, 0);
        }
    }
</script>

<canvas id="ex8" style="border: 1px solid black;" width="200px" height="200px"></canvas>

<script>
    (function() {
        var canvasId = "ex8"
        var graph = new Graph(canvasId)
        graph.r = 500;
        graph.render(function(coord) {
            return (
                coord.x == coord.y
                ||
                coord.x * 2 == coord.y
                ||
                coord.x * 3 == coord.y
                ||
                coord.x * 4 == coord.y
                ||
                coord.x * 5 == coord.y
                ||
                coord.x * 6 == coord.y
                ||
                coord.x * 40 == coord.y
            )
        });
    })()
</script>

```js
graph.render(function(coord) {
    return (
        coord.x == coord.y
        ||
        coord.x * 2 == coord.y
        ||
        coord.x * 3 == coord.y
        ||
        coord.x * 4 == coord.y
        ||
        coord.x * 5 == coord.y
        ||
        coord.x * 6 == coord.y
        ||
        coord.x * 40 == coord.y
    )
});
```

Above we see a predicate function that basically says: "if the current pixel is
on the line described by one of these equations, fill it in. If not, don't!"

You'll notice that some of the lines are not totally smooth, and instead are
made up of dots or dashes. What you're seeing is kind of sort of a version of
the "[screen door effect](https://en.wikipedia.org/wiki/Screen-door_effect)".
For each individual pixel in, say, this equation:

```
x * 2 = y
```

The pixel's coordinate must match _exactly_ with the output of the equation in
order to qualify and be filled in. This means that when it's even with a
multiple of the size of the canvas, it's much more likely to be filled!

If I were building a fully functional graphing library, I would have to deal
with this issue (and many more!). But I'm not, so I won't! This is adequate for
now. Let's talk about sets!

{{#img}}mb/mb06.jpg{{/img}}

Sets wtf is a set
=================

> I'm not going to get into set theory because I don't know really anything
> about it, but maybe it's worth a mention? Wonder what would be a really good
> succinct but not wrong explanation of set theory...

Let's say a [set](https://en.wikipedia.org/wiki/Set_(mathematics)) is pretty
much what you think it is, then. How can we describe a set? We can have a set
that is completely enumerated.

```
{ 1, 4, 397376, 89, 44 }
```

These are just some numbers. They don't really have anything in common with
each other, I just typed some numbers. And so for any number `x` that you can
dream up, `x` will either be in this set, or not.

```
|-----------------+------------+
| `x`             | Is in set? |
|:---------------:|:----------:|
| 2               | no         |
| 20              | no         |
| 76              | no         |
| 88              | no         |
| 397376          | yes        |
| 100             | no         |
|-----------------+------------+
```


Hey actually, JavaScript has a syntax for exactly this!

```js
var mySet = new Set([ 1, 4, 397376, 89, 44 ])
mySet.has(2)      // false
mySet.has(20)     // false
mySet.has(76)     // false
mySet.has(88)     // false
mySet.has(397376) // true
mySet.has(100)    // false
```

Will this work??

<canvas id="ex9" style="border: 1px solid black;" width="200px" height="200px"></canvas>

<script>
    (function() {
        var canvasId = "ex9"
        var graph = new Graph(canvasId)
        graph.r = 2;

        var mySet = new Set([
            { x:0, y:1},
            { x:1, y:-1}
        ]);

        graph.render(function(coord) {
            if (mySet.has(coord)){
                debugger
            };
            return mySet.has(coord);
        });
    })()
</script>

```js

graph.r = 4;

var myset = new set([
    { x:0, y:0 },
    { x:1, y:1 }
    { x:-1, y:-1 }
]);

graph.render(function(coord) {
    return mySet.has(coord);
});
```

Hmm, no it will not. Because of JavaScript's equality rules, objects are not
compared to each other by value. To whit, these are falsy:

```js
{} == {} // false
{} === {} // false
{ thing: 7 } == { thing: 7 } // false
{ thing: 7 } === { thing: 7 } // false
// etc...
```

Objects instead are equal if they are _actually the same object_, meaning the
two sides of the double or triple equals refer to the same memory.

```js
var thing1 = { whatever: "whatevar" };
thing1 == thing1 // true
thing1 === thing1 // true

var thing2 = thing1;

thing1 == thing2 // true
thing1 === thing2 // true
```

You get the idea. Now, I _could_ write a deep checking set class for these
coordinates, or build the coordinates into a real object that has a function
that can do that, but I don't really want to. Instead I'm going to talk
about sets more generally!

{{#img}}mb/mb13.jpg{{/img}}

So, you can have a set that is just a defined set of whatever, and write all
the whatevers out, like the example above.. That works great! But what about
something like this:


```js
var mySet = { /* The set of all even integers */ }
```

Obviously, I can't write that out! But I _can_ check if an arbitrary number is
a member of that set with a simple function.

```js
var isInTheSetOfAllEvenIntegers = function(x) {
    return x % 2 == 0;
}
```

Hey cool! This is like, a programaticalized way to test for set membership in
that particular set of numbers.

<canvas id="ex10" style="border: 1px solid black;" width="200px" height="200px"></canvas>

<script>
    (function() {
        var canvasId = "ex10"
        var graph = new Graph(canvasId)
        graph.r = 20;

        graph.render(function(coord) {
            return coord.x % 2 == 0;
        });
    })()
</script>

```js
// we're making the scale of the graph 20x20 here
graph.r = 20;

graph.render(function(coord) {
    return coord.x % 2 == 0;
});
```

Now we're getting somewhere! What about this one:

```
The set of all points whose x value is higher than 100 and whose y value is higher that -27;
```

<canvas id="ex11" style="border: 1px solid black;" width="200px" height="200px"></canvas>

<script>
    (function() {
        var canvasId = "ex11"
        var graph = new Graph(canvasId)
        graph.r = 500;

        graph.render(function(coord) {
            return (coord.x > 100 && coord.y > -27);
        });
    })()
</script>

```js
// again, changing the scale of the graph.
graph.r = 500;

graph.render(function(coord) {
    return (coord.x > 100 && coord.y > -27);
});
```

This is cool, then, I have a way of "graphing" sets! These sets are pretty
boring though. But you know what's not boring??

{{#img}}mb/mb07.jpg{{/img}}

The Mandelbrot Set
==================

Ok, The Mandelbrot set is:

> The set of all complex numbers that remain bounded when iterated on the equation f<sub>c</sub>(z) = z<sup>2</sup> + c


Ok so real talk, there are like 3 or 4 things in that definition that I totally
did not understand at all when I started this project. But I do now, and I'm
going to explain them to you, one by one!

Let's start with the equation.

> f<sub>c</sub>(z) = z<sup>2</sup> + c

This part's pretty easy. I have a function, and I feed it a number, and I get a number back.

```js
function thinger(z) {
    return Math.pow(z, 2) + c;
}
```

This is, of course, borked.

```js
thinger(2);
```

```
ReferenceError: c is not defined
    at thinger (/private/tmp/thinger.js:2:29)
    at Object.<anonymous> (/private/tmp/thinger.js:5:13)
    at Module._compile (module.js:570:32)
    at Object.Module._extensions..js (module.js:579:10)
    at Module.load (module.js:487:32)
    at tryModuleLoad (module.js:446:12)
    at Function.Module._load (module.js:438:3)
    at Module.runMain (module.js:604:10)
    at run (bootstrap_node.js:394:7)
    at startup (bootstrap_node.js:149:9)
```

`c` here must be defined. I will define it then!

```js
function thinger(z, c) {
    return Math.pow(z, 2) + c;
}
```


Cool cool. I can plug whatever in there now great.

```js
thinger(4, 2);
thinger(40, 3);
thinger(4000, 3.32);
```
```
18
1603
16000003.32
```

Ok so now, what does 'iterated on' mean?

It means that I take the output of the function and feed it back into the same
function. The initial `z` input is always 0.

```js
function thinger(z, c) {
    return thinger(Math.pow(z, 2) + c, c);
}
```

Obviously, this is also borked.

```
RangeError: Maximum call stack size exceeded
    at Object.pow (native)
    ...
```

This is a recursive function with no base case. This is where the "bounded"
part comes in. For a given input, this equation exhibits one of two behaviors
under iteration. It can either stay _bounded_ Or it can _explode_ to infinity.
This makes a little more sense if we see some output. I'll add a counter that
I'll increment on each call just to give us a way to get out of the recursive
loop.

```js
function thinger(z, c, i) {
    if (i > 10) {
        return;
    }

    var next = Math.pow(z, 2) + c;
    console.log(next);
    return thinger(next, c, i += 1);
}
```

Now, we can see some interesting stuff.

```js
thinger(0, 2, 0);
```

```
2
6
38
1446
2090918
4371938082726
1.9113842599189892e+25
3.653389789066062e+50
1.3347256950852164e+101
1.781492681120714e+202
Infinity
```

Exponents are no joke, and 2 decidedly does _not_ remain bounded.

What about this one?

```js
thinger(0, -1, 0);
```

Hmm...

```
-1
0
-1
0
-1
0
-1
0
-1
0
-1
```

_But this one does!_ -1 is thus _in the Mandelbrot set_, and 2 _is not_.

{{#img}}mb/mb08.jpg{{/img}}

Wait, though, we were talking about _complex numbers_. And the numbers -1 and 2
are not coordinates, they are integers. How do you make a 2 dimensional graph
with one number?

These two questions answer each other!

The Mandelbrot set is not plotted on a [Cartesian
plane](http://dl.uncw.edu/digilib/mathematics/algebra/mat111hb/functions/coordinates/coordinates.html),
where each point is represented as a pair of numbers `<x, y>`. It's plotted on
the [_complex plane_](https://en.wikipedia.org/wiki/Complex_plane). Where each
point is represented by a single _complex number._

A _complex number_ is an expression of the form `x + yi` where `x` and `y` are
[real numbers](https://en.wikipedia.org/wiki/Real_number) and `i` is the [_unit
imaginary number_](https://en.wikipedia.org/wiki/Imaginary_number). Though `y` alone
is a real number, it is here the coefficient of `i`, and so cannot be combined
with `x`. On the complex plane, we plot `x` (the "real" part of the complex
number) on the x axis and `y` (the "imaginary" part of the complex number) on
the y axis. This took me a while to understand but it's pretty simple really!
[Here's a Khan Academy
video](https://www.khanacademy.org/math/algebra2/introduction-to-complex-numbers-algebra-2/the-complex-numbers-algebra-2/v/complex-number-intro)
that explains it in more detail.

So the cartesian coordinate `(1, 2)` would be represented on the complex plane as the
complex number `1 + 2i`.

So, remember, we wanted to feed _complex numbers_ into that function, but we
can't because javascript doesn't have a _complex number_ type. There are, of
course, [36 packages on npm that probably can do
this](https://www.npmjs.com/search?q=complex%20number&page=2&ranking=optimal),
but I'm not going to use any of them, because reasons!

No but seriously. It's just one application and I can do it by hand and that's
how we learn new things.

{{#img}}mb/mb09.jpg{{/img}}

So, A complex number is made up of a real part and an imaginary part. Never the
two shall meet. What if I wanted to add two complex numbers together?

```
(1 + 2i) + (3 + 5i) = 4 + 7i
```

Alright. But in JS, I could just keep track of these two parts _separately._

```js
realOne = 1;
imaginaryOne = 2;
realTwo = 3;
imaginaryTwo = 5;

console.log([realOne + realTwo, imaginaryOne + imaginaryTwo]
```
```
[4, 7]
```

Or `4 + 7i`.

I'm returning this as a tuple of two values. I could use objects, if I wanted...

```js
first = {
    real: 1,
    imaginary: 2
};
second = {
    real: 3,
    imaginary: 5
};

console.log({
    real: first.real + second.real,
    imaginary: first.imaginary + second.imaginary
});
```
```js
{ real: 4, imaginary: 7 }
```

Do you see it? Do you see how this is just _dying_ to be made into a prototype
that implements basic math over itself and stuff? Oh man, it really wants me to
do that, but I'm not going to do it.

We also need to be able to _multiply_ complex numbers, in order to square them.
What does that look like? It looks like algebra. Remember `FOIL`? "First,
outer, inner, last."

> (1 + 2i) * (3 + 5i)

> (1 * 3) + (1 * 5i) + (2i * 3) + (2i * 5i)

> 3 + 5i + 6i + 10i<sup>2</sup>

> 3 + 11i + 10i<sup>2</sup>

> 3 + 11i + 10(i * i)

> 3 + 11i + 10(-1)

> 3 + 11i - 10

> -7 + 11i

Remember that `i` is actually the square root of -1, so i<sup>2</sup> is...
`-1`!

{{#img}}mb/mb13.jpg{{/img}}

So... let's go back to our testing function from before! All I need to do is
replace `z` and `c` with "complex numbers" made up of `zr` (z real), `zi` (z
imaginary), `cr` (c real), and `ci` (c imaginary). I'll keep that index var `i` around
for now, as well, but I'm going to change it to `iterations` for a little more clarity.


```js
function thinger(zr, zi, cr, ci, iterations) {
    if (iterations > 10) {
        return;
    }

    var nextr = (zr * zr) - (zi * zi) + cr;
    var nexti = ((zr * zi) *2) + ci

    console.log([nextr, nexti]);

    return thinger(nextr, nexti, cr, ci, iterations += 1);
}
```

Those `nextr` and `nexti` expressions are just what you get when you factor out
the real and imaginary operations from the `FOIL` procedure from above.

So here's the trick. Right now I'm sort of just, winging it with those
iteration counts. But how do I _really_ know if a point is not in the set?

> If the sum of the squares of the real and imaginary parts of the complex
> number _ever exceed 4_, then that complex number is _not_ in the Mandelbrot
> set.

That's a little more useful!

```js
function thinger(zr, zi, cr, ci, iterations) {
    if (iterations > 20) {
        return true;
    }

    var nextr = (zr * zr) - (zi * zi) + cr;
    var nexti = ((zr * zi) *2) + ci
    console.log([nextr, nexti]);

    if (Math.pow(nextr, 2) + Math.pow(nexti, 2) > 4) {
        return false;
    }

    return thinger(nextr, nexti, cr, ci, iterations += 1);
}
```

So what we have here... this is getting there. If the condition stated above is
met, then the number is not in the set. BUT if we've reached some maximum
iteration count, then _as far as we know_, the number _is_ in the set. That's
going to be important later on!

It's cute to have this be recursive and all, but it's unnecessary. The formula
looks cleaner as a loop and is less computationally expensive. We can let that
state be internal and leave it out of the function signature. And as a matter
of fact, dropping the recursion means we don't have to pass in the inital `zr`
and `zi`, either. And what the hell, why don't I change that name from
`thinger` to something a little more descriptive...

```js
function isMandlebrot(cr, ci) {
    var zr = cr;
    var zi = ci

    for (var i = 0; i < 100; i++) {
        if (zr**2 + zi**2 > 4) {
            return false;
        }

        newzr = (zr * zr) - (zi * zi) + cr;
        newzi = ((zr * zi) *2) + ci;
        zr = newzr;
        zi = newzi;
    }
    return true;
}
```
Ok so, remember those predicate functions from before? They took in a `coord`
with an `x` value and a `y` value? Doesn't that look... suspiciously similar to
what we've got above?

```js
function isMandlebrot(coord) {
    var cr = coord.x;
    var ci = coord.y;
    var zr = cr;
    var zi = ci;

    for (var i = 0; i < 100; i++) {
        if (zr**2 + zi**2 > 4) {
            return false;
        }

        newzr = (zr * zr) - (zi * zi) + cr;
        newzi = ((zr * zi) *2) + ci;
        zr = newzr;
        zi = newzi;
    }
    return true;
}
```
<canvas id="ex12" height="200" width="200" style="border: 1px solid black;"></canvas>

<script>
(function() {
    function isMandlebrot(coord) {
        var cr = coord.x;
        var ci = coord.y;
        var zr = cr;
        var zi = ci;

        for (var i = 0; i < 100; i++) {
            if (zr**2 + zi**2 > 4) {
                return false;
            }

            newzr = (zr * zr) - (zi * zi) + cr;
            newzi = ((zr * zi) *2) + ci;
            zr = newzr;
            zi = newzi;
        }
        return true;
    }

    var graph = new Graph("ex12");
    graph.render(isMandlebrot);
})();
</script>

```js
var graph = new Graph("ex12");
graph.render(isMandlebrot);
```

There it is. Our old friend. The Mandelbrot set.

{{#img}}mb/mb44.jpg{{/img}}

That looks like a fuzzy potato
==============================

Yeah, it might look boring from where we're sitting, _but it's totally not_

Remember when I built that "Graph" object, I made both `r` (the zoom factor)
and `center` accessible. We can totally change where we're looking at the graph
and re-render on the fly!

<canvas id="ex13" height="200" width="200" style="border: 1px solid black;"></canvas>

<button class="ex13button" data-centerx="-0.7463" data-centery="0.1102" data-r="0.005" >x:-0.7463, y:0.1102, r:0.005</button>
<button class="ex13button" data-centerx="-0.7453" data-centery="0.1127" data-r="0.00065" >x:-0.7453, y:0.1127, r:0.00065</button>
<button class="ex13button" data-centerx="-1.25066" data-centery="0.02012" data-r="0.0005" >x:-1.25066, y:0.02012, r:0.0005</button>
<button class="ex13button" data-centerx="-0.16" data-centery="1.0405" data-r="0.076">x:-0.16, y:1.0405 r:0.046</button>

<script>
(function() {
    function isMandlebrot(coord) {
        var cr = coord.x;
        var ci = coord.y;
        var zr = cr;
        var zi = ci;

        for (var i = 0; i < 100; i++) {
            if (zr**2 + zi**2 > 4) {
                return false;
            }

            newzr = (zr * zr) - (zi * zi) + cr;
            newzi = ((zr * zi) *2) + ci;
            zr = newzr;
            zi = newzi;
        }
        return true;
    }
    var canvasId = "ex13";
    var graph = new Graph(canvasId);
    graph.render(isMandlebrot);

    var buttons =  document.getElementsByClassName(canvasId + "button");
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].onclick = function(e) {
            graph.center = {
                x: parseFloat(e.currentTarget.getAttribute('data-centerx')),
                y: parseFloat(e.currentTarget.getAttribute('data-centery'))
            };
            graph.r = parseFloat(e.currentTarget.getAttribute('data-r'))
            graph.render(isMandlebrot);
        };
    };

})();
</script>


Small refactor
=================

So at this point I am going to drop the more general `Graph` abstraction and
just hardcode that object's predicate as the Mandelbrot test. That... pretty
much looks like you would expect.

```js
function Mandelbrot(canvasId) {
    var canvas = document.getElementById(canvasId);
    var ctx = canvas.getContext("2d");
    var imageData = ctx.createImageData(canvas.width, canvas.height);
    var aspectRatio = canvas.height / canvas.width

    this.iterations = 200;
    this.r = 4
    this.center = {
        x: 0,
        y: 0
    };

    var indexToCoord = function(index) {
        index /= 4;
        coord =  {
            x: index % canvas.width,
            y: Math.floor(index / canvas.width)
        }
        coord.x = (((coord.x * this.r / canvas.width) - this.r / 2) + (this.center.x * aspectRatio)) / aspectRatio;
        coord.y = ((((coord.y * this.r / canvas.height) - this.r / 2) * -1) + this.center.y);
        return coord;
    }.bind(this)

    var isMandlebrot = function(coord) {
        var cr = coord.x
        var ci = coord.y
        var zr = coord.x
        var zi = coord.y

        var i;
        for (i = 0; i < this.iterations; i++) {
            if (zr**2 + zi**2 > 4) {
                return false;
            }

            newzr = (zr * zr) - (zi * zi) + cr;
            newzi = ((zr * zi) *2) + ci
            zr = newzr
            zi = newzi
        }
        return true;
    }.bind(this);

    this.render = function(predicate) {
        for (var i = 0; i < canvas.width * canvas.height * 4; i += 4) {
            set = predicate(indexToCoord(i)) ? 255 : 0;
            imageData.data[i]     = 0;
            imageData.data[i + 1] = 0;
            imageData.data[i + 2] = 0;
            imageData.data[i + 3] = set;
        }
        ctx.putImageData(imageData, 0, 0);
    }.bind(this)
}
```

<script>
function MandelbrotOne(canvasId) {
    var canvas = document.getElementById(canvasId);
    var ctx = canvas.getContext("2d");
    var imageData = ctx.createImageData(canvas.width, canvas.height);
    var aspectRatio = canvas.height / canvas.width

    this.iterations = 200;
    this.r = 4
    this.center = {
        x: 0,
        y: 0
    };

    var indexToCoord = function(index) {
        index /= 4;
        coord =  {
            x: index % canvas.width,
            y: Math.floor(index / canvas.width)
        }
        coord.x = (((coord.x * this.r / canvas.width) - this.r / 2) + (this.center.x * aspectRatio)) / aspectRatio;
        coord.y = ((((coord.y * this.r / canvas.height) - this.r / 2) * -1) + this.center.y);
        return coord;
    }.bind(this)

    var isMandlebrot = function(coord) {
        var cr = coord.x
        var ci = coord.y
        var zr = coord.x
        var zi = coord.y

        var i;
        for (i = 0; i < this.iterations; i++) {
            if (zr**2 + zi**2 > 4) {
                return false;
            }

            newzr = (zr * zr) - (zi * zi) + cr;
            newzi = ((zr * zi) *2) + ci
            zr = newzr
            zi = newzi
        }
        return true;
    }.bind(this);

    this.render = function() {
        for (var i = 0; i < canvas.width * canvas.height * 4; i += 4) {
            set = isMandlebrot(indexToCoord(i)) ? 255 : 0;
            imageData.data[i]     = 0;
            imageData.data[i + 1] = 0;
            imageData.data[i + 2] = 0;
            imageData.data[i + 3] = set;
        }
        ctx.putImageData(imageData, 0, 0);
    }.bind(this)
}
</script>

<canvas id="ex14" height="200" width="200" style="border: 1px solid black;"></canvas>

<script>
    var mb = new MandelbrotOne("ex14")
    mb.render();
</script>

Now, I can do something like this:

```js
var mb = new Mandelbrot("ex14")
mb.render();
```

There's one important change here! In the `Mandelbrot` object above, you can
see that I've exposed another attribute. `this.iterations`, and used it as a
maximum value in the for loop in the Mandelbrot function.

Why are iterations important? Well, the more iterations we use the more fine
grained the Mandlebrot can be displayed. Look at this!

```js
var mb = new MandelbrotOne("ex15")
var iterations = 1;
var x = 1;
setInterval(function(){
    mb.iterations = iterations += x
    if (iterations == 20) {
        x = -1;
    } else if (iterations == 0) {
        x = 1;
    }
    mb.render();
}, 1000)
```

<canvas id="ex15" height="200" width="200" style="border: 1px solid black;"></canvas>

<script>
(function() {
    var mb = new MandelbrotOne("ex15")
    var iterations = 1;
    var x = 1;
    setInterval(function(){
        mb.iterations = iterations += x
        if (iterations == 20) {
            x = -1;
        } else if (iterations == 0) {
            x = 1;
        }
        mb.render();
    }, 200)
})()
</script>

As the iterations cycle back and forth, you can see that the edges of the set
get more definition. That could go on infinitely, though what you see above is
about as high fidelity as we can get at that zoom level, since pixels have a
definite size, small as they may seem.

{{#img}}mb/mb10.jpg{{/img}}

Colors come out of the speakers
==============================

Let's talk about those trippy ass colors you see on all the zooms on youtube.

Right now we've got a pretty simple true false test that tells us if a pixel is
not in the set or if, _as far as we know_, it is. Every extra iteration increases
the fidelity of that second category, as you can see in the doodad above. The
thing is, we're throwing away some information here We're throwing away _how
many iterations it took us_ to figure out that a point was not in the set. This
is really interesting information!

Currently, the render function uses the boolean value returned by
`isMandlebrot` to decide whether or not to set the `opacity` 'byte' to either
255, or 0.

```js
    this.render = function() {
        for (var i = 0; i < canvas.width * canvas.height * 4; i += 4) {
            set = isMandlebrot(indexToCoord(i)) ? 255 : 0;
            imageData.data[i]     = 0;
            imageData.data[i + 1] = 0;
            imageData.data[i + 2] = 0;
            imageData.data[i + 3] = set;
        }
        ctx.putImageData(imageData, 0, 0);
    }.bind(this)
```

We can change `isMandlebrot` to return a tuple instead, of two things: the
original boolean value _and the iterations required to divine it_.

```js
var isMandlebrot = function(coord) {
    var cr = coord.x
    var ci = coord.y
    var zr = coord.x
    var zi = coord.y

    var i;
    for (i = 0; i < this.iterations; i++) {
        if (zr**2 + zi**2 > 4) {
            return [false, i];
        }

        newzr = (zr * zr) - (zi * zi) + cr;
        newzi = ((zr * zi) *2) + ci
        zr = newzr
        zi = newzi
    }
    return [true, i];
}.bind(this);
```

Now, back in the render function, we can use that information to color the
pixel according to it's iteration score!

```js
this.render = function() {
    for (var i = 0; i < canvas.width * canvas.height * 4; i += 4) {
        thing = isMandlebrot(indexToCoord(i))
        set =  thing[0] ?  0: (thing[1] / this.iterations) * 0xffffff;
        imageData.data[i]     = (set & 0xff0000) >> 16;
        imageData.data[i + 1] = (set & 0x00ff00) >> 8;
        imageData.data[i + 2] = set & 0x0000ff;
        imageData.data[i + 3] = 255;
    }
    ctx.putImageData(imageData, 0, 0);
}.bind(this)
```

> `set` here is a value that I'm first normalizing between 0 and 1, then
> scaling to be between 0 and 16777215. Then I'm extracting RGB values in kind
> from it with some bit twiddling. Sorry I'm not explaining that more/better,
> I'm turning the iteration count into a color value is all!


This is _drastically_ cooler looking.

<script>
    function Mandelbrot(canvasId) {
        var canvas = document.getElementById(canvasId);
        var ctx = canvas.getContext("2d");
        var imageData = ctx.createImageData(canvas.width, canvas.height);
        var aspectRatio = canvas.height / canvas.width

        this.iterations = 200;
        this.r = 4
        this.center = {
            x: 0,
            y: 0
        };

        var indexToCoord = function(index) {
            index /= 4;
            coord =  {
                x: index % canvas.width,
                y: Math.floor(index / canvas.width)
            }
            coord.x = (((coord.x * this.r / canvas.width) - this.r / 2) + (this.center.x * aspectRatio)) / aspectRatio;
            coord.y = ((((coord.y * this.r / canvas.height) - this.r / 2) * -1) + this.center.y);
            return coord;
        }.bind(this)

        var isMandlebrot = function(coord) {
            var cr = coord.x
            var ci = coord.y
            var zr = coord.x
            var zi = coord.y

            var i;
            for (i = 0; i < this.iterations; i++) {
                if (zr**2 + zi**2 > 4) {
                    return [false, i];
                }

                newzr = (zr * zr) - (zi * zi) + cr;
                newzi = ((zr * zi) *2) + ci
                zr = newzr
                zi = newzi
            }
            return [true, i];
        }.bind(this);

        this.render = function() {
            for (var i = 0; i < canvas.width * canvas.height * 4; i += 4) {
                thing = isMandlebrot(indexToCoord(i))
                set =  thing[0] ? 0 : (thing[1] / this.iterations) * 0xffffff;
                imageData.data[i]     = (set & 0xff0000) >> 16;
                imageData.data[i + 1] = (set & 0x00ff00) >> 8;
                imageData.data[i + 2] = set & 0x0000ff;
                imageData.data[i + 3] = 255;
            }
            ctx.putImageData(imageData, 0, 0);
        }.bind(this)
    }
</script>

<canvas id="ex16" height="200" width="200" style="border: 1px solid black;"></canvas>

<script>
(function() {
    var mb = new Mandelbrot("ex16")
    mb.render();
})()
</script>

```js
var mb = new Mandelbrot("ex16")
mb.render();
```

Remember those little thingers from before? Look what they look like in _color_!!

<canvas id="ex17" height="200" width="200" style="border: 1px solid black;"></canvas>
<button class="ex17button" data-centerx="-0.7463" data-centery="0.1102" data-r="0.005" >x:-0.7463, y:0.1102, r:0.005</button>
<button class="ex17button" data-centerx="-0.7453" data-centery="0.1127" data-r="0.00065" >x:-0.7453, y:0.1127, r:0.00065</button>
<button class="ex17button" data-centerx="-1.25066" data-centery="0.02012" data-r="0.0005" >x:-1.25066, y:0.02012, r:0.0005</button>
<button class="ex17button" data-centerx="-0.16" data-centery="1.0405" data-r="0.076">x:-0.16, y:1.0405 r:0.046</button>

<script>
(function() {
    var canvasId = "ex17";
    var graph = new Mandelbrot(canvasId);
    graph.iterations = 1500;
    graph.render();
    var buttons =  document.getElementsByClassName(canvasId + "button");
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].onclick = function(e) {
            console.log("dfjio");
            graph.center = {
                x: parseFloat(e.currentTarget.getAttribute('data-centerx')),
                y: parseFloat(e.currentTarget.getAttribute('data-centery'))
            };
            graph.r = parseFloat(e.currentTarget.getAttribute('data-r'))
            graph.render();
        };
    };
})();
</script>

{{#img}}mb/mb50.jpg{{/img}}

Alright! This totally works and is beautiful! But, it's _slow._ On the one hand
_of course it is_, this is a lot of computation. But on the other hand... we can do better.

Way, way better.

So, I've made a little doodad that computes Mandelbrots on the gpu using WebGL.
It lives here:

[http://mandelbrot.jfo.click](http://mandelbrot.jfo.click)

All of the illustrations above that aren't example canvases were made with
this tool. I've really enjoyed playing with it! You can even resize the canvas
to download high resolution backgrounds as large as you want! Though of course
the bigger they go, the slower they'll run, but just give it a try and see what
you can find.

I am not going to explain the code in the webgl widget just yet for a few
reasons. First, I'm really happy with how the final product turned out, but the
code is a wreck, organizationally! And anyway, most of it is boilerplate to get
the webgl connected and up and running, and the parts that aren't boilerplate
aren't substantially different from the code I've shown in vanilla javascript
over the course of this post.

I hacked together this widget using

- [https://webglfundamentals.org](https://webglfundamentals.org)

The author [Greggman](https://github.com/greggman) also maintains a library called
[twgl.js](http://twgljs.org/) for making the WebGL api less verbose and I am
definitely going to use it next time.

- [https://www.shadertoy.com/view/4df3Rn](https://www.shadertoy.com/view/4df3Rn)

Íñigo Quílez, who created [shadertoy](https://www.shadertoy.com/), also
practically has the [market cornered on Mandelbrot
renders](https://www.shadertoy.com/results?query=mandelbrot). The link above
served as both inspiration for this whole thing (wait... we can compute in
realtime now?) and model while porting my js code over to webgl. I have that
shader to thank for that incredible coloring function that I used as the base
of mine; I'm still not entirely sure how it works.

A few caveats- this isn't really designed for mobile. UX wise it's definitely
not, but more importantly mobile platforms don't seem to have the same caliber
of graphics processing as a lap or desktop. This isn't really a huge surprise;
you might be able to get it to render something, but no promises.

Also, unfortunately, current
[GLSL](https://en.wikipedia.org/wiki/OpenGL_Shading_Language) only natively
supports 32 bit floats for use on the gpu, so we run out of precision
relatively quickly on the widget. You can barely see where the pixels become
blockish at the highest zooms, but don't be mistaken- this is not the end of
the set- the set goes on _forever._ There are techniques to work around this
and achieve a higher precision, but my mandelbrot bike shed doesn't need
_another_ coat of paint before shipping. I'll likely try to get around to that
sometime, or just put it off until 64 bit floats are native to the platform!

{{#img}}mb/mb11.jpg{{/img}}
<hr>


<span id="references"></span>

References
==========

Here are some things I found really helpful while working on this project.

- [Holly Krieger's explanation of the set on Numberphile](https://www.youtube.com/watch?v=NGMRB4O922I)

- [This documentary excerpt featuring Benoit Mandelbrot](https://www.youtube.com/watch?v=56gzV0od6DU)

- [Mandelbrot's Ted talk about roughness from 2010](https://www.youtube.com/watch?v=56gzV0od6DU)

- [This deep zoom video accompanied by Jonathan Coulton's song "Mandelbrot Set"](https://www.youtube.com/watch?v=ZDU40eUcTj0)

- [This JavaScript Mandelbrot generator](http://tilde.club/~david/m/#zoom=6.2260371959942775,3.4&lookAt=-0.6,0&iterations=85&superSamples=1&escapeRadius=10.0&colorScheme=pickColorGrayscale)

- [This wikihow.com page (I know right? But it was helpful early on!)](http://www.wikihow.com/Plot-the-Mandelbrot-Set-By-Hand)

- [This collection of interesting coordinates I used for testing.](http://www.cuug.ab.ca/dewara/mandelbrot/Mandelbrowser.html)

- [Fractals: an animated discussion](https://searchworks.stanford.edu/view/dd592sd0866)

Unfortunately the last one is probably the best but I haven't been able to find
it online anywhere. The one I saw was loaned to me by fellow fractal enthusiast
and Etsian [Paul-Jean Letourneau](http://paul-jean.github.io/). Thanks Paul-Jean!

> Update: [someone found it!](https://fod.infobase.com/p_ViewPlaylist.aspx?AssignmentID=6U4LJA)

Also thanks to [Julia Evans](https://jvns.ca/) for talking me through some of
the math early on and helping me with my complex number algebra that I kept
messing up and which produced weird blobs on the canvas.

I hope this was interesting. I'm going to shut off my computer for the rest of
the day now. I've been thinking of picking one day a week and not looking at
any screens, or at least not staring at the computer screen for the whole day.

{{#img}}mb/mb57.jpg{{/img}}

(That one is secretely my favorite :))


<div id="update"></div>

Sept 2017 update!
---------------

As part of my self hosting images
[initiative](/s3-hugo-and-static-asset-hosting/), I've updated all of the
examples on this page to much more hi-res and web optimized images, and they
look SO GOOD NOW despite being the same weight or lighter than the [images I
used to have up here](https://imgur.com/gallery/15NIE). Special thanks to [Lara
Hogan](https://twitter.com/Lara_Hogan) from whose book [Designing for
Performance](http://shop.oreilly.com/product/0636920033578.do) I was able to
figure out how to make that quality / size balance work optimally!
