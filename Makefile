HAXE   ?= haxe
NEKO   ?= neko
OPENFL ?= openfl
SWF    ?= open

SRC_FILES  = $(shell find src -name '*.hx')
TEST_FILES = t/*Test.hx
TEST_DEPS  = build $(SRC_FILES) t/*.hx t/Main.hx
TEST_LIBS  = -lib lime -lib openfl -lib actuate -lib svg


test-neko: build/test.n
	$(NEKO) $<

build/test.n: $(TEST_DEPS)
	$(HAXE) -cp src -cp t -main Main $(TEST_LIBS) -debug -neko $@


test-swf: build/flash/debug/bin/test.swf
	$(SWF) $<

build/flash/debug/bin/test.swf: $(TEST_DEPS)
	$(OPENFL) build flash -debug


build:
	mkdir -p build

t/Main.hx: $(TEST_FILES) share/Main.hx.sh
	share/Main.hx.sh > $@


clean:
	rm -rf build


.PHONY: test-neko test-swf clean
