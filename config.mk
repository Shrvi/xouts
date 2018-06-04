
VERSION ?= 0.1.0

PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

LDLIBS  = -lX11 -lXrandr
LDFLAGS =

CPPFLAGS = -DVERSION=\"${VERSION}\"

CFLAGS = -std=c99 -Wall -pedantic

DFLAGS = -g

