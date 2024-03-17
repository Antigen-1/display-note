.PHONY: clean all build run deps

RACO = raco
RACKET_FOR_BUILD = racket
RACKET = racket
DFLAGS =
UFLAGS =
EFLAGS =
DISPLAY = $(shell ${RACKET} -e "(begin (require setup/cross-system) (display (if (eq? (cross-system-type 'os) 'windows) \"display.exe\" \"display\")))")
UPDATE = $(shell ${RACKET} -e "(begin (require setup/cross-system) (display (if (eq? (cross-system-type 'os) 'windows) \"update.exe\" \"update\")))")
LOCK = $(shell ${RACKET} -e "(display (make-lock-file-name \"build\"))")
ARCHIVE = display-note.zip
UPDATE_DEPS = update.rkt installer.rkt database.rkt content.rkt
PKGS = pollen sugar txexpr "git://github.com/Antigen-1/hasket.git"
COLLECTS = collects
EXE = exe --collects-path $(COLLECTS)

all: deps build $(ARCHIVE)

run: main.rkt
	$(RACKET_FOR_BUILD) $< --launch-browser --banner

$(ARCHIVE): $(DISPLAY) $(UPDATE)
	$(RACO) dist display-note $^
	zip -r $@ display-note

build: $(UPDATE_DEPS)
	$(RACKET_FOR_BUILD) $<

$(DISPLAY): main.rkt database.rkt
	$(RACO) $(EXE) $(DFLAGS) $(EFLAGS) -o $@ $<

$(UPDATE): $(UPDATE_DEPS)
	$(RACO) $(EXE) \
		++lang pollen ++lang pollen/markup ++lang racket \
		++lib sugar/list ++lib hasket ++lib txexpr ++lib pollen/top ++lib pollen/private/runtime-config \
		$(UFLAGS) $(EFLAGS) -o $@ $<

deps:
	$(RACO) pkg install --deps search-auto --skip-installed $(PKGS)

clean:
	-rm -rf display-note* $(DISPLAY) build xexpr $(UPDATE) $(COLLECTS) $(LOCK)
