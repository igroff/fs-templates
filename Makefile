SHELL=/bin/bash
.PHONY: watch lint clean install gulp clean_build

watch:
	DEBUG=true ./node_modules/.bin/supervisor --watch 'src/,./' --ignore "./test"  -e "litcoffee,coffee,js" --exec make run-server

lint:
	find ./src -name '*.coffee' | xargs ./node_modules/.bin/coffeelint -f ./etc/coffeelint.conf
	find ./src -name '*.js' | xargs ./node_modules/.bin/jshint 

install: node_modules/

node_modules/:
	npm install .

build_output/: node_modules/
	mkdir -p build_output
	mkdir -p build_output/js
	mkdir -p build_output/css

run-server: build_output/
	cd build_output && exec ../node_modules/.bin/http-server

clean:
	rm -rf ./node_modules/

clean_build:
	rm -rf ./build_output/

gulp: clean_build/ build_output/
	./node_modules/.bin/gulp
