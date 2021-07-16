# -*- coding: utf-8 -*-
import os
import re
import socket
import subprocess
from libqtile.config import KeyChord, Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook, qtile
from libqtile.popup import Popup
from libqtile.lazy import lazy
from libqtile.log_utils import logger
from typing import List  # noqa: F401


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


confirm_exit = Confirm(
    "exit",
    qtile.cmd_shutdown,
    font="FiraCode",
    font_size=40,
    x_incr=25,
    height=125,
    horizontal_padding=30,
    vertical_padding=15,
    background="#292d3e",
    foreground="#d0d0d0",
)


def focus_master(qtile):
    """Focus on window in the Master position, if focus is already there, move
    focus to the next position."""
    grp = qtile.current_group
    if grp.layout.clients.current_index > 0:
        c = grp.layout.clients.focus_first()
        grp.focus(c, True)
    elif grp.layout.clients.current_index == 0 and len(grp.layout.clients.clients) > 0:
        grp.layout.cmd_down()


def swap_master(qtile):
    """Swap focused window to Master position. If focus is on Master, swap it
    with the next window, placing focus on the new Master."""
    grp = qtile.current_group
    if grp.layout.clients.current_index > 0:
        grp.layout.cmd_swap_main()
    elif grp.layout.clients.current_index == 0 and len(grp.layout.clients.clients) > 0:
        grp.layout.cmd_shuffle_down()
        c = grp.layout.clients.focus_first()
        grp.focus(c, True)


def float_to_front(qtile):
    """Bring all floating windows of the group to front."""
    for window in qtile.current_group.windows:
        if window.floating:
            window.cmd_bring_to_front()


def sink_floats(qtile):
    """Bring all floating windows of the group to front."""
    for window in qtile.current_group.windows:
        if window.floating:
            window.toggle_floating()


# Special configs
auto_fullscreen = True
focus_on_window_activation = "smart"

mod = "mod4"  # SUPER
alt = "mod1"
my_term = "kitty"
term_exec = my_term + " -e "

keys = [
    ### The essentials
    Key([mod], "Return", lazy.spawn(my_term), desc='Launches Terminal'),
    Key([mod], "space", lazy.spawn("rofi -show drun"), desc='Run Launcher'),
    Key([mod], "Tab", lazy.next_layout(), desc='Toggle through layouts'),
    Key([mod, "shift"], "q", lazy.window.kill(), desc='Kill active window'),
    Key([mod, "shift"], "r", lazy.restart(), desc='Restart Qtile'),
    Key([mod, "shift"], "e", lazy.function(confirm_exit.show), desc='Shutdown Qtile'),
    Key([mod], "e", lazy.spawn("emacs"), desc='Doom Emacs'),
    ### Switch focus to specific monitor (out of three)
    Key([mod], "z", lazy.to_screen(0), desc='Keyboard focus to monitor 1'),
    Key([mod], "x", lazy.to_screen(1), desc='Keyboard focus to monitor 2'),
    Key([mod], "c", lazy.to_screen(2), desc='Keyboard focus to monitor 3'),
    ### Window controls
    Key([mod], "j", lazy.layout.down(), desc='Move focus down in current stack pane'),
    Key([mod], "k", lazy.layout.up(), desc='Move focus up in current stack pane'),
    Key(
        [mod, "shift"],
        "j",
        lazy.layout.shuffle_down(),
        desc='Move windows down in current stack'
    ),
    Key(
        [mod, "shift"],
        "k",
        lazy.layout.shuffle_up(),
        desc='Move windows up in current stack'
    ),
    Key(
        [mod],
        "l",
        lazy.layout.grow(),
        lazy.layout.increase_nmaster(),
        desc='Expand window (MonadTall), increase number in master pane (Tile)'
    ),
    Key(
        [mod],
        "h",
        lazy.layout.shrink(),
        lazy.layout.decrease_nmaster(),
        desc='Shrink window (MonadTall), decrease number in master pane (Tile)'
    ),
    Key([mod], "n", lazy.layout.normalize(), desc='normalize window size ratios'),
    Key(
        [mod, "control"],
        "m",
        lazy.layout.maximize(),
        desc='toggle window between minimum and maximum sizes'
    ),
    Key([mod], "m", lazy.function(focus_master), desc="Focus on master."),
    Key(
        [mod, "shift"],
        "m",
        lazy.function(swap_master),
        desc="Swap current window with master."
    ),
    Key([mod, "shift"], "f", lazy.window.toggle_floating(), desc='toggle floating'),
    Key(
        [mod, alt],
        "f",
        lazy.function(float_to_front),
        desc="Uncover all floating windows."
    ),
    Key(
        [mod],
        "t",
        lazy.function(sink_floats),
        desc="Drop all floating windows into tiled layer."
    ),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc='toggle fullscreen'),
    ### Stack controls
    Key(
        [mod, "shift"],
        "space",
        lazy.layout.rotate(),
        lazy.layout.flip(),
        desc='Switch which side main pane occupies (XmonadTall)'
    ),
    ### Misc Applications
    Key([mod, "shift"], "Return", lazy.spawn("firefox"), desc="Internet Browser"),
    Key([mod], "p", lazy.spawn("pcmanfm"), desc="Graphical File Manager"),
    Key([mod, "shift"], "s", lazy.spawn("flameshot gui"), desc="Screenshot Tool"),
    Key([mod, alt], "d", lazy.spawn("discord"), desc="Discord"),
    Key([mod], "v", lazy.spawn(term_exec + "nvim"), desc="Neovim"),
    Key([mod, "shift"], "o", lazy.spawn(term_exec + "htop"), desc="Htop"),
    ### Scripts
    Key([mod, alt], "w", lazy.spawn("sh /home/geoff/.screenlayout/work_right_hdmi.sh")),
    Key([mod, alt], "h", lazy.spawn("sh /home/geoff/.screenlayout/right_hdmi.sh")),
]

layout_theme = {
    "border_width": 3,
    "margin": 12,
    "border_focus": "6623df",
    "border_normal": "422773",
    "new_at_current": True,
}

default_tall = layout.MonadTall(**layout_theme)
default_max = layout.Max(**layout_theme)
www_tall = layout.MonadTall(**layout_theme, ratio=.6)

### Special name, this is used as the default layouts list
layouts = [
    #layout.MonadWide(**layout_theme),
    #layout.Bsp(**layout_theme),
    #layout.Stack(stacks=2, **layout_theme),
    #layout.Columns(**layout_theme),
    #layout.RatioTile(**layout_theme),
    #layout.VerticalTile(**layout_theme),
    #layout.Matrix(**layout_theme),
    #layout.Zoomy(**layout_theme),
    default_tall,
    default_max,
    # layout.Tile(shift_windows=True, **layout_theme),
    # layout.Stack(num_stacks=2),
    # layout.Floating(**layout_theme)
]

group_names = [
    ("WWW", {
        "layout": "monadtall",
        "layouts": [www_tall, default_max]
    }), ("DEV", {
        "layout": "monadtall",
    }), ("SCI", {
        "layout": "monadtall"
    }), ("DIR", {
        "layout": "monadtall",
    }), ("SYS", {
        "layout": "monadtall",
    }), ("GAME", {
        "layout": "monadtall",
        "matches": [Match(wm_class=["Steam"])],
    }), ("PRV", {
        "layout": "monadtall",
    }), ("8", {
        "layout": "monadtall"
    }), ("9", {
        "layout": "monadtall"
    })
]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    # Switch to another group
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))
    # Send current window to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name)))

colors = [
    ["#282c34", "#282c34"],  # panel background
    ["#434758", "#434758"],  # background for current screen tab
    ["#ffffff", "#ffffff"],  # font color for group names
    ["#6623df", "#6623df"],  # border line color for current tab
    ["#730c7d", "#730c7d"],  # border line color for other tab and odd widgets
    ["#422773", "#422773"],  # color for the even widgets
    ["#6df1d8", "#6df1d8"],  # window name
]

prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

##### DEFAULT WIDGET SETTINGS #####
widget_defaults = dict(font="FiraCode", fontsize=12, padding=2, background=colors[2])
extension_defaults = widget_defaults.copy()


def init_widgets_list():
    widgets_list = [
        widget.Sep(linewidth=0, padding=6, foreground=colors[2], background=colors[0]),
        widget.Image(
            filename="~/.config/qtile/icons/python.png",
            mouse_callbacks={'Button1': lambda qtile: qtile.cmd_spawn('dmenu_run')}
        ),
        widget.GroupBox(
            font="FiraCode",
            fontsize=14,
            margin_y=3,
            margin_x=0,
            padding_y=5,
            padding_x=3,
            borderwidth=3,
            active=colors[2],
            inactive=colors[2],
            rounded=False,
            highlight_color=colors[1],
            highlight_method="line",
            this_current_screen_border=colors[3],
            this_screen_border=colors[4],
            other_current_screen_border=colors[0],
            other_screen_border=colors[0],
            foreground=colors[2],
            background=colors[0]
        ),
        widget.Prompt(
            prompt=prompt,
            font="FiraCode",
            padding=10,
            foreground=colors[3],
            background=colors[1]
        ),
        widget.Sep(linewidth=1, padding=15, foreground=colors[2], background=colors[0]),
        widget.WindowName(
            foreground=colors[6], background=colors[0], padding=0, fontsize=13
        ),
        widget.TextBox(
            text='', background=colors[0], foreground=colors[5], padding=0, fontsize=37
        ),
        widget.CurrentLayoutIcon(
            custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
            foreground=colors[0],
            background=colors[5],
            padding=0,
            scale=0.7
        ),
        widget.CurrentLayout(foreground=colors[2], background=colors[5], padding=5),
        widget.TextBox(
            text='', background=colors[5], foreground=colors[4], padding=0, fontsize=37
        ),
        widget.TextBox(
            text=" 🌡", padding=2, foreground=colors[2], background=colors[4], fontsize=11
        ),
        widget.ThermalSensor(
            foreground=colors[2], background=colors[4], threshold=90, padding=5
        ),
        widget.TextBox(
            text='', background=colors[4], foreground=colors[5], padding=0, fontsize=37
        ),
        widget.TextBox(
            text=" 🖬", foreground=colors[2], background=colors[5], padding=0, fontsize=14
        ),
        widget.Memory(
            foreground=colors[2],
            background=colors[5],
            mouse_callbacks={
                'Button1': lambda qtile: qtile.cmd_spawn(term_exec + "htop")
            },
            padding=5
        ),
        widget.TextBox(
            text='', background=colors[5], foreground=colors[4], padding=0, fontsize=37
        ),
        widget.CPU(foreground=colors[2], background=colors[4], padding=5),
        widget.TextBox(
            text='', background=colors[4], foreground=colors[5], padding=0, fontsize=37
        ),
        widget.TextBox(
            text=" ⟳", padding=2, foreground=colors[2], background=colors[5], fontsize=14
        ),
        widget.CheckUpdates(
            no_update_string="Fresh ",
            display_format="Updates: {updates}",
            update_interval=1800,
            foreground=colors[2],
            mouse_callbacks={
                'Button1': lambda qtile: qtile.cmd_spawn(term_exec + "pamac update")
            },
            background=colors[5],
        ),
        widget.TextBox(
            text='', background=colors[5], foreground=colors[4], padding=0, fontsize=37
        ),
        widget.Clock(
            foreground=colors[2], background=colors[4], format="%A, %B %d  [ %H:%M ]"
        ),
        widget.TextBox(
            text='', background=colors[4], foreground=colors[0], padding=0, fontsize=37
        ),
        widget.Systray(background=colors[0], padding=5),
    ]
    return widgets_list


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1  # Slicing removes unwanted widgets on Monitors 1,3


def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2  # Monitor 2 will display all widgets in widgets_list


def init_screens():
    return [
        Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=1.0, size=20)),
        Screen(top=bar.Bar(widgets=init_widgets_screen2(), opacity=1.0, size=20)),
    ]


if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position()
    ),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False

# windows caught with these rules will spawn as floating
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(title='Confirmation'),  # tastyworks exit box
        Match(title='Qalculate!'),  # qalculate-gtk
        Match(wm_class='kdenlive'),  # kdenlive
        Match(wm_class='pinentry-gtk-2'),  # GPG key password entry
        Match(wm_class="Gimp"),
        Match(wm_class="Nitrogen"),
        Match(wm_class="Lightdm-settings"),
        Match(wm_class="Pavucontrol"),
        Match(wm_class="NEURON"),
        Match(wm_class="matplotlib"),
        Match(wm_class="Viewnior"),
        Match(wm_class="Gnome-calculator"),
        Match(wm_class="StimGen 5.0"),  # BMB stimulus generator
    ]
)


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])


@hook.subscribe.screen_change
def restart_on_randr(qtile, event):
    qtile.cmd_restart()


@hook.subscribe.startup_complete
def refresh_wallpaper():
    qtile.cmd_spawn("nitrogen --restore")


auto_spawns = {
    "WWW": {
        "spawn": ["firefox", "element-desktop"],
    },
    "DEV": {
        "spawn": ["emacs", "firefox", "kitty -d ~/GitRepos"],
    },
    "DIR": {
        "spawn": ["pcmanfm", term_exec + "ranger", my_term],
    },
    "SYS": {
        "spawn": [term_exec + "htop", term_exec + "ytop -c monokai", my_term],
    },
    "GAME": {
        "spawn": ["steam"],
    },
    "PRV": {
        "spawn": ["firefox -private-window"],
    },
}


def group_spawn(grp):
    if grp.name in auto_spawns and len(grp.windows) == 0:
        for s in auto_spawns[grp.name]["spawn"]:
            qtile.cmd_spawn(s)


restarting = True


@hook.subscribe.startup_complete
def finished_restarting():
    """hack to prevent auto-spawner from firing off during restart.
    TODO: Perhaps make a class that offers a more clean solution."""
    global restarting
    restarting = False
    group_spawn(qtile.current_group)


@hook.subscribe.setgroup
def auto_spawner():
    if not restarting:
        grp = qtile.current_group
        if grp.name in auto_spawns and len(grp.windows) == 0:
            for s in auto_spawns[grp.name]["spawn"]:
                qtile.cmd_spawn(s)


@hook.subscribe.client_managed
def dev_term_shrinker(c):
    grp = qtile.current_group
    if qtile.current_group.name == "DEV":
        clients = grp.layout.clients.clients
        n = len(clients)
        # check that new window is client of the group (ignore transient popups)
        if n == 3 and c in clients:
            is_term = [my_term in c.window.get_wm_class() for c in clients]
            if True in is_term:
                term_idx = is_term.index(True)
                grp.focus(clients[term_idx], True)
                for _ in range(n - term_idx):
                    grp.layout.cmd_shuffle_down()
                grp.layout._shrink_secondary(grp.layout.change_size * 15)


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


s = ShowGroupName(
    font="FiraCode",
    font_size=80,
    x_incr=50,
    fmt="[{}]",
    height=125,
    horizontal_padding=25,
    vertical_padding=15,
    background="#292d3e",
    foreground="#d0d0d0",
)

wmname = "LG3D"
