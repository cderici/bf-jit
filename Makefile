#/usr/bin/make -f

#
# Path of pypy checkout
PYPYPATH ?= pypy

# Invocation of pytest, defaults to pypy's stuff
# but may also be `py.test`
PYTEST ?= $(PYPYPATH)/pytest.py
RPYTHON ?= $(PYPYPATH)/rpython/bin/rpython --batch

PYFILES := $(shell find . -name '*.py' -type f)

PYPY_EXECUTABLE := $(shell which pypy)
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

ifeq ($(PYPY_EXECUTABLE),)
RUNINTERP = python
else
RUNINTERP = $(PYPY_EXECUTABLE)
endif

WITH_JIT = -Ojit --translation-jit_opencoder_model=big

translate-jit: bf-c

bf-c: $(PYFILES)
	$(RUNINTERP) $(RPYTHON) $(WITH_JIT) targetbf.py

debug: $(PYFILES)
	$(RUNINTERP) $(RPYTHON) $(WITH_JIT) --lldebug targetbf.py
	cp bf-c bf-c-debug

get-pypy:
	hg clone https://bitbucket.org/pypy/pypy

update-pypy:
	hg -R $(PYPYPATH) pull && \
	hg -R $(PYPYPATH) update
