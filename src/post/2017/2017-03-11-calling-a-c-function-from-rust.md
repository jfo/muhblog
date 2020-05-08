---
date: 2017-03-11T00:00:00Z
title: Calling a C function from Rust
---

Today I went to a Rust meetup. I had some ideas of what I might work on, but
I've started to try and be more open to random nerdsnipes and discussions at
these things. Here's something I was thinking about and a little experiment
that was an equally little success, that is to say, a success that was :+1: but
isn't that big of a thing. I'm happy about it though.

Let's say I want to call a C function from Rust. How do I do this? What does it
_mean_ to call a C function from Rust? Initial investigations lead me straight
to [this](https://doc.rust-lang.org/book/ffi.html). I've heard "ffi" before,
ok.  Foreign Function Interface. Ok.

So, first I make a C file that has a single, simple function declaration and a `main` that uses it, and nothing else.

```c
// main.c
#include <stdio.h>

int doubler(int x) {
    return x * 2;
}

int main() {
    printf("%i", doubler(1));
    return 0;
}
```

```
clang main.c
./a.out
```

Produces, as you would expect,

```
2
```

I'll pull this into two files now, one for the function, and one for the executable.

```c
// doubler.c

int doubler(int x) {
    return x * 2;
}
```

```c
// main.c

#include <stdio.h>
#include "doubler.c"

int main() {
    printf("%i", doubler(1));
    return 0;
}
```

This also "just works"

```
clang main.c
./a.out
```

Of course, I don't want to `#include "doubler.c"`, because of reasons. See
[here](/sild-header-files/) for much more on why.

Instead, I want to  `#include "doubler.h"`. What is `doubler.h`? It looks like
this, simply stating the function signature of `doubler`:

```c
// doubler.h
int doubler(int x);
```

The other two look like this now, with only the change from
`#include "doubler.c"` to `#include "doubler.h"`

```c
// doubler.c
int doubler(int x) {
    return x * 2;
}
```
```c
// main.c
#include <stdio.h>
#include "doubler.h"

int main() {
    printf("%i", doubler(1));
    return 0;
}
```
```
clang main.c
```

Aha.

```
Undefined symbols for architecture x86_64:
  "_doubler", referenced from:
        _main in doub-715218.o
        ld: symbol(s) not found for architecture x86_64
        clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

So, the header file is _just the symbol_. This is where the 'linking' happens.
I'll need to compile the `doubler.c` file into an object and then _link that
into the main executable_ at the compiler level.


I'll compile this `.c` file into an `.o` file with the following compiler command:

```
clang doubler.c -c
```

The `-c` flag instructs the compiler to produce an object file... an `.o` file,
that is not an executable binary and so does not need a `main()` declaration.

This is a shared object file. It might be called `.so` or `dylib` (for 'dynamic
library'). I am not sure of the distinction if any between these suffixes, but
the basic idea is that the file contains machine code designated by symbols
that can be linked into other programs.

> Update: good [feedback on
> Twitter](https://twitter.com/dev_console/status/841071717166534661)
> elucidated this distinction some, and [Julia](https://jvns.ca/) pointed me to
> a [much more in depth resource](https://lwn.net/Articles/276782/)

What does that `.o` file look like?

```
Ïúíþ^G^@^@^A^C^@^@^@^A^@^@^@^D^@^@^@°^A^@^@^@ ^@^@^@^@^@^@^Y^@^@^@8^A^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@x^@^@^@^@^@^@^@Ð^A^@^@^@^@^@^@x^@^@^@^@^@^@^@^G^@^@^@^G^@^@^@^C^@^@^@^@^@^@^@__text^@^@^@^@^@^@^@^@^@^@__TEXT^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^Q^@^@^@^@^@^@^@Ð^A^@^@^D^@^@^@^@^@^@^@^@^@^@^@^@^D^@<80>^@^@^@^@^@^@^@^@^@^@^@^@__compact_unwind__LD^@^@^@^@^@^@^@^@^@^@^@^@^X^@^@^@^@^@^@^@ ^@^@^@^@^@^@^@è^A^@^@^C^@^@^@H^B^@^@^A^@^@^@^@^@^@^B^@^@^@^@^@^@^@^@^@^@^@^@__eh_frame^@^@^@^@^@^@__TEXT^@^@^@^@^@^@^@^@^@^@8^@^@^@^@^@^@^@@^@^@^@^@^@^@^@^H^B^@^@^C^@^@^@^@^@^@^@^@^@^@^@^K^@^@h^@^@^@^@^@^@^@^@^@^@^@^@$^@^@^@^P^@^@^@^@^K
^@^@^@^@^@^B^@^@^@^X^@^@^@P^B^@^@^A^@^@^@`^B^@^@^L^@^@^@^K^@^@^@P^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^A^@^@^@^A^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@UH<89>å<89>}ü<8b>}üÁç^A<89>ø]Ã^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^Q^@^@^@^@^@^@^A^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^T^@^@^@^@^@^@^@^AzR^@^Ax^P^A^P^L^G^H<90>^A^@^@$^@^@^@^\^@^@^@¨ÿÿÿÿÿÿÿ^Q^@^@^@^@^@^@^@^@A^N^P<86>^BC^M^F^@^@^@^@^@^@^@^@^@^@^@^A^@^@^F^A^@^@^@^O^A^@^@^@^@^@^@^@^@^@^@^@_doubler^@^@^@
```

Yeah, so like, of course that's a bunch of unprintable junk mostly, because
it's not a text file, it's machine code, and is not designed to be printed to the
screen directly like that. But, there is `_doubler` in there... that's the
symbol I actually want to link to.

I can link all these together simply by supplying all the names to `clang`.

```
clang main.c doubler.o
```

produces an `a.out` file that when executed prints `2`.

So how do I do this from Rust, in the most basic way?

```rust
// main.rs
fn main() {
    println!("{}", doubler(1));
}
```

If I try to compile this with `rustc main.rs`, I get an obvious error:

```
error[E0425]: unresolved name `doubler`
 --> doubler.rs:2:20
   |
 2 |     println!("{}", doubler(1));
   |                    ^^^^^^^ unresolved name

     error: aborting due to previous error
```

I already know that I can't do the equivalent of `#include "doubler.c"` or
`#include "doubler.h"`, because those don't make any sense in this context. I
also know that what I need to do is direct the compiler to expect the symbol
`doubler` to be linked _to_. I want, basically, the rust equivalent of what
exists in the C header file, just the function signature.

That equivalent can be put into an `extern` block, like this:

```rust
// main.rs
extern {
    fn doubler(x: u32) -> u32;
}

fn main() {
    println!("{}", doubler(1));
}
```

> I am using `u32` here because on my machine `sizeof(int)` returns `4`, which
> is 4 bytes, so 4 * 8 bits = 32 bits.

Now I get a different error!

```
error[E0133]: call to unsafe function requires unsafe function or block
 --> /Users/jfowler/code/linkertest/doubler.rs:6:20
  |
6 |     println!("{}", doubler(1));
  |                    ^^^^^^^^^^ call to unsafe function

error: aborting due to previous error
```

Because the Rust compiler has no way of controlling what the C code is going to
do to the data passed into it, I need to wrap this in an unsafe block.

```rust
extern {
    fn doubler(x: u8) -> u8;
}

fn main() {
    unsafe {
        println!("{}", doubler(1));
    }
}
```


```
error: linking with `cc` failed: exit code: 1
  |
  = note: Undefined symbols for architecture x86_64:
  "_doubler", referenced from:
      main::main::hf64fd37c24bdc499 in doubler.0.o
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

This looks familiar! I got the same basic error on the C version when I didn't
link the object file to the executable at compile time.

Is there a way to instruct `rustc` to do this? What about simply passing the
list of names of the files (this is after `clang doubler.c -c` has produced
`doubler.o`)

```
rustc main.rs doubler.o
```

Nope.

```
error: multiple input filenames provided
```

Running `rustc` without arguments shows me the flags, including:

```
-l [KIND=]NAME      Link the generated crate(s) to the specified native
                    library NAME. The optional KIND can be one of static,
                    dylib, or framework. If omitted, dylib is assumed.
```

Perhaps...

```
rustc main.rs -l doubler.o
```

We are getting warmer:

```
error: linking with `cc` failed: exit code: 1
  |
      = note: ld: library not found for -ldoubler.o
      clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

This is similar to the error above, but notice an important difference- it is
not looking for the symbol and not finding it, it is looking for the _library_
and not finding it. We know definitely that the library _exists_, so we just
need to know how to tell `rustc` how to _find it_. Wherever it's looking, it's not finding it. From the flags again:

```
-L [KIND=]PATH      Add a directory to the library search path. The
                    optional KIND can be one of dependency, crate, native,
                    framework or all (the default).
```

Aha. I will add the current directory, where the `.o` file lives, to the search
path.

```
rustc main.rs -l doubler.o -L .
```

This works!! And produces a `main` execuatable, that when run, gives me:

```
2
```

> Note: This no longer works! The `-l` flag is really only for system
> libraries, and at the time I wrote this I think it functioned by a fluke of how
> the linker was looking for them. Alas, no more! A proper linking script or
> configuration is likely necessary to do this now, refer to the links below
> for more coherent information about that. This post describes the process of
> trying to understand how objects are linked into the final executable in
> general, and was never intended to be a tutorial on best practices.
> - 11/2018


<hr>

This is a trivial example, yes! Also, I'm pretty sure this is most definitely
_not_ the recommended way to do this.  Read
[this](https://doc.rust-lang.org/book/ffi.html)
and [this](https://doc.rust-lang.org/1.9.0/book/advanced-linking.html) for more
thorough, idiomatic info. Afaict, the more normal way to do this kind of
thing would be to link against installed libraries or use [cargo and a
build script](http://doc.crates.io/build-script.html) to codify how the
external deps should be handled.  My sense is that the `link` attributes in the
Rust ffi docs do something at the end of the pipe that isn't wholly different
from what I've done directly above by calling `rustc` with some flags.

Also, I asked at the beginning of this post- "What does it mean to call a C
function from Rust?" I hope it's pretty clear that when you do something like
this, you're not really doing that at all! You start with source code that
happens to be in two different languages, sure... and the compilers for those
languages have their own flags and rules and such and such, but at the end of
the day you're simply allowing the Rust code to access already compiled machine
code in those object files that came from a separate compiler step. From that perspective, it's really not accurate to say that you're calling C functions from Rust!

It works, though! And it is proof that it's rudimentarily not that hard to link
together compiled outputs from different languages as long as you know the
right incantations and have a sense of what it actually means to do that. 

I am looking forward to learning more about this and learning the "right way"
to do it!
