

ECHO = @echo

all: src/spd.js
	@mocha 

src/spd.js: src/spd.jison
	jison src/spd.jison  -o src/spd.js