.PHONY: clean all build run deps

RACO = raco
RACKET_FOR_BUILD = racket
RACKET = racket
DFLAGS =
UFLAGS =
EFLAGS =
DISPLAY = $(shell ${RACKET} -e "(begin (require setup/cross-system) (display (if (eq? (cross-system-type 'os) 'windows) \"display.exe\" \"display\")))")
UPDATE = $(shell ${RACKET} -e "(begin (require setup/cross-system) (display (if (eq? (cross-system-type 'os) 'windows) \"update.exe\" \"update\")))")
ARCHIVE = display-note.zip

all: deps build $(ARCHIVE)

run: $(DISPLAY)
	$(abspath $<) --launch-browser --banner

$(ARCHIVE): $(DISPLAY) $(UPDATE)
	$(RACO) dist display-note $^
	zip -r $@ display-note

build: $(UPDATE)
	$(abspath $<)

$(DISPLAY): main.rkt database.rkt
	$(RACO) exe $(DFLAGS) $(EFLAGS) -o $@ $<

$(UPDATE): update.rkt installer.rkt database.rkt content.rkt
	$(RACO) exe $(UFLAGS) $(EFLAGS) -o $@ $<

deps:
	$(RACO) pkg install --deps search-auto --skip-installed pollen sugar "git://github.com/Antigen-1/hasket.git"

clean:
	-rm -rf display-note* $(DISPLAY) $(UPDATE) build xexpr
