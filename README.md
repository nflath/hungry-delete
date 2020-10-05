hungry-delete.el - hungry delete minor mode
============

Copyright (C) 2009-2014 Nathaniel Flath <flat0103@gmail.com>

Version: 1.0

### Commentary ###

This package implements hungry deletion, meaning that deleting a whitespace character
will delete all whitespace until the next non-whitespace character.

cc-mode implements hungry deletion for its programming modes. This package borrows
its implementation in a minor mode, so that hungry deletion can be used in all modes.

The function global-hungry-delete-mode will turn on hungry-delete-mode in all
buffers.

### Installation ###

To use this mode, just put the following in your init.el:

```elisp
(require 'hungry-delete)
(global-hungry-delete-mode)
```
### hungry-ish deletion ###

Some users mght find hungry-delete's default behavior too aggressive, since it
will often merge the words before and after the deletion point. This behavior
can be changed by setting the `hungry-delete-join-reluctantly` flag to true.
This will cause the hungry deletion functions to leave words seperated by a
single space if they would have been joined, unless the words were separated by
just one space to begin with

As an example, suppose you're in the following state.

```elisp
;; State A
foo        bar
           ^
```

Pressing backspace with `hungry-delete-join-reluctantly` as `nil` (the default)
will land you here

```elisp
;; State B
foobar
   ^
```

Whereas if `hungry-delete-join-reluctantly`is enabled, you'll end up here

```elisp
;; State C
foo bar
    ^
```
whereupon you can press backspace again to get to state B
