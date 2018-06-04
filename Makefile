
include config.mk

SRC := $(wildcard *.c)
OBJ := $(SRC:.c=.o)

all: lso

debug: CFLAGS += $(DFLAGS)
debug: lso

lso: $(OBJ)
	$(CC) -o $@ $(LDFLAGS) $(LDLIBS) $(OBJ)

$(OBJ): %.o : %.c
	$(CC) -c $< $(CFLAGS) $(CPPFLAGS)

clean:
	$(RM) lso $(OBJ) lso-$(VERSION).tar.gz

dist: clean
	mkdir -p lso-$(VERSION)
	cp -R Makefile config.mk LICENSE README.md lso.1 arg.h $(SRC) lso-$(VERSION)
	tar -cf - lso-$(VERSION) | gzip > lso-$(VERSION).tar.gz
	$(RM) -r lso-$(VERSION)

install: lso
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f lso $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/lso
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < lso.1 > $(DESTDIR)$(MANPREFIX)/man1/lso.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/lso.1

uninstall:
	$(RM) $(DESTDIR)$(PREFIX)/bin/lso
	$(RM) $(DESTDIR)$(MANPREFIX)/man1/lso.1

.PHONY: all clean

