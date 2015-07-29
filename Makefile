# st - simple terminal
# See LICENSE file for copyright and license details.

include config.mk

SRC = st.c
CONF1 = config-solarized-dark.h
CONF2 = config-solarized-light.h
OBJ1 = st-solarized-dark.o
OBJ2 = st-solarized-light.o
OBJS = ${OBJ1} ${OBJ2}
BIN1 = st-solarized-dark
BIN2 = st-solarized-light
BINS = ${BIN1} ${BIN2}

all: options ${BINS}

options:
	@echo st build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

base-config.h: config.def.h
	@cp config.def.h base-config.h

${CONF1}: base-config.h
	@cp base-config.h ${CONF1}
	@patch < st-solarized-dark.diff
	@rm ${CONF1}.orig

${CONF2}: base-config.h
	@cp base-config.h ${CONF2}
	@patch < st-solarized-light.diff
	@rm ${CONF2}.orig

${OBJ1}: st.c config-solarized-dark.h
	@cp ${CONF1} config.h
	@echo CC $<
	@${CC} -c -o ${OBJ1} ${CFLAGS} $<
	@rm config.h

${OBJ2}: st.c config-solarized-light.h
	@cp ${CONF2} config.h
	@echo CC $<
	@${CC} -c -o ${OBJ2} ${CFLAGS} $<
	@rm config.h

${BIN1}: ${OBJ1}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ1} ${LDFLAGS}

${BIN2}: ${OBJ2}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ2} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f ${BINS} ${OBJS} st-${VERSION}.tar.gz

#dist: clean
#	@echo creating dist tarball
#	@mkdir -p st-${VERSION}
#	@cp -R LICENSE Makefile README config.mk config.def.h st.info st.1 ${SRC} st-${VERSION}
#	@tar -cf st-${VERSION}.tar st-${VERSION}
#	@gzip st-${VERSION}.tar
#	@rm -rf st-${VERSION}

install: all
	@echo installing executable files to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f ${BIN1} ${DESTDIR}${PREFIX}/bin/
	@chmod 755 ${DESTDIR}${PREFIX}/bin/${BIN1}
	@cp -f ${BIN2} ${DESTDIR}${PREFIX}/bin/
	@chmod 755 ${DESTDIR}${PREFIX}/bin/${BIN2}
	@cp st.sh ${DESTDIR}${PREFIX}/bin/st
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < st.1 > ${DESTDIR}${MANPREFIX}/man1/st.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/st.1
	@echo Please see the README file regarding the terminfo entry of st.
	@tic -s st.info
	@echo Installing fonts to ${FONTDIR}
	@cp fonts/* ${FONTDIR}/
	@fc-cache -f

uninstall:
	@echo removing executable files from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/st
	@rm -f ${DESTDIR}${PREFIX}/bin/${BIN1}
	@rm -f ${DESTDIR}${PREFIX}/bin/${BIN2}
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/st.1

.PHONY: all options clean dist install uninstall
