import matplotlib.pyplot as plt
import csv
import numpy as np

def make_patch_spines_invisible(ax):
    ax.set_frame_on(True)
    ax.patch.set_visible(False)
    for sp in ax.spines.values():
        sp.set_visible(False)

time = []
altitude = []
temp = []
axial = []

with open('dataflat.csv','r') as csvfile:
    plots = csv.DictReader(csvfile)
    for row in plots:
        time.append(float(row['time']))
        altitude.append(float(row['agl']))
        temp.append(float(row['temp']))
        axial.append(float(row['axial']))


with plt.xkcd():
    fig, host = plt.subplots()
    fig.subplots_adjust(right=0.75)

    ax1 = host.twinx()
    ax2 = host.twinx()

    ax2.spines["right"].set_position(("axes", 1.2))
    make_patch_spines_invisible(ax2)
    ax2.spines["right"].set_visible(True)

    p1, = host.plot(time, altitude, 'b-', label='Altitude')
    p2, = ax1.plot(time, axial, 'r-', label='Axial Acceleration')
    p3, = ax2.plot(time, temp, 'g-', label='Temperature')

    host.set_xlabel('time(s)')
    host.set_ylabel('altitude (ft)')
    ax1.set_ylabel('axial acceleration (Gs)')
    ax2.set_ylabel('temperature (F)')

    host.yaxis.label.set_color(p1.get_color())
    ax1.yaxis.label.set_color(p2.get_color())
    ax2.yaxis.label.set_color(p3.get_color())

    tkw = dict(size=4, width=1.5)
    host.tick_params(axis='y', colors=p1.get_color(), **tkw)
    ax1.tick_params(axis='y', colors=p2.get_color(), **tkw)
    ax2.tick_params(axis='y', colors=p3.get_color(), **tkw)
    host.tick_params(axis='x', **tkw)

    lines = [p1,p2,p3]
    host.legend(lines, [l.get_label() for l in lines], loc=9)

    plt.title('FNL 2019 - Launch - April 26, 2019, 12:08:18 PM')
    plt.show()



