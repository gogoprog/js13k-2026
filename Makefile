default: build

compile:
	haxe build.hxml

build: compile
	mkdir -p build
	cat src/before.html > build/index.html
	# cat deps/w.full.min.js >> build/index.html
	cat deps/w.js >> build/index.html
	cat temp/main.js >> build/index.html
	cat src/after.html >> build/index.html

minify:
	terser --compress unsafe_arrows=true,unsafe=true,toplevel=true,passes=8 --mangle --mangle-props --toplevel --ecma 6 -O ascii_only=true -- temp/main.js > temp/main.min.js
	regpack temp/main.min.js > temp/main.min.regpack.js
	stat temp/main.min.regpack.js | grep Size

retail: compile
	mkdir -p build
	rm -rf retail
	mkdir -p retail
	# terser --compress unsafe_arrows=true,unsafe=true,toplevel=true,passes=8 --mangle --mangle-props --toplevel --ecma 6 -O ascii_only=true -- temp/main.js > temp/main.min.js
	terser --compress toplevel=true,passes=2 --ecma 6 -O ascii_only=true -- temp/main.js > temp/main.min.js
	# terser --compress toplevel=true,passes=2 --ecma 6 -O ascii_only=true -- temp/main.js > temp/main.min.js
	# cp temp/main.js temp/main.min.js
	# regpack temp/main.min.js > temp/main.min.regpack.js
	cat src/before.html > retail/index.html
	cat deps/w.full.min.js >> retail/index.html
	echo "" >> retail/index.html
	cat temp/main.min.js >> retail/index.html
	cat src/after.html >> retail/index.html
	stat retail/index.html | grep Size

zip: retail
	rm -f retail.zip
	cd retail && zip ../retail.zip -r .
	stat retail.zip | grep Size


.PHONY: build retail
