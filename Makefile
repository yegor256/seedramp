URL = www.seedramp.com
HTML = $(patsubst pages/%.haml, target/%.html, $(wildcard pages/[^_]*.haml))
AMP = $(patsubst %.html, %.amp.html, $(HTML))
DEPS = $(wildcard pages/[_]*.haml)
CSS_DEPS = $(wildcard sass/[_]*.scss)
LOG = $(patsubst log/%.md, target/log/%.html, $(shell find log -name '*.md'))
CSS = $(patsubst sass/%.scss, target/css/%.css, $(wildcard sass/[^_]*.scss))
IMAGES = $(patsubst images/%, target/images/%, $(wildcard images/*))
REVISION = $(shell git rev-parse --short HEAD)

all: target lint site

target:
	mkdir -p target

temp:
	mkdir -p temp

target/css/scsslint: $(CSS)
	scss-lint -c .scss-lint.yml > $@

target/CNAME: target
	echo "$(URL)" > target/CNAME

target/sitemap.xml: make-sitemap.rb $(HTML)
	./make-sitemap.rb > target/sitemap.xml

target/rss.xml: make-rss.rb $(HTML)
	./make-rss.rb > target/rss.xml

target/robots.txt: target
	echo "" > target/robots.txt

target/images/%: images/% target
	mkdir -p target/images
	cp $< $@

target/%.html: temp/%.min.html target
	mkdir -p $$(dirname $@)
	cp $< $@
	sed -i 's|/canonical\.html|http://www.seedramp.com$(patsubst target/%.html,/%.html,$@)|g' $@
	sed -i 's|REVISION|$(REVISION)|g' $@

temp/%.html: pages/%.haml temp $(DEPS)
	haml --format=xhtml --style=indented $< > $@

temp/%.amp.html: temp/%.html make-amp.rb
	./make-amp.rb < $< > $@

temp/%.min.html: temp/%.html
	html-minifier --lint --minify-css --minify-js --keep-closing-slash --remove-comments --collapse-whitespace --output $@ $<

target/css/%.css: sass/%.scss target $(CSS_DEPS)
	mkdir -p target/css
	sass --style=compressed --sourcemap=none $< $@

temp/log/%.html: log/%.md temp $(DEPS) make-log.rb
	mkdir -p `dirname $@`
	./make-log.rb $< > $@

site: $(HTML) $(AMP) $(CSS) $(IMAGES) $(LOG) target/CNAME target/robots.txt target/sitemap.xml target/rss.xml

lint: target/css/scsslint

clean:
	rm -rf target temp

