# sstoy - a simple shadertoy viewer for X & GLES2
# See LICENSE file for copyright and license details

include config.mk

SRC = sstoy.c
OBJ = ${SRC:.c=.o}

all: options sstoy

options:
	@echo sstoy build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

sstoy: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f sstoy ${OBJ} sstoy-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p sstoy-${VERSION}
	@cp -R LICENSE Makefile README config.def.h config.mk ${SRC} sstoy-${VERSION}
	@tar -cf sstoy-${VERSION}.tar sstoy-${VERSION}
	@gzip sstoy-${VERSION}.tar
	@rm -rf sstoy-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f sstoy ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/sstoy
	@chmod u+s ${DESTDIR}${PREFIX}/bin/sstoy

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/sstoy

.PHONY: all options clean dist install uninstall
