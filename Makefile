all: target lint site

target:
	mkdir -p target

scsslint:
	scss-lint -c .scss-lint.yml 

target/CNAME: target
	echo "www.seedramp.com" > target/CNAME

target/robots.txt: target
	echo "" > target/robots.txt

target/logo.svg: target
	cp -R images/* target

target/%.html : pages/%.haml target
	haml --style=indented $< > $@

target/%.css: sass/%.scss target
	sass --style=compressed --sourcemap=none $< $@

HTML=target/404.html target/index.html target/faq.html target/consent.html target/safe.html
CSS=target/index.css target/safe.css

site: $(HTML) $(CSS) target/CNAME target/logo.svg target/robots.txt

lint: scsslint

clean:
	rm -rf target

