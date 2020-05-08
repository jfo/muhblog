---
title: WebAssembly sections, part 2
date: 2019-08-29
syndicate: true
---

[Last time](/wat-is-up-with-web-assembly) I started from the binary format and made a little
module that doesn't do anything.

This is how the rest of this series of posts is going to go... a bunch of
iterative examples building up to a small webassembly program in text format
that does some useless stuff but uses all of the possible sections that can
appear in a webassembly program. Of course, I won't be exhaustively listing all the
instructions or every single thing that can go in any place in the file, as you
are free to pore over the
[ur-docs](https://webassembly.github.io/spec/core/index.html) for
that, as I have attempted to do in part here.  Hopefully by the end, we'll both
have a better idea of how a wasm module is or can be structured, and why.

Doing useful things with that comes later, but stick with me; maybe we'll
get there.

Like in the last post, I'll just be compiling these examples with `wat2wasm`,
which is part of the web assembly binary toolkit (wabt), which you can get
[here](https://github.com/WebAssembly/wabt). There is apparently a [node module
port](https://www.npmjs.com/package/wabt) of these tools, that might work too.

A little test script might look something like this:

```js
const { execSync } = require('child_process');
const { readFileSync } = require('fs');

execSync('wat2wasm test.wat -o out.wasm');
const buf = readFileSync('out.wasm');

WebAssembly.instantiate(buf).then(e => {
  console.log(
    e.instance.exports
  );
});
```

I'm just using synchronous blocking io functions, because who cares, and you'll
notice the interesting stuff happens in the promise resolution where right now
I'm just logging the exports.

Webassembly programs are composed of some combination of the following
sections, arranged here in not really any particular order:

- global
- export
- functions
- types
- tables
- memory
- elements
- data
- import
- start

I ended the last time with this program:

```
(module
  (global (;0;) i32 (i32.const 42))
  (export "x" (global 0)))
```

so the first two sections, globals and exports, have already been covered.
Let's move on!


Functions
-------

Here is an empty function.

```
(module
  (func)
  (global (;0;) i32 (i32.const 42))
  (export "x" (global 0)))
```

You can declare a function signature type, and return a constant of that type.
With no return type specified, the return type is default "`null`", or
"`undefined`", or something falsy, right? notice the air quotes... wasm doesn't
really have those types, what it _has_ got is an "empty stack".

Let's say I try to assemble this:

```
(module
  (func i32.const 123))
```

I'll get this error:

```
test.wat:2:9: error: type mismatch in function, expected [] but got [i32]
  (func i32.const 123))
        ^^^^^^^^^
```

This tracks, the function doesn't so much "return" as it does "leave its stack
in a state compatible with the stated expected result". This may seem hair splitting,
and it is of course, but I think it's valuable to draw subtle distinctions
between the way we usually think about functions in a higher level language and
how we think about them in a stack machine environment. More on that later.

Moving on, I can return a constant value:

```
(module
  (func (result i32)
    i32.const 123)
  (global (;0;) i32 (i32.const 42))
  (export "x" (global 0)))
```

Perhaps instead of a constant value, you can return the global value declared
previously. It's available to you here:

```
(module
  (func (result i32)
    global.get 0)
  (global (;0;) i32 (i32.const 42))
  (export "x" (global 0)))
```

Now is a good time to mention you can assign an alias to a global value and
refer to it that way.

```
(module
  (func (result i32)
    global.get $theMeaningOfLife)
  (global $theMeaningOfLife i32 (i32.const 42))
  (export "x" (global $theMeaningOfLife)))
```
Also it doesn't matter what order these modules are declared in:

```
(module
  (global $theMeaningOfLife i32 (i32.const 42))
  (func (result i32)
    global.get $theMeaningOfLife)
  (export "x" (global $theMeaningOfLife)))
```

> You may also see `get_global`, I think that's an older way to do that, I'm
> not sure.

Maybe we give it a parameter?

```
(module
  (global $theMeaningOfLife i32 (i32.const 42))
  (func (param i32) (result i32)
    global.get $theMeaningOfLife)
  (export "x" (global $theMeaningOfLife)))
```

You can also assign a name to parameters instead of referring to them by their index.

```
(module
  (global $theMeaningOfLife i32 (i32.const 42))
  (func (param $n i32) (result i32)
    global.get $theMeaningOfLife)
  (export "x" (global $theMeaningOfLife)))
```

Here's a good place to talk about what a stack machine _is_; really this is
the business end of wasm computation. I won't enumerate all the instructions,
of course, but this is where most of them would go. A stack machine is a pretty
simple model, things get loaded into a FILO stack (first in, last out), and
when instructions are applied to them, they pull out the number of arguments
they need.

```
(module
  (global $theMeaningOfLife i32 (i32.const 42))
  (func (param $n i32) (result i32)
    local.get $n
    global.get $theMeaningOfLife
    i32.add)
  (export "x" (global $theMeaningOfLife)))
```

The body of this function has three lines, after this line:

```
local.get $n
```

`local` here refers to the parameter passed in; now the stack looks like this
(let's pretend we called this function in javascript with `10`):

```
[10]
```

Then after this line:

```
global.get $theMeaningOfLife
```

```
[42, 10]
```

Now,

```
i32.add
```

pops two values off the stack and pushes the result of the operation onto the
stack, so in the end, it looks like this

```
[52]
```

The function then "returns" this value by leaving it in the stack. If what's in
the stack doesn't match the result type, you'll get an error.

Of course, we may like to export the function the same way we exported the global:

```
(module
  (global $theMeaningOfLife i32 (i32.const 42))
  (func (param $n i32) (result i32)
    local.get $n
    global.get $theMeaningOfLife
    i32.add)
  (export "x" (global $theMeaningOfLife))
  (export "aFunction" (func 0)))
```

In this way we can call it from javascript land, which might look like:

```js
const { execSync } = require('child_process');
const { readFileSync } = require('fs');

execSync('wat2wasm test.wat -o out.wasm');
const buf = readFileSync('out.wasm');

WebAssembly.instantiate(buf).then(e => {
  console.log(
    e.instance.exports.aFunction(10)
  );
});
```

And we can name it as well, although again, this name is only textual; it
still needs to be exported explicitly.

```
(module
  (global $theMeaningOfLife i32 (i32.const 42))
  (func $aFunction (param $n i32) (result i32)
    get_local $n
    get_global $theMeaningOfLife
    i32.add)
  (export "x" (global $theMeaningOfLife))
  (export "aFunction" (func $aFunction)))
```

> maybe a useful note: these alias names are thrown away on assembly, if we run
> `wasm2wat` on the output of `wat2wasm`, we get
```
(module
  (global (;0;) i32 (i32.const 42))
  (func (;0;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 0
    i32.add)
  (export "x" (global 0))
  (export "aFunction" (func 0)))
```
>

If you have two functions, you could call one from the other... maybe one of
them is a helper and the other is exported. You call this internally with `call`, like so

```
(module
  (global $theMeaningOfLife i32 (i32.const 42))
  (func $addOne (param $x i32) (result i32)
        i32.const 1
        local.get $x
        i32.add)
  (func $aFunction (param $x i32) (result i32)
        local.get $x
        call $addOne
        i32.const 42
        i32.add)
  (export "x" (global $theMeaningOfLife))
  (export "aFunction" (func $aFunction)))
```

types
-------

The type section defines function signatures that can be referenced in the
function declarations. Unfortunately it seems like the local variable name
doesn't propogate to the function scope, but the types themselves accept an
alias.

```
(module
  (type $ourFriend (func (param i32) (result i32)))
  (global $theMeaningOfLife i32 (i32.const 42))
  (func $addOne (type $ourFriend)
        i32.const 1
        local.get $x
        i32.add)
  (func $aFunction (type $ourFriend)
        local.get $x
        call $addOne
        i32.const 42
        i32.add)
  (export "x" (global $theMeaningOfLife))
  (export "aFunction" (func $aFunction)))
```

It should be noted that the current spec only allows results of a single value,
meaning you can't return a vector of more than one value. So this, which looks
like it could or should be valid and would leave the stack in the state `[2, 1]`,

```
(module
  (func (result i32 i32)
        i32.const 1
        i32.const 2))
```

Will error on assembly:

```
test.wat:2:4: error: multiple result values not currently supported.
  (func (result i32 i32)
   ^^^^
```

I take this to mean that it is likely to be supported in the future, if I had
to bet.

More to come.
