There is a bug where "quit" commands coming from anything other than a "q" keypress
or window closure (e.g. via openbox) the shim breaks and must be killed along with
the mpv instance. Thus, I have set `windowcontrols=no` in `osc.conf`
(for `modernx.lua`), removed the "Quit" menu item as well as "Play Menu > Stop" in
`mpvcontextmenu/main.lua`. Despite both of these simply calling the mpv `quit` command,
supposedly similar to hitting "q", the shim does not handle it the same. Maybe worth
looking into the logs one day to see if a simple fix is possible.

Though `modernx.lua` works fine with `"enable_osc": false` in `conf.json`,
unfortunately once the shim mpv has been killed once it doesn't come back, so I've
disabled it along with thumbnails and re-enabled the default osc via the shim.

`"mpv_ext": true` is working, but due the osc differences, I need to maintain and use
separate config folders, so `"mpv_ext_no_over": false` must remain
