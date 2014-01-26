

ECHO = @echo
RM   = rm -f

all: test

test: lib
	@mocha

lib: src/spd.js

clean:
	$(RM) src/spd.js

src/spd.js: src/spd.jison
	jison src/spd.jison  -o src/spd.js