# -*- coding: utf-8 -*-
import os
import re
import socket
import subprocess
from libqtile.config import KeyChord, Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile.lazy import lazy
from typing import List  # noqa: F401

# NOTE: mod1 = ALT
mod = "mod4"  # SUPER/WINDOWS
myTerm = "kitty"
termExec = myTerm + " -e "
myConfig = "/home/dt/.config/qtile/config.py"  # The Qtile config file location

keys = [
    ### The essentials
    Key([mod], "Return", lazy.spawn(myTerm), desc='Launches Terminal'),
    Key([mod], "space", lazy.spawn("rofi -show drun"), desc='Run Launcher'),
    Key([mod], "Tab", lazy.next_layout(), desc='Toggle through layouts'),
    Key([mod, "shift"], "q", lazy.window.kill(), desc='Kill active window'),
    Key([mod, "shift"], "r", lazy.restart(), desc='Restart Qtile'),
    Key([mod, "shift"], "e", lazy.shutdown(), desc='Shutdown Qtile'),
    Key([mod], "e", lazy.spawn("emacs"), desc='Doom Emacs'),
    ### Switch focus to specific monitor (out of three)
    Key([mod, "control"], "1", lazy.to_screen(0), desc='Keyboard focus to monitor 1'),
    Key([mod, "control"], "2", lazy.to_screen(1), desc='Keyboard focus to monitor 2'),
    Key([mod, "control"], "3", lazy.to_screen(2), desc='Keyboard focus to monitor 3'),
    ### Treetab controls
    Key(
        [mod, "control"],
        "k",
        lazy.layout.section_up(),
        desc='Move up a section in treetab'
    ),
    Key(
        [mod, "control"],
        "j",
        lazy.layout.section_down(),
        desc='Move down a section in treetab'
    ),
    ### Window controls
    Key([mod], "k", lazy.layout.down(), desc='Move focus down in current stack pane'),
    Key([mod], "j", lazy.layout.up(), desc='Move focus up in current stack pane'),
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
    Key(
        [mod, "shift"],
        "m",
        lazy.layout.swap_main(),
        desc="Swap current window with master."
    ),
    Key([mod, "shift"], "f", lazy.window.toggle_floating(), desc='toggle floating'),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc='toggle fullscreen'),
    ### Stack controls
    Key(
        [mod, "shift"],
        "space",
        lazy.layout.rotate(),
        lazy.layout.flip(),
        desc='Switch which side main pane occupies (XmonadTall)'
    ),
    # Key([mod], "space",
    #     lazy.layout.next(),
    #     desc='Switch window focus to other pane(s) of stack'
    #     ),
    # Key([mod, "control"], "Return",
    #     lazy.layout.toggle_split(),
    #     desc='Toggle between split and unsplit sides of stack'
    #     ),
    ### Misc Applications
    Key([mod, "shift"], "Return", lazy.spawn("firefox"), desc="Internet Browser"),
    Key([mod], "p", lazy.spawn("pcmanfm"), desc="Graphical File Manager"),
    Key([mod, "shift"], "s", lazy.spawn("flameshot gui"), desc="Screenshot Tool"),
    Key([mod, "shift"], "s", lazy.spawn("flameshot gui"), desc="Screenshot Tool"),
    Key([mod, "mod1"], "d", lazy.spawn("discord"), desc="Discord"),
    Key([mod], "v", lazy.spawn(termExec + "nvim"), desc="Neovim"),
    Key([mod, "shift"], "o", lazy.spawn(termExec + "htop"), desc="Htop"),
]

group_names = [
    ("WWW", {
        "layout": "monadtall",
        "spawn": ["firefox", "element-desktop"]
    }),
    ("DEV", {
        "layout": "monadtall",
        "spawn": ["emacs", "firefox", "kitty"],
    }),
    ("SCI", {
        "layout": "monadtall"
    }),
    ("DIR", {
        "layout": "monadtall",
        "spawn": ["pcmanfm", termExec + "ranger", myTerm],
    }),
    (
        "SYS", {
            "layout": "monadtall",
            "spawn": [termExec + "htop", termExec + "ytop -c monokai", myTerm],
        }
    ),
    ("GAME", {
        "layout": "monadtall",
        "matches": [Match(wm_class=["Steam"])],
    }),
    (
        "PRV",
        {
            "layout": "monadtall",
            # "spawn": ["firefox -private-window"],
        }
    ),
    ("8", {
        "layout": "monadtall"
    }),
    ("9", {
        "layout": "monadtall"
    })
]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(
        Key([mod], str(i), lazy.group[name].toscreen())
    )  # Switch to another group
    keys.append(
        Key([mod, "shift"], str(i), lazy.window.togroup(name))
    )  # Send current window to another group

layout_theme = {
    "border_width": 3,
    "margin": 12,
    "border_focus": "6623df",
    "border_normal": "422773"
}

layouts = [
    #layout.MonadWide(**layout_theme),
    #layout.Bsp(**layout_theme),
    #layout.Stack(stacks=2, **layout_theme),
    #layout.Columns(**layout_theme),
    #layout.RatioTile(**layout_theme),
    #layout.VerticalTile(**layout_theme),
    #layout.Matrix(**layout_theme),
    #layout.Zoomy(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    # layout.Tile(shift_windows=True, **layout_theme),
    # layout.Stack(num_stacks=2),
    # layout.TreeTab(
    #     font="Ubuntu",
    #     fontsize=10,
    #     sections=["FIRST", "SECOND"],
    #     section_fontsize=11,
    #     bg_color="141414",
    #     active_bg="90C435",
    #     active_fg="000000",
    #     inactive_bg="384323",
    #     inactive_fg="a0a0a0",
    #     padding_y=5,
    #     section_top=10,
    #     panel_width=320
    # ),
    # layout.Floating(**layout_theme)
]

colors = [
    ["#282c34", "#282c34"],  # panel background
    ["#434758", "#434758"],  # background for current screen tab
    ["#ffffff", "#ffffff"],  # font color for group names
    ["#ff5555", "#ff5555"],  # border line color for current tab
    ["#8d62a9", "#8d62a9"],  # border line color for other tab and odd widgets
    ["#668bd7", "#668bd7"],  # color for the even widgets
    ["#e1acff", "#e1acff"]
]  # window name

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
            fontsize=12,
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
        widget.Sep(linewidth=0, padding=40, foreground=colors[2], background=colors[0]),
        widget.WindowName(foreground=colors[6], background=colors[0], padding=0),
        widget.TextBox(
            text='', background=colors[0], foreground=colors[4], padding=0, fontsize=37
        ),
        widget.TextBox(
            text=" ₿", padding=0, foreground=colors[2], background=colors[4], fontsize=12
        ),
        widget.BitcoinTicker(foreground=colors[2], background=colors[4], padding=5),
        widget.TextBox(
            text='', background=colors[4], foreground=colors[5], padding=0, fontsize=37
        ),
        widget.TextBox(
            text=" 🌡", padding=2, foreground=colors[2], background=colors[5], fontsize=11
        ),
        widget.ThermalSensor(
            foreground=colors[2], background=colors[5], threshold=90, padding=5
        ),
        widget.TextBox(
            text='', background=colors[5], foreground=colors[4], padding=0, fontsize=37
        ),
        widget.TextBox(
            text=" ⟳", padding=2, foreground=colors[2], background=colors[4], fontsize=14
        ),
        widget.Pacman(
            update_interval=1800,
            foreground=colors[2],
            mouse_callbacks={
                # 'Button1': lambda qtile: qtile.cmd_spawn(myTerm + ' -e sudo pacman -Syu')
                'Button1': lambda qtile: qtile.cmd_spawn(termExec + "sudo pamac update")
            },
            background=colors[4]
        ),
        widget.TextBox(
            text="Updates",
            padding=5,
            mouse_callbacks={
                # 'Button1': lambda qtile: qtile.cmd_spawn(myTerm + ' -e sudo pacman -Syu')
                'Button1': lambda qtile: qtile.cmd_spawn(termExec + "sudo pamac update")
            },
            foreground=colors[2],
            background=colors[4]
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
            mouse_callbacks={'Button1': lambda qtile: qtile.cmd_spawn(termExec + "htop")},
            padding=5
        ),
        widget.TextBox(
            text='', background=colors[5], foreground=colors[4], padding=0, fontsize=37
        ),
        widget.Net(
            interface="enp6s0",
            format='{down} ↓↑ {up}',
            foreground=colors[2],
            background=colors[4],
            padding=5
        ),
        widget.TextBox(
            text='', background=colors[4], foreground=colors[5], padding=0, fontsize=37
        ),
        widget.TextBox(
            text=" Vol:", foreground=colors[2], background=colors[5], padding=0
        ),
        widget.Volume(foreground=colors[2], background=colors[5], padding=5),
        widget.TextBox(
            text='', background=colors[5], foreground=colors[4], padding=0, fontsize=37
        ),
        widget.CurrentLayoutIcon(
            custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
            foreground=colors[0],
            background=colors[4],
            padding=0,
            scale=0.7
        ),
        widget.CurrentLayout(foreground=colors[2], background=colors[4], padding=5),
        widget.TextBox(
            text='', background=colors[4], foreground=colors[5], padding=0, fontsize=37
        ),
        widget.Clock(
            foreground=colors[2], background=colors[5], format="%A, %B %d  [ %H:%M ]"
        ),
        widget.Sep(linewidth=0, padding=10, foreground=colors[0], background=colors[5]),
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
        # Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=1.0, size=20))
    ]


if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()


def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)


def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)


def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)


def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)


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
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

floating_layout = layout.Floating(
    float_rules=[
        {
            'wmclass': 'confirm'
        },
        {
            'wmclass': 'dialog'
        },
        {
            'wmclass': 'download'
        },
        {
            'wmclass': 'error'
        },
        {
            'wmclass': 'file_progress'
        },
        {
            'wmclass': 'notification'
        },
        {
            'wmclass': 'splash'
        },
        {
            'wmclass': 'toolbar'
        },
        {
            'wmclass': 'confirmreset'
        },  # gitk
        {
            'wmclass': 'makebranch'
        },  # gitk
        {
            'wmclass': 'maketag'
        },  # gitk
        {
            'wname': 'branchdialog'
        },  # gitk
        {
            'wname': 'pinentry'
        },  # GPG key password entry
        {
            'wmclass': 'ssh-askpass'
        },  # ssh-askpass
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])


wmname = "LG3D"
