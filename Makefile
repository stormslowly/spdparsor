

ECHO = @echo
RM   = @rm -f

all: src/spd.js
	@mocha

clean:
	$(RM) src/spd.js

src/spd.js: src/spd.jison
	jison src/spd.jison  -o src/spd.js