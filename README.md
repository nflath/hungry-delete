hungry-delete.el - hungry delete minor mode

Copyright (C) 2009 Nathaniel Flath <flat0103@gmail.com>
Version: 1.0

Commentary:

This project contains all the necessary functions and macros, taken
from cc-mode, to implement hungry deletion without relying on
cc-mode. This allows it to be used more easily in all modes, as it is
now a minor mode in its own right. global-hungry-delete-mode will turn
on hungry-delete-mode in all buffers.

To use this mode, just put the following in your .emacs file:

```elisp
(require 'hungry-delete)
(global-hungry-delete-mode)
```
