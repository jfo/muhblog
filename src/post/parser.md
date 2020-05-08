---
title: Parser Combinators
draft: true
---

This is my parser combinator blogpost. There are [many like it](#references),
but this one is mine.

Perhaps I have a string lying around somewhere.

```js
const testString = "Abcd123";
```

What a lovely little string.

A parser is
-----------

a function that takes a string as input and tells you if the input passes some
test you've set out for it.

```js
const aParser = input => input === "Abcd123"
aParser(testString); // true

const anotherParser = input => input === "something else"
anotherParser(testString); // false
```

That's not very interesting. Maybe a more interesting question?

```js
const aMoreInterestingParser = input => input[0] === "A"
aMoreInterestingParser(testString); // true
aMoreInterestingParser("Aadjfiojda"); // true
```

But what now?

I lied before, actually,

A parser is
-----------

a function that takes a string as input and tells you if the input passes some
test you've set out for it and also returns the remaining input to be parsed.

I can do this quite simply as a little informal tuple:

```js
const aBetterAndMoreInterestingParser = input =>
  [
    input[0] === "A",
    input.slice(1, input.length)
  ]
aBetterAndMoreInterestingParser("Aadjfiojda"); // [ true, 'adjfiojda' ]
aBetterAndMoreInterestingParser("Zadjfiojda"); // [ false, 'adjfiojda' ]
```

But wait, if the parser fails then we don't want to keep parsing the input from
there, we want to try the same place again, don't we? Yes we do.

```js
const aBetterAndMoreInterestingParser = input => {
  if (input[0] === "A") {
    return [true, input.slice(1, input.length)]
  } else {
    return [false, input]
  }
}
aBetterAndMoreInterestingParser("Aadjfiojda"); // [ true, 'adjfiojda' ]
aBetterAndMoreInterestingParser("Zadjfiojda"); // [ false, 'Zadjfiojda' ]
```

A parser generator is
-----------

a function that returns a parser. Maybe you give it some input and it decides
what to match based on that...

```js
const parseChar = char =>
  input => [
    input[0] === char,
    input.slice(1, input.length)
  ];

const parseA = parseChar('A');
const parseA = parseChar('B');
parseA(testString) // [ true, 'bcd123' ]
parseB(testString) // [ false, 'Abcd123' ]
```

A parser combinator is
-----------

