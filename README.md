# xouts - X outputs

The intention of this program is, no longer having to `grep`, `cut`, `sed`, `awk` the result of `xrandr --query`.

## Description

Prints a filterable list of available X outputs.
Available filters: **all**, **connected**, **disconnected**, **unknown connection**, **primary**, **secondary**.

For more informations  
`man xouts`


## Dependencies

Required libraries
*  X11/Xlib
*  X11/extensions/Xrandr

## Installation

Edit config.mk to your wishes.
By default xouts is installed into '/usr/local'.
The Makefile provides support for DESTDIR and PREFIX variables.

Afterwards enter following command to build and install xouts.
You may need root rights.  
`make clean install`

