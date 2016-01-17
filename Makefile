all: target lint site

target:
	mkdir -p target

scsslint:
	scss-lint -c .scss-lint.yml 

target/CNAME: target
	echo "www.seedramp.com" > target/CNAME

target/robots.txt: target
	echo "" > target/robots.txt

target/images/logo.svg: target
	cp -R images target

target/%.html : pages/%.haml target
	haml --style=ugly $< > $@

target/css/%.css: sass/%.scss target
	mkdir -p target/css
	sass --style=compressed --sourcemap=none $< $@

HTML=target/index.html target/faq.html target/consent.html target/safe.html
CSS=target/css/index.css target/css/safe.css

site: $(HTML) $(CSS) target/CNAME target/images/logo.svg target/robots.txt

lint: scsslint

clean:
	rm -rf target

