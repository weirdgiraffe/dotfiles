#!/usr/bin/env python
# coding: utf-8
# vim:fenc=utf-8:ts=2:tw=80

import string
import i3pystatus.battery
import i3pystatus.network


def font_awesome_battery_icon(percentage):
    p = int(percentage)
    if p <= 10:
        return ' '
    if p > 10 and p <= 25:
        return ' '
    elif p > 25 and p <= 50:
        return ' '
    elif p > 50 and p <= 75:
        return ' '
    else:
        return ' '

i3pystatus.battery.make_bar = font_awesome_battery_icon
old_network_run = i3pystatus.network.Network.run


def network_text_fixed_width(cls):
    old_network_run(cls)
    text = cls.output['full_text']
    cls.output['full_text'] = '{:40}'.format(text)


i3pystatus.network.Network.run = network_text_fixed_width

from i3pystatus import Status


colors = {
    'base03': '#002b36',
    'base02': '#073642',
    'base01': '#586e75',
    'base00': '#657b83',
    'base0': '#839496',
    'base1': '#93a1a1',
    'base2': '#eee8d5',
    'base3': '#fdf6e3',
    'yellow': '#b58900',
    'orange': '#cb4b16',
    'red': '#dc322f',
    'magenta': '#d33682',
    'violet': '#6c71c4',
    'blue': '#268bd2',
    'cyan': '#2aa198',
    'green': '#859900',
}
default_color = colors['base1']

status = Status(standalone=True)

status.register(
    'battery',
    interval=5,
    color=default_color,
    full_color=default_color,
    charging_color=default_color,
    critical_color=colors['red'],
    format='[{status} ]{bar} {percentage_design:.0f}%',
    alert=True,
    alert_percentage=15,
    status={'CHR': '',
            'DIS': '    ',
            'DPL': '    ',
            'FULL': '    '}
)
status.register(
    'alsa',
    format='  {volume:3d}% ',
    format_muted='             ',
    hints={"separator": False,
           "separator_block_width": 2},
    color=default_color,
    color_muted=default_color,
)
status.register(
    'mem_bar',
    format='{used_mem_bar}',
    hints={"separator": False,
           "separator_block_width": 2},
    color=colors['base01'],
    alert_color=colors['red'],
    multi_colors=True,
)
status.register(
    'text',
    text='Mem:',
    hints={"separator": False, "separator_block_width": 2},
    color=default_color,
)
status.register(
    'cpu_usage_graph',
    format='{cpu_graph}',
    graph_width=10,
    hints={"separator": False, "separator_block_width": 10},
    start_color=colors['base01'],
    end_color=colors['red'],
)
status.register(
    'text',
    text='Cpu:',
    hints={"separator": False, "separator_block_width": 2},
    color=default_color,
)
status.register(
    'network',
    interface='wlp4s0',
    format_up='  {essid} {quality} {network_graph} {kbs}KB/s',
    format_down=' {interface}: DOWN',
    hints={"separator": False, "separator_block_width": 2},
    dynamic_color=False,
    color_up=default_color,
    color_down=default_color,
    start_color=default_color,
    end_color=default_color,
    graph_width=10,
    graph_type='input',
)
status.register(
    'clock',
    format='%H:%M:%S %a %d %b %Y',
    hints={"separator": False, "separator_block_width": 180},
    color=default_color,
)


status.run()
