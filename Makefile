VERSION = 0.6
PROJECT = boardname

CC := gcc
OBJ = boardname.o
LIBNAME = libboardname.so
SOVER = 1

CFLAGS= -fPIC -g -c -Wall -Os -fstack-protector -D_FORTIFY_SOURCE=2 -Wformat \
	-fno-common -Wimplicit-function-declaration  -Wimplicit-int
LDFLAGS = -Wl,-soname,$(LIBNAME).$(SOVER) -o $(LIBNAME).$(SOVER) -lc

DEPS = boardname.h

all: libboardname.so.$(SOVER) boardname.pc

%.o: %.c $(DEPS) Makefile
	$(CC) $(CFLAGS) -c -o $@ $<

libboardname.so.$(SOVER): $(OBJ) Makefile
	$(CC) -shared $(LDFLAGS) -o $@ $(OBJ)

boardname.pc: boardname.pc.in
	sed 's/@@VERSION@@/$(VERSION)/' < boardname.pc.in > boardname.pc

install: libboardname.so.$(SOVER) boardname.pc
	install -D -m0644 $(LIBNAME).$(SOVER) $(DESTDIR)/usr/lib/$(LIBNAME).$(SOVER)
	ln -sf $(LIBNAME).$(SOVER) $(DESTDIR)/usr/lib/$(LIBNAME)
	install -D -m0644 $(DEPS) $(DESTDIR)/usr/include/$(PROJECT)/$(DEPS)
	install -D -m0755 boardname $(DESTDIR)/sbin/boardname
	install -D -m0644 boardname.pc $(DESTDIR)/usr/lib/pkgconfig/boardname.pc
clean:
	rm -rf *.o *.so* *.pc
dist:
	git tag v$(VERSION)
	git archive --format=tar --prefix="$(PROJECT)-$(VERSION)/" \
	    v$(VERSION) | gzip > $(PROJECT)-$(VERSION).tar.gz
