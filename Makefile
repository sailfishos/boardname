VERSION = 0.5
PROJECT = boardname

CC := gcc
OBJ = boardname.o
LIBNAME = libboardname.so

CFLAGS= -fPIC -g -c -Wall
LFLAGS= -shared -W1,-soname,$(LIBNAME).1 -o $(LIBNAME) $(OBJ) -lc

DEPS = boardname.h

all: libboardname boardname.pc

%.o: %.c $(DEPS) Makefile
	$(CC) $(CFLAGS) -c -o $@ $<

libboardname: $(OBJ) Makefile 
	$(CC) -shared -W1,-soname,$@.so.1 -o $(LIBNAME) $(OBJ) -lc

boardname.pc: boardname.pc.in
	sed 's/@@VERSION@@/$(VERSION)/' < boardname.pc.in > boardname.pc

install: libboardname
	install -D -m0644 $(LIBNAME) $(DESTDIR)/usr/lib/$(PROJECT)/$(LIBNAME)
	install -D -m0644 $(DEPS) $(DESTDIR)/usr/include/$(PROJECT)/$(DEPS)
	install -D -m0755 boardname $(DESTDIR)/sbin/boardname
	install -D -m0644 boardname.pc $(DESTDIR)/usr/lib/pkgconfig/boardname.pc
clean:
	rm -rf *.o *.so* *.pc
dist:
	git tag v$(VERSION)
	git archive --format=tar --prefix="$(PROJECT)-$(VERSION)/" v$(VERSION) | \
                gzip > $(PROJECT)-$(VERSION).tar.gz
