
include config.mk

SRC := $(wildcard *.c)
OBJ := $(SRC:.c=.o)

all: xouts

debug: CFLAGS += $(DFLAGS)
debug: xouts

xouts: $(OBJ)
	$(CC) -o $@ $(LDFLAGS) $(LDLIBS) $(OBJ)

$(OBJ): %.o : %.c
	$(CC) -c $< $(CFLAGS) $(CPPFLAGS)

clean:
	$(RM) xouts $(OBJ) xouts-$(VERSION).tar.gz

dist: clean
	mkdir -p xouts-$(VERSION)
	cp -R Makefile config.mk LICENSE README.md xouts.1 arg.h $(SRC) xouts-$(VERSION)
	tar -cf - xouts-$(VERSION) | gzip > xouts-$(VERSION).tar.gz
	$(RM) -r xouts-$(VERSION)

install: xouts
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f xouts $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/xouts
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < xouts.1 > $(DESTDIR)$(MANPREFIX)/man1/xouts.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/xouts.1

uninstall:
	$(RM) $(DESTDIR)$(PREFIX)/bin/xouts
	$(RM) $(DESTDIR)$(MANPREFIX)/man1/xouts.1

.PHONY: all clean

