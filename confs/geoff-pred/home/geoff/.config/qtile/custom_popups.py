# TODO: this is copied over from the last commit that these classes
# were a part of config.py. There may be some bugs that were fixed after
# they were moved / improvements /changes to the interface. Compare once
# I have emacs up and running again.

from libqtile.popup import Popup
from libqtile import layout, bar, widget, hook

class ShowGroupName:
    def __init__(self, duration=0.8, x_incr=50, fmt="{}", **popup_config):
        """Display popup on screen when switching to a group for `duration` in
        seconds. `x_incr` should be roughly the width of a character in the given
        `font` (monospace) at the specified `font_size`."""
        # HACK: changing width later doesn't paint more background
        popup_config["width"] = 1920
        self.duration, self.x_incr, self.fmt = duration, x_incr, fmt
        self.popup = Popup(qtile, **popup_config)
        self.pending_hide = None  # asyncio.Handle object from qtile.call_later.
        self.suppressed = False
        hook.subscribe.setgroup(self.show)
        hook.subscribe.current_screen_change(self.suppress_screen_change)

    def suppress_screen_change(self):
        """When the current screen changes, suppress the show() which would
        immediately follow due to the accompanying group change. Since the
        current_screen_change hook is fired before setgroup, this seems to be
        adequate."""
        self.suppressed = True

    def cancel_hide(self):
        """Cancel the deferred popup hide. Important when switching groups before
        the the duration is up on the last show."""
        if self.pending_hide is not None:
            self.pending_hide.cancel()

    def draw(self):
        self.popup.clear()
        self.popup.place()
        self.popup.unhide()
        self.popup.draw_text()
        self.popup.draw()

    def show(self):
        if not restarting:
            if self.suppressed:
                self.suppressed = False
            else:
                self.cancel_hide()
                grp = qtile.current_group
                scrn = grp.screen
                text = self.fmt.format(grp.name)
                self.popup.width = self.popup.horizontal_padding * 2 + (
                    len(text) * self.x_incr
                )
                self.popup.text = text
                self.popup.x = int(scrn.x + (scrn.width / 2 - self.popup.width / 2))
                self.popup.y = int(scrn.y + (scrn.height / 2 - self.popup.height / 2))
                self.draw()
                self.pending_hide = qtile.call_later(self.duration, self.popup.hide)


#s = ShowGroupName(
#    font="FiraCode",
#    font_size=80,
#    x_incr=50,
#    fmt="[{}]",
#    height=125,
#    horizontal_padding=25,
#    vertical_padding=15,
#    background="#292d3e",
#    foreground="#d0d0d0",
#)

class Confirm:
    def __init__(self, label, action, x_incr=50, **popup_config):
        """Confirmation popup."""
        # HACK: changing width later doesn't paint more background
        popup_config["width"] = 1920
        self.label, self.action, self.x_incr = label, action, x_incr
        self.popup = Popup(qtile, **popup_config)
        self.build_message(label)
        self.popup.win.handle_ButtonPress = self.handle_button_press
        self.popup.win.handle_KeyPress = self.handle_key_press

    def build_message(self, label):
        self.question = "Are you sure you want to %s?" % label
        self.instruction = "y / n"
        self.pad = " " * ((len(self.question) - len(self.instruction)) // 2)
        self.message = self.question + "\n" + self.pad + self.instruction

    def handle_button_press(self, ev):
        self.popup.win.cmd_focus()

    def handle_key_press(self, ev):
        if ev.detail == 29:  # y
            self.popup.hide()
            self.action()
        elif ev.detail == 57:  # n
            self.popup.hide()

    def draw(self):
        self.popup.clear()
        self.popup.place()
        self.popup.unhide()
        self.popup.draw_text()
        self.popup.draw()

    def show(self, qtile):
        grp = qtile.current_group
        scrn = grp.screen
        self.popup.width = self.popup.horizontal_padding * 2 + (
            len(self.question) * self.x_incr
        )
        self.popup.text = self.message
        self.popup.x = int(scrn.x + (scrn.width / 2 - self.popup.width / 2))
        self.popup.y = int(scrn.y + (scrn.height / 2 - self.popup.height / 2))
        self.draw()
        self.popup.win.cmd_focus()

# confirm_exit = Confirm(
#     "exit",
#     qtile.cmd_shutdown,
#     font="FiraCode",
#     font_size=40,
#     x_incr=25,
#     height=125,
#     horizontal_padding=30,
#     vertical_padding=15,
#     background="#292d3e",
#     foreground="#d0d0d0",
# )
