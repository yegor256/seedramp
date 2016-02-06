URL = www.seedramp.com
HTML = $(patsubst pages/%.haml, target/%.html, $(wildcard pages/[^_]*.haml))
CSS = $(patsubst sass/%.scss, target/css/%.css, $(wildcard sass/[^_]*.scss))
IMAGES = $(patsubst images/%, target/images/%, $(wildcard images/*))

all: target lint site

target:
	mkdir -p target

scsslint:
	scss-lint -c .scss-lint.yml 

target/CNAME: target
	echo "$(URL)" > target/CNAME

target/robots.txt: target
	echo "" > target/robots.txt

target/images/%: images/% target
	mkdir -p target/images
	cp $< $@

target/%.html : pages/%.haml target
	haml --style=indented $< > $@

target/css/%.css: sass/%.scss target
	mkdir -p target/css
	sass --style=compressed --sourcemap=none $< $@

site: $(HTML) $(CSS) $(IMAGES) target/CNAME target/robots.txt

lint: scsslint

clean:
	rm -rf target

