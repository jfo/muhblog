---
title: Keybord
draft: true
---

This is the ultimate yak shave. How much further down can you go, really? I
could design my own processor out of switches, or
[dominoes](https://www.youtube.com/watch?v=OpLU__bhu2w()), or silicone I guess.
And then write my own bytecode for it? I love making things myself but even I
have limits.

But building my own keyboard firmware is not beyond those limits!
It's going to be the best firmware, yuge.  Fantastic, luxurious firmware.

No seriously why are you doing this what a huge waste of time use [this]( https://github.com/tmk/tmk_keyboard ) instead
----------------------------------------------------------------------------------------------

I want to learn things and stuff and that's why I'm doing this the hard way. I
don't have occasion to write embedded systems software, normally... and so the
toolchains and techniques that are used to write them remain pretty obscure to
me. I know that there is a chip- I know that I can write C (or something else
maybe!) and compile it and assemble it and link it and flash it, and I know the
chip can run the code I've written to do things. Things! Imagine it!

I have an understanding, conceptually, of how that process works, and how
bytecode is interpreted and how memory is laid out, and I've heard the word
'cache' before and also 'interrupt' and I kind of know what they mean. But I
don't _really_ know what they mean.

And there aren't all that many entry vector level resources floating around out
there, either. I discovered a dearth of accessible writing bounded on the upper
end by cool af Arduino projects and on the lower end by [giant
specs](http://www.usb.org/developers/docs/usb20_docs/) and
[manuals](http://www.atmel.com/images/Atmel-0856-AVR-Instruction-Set-Manual.pdf).
The latter are definitely great resources and it would be really beneficial to sit
down and go through them with a fine tooth comb, but without context and a
general understanding of what I'm reading about, I probably wouldn't get super
far. I need to start from a contained project and hit a bunch of roadblocks to
gain that context, and keyboard firmware seemed like a good candidate for that.

Also, I wanted to [build a keyboard from scratch.](/keyboard).

It seems that a lot of people that do embedded systems stuff seem to come
_up_ from electrical engineering rather than _down_ from interpreted and 'high
level' compiled languages. Arduinos are very cool and do amazing things to make
hardware programming accessible for driven folks from artists to enthusiasts to
programmers of all stripes, but I want more and deeper understanding of what
I'm actually doing. I know that I can write C and compile it and get it on the
chip and have it run, and that's what I really want to know how about.

So here is an excruciatingly detailed post about that!

Start from what I know.
--------------------------

Here is a tiny arduino program.

```arduino

void setup() {
  pinMode(13, OUTPUT);
  digitalWrite(13, HIGH);
}

void loop() {
}
```

This program powers pin 13, which has a LED attached to it. The LED is on
because I've set the pin to `HIGH`, that makes sense.

If I take a small wire and connect pin 13 to ground, the led will go off. This also makes sense.

> more about that


```arduino

void setup() {
  pinMode(13, OUTPUT);
  digitalWrite(13, HIGH);

  Serial.begin(9600);
}

void loop() {
  if (digitalRead(13) == 0) {
      Serial.println("Yeah alright yeah!");
  }
}
```

When the LED is on, `digitalRead(13)` will return `1` because the pin has
power. When it's connected to ground, it loses that power, because the power
goes to ground.

So now, in the arduino IDE, you can open the serial monitor and see "Yeah
alright yeah!" print to it everytime you press down the switch.

As it turns out, it's actually pretty easy to make the computer think your
arduino is a keyboard!

Take it away, built in libs!

```arduino
void setup() {
  pinMode(12, OUTPUT);
  digitalWrite(12, HIGH);

  Keyboard.begin();
}

void loop() {
  if (digitalRead(12) == 1) {
    Keyboard.print("a");
  }
}
```

So, this will totally work. I now have a functioning keyboard of just one key
that presses "a".




How do I turn a switch into a signal on the arduino?  what is a signal on the
arduino? HIGH LOW the signal going through the pull up resistor when grounded
gives a signal.  could be the other way around but then you couldn't stack them
the same way.  do the arduino with a single switch, sending serial chars.
switch to sending a single keystroke.

explain the matrix, links to those good posts

http://blog.komar.be/how-to-make-a-keyboard-the-matrix/
http://pcbheaven.com/wikipages/How_Key_Matrices_Works/

Introduce the teensy.
compile and run the arduino code for the teensy?

talk about wanting to write my own stuff. How far down do you go? do you write
the bootloader? do you write the usb stuff? what does the teensy have?

I decided to use the loader.

Talk about the example code from pjcr, use that as a base.

can I do it in rust?


http://hackaday.com/2012/06/29/turning-an-arduino-into-a-usb-keyboard/

step one:

send a keycode to the computer every 2 seconds.

