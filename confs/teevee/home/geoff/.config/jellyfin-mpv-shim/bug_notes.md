There is a bug where "quit" commands coming from anything other than a "q" keypress
or window closure (e.g. via openbox) the shim breaks and must be killed along with 
the mpv instance. Thus, I have set `windowcontrols=no` in `osc.conf` 
(for `modernx.lua`) and removed the "Quit" menu item in `mpvcontextmenu/main.lua`.
Despite both of these simply calling the mpv `quit` command, supposedly similar to
hitting "q", the shim does not handle it the same. Maybe worth looking into the logs
one day to see if a simple fix is possible.
