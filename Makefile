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

run:
	DISPLAY=:1 xdotool keydown F5
	sleep 0.1
	DISPLAY=:1 xdotool keyup F5
	sleep 0.1

screenshot:
	sleep 0.5
	export DISPLAY=:1 && maim -i `xdotool search --onlyvisible --name Firefox` ./screenshot_full.png && magick ./screenshot_full.png -resize 640x480 ./screenshot.png

key:
	DISPLAY=:1 xdotool keydown $(KEY)
	sleep 0.1
	DISPLAY=:1 xdotool keyup $(KEY)
	sleep 0.1



.PHONY: build retail
