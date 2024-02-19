# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile import bar, layout
from libqtile.config import (
    Click,
    Drag,
    Group,
    Key,
    KeyChord,
    Match,
    Screen,
    ScratchPad,
    DropDown,
)
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration
import socket
import os
import subprocess

from libqtile import hook

import json


def get_monitor_count():
    return int(
        subprocess.getoutput(
            "/usr/bin/xrandr --listmonitors|grep Monitors:|awk '{print $2}'"
        )
    )


def read_pywal_colors(file):
    with open(file) as json_file:
        data = json.load(json_file)
        return {
            "bg": data["special"]["background"],
            "fg": data["special"]["foreground"],
            "color0": data["colors"]["color1"],
            "color1": data["colors"]["color3"],
            "color2": data["colors"]["color5"],
            "color3": data["colors"]["color6"],
            "color4": data["colors"]["color7"],
            "color5": data["colors"]["color9"],
            "color6": data["colors"]["color11"],
        }


# colors = read_pywal_colors(os.path.expanduser("~/.cache/wal/colors.json"))
rose_pine = dict(
    base="#191724",
    surface="#1f1d2e",
    overlay="#26233a",
    muted="#6e6a86",
    subtle="908caa",
    text="e0def4",
    love="eb6f92",
    gold="f6c177",
    rose="ebbcba",
    pine="#31748f",
    foam="9ccfd8",
    iris="c4a7e7",
    highlight_low="#21202e",
    highlight_med="#403d52",
    highlight_high="#524f67",
)

colors = {
    "bg": rose_pine["base"],
    "fg": rose_pine["text"],
    "color0": rose_pine["love"],
    "color1": rose_pine["gold"],
    "color2": rose_pine["rose"],
    "color3": rose_pine["pine"],
    "color4": rose_pine["foam"],
    "color5": rose_pine["iris"],
    "color6": rose_pine["foam"],
}


def is_host(name):
    return socket.gethostname() == name


mod = "mod1"
terminal = guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key(
        [mod, "control", "shift"],
        "r",
        lazy.spawn("/opt/qtile/venv/bin/qtile cmd-obj -o cmd -f restart"),
        desc="Restart qtile",
    ),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "comma", lazy.to_screen(0), desc="Keyboard focus to monitor 1"),
    Key([mod], "period", lazy.to_screen(1), desc="Keyboard focus to monitor 2"),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("amixer sset Master 5%-"),
        desc="Lower Volume by 5%",
    ),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("amixer sset Master 5%+"),
        desc="Raise Volume by 5%",
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("amixer sset Master 1+ toggle"),
        desc="Mute/Unmute Volume",
    ),
    Key(
        [],
        "XF86AudioPlay",
        lazy.spawn("playerctl play-pause"),
        desc="Play/Pause player",
    ),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc="Skip to next"),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc="Skip to previous"),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("xbacklight -dec 2"),
        desc="Decrease display brightness",
    ),
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("xbacklight -inc 2"),
        desc="Increase display brightness",
    ),
    Key([mod], "e", lazy.spawn("thunar"), desc="Open file browser"),
    Key([mod, "shift"], "s", lazy.spawn("flameshot gui"), desc="Take screenshot"),
    Key([mod, "shift"], "w", lazy.spawn(".script/setwal.sh"), desc="Swap Wallpaper"),
    Key([mod], "d", lazy.spawn(".config/rofi/main.sh"), desc="Run rofi"),
    Key([mod], "equal", lazy.spawn(".config/rofi/calc.sh"), desc="Launch Calculator"),
    Key(
        [mod, "shift"],
        "p",
        lazy.spawn(".config/rofi/powermenu.sh"),
        desc="Open power menu",
    ),
    Key(
        [mod, "shift"],
        "n",
        lazy.spawn(".config/rofi/netselect.sh"),
        desc="Open network menu",
    ),
    Key(
        [mod, "shift"],
        "u",
        lazy.spawn(".config/rofi/rofi-nerdfonts.sh"),
        desc="Select symbol",
    ),
    # Add/remove columns to Matrix layout
    Key(
        [mod, "shift"],
        "bracketleft",
        lazy.layout.delete(),
        desc="Remove column from layout",
    ),
    Key([mod, "shift"], "bracketright", lazy.layout.add(), desc="Add column to layout"),
    # KEY CHORDS
]

groups = [
    Group("  "),
    Group(
        " 爵 ",
        matches=[Match(wm_class=["Google-chrome", "Firefox-esr", "Brave-browser"])],
    ),
    Group(" ",
        matches=[Match(wm_class=["Caprine", "discord", "Microsoft Teams - Preview"])],
    ),
    Group(
        "  ",
        matches=[
            Match(wm_class=["jetbrains-pycharm", "jetbrains-rider", "jetbrains-clion"])
        ],
    ),
    Group("   ", matches=[Match(wm_class=["Virt-manager", "looking-glass-client"])]),
    Group("   ", matches=[Match(wm_class=["obsidian"])]),
    Group("  ", matches=[Match(wm_class=["Blender", "geeqie"])]),
    Group("  ", matches=[Match(wm_class=["vlc", "Parole"])], layout="grid"),
    Group("  ", matches=[Match(wm_class=["vlc", "Parole"])], layout="grid"),
]

for idx, i in enumerate(groups):
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                str(idx + 1),
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            # Key(
            #    [mod, "shift"],
            #    i,
            #    lazy.window.togroup(i.name, switch_group=True),
            #    desc="Switch to & move focused window to group {}".format(i.name),
            # ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            Key(
                [mod, "shift"],
                str(idx + 1),
                lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name),
            ),
        ]
    )

groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown("term", "alacritty", width=0.4, x=0.3, y=0.2, opacity=0.9),
            # DropDown("volume", "pavucontrol", width=0.5, x=0.3, y=0.3, opacity=0.9),
            DropDown(
                "camera",
                "mplayer -nosound -nocache 'http://zmalias/zm/cgi-bin/nph-zms?monitor=1&user=readonly&pass=readonlycameraview'",
                width=0.8,
                x=0.1,
                y=0.1,
                opacity=0.9,
            ),
            DropDown(
                "top",
                "alacritty -e btop",
                width=0.8,
                height=0.8,
                x=0.1,
                y=0.1,
                opacity=0.9,
            ),
        ],
    )
)

keys.extend(
    [
        Key([mod], "grave", lazy.group["scratchpad"].dropdown_toggle("term")),
        KeyChord(
            [mod],
            "c",
            [
                Key([], "t", lazy.group["scratchpad"].dropdown_toggle("top")),
                # Key([], "s", lazy.group["scratchpad"].dropdown_toggle("volume")),
                Key([], "c", lazy.group["scratchpad"].dropdown_toggle("camera")),
                #  Key([], "n", lazy.group["scratchpad"].dropdown_toggle("notes")),
            ],
        ),
    ]
)

widget_border_default = [0, 0, 0, 0]

layout_margin_defaults = dict(
    margin=8,
    border_width=4,
)

layout_border_defaults = dict(
    # border_focus_stack=[colors['color3'], colors['color4']],
    border_focus=colors["color4"],
    border_normal=colors["bg"],
)

layouts = [
    layout.Columns(
        **layout_margin_defaults,
        **layout_border_defaults,
    ),
    # layout.MonadTall(**layout_defaults),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    layout.Matrix(
        columns=2,
        name="grid",
        **layout_border_defaults,
    ),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(**layout_defaults),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(**layout_defaults),
]

widget_defaults = dict(
    font="0xProto Nerd Font",
    # font="MonaspiceNe NFP Medium",
    fontsize=14,
)

extension_defaults = widget_defaults.copy()

font_defaults = dict(
    font="0xProto Nerd Font",
    fontsize=16
)


def get_gap_widget(size, bg_color="00000000"):
    return widget.Spacer(size, background=bg_color)


def get_separator_widget(separator, fg_color, bg_color="00000000"):
    separator_conf = dict(
        margin=0,
        padding=0,
        font="0xProto Nerd Font",
        fontsize=26,  # Font pixel size. Calculated if None.
        foreground=fg_color,
        background=bg_color
    )
    return widget.TextBox(separator, **separator_conf)


def get_battery_widget(bg_color=colors["bg"]):
    conf = dict(
        background=bg_color,
        charge_char="",
        discharge_char="",
        full_char="",
        not_charging_char="",
        format="{char}  {percent:2.0%} {hour:d}:{min:02d} {watt:.2f}W",
        foreground=colors["color2"],
        low_background=None,
        low_foreground="ff0000",
        low_percentage=0.08,
        padding=2,
        update_interval=15,
        notify_below=10,
        decorations=[
            BorderDecoration(
                border_width=widget_border_default,
                colour=colors["color2"],
                padding=0,
                padding_x=4,
            )
        ],
        **font_defaults,
    )
    if is_host("misterpond"):
        return widget.Battery(battery=0, **conf)
    elif is_host("rfi-linux-dev-02"):
        return widget.Battery(battery=0, **conf)
    else:
        return widget.Spacer(length=0)


def get_wlan_widget():
    wlan_config = dict(
        decorations=[
            BorderDecoration(
                border_width=widget_border_default,
                colour=colors["color1"],
                padding=0,
                padding_x=4,
            )
        ],
        format="{essid} {percent:2.0%}",
        **font_defaults,
    )
    if is_host("misterpond"):
        return widget.Wlan(interface="wlp0s20f3", **wlan_config)
    elif is_host("rfi-linux-dev-02"):
        return widget.Wlan(interface="wlp4s0", **wlan_config)
    else:
        return widget.Spacer(length=0)


def get_systray():
    if not get_systray.has_systray:
        get_systray.has_systray = True
        return widget.Systray(
            decorations=[
                BorderDecoration(
                    border_width=widget_border_default,
                    colour=colors["color4"],
                    padding=0,
                    padding_x=4,
                )
            ],
            padding=8,
        )
    else:
        return widget.Spacer(length=0)


get_systray.has_systray = False


# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]


def group_box(bg_color):
    return widget.GroupBox(
        margin_x=0,
        padding_x=0,
        margin_y=5,
        spacing=0,
        rounded=False,
        background=bg_color,
        highlight_method="line",
        highlight_color=colors["color3"],
        active=colors["color4"],
        this_screen_border=colors["color0"],
        this_current_screen_border=colors["color0"],
        other_current_screen_border=colors["color2"],
        other_screen_border=colors["color2"],
        inactive=colors["color5"],
        foreground=colors["fg"],
        disable_drag=True,
        **font_defaults,
    )


def get_layout_icon():
    lazy.widget["currentlayout"].info()


def window_count(bg_color):
    return widget.WindowCount(
        foreground=colors["fg"],
        background=bg_color,
        text_format="{num}",
        padding=0,
        show_zero=True,
        fontsize=11
    )


def current_layout(bg_color):
    # return widget.TextBox(

    # )
    return widget.CurrentLayoutIcon(
        background=bg_color,
        padding=4,
        fontsize=12,
        scale=0.6
    )


def window_name(bg_color):
    return widget.WindowName(
        decorations=[
            BorderDecoration(
                border_width=widget_border_default,
                colour=colors["color2"],
            )
        ],
        background=bg_color,
        **font_defaults,
    )


def net(bg_color=colors["bg"]):
    return widget.Net(
        decorations=[
            BorderDecoration(
                border_width=widget_border_default,
                colour=colors["color2"],
                padding=0,
                padding_x=3,
            )
        ],
        background=bg_color,
        **font_defaults,
    )


def cpu_graph(bg_color=colors["bg"]):
    return widget.CPUGraph(
        background=bg_color,
        border_width=0,
        margin_y=2,
        border_color=colors["color2"],
        fill_color=colors["color2"],
        graph_color=colors["color2"],
        line_width=1,
        samples=50,
        width=50,
        decorations=[
            BorderDecoration(
                border_width=widget_border_default,
                colour=colors["color2"],
                padding=0,
                padding_x=3,
            )
        ],
    )


def memory_graph(bg_color=colors["bg"]):
    return widget.MemoryGraph(
        background=bg_color,
        width=40,
        border_width=0,
        margin_y=2,
        line_width=1,
        border_color=colors["color6"],
        fill_color=colors["color6"],
        decorations=[
            BorderDecoration(
                border_width=widget_border_default,
                colour=colors["color6"],
                padding=0,
                padding_x=3,
            )
        ],
    )


def hdd_graph():
    return widget.HDDGraph(
        border_width=1,
        line_width=1,
        path="/",
        samples=15,
        width=15,
        space_type="used",
        fill_color=colors["color2"],
        border_color=colors["color2"],
    )


def df_root(bg_color=colors["bg"]):
    return widget.DF(
        background=bg_color,
        format=" {uf}{m}|{r:.0f}%",
        measure="G",
        partition="/",
        update_interval=15,
        visible_on_warn=False,
        decorations=[
            BorderDecoration(
                border_width=widget_border_default,
                colour=colors["color2"],
                padding=0,
                padding_x=4,
            )
        ],
        padding=8,
        **font_defaults,
    )


def df_home(bg_color=colors["bg"]):
    return widget.DF(
        background=bg_color,
        format=" {uf}{m}|{r:.0f}%",
        measure="G",
        partition="/home",
        update_interval=15,
        visible_on_warn=False,
        decorations=[
            BorderDecoration(
                border_width=widget_border_default,
                colour=colors["color3"],
                padding=0,
                padding_x=4,
            )
        ],
        padding=8,
        **font_defaults,
    )


def pulse_volume():
    return widget.PulseVolume(
        decorations=[
            BorderDecoration(
                border_width=widget_border_default,
                colour=colors["color5"],
                padding=0,
                padding_x=4,
            )
        ],
        padding=2,
    )


def notify():
    return widget.Notify(
        audiofile=".config/qtile/alert.wav",
        decorations=[
            BorderDecoration(
                border_width=widget_border_default,
                colour=colors["color6"],
                padding=0,
                padding_x=4,
            )
        ],
        padding=8,
        **font_defaults,
    )


def clock(bg_color=colors["bg"]):
    return widget.Clock(
        background=bg_color,
        format="%A %m/%d/%Y %I:%M %p",
        decorations=[
            BorderDecoration(
                border_width=widget_border_default,
                colour=colors["color6"],
                padding=0,
                padding_x=4,
            )
        ],
        padding=8,
        **font_defaults,
    )


def get_screen_bar(screen_number):
    conf = dict(
        border_width=[0, 0, 0, 0],  # Draw top and bottom borders
        border_color=[colors["bg"], "000000", colors["bg"], "000000"],
        background=["#00000000", "#00000000"],
    )

    if screen_number == 0:
        return bar.Bar(
            [
                group_box(colors["bg"]),
                get_separator_widget("", colors["bg"]),
                get_gap_widget(5),
                get_separator_widget("", colors["color3"]),
                current_layout(colors["color3"]),
                window_count(colors["color3"]),
                get_separator_widget("", colors["color3"], colors["bg"]),
                window_name(colors["bg"]),
                get_separator_widget("", colors["bg"]),
                get_gap_widget(5),
                get_separator_widget("", colors["color3"]),
                get_wlan_widget(),
                get_separator_widget("", colors["color3"], colors["bg"]),
                net(colors["bg"]),
                get_separator_widget("", colors["bg"]),
                get_gap_widget(5),
                get_separator_widget("", colors["bg"]),
                cpu_graph(colors["bg"]),
                memory_graph(colors["bg"]),
                get_gap_widget(5, colors["bg"]),
                get_separator_widget("", colors["bg"], colors["color5"]),
                df_root(colors["color5"]),
                df_home(colors["color5"]),
                get_separator_widget("", colors["color5"]),
                get_gap_widget(5),
                pulse_volume(),
                get_gap_widget(5),
                get_systray(),
                get_gap_widget(5),
                notify(),
                get_gap_widget(5),
                get_separator_widget("", colors["bg"]),
                get_battery_widget(),
                clock(),
            ],
            30,
            **conf
        )
    elif screen_number == 1:
        return bar.Bar(
            [
                group_box(colors["bg"]),
                get_separator_widget("", colors["bg"]),
                get_gap_widget(5),
                get_separator_widget("", colors["color3"]),
                current_layout(colors["color3"]),
                window_count(colors["color3"]),
                get_separator_widget("", colors["color3"], colors["bg"]),
                window_name(colors["bg"]),
                get_separator_widget("", colors["bg"]),
                get_gap_widget(5),
                get_separator_widget("", colors["color3"]),
                get_wlan_widget(),
                get_separator_widget("", colors["color3"], colors["bg"]),
                net(colors["bg"]),
                get_separator_widget("", colors["bg"]),
                get_gap_widget(5),
                get_separator_widget("", colors["bg"]),
                cpu_graph(colors["bg"]),
                memory_graph(colors["bg"]),
                get_gap_widget(5, colors["bg"]),
                get_separator_widget("", colors["bg"], colors["color5"]),
                df_root(colors["color5"]),
                df_home(colors["color5"]),
                get_separator_widget("", colors["color5"]),
                get_gap_widget(5),
                pulse_volume(),
                get_gap_widget(5),
                get_systray(),
                get_gap_widget(5),
                notify(),
                get_gap_widget(5),
                get_separator_widget("", colors["bg"]),
                get_battery_widget(),
                clock(),
            ],
            30,
            **conf
        )


dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="Plexamp"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

screens = []

for i in range(get_monitor_count()):
    screens.append(Screen(top=get_screen_bar(i)))
    # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
    # By default we handle these events delayed to already improve performance, however your system might still be struggling
    # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
    # x11_drag_polling_rate = 60,


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.run([home])
