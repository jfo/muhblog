---
title: assemble
draft: true
---

Make nothing.

```
touch nothing
```

Point Ruby at nothing.

```
ruby nothing
```
or python

```
python nothing
```

or node

```
node nothing
```

Nothing happens.

Point clang at nothing

```
clang nothing
```

```
/nix/store/cg0k49h66nkdqx6ccwnqr0i4q0fnfznc-binutils-2.31.1/bin/ld: nothing: file not recognized: file truncated
clang-7: error: linker command failed with exit code 1 (use -v to see invocation)
```

Clang is a compiler, and it is also an assembler, _and_ a
linker. It cares about what you're putting into it, it cares about what you're
starting with, so it knows where to start from in its own process.

```
touch nothing.c
```

```
clang nothing.c
```

```
/nix/store/cg0k49h66nkdqx6ccwnqr0i4q0fnfznc-binutils-2.31.1/bin/ld: /nix/store/qn76sklvyalzw9ilnxz6sh0020gl2qn6-glibc-2.27/lib/crt1.o: in function `_start':
/build/glibc-2.27/csu/../sysdeps/x86_64/start.S:104: undefined reference to `main'
clang-7: error: linker command failed with exit code 1 (use -v to see invocation)
```
