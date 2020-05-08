---
title: mandelwat2
draft: true
---

Last year I wrote [this](/the-mandelwat-set/). I said I would write about using
webgl to create a real time renderer, so now I finally got around to that and
this post is that so here we go.

My usual disclaimer goes here and that is this: I am far from a subject matter
expert, in this case of graphics programming; this is more of a devlog
concerned with this one project.  I think it is useful to share this way and to
write about process, without trying to maintain a stance of authority. I should
probably write a general disclaimer sometime about this but I haven't yet.

That said, I've tried as always to include links to resources I found helpful,
chief among them the _excellent_ [WebGL
Fundamentals](https://webglfundamentals.org/), from which most of the working
boilerplate below is cribbed and which I highly recommend.  WebGL, like its
native counterparts OpenGL and Cuda, is, for very good reasons, _extremely
complicated_, and I'm only barely scratching the surface of what these
technologies are capable of, just enough to accomplish my goal. In fact, It's
likely to be worth reading over the
[introduction](https://webglfundamentals.org/webgl/lessons/webgl-fundamentals.html)
if anything in the next section doesn't make enough sense. I'm just barely
skimming it here. I've used WebGL 1.0 because it's better supported and honestly
I'm not doing anything that sophisticated from a graphics programming
perspective- I haven't checked but it's likely the WebGL 2.0 would be almost
the exact same.

With that said, let's get into it.

What is WebGL?
-------------

WebGL is a [well supported](https://caniuse.com/#search=webgl) browser protocol
that allows direct access to graphics hardware. The fact that we are dealing
with a _different piece of hardware_ that also has a different computing paradigm is
what introduces all of the the technical complexity into this protocol. This is
_not_ a javascript library that utilizes graphics hardware, it's the _bridge_
between that browser and that hardware that software like that _uses_.

[D3.js](https://d3js.org/) is probably the most well known library that uses webGL
or maybe three.js.

WebGL is a _rasterization engine_. This means that it takes geometries and
converts them into the pixels that actually draw on the screen at runtime.
Let's say I ask it to "draw a triangle whose vertices are in `x`, `y`, and `z`
places.  "Ok," it dutifully responds, "then I will draw the shape that has
those vertices for you". You do not need to specifically express which pixels
to fill in to create that shape, the engine does that part. _But_, you _do_
need to tell it how to decide what color each pixel will be. This is naturally
a two step process, expressing geometries through vertices, and expressing
color choice of the resulting fragment's constituent pixels.

We need to create one _shader_ for each of these two steps: the first is a
`vertex shader` and the second is a `fragment shader`.

Here is a very simple example of each of those- this is written in OpenGL
Shading Language, or
[GLSL](https://www.khronos.org/opengl/wiki/OpenGL_Shading_Language), a C like
domain specific language designed for this purpose.

Here is a vertex shader:

```glsl
attribute vec2 a_position;
void main() {
  gl_Position = vec4(a_position, 0, 1);
}
```

and here is a fragment shader:

```glsl
precision mediump float;
void main() {
  gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
}
```

You'll notice that, like C and many other compiled languages, each shader has a
`main` function which will execute at runtime.
