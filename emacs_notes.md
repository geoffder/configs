
# Evil reminders:
Normal za -> toggle fold
Normal ysw -> surround word (stops on non-word characters like '_')
Normal ysio -> surround symbol that includes non-word characters like '_'
## Multi Cursors:
source: https://noelwelsh.com/posts/2019-01-10-doom-emacs.html
Normal gzz -> new add cursor at cursor position
Normal gzu -> kill cursors

# Emacs basics:
Alt-% -> basic emacs find and replace
C-x u -> emacs undo tree

# Magit:
>> SHIFT skips my C-c exit binding
(Hold SHIFT) C-c C-c -> Commit from message text

# FSharp
f-sharp-mode HACK to fix nested block indentation bug.
/home/geoff/.emacs.d/.local/straight/build/fsharp-mode/fsharp-mode-structure.el
commented lines 637 -> 641 as per:
https://github.com/fsharp/emacs-fsharp-mode/issues/211
