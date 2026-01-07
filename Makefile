# SPDX-FileCopyrightText: Copyright (c) 2016-2026 SeedRamp
# SPDX-License-Identifier: MIT

.PHONY: all clean test site
.ONESHELL:
.SHELLFLAGS := -e -o pipefail -c
.SECONDARY:
SHELL := bash

URL = www.seedramp.com
HTML = $(patsubst pages/%.haml, target/%.html, $(wildcard pages/[^_]*.haml))
DEPS = $(wildcard pages/[_]*.haml)
CSS_DEPS = $(wildcard sass/[_]*.scss)
LOG = $(patsubst log/%.md, target/log/%.html, $(shell find log -name '*.md'))
AMP = $(patsubst %.html, %.amp.html, $(HTML) $(LOG))
CSS = $(patsubst sass/%.scss, target/css/%.css, $(wildcard sass/[^_]*.scss))
IMAGES = $(patsubst images/%, target/images/%, $(wildcard images/*))
REVISION = $(shell git rev-parse --short HEAD)

all: target lint site

target:
	mkdir -p target

temp:
	mkdir -p temp

target/css/scsslint: $(CSS)
	bundle exec scss-lint -c .scss-lint.yml | tee $@

target/CNAME: target
	echo "$(URL)" > target/CNAME

target/sitemap.xml: make_sitemap.rb $(HTML)
	bundle exec ./make_sitemap.rb > target/sitemap.xml

target/rss.xml: make_rss.rb $(HTML)
	bundle exec ./make_rss.rb > target/rss.xml

target/robots.txt: target
	echo "" > target/robots.txt

target/images/%: images/% target
	mkdir -p target/images
	cp $< $@

target/%.html: temp/%.min.html target
	mkdir -p $$(dirname $@)
	cp $< $@

temp/%.html: pages/%.haml temp $(DEPS) $(CSS)
	bundle exec ./make_html.rb --revision=$(REVISION) --canonical=https://www.seedramp.com$(patsubst temp/%.html,/%,$@) < $< > $@

temp/%.amp.html: pages/%.haml temp $(DEPS) $(CSS)
	bundle exec ./make_html.rb --amp --revision=$(REVISION) --canonical=https://www.seedramp.com$(patsubst temp/%.amp.html,/%,$@) < $< > $@

temp/%.min.html: temp/%.html
	html-minifier --lint --minify-css --minify-js --keep-closing-slash --remove-comments --collapse-whitespace --output $@ $<

target/css/%.css: sass/%.scss target $(CSS_DEPS)
	mkdir -p target/css
	bundle exec sass --style=compressed $< $@

temp/log/%.html: log/%.md temp $(DEPS) make_log.rb
	mkdir -p `dirname $@`
	bundle exec ./make_log.rb --path=$< --revision=$(REVISION) --canonical=https://www.seedramp.com$(patsubst temp/%.html,/%,$@) < $< > $@

temp/log/%.amp.html: log/%.md temp $(DEPS) make_log.rb
	mkdir -p `dirname $@`
	bundle exec ./make_log.rb --path=$< --amp --revision=$(REVISION) --canonical=https://www.seedramp.com$(patsubst temp/%.html,/%,$@) < $< > $@

site: $(HTML) $(AMP) $(CSS) $(IMAGES) $(LOG) target/CNAME target/robots.txt target/sitemap.xml target/rss.xml

lint: target/css/scsslint
	bundle exec rubocop

clean:
	rm -rf target temp
