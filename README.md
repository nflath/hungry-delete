hungry-delete.el - hungry delete minor mode
============

Copyright (C) 2009-2014 Nathaniel Flath <flat0103@gmail.com>

Version: 1.0

### Commentary ###

cc-mode implements hungry deletion for its programming modes. This
package borrows its implementation in a minor mode, so that hungry
deletion can be used in all modes.

The function global-hungry-delete-mode will turn on hungry-delete-mode
in all buffers.

### Installation ###

To use this mode, just put the following in your init.el:

```elisp
(require 'hungry-delete)
(global-hungry-delete-mode)
```
